<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;
use Illuminate\Http\Client\Response;
use Illuminate\Http\Client\PendingRequest;
use InvalidArgumentException;

/**
 * API Service
 * Supports multiple API configurations
 */
class ApiService
{
  private array $config;
  private string $currentService;

  public function __construct(string $serviceName = 'default')
  {
    $this->currentService = $serviceName;
    $this->loadConfig($serviceName);
  }

  /**
   * Create instance for specific service
   */
  public static function for(string $serviceName): self
  {
    return new self($serviceName);
  }

  /**
   * Load configuration for service
   */
  private function loadConfig(string $serviceName): void
  {
    $configKey = "services.apis.{$serviceName}";
    $this->config = config($configKey);

    if (empty($this->config)) {
      throw new InvalidArgumentException("API service configuration not found: {$serviceName}");
    }

    // Set defaults
    $this->config = array_merge([
      'base_url' => '',
      'ssl_verify' => true,
      'timeout' => 30,
      'connect_timeout' => 10,
      'key' => '',
      'auth_type' => 'bearer', // bearer, basic, header, query
      'auth_header' => 'Authorization',
      'retry' => [
        'times' => 0,
        'sleep' => 1000
      ]
    ], $this->config);
  }

  /**
   * Switch to different API service
   */
  public function switchTo(string $serviceName): self
  {
    $this->currentService = $serviceName;
    $this->loadConfig($serviceName);
    return $this;
  }

  /**
   * Get current service name
   */
  public function getCurrentService(): string
  {
    return $this->currentService;
  }

  /**
   * Get base HTTP client
   */
  private function getClient(): PendingRequest
  {
    $client = Http::baseUrl($this->config['base_url'])
      ->timeout($this->config['timeout'])
      ->connectTimeout($this->config['connect_timeout'])
      ->withOptions([
        'verify' => $this->config['ssl_verify'],
      ]);

    // Add retry if configured
    if ($this->config['retry']['times'] > 0) {
      $client->retry(
        $this->config['retry']['times'],
        $this->config['retry']['sleep']
      );
    }

    return $client;
  }

  /**
   * Get authenticated client
   */
  private function getAuthenticatedClient(?string $token = null): PendingRequest
  {
    $client = $this->getClient();
    $authToken = $token ?? $this->config['key'];

    if (!$authToken) {
      return $client;
    }

    switch ($this->config['auth_type']) {
      case 'bearer':
        $client->withToken($authToken);
        break;

      case 'basic':
        $credentials = explode(':', $authToken, 2);
        $client->withBasicAuth($credentials[0], $credentials[1] ?? '');
        break;

      case 'header':
        $client->withHeaders([
          $this->config['auth_header'] => $authToken
        ]);
        break;

      case 'query':
        // Token will be added as query parameter in requests
        break;
    }

    return $client;
  }

  /**
   * Add query auth if needed
   */
  private function addQueryAuth(array $params, ?string $token = null): array
  {
    if ($this->config['auth_type'] === 'query') {
      $authToken = $token ?? $this->config['key'];
      if ($authToken) {
        $params[$this->config['auth_header']] = $authToken;
      }
    }
    return $params;
  }

  /**
   * GET request
   */
  public function get(string $endpoint, array $params = [], ?string $token = null): Response
  {
    $params = $this->addQueryAuth($params, $token);
    return $this->getAuthenticatedClient($token)->get($endpoint, $params);
  }

  /**
   * POST request
   */
  public function post(string $endpoint, array $data = [], ?string $token = null): Response
  {
    if ($this->config['auth_type'] === 'query') {
      $data = $this->addQueryAuth($data, $token);
    }

    return $this->getAuthenticatedClient($token)->post($endpoint, $data);
  }

  /**
   * POST as form with JSON response
   */
  public function postFormAcceptJson(string $endpoint, array $data = [], ?string $token = null): Response
  {
    if ($this->config['auth_type'] === 'query') {
      $data = $this->addQueryAuth($data, $token);
    }

    return $this->getAuthenticatedClient($token)
      ->acceptJson()
      ->asForm()
      ->post($endpoint, $data);
  }

  /**
   * POST with file attachment
   */
  public function attachPostAcceptJson(string $endpoint, $file, array $data = [], ?string $token = null): Response
  {
    if ($this->config['auth_type'] === 'query') {
      $data = $this->addQueryAuth($data, $token);
    }

    return $this->getAuthenticatedClient($token)
      ->acceptJson()
      ->attach(
        'file',
        file_get_contents($file->getRealPath()),
        $file->getClientOriginalName()
      )
      ->post($endpoint, $data);
  }

  /**
   * PUT request
   */
  public function put(string $endpoint, array $data = [], ?string $token = null): Response
  {
    if ($this->config['auth_type'] === 'query') {
      $data = $this->addQueryAuth($data, $token);
    }

    return $this->getAuthenticatedClient($token)->put($endpoint, $data);
  }

  /**
   * PATCH request
   */
  public function patch(string $endpoint, array $data = [], ?string $token = null): Response
  {
    if ($this->config['auth_type'] === 'query') {
      $data = $this->addQueryAuth($data, $token);
    }

    return $this->getAuthenticatedClient($token)->patch($endpoint, $data);
  }

  /**
   * DELETE request
   */
  public function delete(string $endpoint, ?string $token = null): Response
  {
    return $this->getAuthenticatedClient($token)->delete($endpoint);
  }

  /**
   * Upload multiple files
   */
  public function upload(string $endpoint, array $files, array $data = [], ?string $token = null): Response
  {
    if ($this->config['auth_type'] === 'query') {
      $data = $this->addQueryAuth($data, $token);
    }

    $client = $this->getAuthenticatedClient($token);

    foreach ($files as $key => $file) {
      $client->attach($key, $file);
    }

    return $client->post($endpoint, $data);
  }

  /**
   * Custom request with full control
   */
  public function request(string $method, string $endpoint, array $options = []): Response
  {
    $client = $this->getClient();

    // Handle authentication
    if (isset($options['token'])) {
      $client = $this->getAuthenticatedClient($options['token']);
    } elseif (isset($options['no_auth']) && $options['no_auth']) {
      // Skip authentication
    } else {
      $client = $this->getAuthenticatedClient();
    }

    // Add headers
    if (isset($options['headers'])) {
      $client->withHeaders($options['headers']);
    }

    // Handle different content types
    if (isset($options['as_json']) && $options['as_json']) {
      $client->asJson();
    } elseif (isset($options['as_form']) && $options['as_form']) {
      $client->asForm();
    }

    // Handle response type
    if (isset($options['accept_json']) && $options['accept_json']) {
      $client->acceptJson();
    }

    // Handle query parameters for GET
    $data = $options['data'] ?? [];
    if (strtoupper($method) === 'GET' && !empty($data)) {
      return $client->get($endpoint, $data);
    }

    return $client->send($method, $endpoint, $data);
  }

  /**
   * Get service configuration
   */
  public function getConfig(?string $key = null)
  {
    return $key ? ($this->config[$key] ?? null) : $this->config;
  }

  /**
   * Update service configuration at runtime
   */
  public function setConfig(string $key, $value): self
  {
    $this->config[$key] = $value;
    return $this;
  }

  /**
   * Add default headers to all requests
   */
  public function withDefaultHeaders(array $headers): self
  {
    $this->config['default_headers'] = array_merge(
      $this->config['default_headers'] ?? [],
      $headers
    );
    return $this;
  }

  /**
   * Create a new client with custom headers
   */
  public function withHeaders(array $headers): PendingRequest
  {
    return $this->getClient()->withHeaders($headers);
  }

  /**
   * Enable/disable SSL verification
   */
  public function sslVerify(bool $verify): self
  {
    $this->config['ssl_verify'] = $verify;
    return $this;
  }

  /**
   * Set timeout
   */
  public function timeout(int $seconds): self
  {
    $this->config['timeout'] = $seconds;
    return $this;
  }

  /**
   * Health check endpoint
   */
  public function healthCheck(?string $endpoint = null): bool
  {
    try {
      $checkEndpoint = $endpoint ?? ($this->config['health_check'] ?? '/health');
      $response = $this->get($checkEndpoint);
      return $response->successful();
    } catch (\Exception $e) {
      return false;
    }
  }
}

/**
 * API Service Factory
 */
class ApiServiceFactory
{
  private static array $instances = [];

  /**
   * Get or create API service instance
   */
  public static function make(string $serviceName): ApiService
  {
    if (!isset(self::$instances[$serviceName])) {
      self::$instances[$serviceName] = new ApiService($serviceName);
    }

    return self::$instances[$serviceName];
  }

  /**
   * Get all available services
   */
  public static function getAvailableServices(): array
  {
    return array_keys(config('services.apis', []));
  }

  /**
   * Clear cached instances
   */
  public static function clearCache(): void
  {
    self::$instances = [];
  }
}
