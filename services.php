<?php

// File: config/services.php
return [
  // ... existing config ...

  'apis' => [
    // Default/Legacy API (UAuth)
    'uauth' => [
      'base_url' => env('UAUTH_API_BASE_URL', 'https://api.uauth.com'),
      'ssl_verify' => env('UAUTH_SSL_VERIFY', true),
      'timeout' => env('UAUTH_TIMEOUT', 30),
      'connect_timeout' => env('UAUTH_CONNECT_TIMEOUT', 10),
      'key' => env('UAUTH_API_KEY'),
      'auth_type' => 'bearer',
      'retry' => [
        'times' => 3,
        'sleep' => 1000
      ]
    ],

    // Payment Gateway API
    'payment' => [
      'base_url' => env('PAYMENT_API_BASE_URL', 'https://api.payment.com'),
      'ssl_verify' => env('PAYMENT_SSL_VERIFY', true),
      'timeout' => 45,
      'connect_timeout' => 15,
      'key' => env('PAYMENT_API_KEY'),
      'auth_type' => 'header',
      'auth_header' => 'X-API-Key',
      'retry' => [
        'times' => 2,
        'sleep' => 2000
      ]
    ],

    // Social Media API
    'social' => [
      'base_url' => env('SOCIAL_API_BASE_URL', 'https://api.social.com'),
      'ssl_verify' => true,
      'timeout' => 20,
      'connect_timeout' => 5,
      'key' => env('SOCIAL_API_KEY'),
      'auth_type' => 'bearer',
      'health_check' => '/status'
    ],

    // External Service dengan Basic Auth
    'external' => [
      'base_url' => env('EXTERNAL_API_BASE_URL'),
      'ssl_verify' => false,
      'timeout' => 60,
      'connect_timeout' => 20,
      'key' => env('EXTERNAL_API_USERNAME') . ':' . env('EXTERNAL_API_PASSWORD'),
      'auth_type' => 'basic'
    ],

    // API dengan Query Parameter Auth
    'legacy' => [
      'base_url' => env('LEGACY_API_BASE_URL'),
      'ssl_verify' => true,
      'timeout' => 30,
      'connect_timeout' => 10,
      'key' => env('LEGACY_API_KEY'),
      'auth_type' => 'query',
      'auth_header' => 'api_key'
    ]
  ]
];
