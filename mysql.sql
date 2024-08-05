CREATE TABLE email_templates (
  id                       BINARY(16)   NOT NULL,
  default_from_name        VARCHAR(255) NULL,
  default_html_template    MEDIUMTEXT   NOT NULL,
  default_subject          VARCHAR(255) NOT NULL,
  default_text_template    MEDIUMTEXT   NOT NULL,
  from_email               VARCHAR(255) NULL,
  insert_instant           BIGINT       NOT NULL,
  last_update_instant      BIGINT       NOT NULL,
  localized_from_names     TEXT         NULL,
  localized_html_templates MEDIUMTEXT   NOT NULL,
  localized_subjects       TEXT         NOT NULL,
  localized_text_templates MEDIUMTEXT   NOT NULL,
  name                     VARCHAR(191) NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT email_templates_uk_1 UNIQUE (name)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

CREATE TABLE message_templates (
  id                  BINARY(16)   NOT NULL,
  data                TEXT         NOT NULL,
  insert_instant      BIGINT       NOT NULL,
  last_update_instant BIGINT       NOT NULL,
  name                VARCHAR(191) NOT NULL,
  type                SMALLINT     NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT message_templates_uk_1 UNIQUE (name)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

CREATE TABLE user_actions (
  id                          BINARY(16)   NOT NULL,
  active                      BIT(1)       NOT NULL,
  cancel_email_templates_id   BINARY(16)   NULL,
  end_email_templates_id      BINARY(16)   NULL,
  include_email_in_event_json BIT(1)       NOT NULL,
  insert_instant              BIGINT       NOT NULL,
  last_update_instant         BIGINT       NOT NULL,
  localized_names             TEXT         NULL,
  modify_email_templates_id   BINARY(16)   NULL,
  name                        VARCHAR(191) NOT NULL,
  options                     TEXT         NULL,
  prevent_login               BIT(1)       NOT NULL,
  send_end_event              BIT(1)       NOT NULL,
  start_email_templates_id    BINARY(16)   NULL,
  temporal                    BIT(1)       NOT NULL,
  transaction_type            SMALLINT     NOT NULL,
  user_notifications_enabled  BIT(1)       NOT NULL,
  user_emailing_enabled       BIT(1)       NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT user_actions_uk_1 UNIQUE (name),
  CONSTRAINT user_actions_fk_1 FOREIGN KEY (cancel_email_templates_id) REFERENCES email_templates(id),
  CONSTRAINT user_actions_fk_2 FOREIGN KEY (end_email_templates_id) REFERENCES email_templates(id),
  CONSTRAINT user_actions_fk_3 FOREIGN KEY (modify_email_templates_id) REFERENCES email_templates(id),
  CONSTRAINT user_actions_fk_4 FOREIGN KEY (start_email_templates_id) REFERENCES email_templates(id)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

CREATE TABLE user_action_reasons (
  id                  BINARY(16)   NOT NULL,
  insert_instant      BIGINT       NOT NULL,
  last_update_instant BIGINT       NOT NULL,
  localized_texts     TEXT         NULL,
  text                VARCHAR(191) NOT NULL,
  code                VARCHAR(191) NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT user_action_reasons_uk_1 UNIQUE (text),
  CONSTRAINT user_action_reasons_uk_2 UNIQUE (code)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

-- UI Theme
CREATE TABLE themes (
  id                  BINARY(16)   NOT NULL,
  data                LONGTEXT     NOT NULL,
  insert_instant      BIGINT       NOT NULL,
  last_update_instant BIGINT       NOT NULL,
  name                VARCHAR(191) NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT themes_uk_1 UNIQUE (name)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

CREATE TABLE consents (
  id                            BINARY(16)   NOT NULL,
  consent_email_templates_id    BINARY(16)   NULL,
  data                          MEDIUMTEXT   NULL,
  insert_instant                BIGINT       NOT NULL,
  last_update_instant           BIGINT       NOT NULL,
  name                          VARCHAR(191) NOT NULL,
  email_plus_email_templates_id BINARY(16)   NULL,
  PRIMARY KEY (id),
  CONSTRAINT consents_uk_1 UNIQUE (name),
  CONSTRAINT consents_fk_1 FOREIGN KEY (consent_email_templates_id) REFERENCES email_templates(id),
  CONSTRAINT consents_fk_2 FOREIGN KEY (email_plus_email_templates_id) REFERENCES email_templates(id)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

-- Custom Registration Forms

-- Fields
CREATE TABLE form_fields (
  id                  BINARY(16)   NOT NULL,
  consents_id         BINARY(16)   NULL,
  data                TEXT         NULL,
  insert_instant      BIGINT       NOT NULL,
  last_update_instant BIGINT       NOT NULL,
  name                VARCHAR(191) NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT form_fields_uk_1 UNIQUE (name),
  CONSTRAINT form_fields_fk_1 FOREIGN KEY (consents_id) REFERENCES consents(id)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

-- Forms
CREATE TABLE forms (
  id                  BINARY(16)   NOT NULL,
  data                TEXT         NULL,
  insert_instant      BIGINT       NOT NULL,
  last_update_instant BIGINT       NOT NULL,
  name                VARCHAR(191) NOT NULL,
  type                SMALLINT     NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT forms_uk_1 UNIQUE (name)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

-- Form Steps
CREATE TABLE form_steps (
  form_fields_id BINARY(16) NOT NULL,
  forms_id       BINARY(16) NOT NULL,
  sequence       SMALLINT   NOT NULL,
  step           SMALLINT   NOT NULL,
  PRIMARY KEY (forms_id, form_fields_id),
  CONSTRAINT form_steps_fk_1 FOREIGN KEY (forms_id) REFERENCES forms(id),
  CONSTRAINT form_steps_fk_2 FOREIGN KEY (form_fields_id) REFERENCES form_fields(id)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

CREATE TABLE `keys` (
  id                  BINARY(16)   NOT NULL,
  algorithm           VARCHAR(255) NULL,
  certificate         TEXT         NULL,
  expiration_instant  BIGINT       NULL,
  insert_instant      BIGINT       NOT NULL,
  issuer              VARCHAR(255) NULL,
  kid                 VARCHAR(191) NOT NULL,
  last_update_instant BIGINT       NOT NULL,
  name                VARCHAR(191) NOT NULL,
  private_key         TEXT         NULL,
  public_key          TEXT         NULL,
  secret              TEXT         NULL,
  type                VARCHAR(255) NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT keys_uk_1 UNIQUE (kid),
  CONSTRAINT keys_uk_2 UNIQUE (name)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

-- Messengers
CREATE TABLE messengers (
  id                  BINARY(16)   NOT NULL,
  data                TEXT         NOT NULL,
  insert_instant      BIGINT       NOT NULL,
  last_update_instant BIGINT       NOT NULL,
  name                VARCHAR(191) NOT NULL,
  type                SMALLINT     NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT messengers_uk_1 UNIQUE (name)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

CREATE TABLE lambdas (
  id                  BINARY(16)   NOT NULL,
  body                MEDIUMTEXT   NOT NULL,
  debug               BIT(1)       NOT NULL,
  engine_type         VARCHAR(255) NOT NULL,
  insert_instant      BIGINT       NOT NULL,
  last_update_instant BIGINT       NOT NULL,
  name                VARCHAR(255) NOT NULL,
  type                SMALLINT     NOT NULL,
  PRIMARY KEY (id)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

-- IP allow/block table
CREATE TABLE ip_access_control_lists (
  id                  BINARY(16)   NOT NULL,
  data                TEXT         NOT NULL,
  insert_instant      BIGINT       NOT NULL,
  last_update_instant BIGINT       NOT NULL,
  name                VARCHAR(191) NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT ip_access_control_lists_uk_1 UNIQUE (name)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

CREATE TABLE entity_types (
  id                           BINARY(16)   NOT NULL,
  access_token_signing_keys_id BINARY(16)   NULL,
  data                         TEXT         NULL,
  insert_instant               BIGINT       NOT NULL,
  last_update_instant          BIGINT       NOT NULL,
  name                         VARCHAR(191) NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT entity_types_fk_1 FOREIGN KEY (access_token_signing_keys_id) REFERENCES `keys`(id),
  CONSTRAINT entity_types_uk_1 UNIQUE (name)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

CREATE TABLE tenants (
  id                                                  BINARY(16)   NOT NULL,
  access_token_signing_keys_id                        BINARY(16)   NOT NULL,
  admin_user_forms_id                                 BINARY(16)   NOT NULL,
  client_credentials_access_token_populate_lambdas_id BINARY(16)   NULL,
  confirm_child_email_templates_id                    BINARY(16)   NULL,
  data                                                TEXT         NULL,
  email_update_email_templates_id                     BINARY(16)   NULL,
  email_verified_email_templates_id                   BINARY(16)   NULL,
  failed_authentication_user_actions_id               BINARY(16)   NULL,
  family_request_email_templates_id                   BINARY(16)   NULL,
  forgot_password_email_templates_id                  BINARY(16)   NULL,
  id_token_signing_keys_id                            BINARY(16)   NOT NULL,
  insert_instant                                      BIGINT       NOT NULL,
  last_update_instant                                 BIGINT       NOT NULL,
  login_id_in_use_on_create_email_templates_id        BINARY(16)   NULL,
  login_id_in_use_on_update_email_templates_id        BINARY(16)   NULL,
  login_new_device_email_templates_id                 BINARY(16)   NULL,
  login_suspicious_email_templates_id                 BINARY(16)   NULL,
  multi_factor_email_message_templates_id             BINARY(16)   NULL,
  multi_factor_sms_message_templates_id               BINARY(16)   NULL,
  multi_factor_sms_messengers_id                      BINARY(16)   NULL,
  name                                                VARCHAR(191) NOT NULL,
  password_reset_success_email_templates_id           BINARY(16)   NULL,
  password_update_email_templates_id                  BINARY(16)   NULL,
  parent_registration_email_templates_id              BINARY(16)   NULL,
  passwordless_email_templates_id                     BINARY(16)   NULL,
  scim_client_entity_types_id                         BINARY(16)   NULL,
  scim_enterprise_user_request_converter_lambdas_id   BINARY(16)   NULL,
  scim_enterprise_user_response_converter_lambdas_id  BINARY(16)   NULL,
  scim_group_request_converter_lambdas_id             BINARY(16)   NULL,
  scim_group_response_converter_lambdas_id            BINARY(16)   NULL,
  scim_server_entity_types_id                         BINARY(16)   NULL,
  scim_user_request_converter_lambdas_id              BINARY(16)   NULL,
  scim_user_response_converter_lambdas_id             BINARY(16)   NULL,
  set_password_email_templates_id                     BINARY(16)   NULL,
  themes_id                                           BINARY(16)   NOT NULL,
  two_factor_method_add_email_templates_id            BINARY(16)   NULL,
  two_factor_method_remove_email_templates_id         BINARY(16)   NULL,
  ui_ip_access_control_lists_id                       BINARY(16)   NULL,
  verification_email_templates_id                     BINARY(16)   NULL,
  PRIMARY KEY (id),
  CONSTRAINT tenants_fk_1 FOREIGN KEY (forgot_password_email_templates_id) REFERENCES email_templates(id),
  CONSTRAINT tenants_fk_2 FOREIGN KEY (set_password_email_templates_id) REFERENCES email_templates(id),
  CONSTRAINT tenants_fk_3 FOREIGN KEY (verification_email_templates_id) REFERENCES email_templates(id),
  CONSTRAINT tenants_fk_4 FOREIGN KEY (passwordless_email_templates_id) REFERENCES email_templates(id),
  CONSTRAINT tenants_fk_5 FOREIGN KEY (confirm_child_email_templates_id) REFERENCES email_templates(id),
  CONSTRAINT tenants_fk_6 FOREIGN KEY (family_request_email_templates_id) REFERENCES email_templates(id),
  CONSTRAINT tenants_fk_7 FOREIGN KEY (parent_registration_email_templates_id) REFERENCES email_templates(id),
  CONSTRAINT tenants_fk_8 FOREIGN KEY (failed_authentication_user_actions_id) REFERENCES user_actions(id),
  CONSTRAINT tenants_fk_9 FOREIGN KEY (themes_id) REFERENCES themes(id),
  CONSTRAINT tenants_fk_10 FOREIGN KEY (access_token_signing_keys_id) REFERENCES `keys`(id),
  CONSTRAINT tenants_fk_11 FOREIGN KEY (id_token_signing_keys_id) REFERENCES `keys`(id),
  CONSTRAINT tenants_fk_12 FOREIGN KEY (admin_user_forms_id) REFERENCES forms(id),
  CONSTRAINT tenants_fk_13 FOREIGN KEY (multi_factor_email_message_templates_id) REFERENCES email_templates(id),
  CONSTRAINT tenants_fk_14 FOREIGN KEY (multi_factor_sms_message_templates_id) REFERENCES message_templates(id),
  CONSTRAINT tenants_fk_15 FOREIGN KEY (multi_factor_sms_messengers_id) REFERENCES messengers(id),
  CONSTRAINT tenants_fk_16 FOREIGN KEY (client_credentials_access_token_populate_lambdas_id) REFERENCES lambdas(id),
  CONSTRAINT tenants_fk_17 FOREIGN KEY (email_update_email_templates_id) REFERENCES email_templates(id),
  CONSTRAINT tenants_fk_18 FOREIGN KEY (email_verified_email_templates_id) REFERENCES email_templates(id),
  CONSTRAINT tenants_fk_19 FOREIGN KEY (login_id_in_use_on_create_email_templates_id) REFERENCES email_templates(id),
  CONSTRAINT tenants_fk_20 FOREIGN KEY (login_id_in_use_on_update_email_templates_id) REFERENCES email_templates(id),
  CONSTRAINT tenants_fk_21 FOREIGN KEY (login_new_device_email_templates_id) REFERENCES email_templates(id),
  CONSTRAINT tenants_fk_22 FOREIGN KEY (login_suspicious_email_templates_id) REFERENCES email_templates(id),
  CONSTRAINT tenants_fk_23 FOREIGN KEY (password_reset_success_email_templates_id) REFERENCES email_templates(id),
  CONSTRAINT tenants_fk_24 FOREIGN KEY (password_update_email_templates_id) REFERENCES email_templates(id),
  CONSTRAINT tenants_fk_25 FOREIGN KEY (two_factor_method_add_email_templates_id) REFERENCES email_templates(id),
  CONSTRAINT tenants_fk_26 FOREIGN KEY (two_factor_method_remove_email_templates_id) REFERENCES email_templates(id),
  CONSTRAINT tenants_fk_27 FOREIGN KEY (ui_ip_access_control_lists_id) REFERENCES ip_access_control_lists(id),
  CONSTRAINT tenants_fk_28 FOREIGN KEY (scim_client_entity_types_id) REFERENCES entity_types(id),
  CONSTRAINT tenants_fk_29 FOREIGN KEY (scim_enterprise_user_request_converter_lambdas_id) REFERENCES lambdas(id),
  CONSTRAINT tenants_fk_30 FOREIGN KEY (scim_enterprise_user_response_converter_lambdas_id) REFERENCES lambdas(id),
  CONSTRAINT tenants_fk_31 FOREIGN KEY (scim_group_request_converter_lambdas_id) REFERENCES lambdas(id),
  CONSTRAINT tenants_fk_32 FOREIGN KEY (scim_group_response_converter_lambdas_id) REFERENCES lambdas(id),
  CONSTRAINT tenants_fk_33 FOREIGN KEY (scim_server_entity_types_id) REFERENCES entity_types(id),
  CONSTRAINT tenants_fk_34 FOREIGN KEY (scim_user_request_converter_lambdas_id) REFERENCES lambdas(id),
  CONSTRAINT tenants_fk_35 FOREIGN KEY (scim_user_response_converter_lambdas_id) REFERENCES lambdas(id),
  CONSTRAINT tenants_uk_1 UNIQUE (name)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

CREATE TABLE users (
  id                  BINARY(16)   NOT NULL,
  active              BIT(1)       NOT NULL,
  birth_date          CHAR(10)     NULL,
  clean_speak_id      BINARY(16)   NULL,
  data                MEDIUMTEXT   NULL,
  expiry              BIGINT       NULL,
  first_name          VARCHAR(255) NULL,
  full_name           VARCHAR(255) NULL,
  image_url           TEXT         NULL,
  insert_instant      BIGINT       NOT NULL,
  last_name           VARCHAR(255) NULL,
  last_update_instant BIGINT       NOT NULL,
  middle_name         VARCHAR(255) NULL,
  mobile_phone        VARCHAR(255) NULL,
  parent_email        VARCHAR(255) NULL,
  tenants_id          BINARY(16)   NOT NULL,
  timezone            VARCHAR(255) NULL,
  PRIMARY KEY (id),
  CONSTRAINT users_fk_1 FOREIGN KEY (tenants_id) REFERENCES tenants(id)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;
CREATE INDEX users_i_1 ON users(clean_speak_id);
CREATE INDEX users_i_2 ON users(parent_email);

CREATE TABLE user_consents (
  id                  BINARY(16) NOT NULL,
  consents_id         BINARY(16) NOT NULL,
  data                MEDIUMTEXT NULL,
  giver_users_id      BINARY(16) NOT NULL,
  insert_instant      BIGINT     NOT NULL,
  last_update_instant BIGINT     NOT NULL,
  users_id            BINARY(16) NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT user_consents_fk_1 FOREIGN KEY (consents_id) REFERENCES consents(id),
  CONSTRAINT user_consents_fk_2 FOREIGN KEY (giver_users_id) REFERENCES users(id),
  CONSTRAINT user_consents_fk_3 FOREIGN KEY (users_id) REFERENCES users(id)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

CREATE TABLE user_consents_email_plus (
  id                 BIGINT     NOT NULL AUTO_INCREMENT,
  next_email_instant BIGINT     NOT NULL,
  user_consents_id   BINARY(16) NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT user_consents_email_plus_fk_1 FOREIGN KEY (user_consents_id) REFERENCES user_consents(id)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;
CREATE INDEX user_consents_email_plus_i_1 ON user_consents_email_plus(next_email_instant);

CREATE TABLE applications (
  id                                              BINARY(16)   NOT NULL,
  access_token_populate_lambdas_id                BINARY(16)   NULL,
  access_token_signing_keys_id                    BINARY(16)   NULL,
  active                                          BIT(1)       NOT NULL,
  admin_registration_forms_id                     BINARY(16)   NOT NULL,
  data                                            TEXT         NOT NULL,
  email_update_email_templates_id                 BINARY(16)   NULL,
  email_verification_email_templates_id           BINARY(16)   NULL,
  email_verified_email_templates_id               BINARY(16)   NULL,
  forgot_password_email_templates_id              BINARY(16)   NULL,
  forms_id                                        BINARY(16)   NULL,
  id_token_populate_lambdas_id                    BINARY(16)   NULL,
  id_token_signing_keys_id                        BINARY(16)   NULL,
  insert_instant                                  BIGINT       NOT NULL,
  last_update_instant                             BIGINT       NOT NULL,
  login_id_in_use_on_create_email_templates_id    BINARY(16)   NULL,
  login_id_in_use_on_update_email_templates_id    BINARY(16)   NULL,
  login_new_device_email_templates_id             BINARY(16)   NULL,
  login_suspicious_email_templates_id             BINARY(16)   NULL,
  multi_factor_email_message_templates_id         BINARY(16)   NULL,
  multi_factor_sms_message_templates_id           BINARY(16)   NULL,
  name                                            VARCHAR(191) NOT NULL,
  passwordless_email_templates_id                 BINARY(16)   NULL,
  password_update_email_templates_id              BINARY(16)   NULL,
  password_reset_success_email_templates_id       BINARY(16)   NULL,
  samlv2_default_verification_keys_id             BINARY(16)   NULL,
  samlv2_issuer                                   VARCHAR(191) NULL,
  samlv2_keys_id                                  BINARY(16)   NULL,
  samlv2_logout_keys_id                           BINARY(16)   NULL,
  samlv2_logout_default_verification_keys_id      BINARY(16)   NULL,
  samlv2_populate_lambdas_id                      BINARY(16)   NULL,
  samlv2_single_logout_keys_id                    BINARY(16)   NULL,
  self_service_registration_validation_lambdas_id BINARY(16)   NULL,
  self_service_user_forms_id                      BINARY(16)   NULL,
  set_password_email_templates_id                 BINARY(16)   NULL,
  tenants_id                                      BINARY(16)   NOT NULL,
  themes_id                                       BINARY(16)   NULL,
  two_factor_method_add_email_templates_id        BINARY(16)   NULL,
  two_factor_method_remove_email_templates_id     BINARY(16)   NULL,
  ui_ip_access_control_lists_id                   BINARY(16)   NULL,
  verification_email_templates_id                 BINARY(16)   NULL,
  userinfo_populate_lambdas_id                    BINARY(16)   NULL,
  PRIMARY KEY (id),
  CONSTRAINT applications_uk_1 UNIQUE (name, tenants_id),
  CONSTRAINT applications_uk_2 UNIQUE (samlv2_issuer, tenants_id),
  CONSTRAINT applications_fk_1 FOREIGN KEY (verification_email_templates_id) REFERENCES email_templates(id),
  CONSTRAINT applications_fk_2 FOREIGN KEY (tenants_id) REFERENCES tenants(id),
  CONSTRAINT applications_fk_3 FOREIGN KEY (access_token_populate_lambdas_id) REFERENCES lambdas(id),
  CONSTRAINT applications_fk_4 FOREIGN KEY (id_token_populate_lambdas_id) REFERENCES lambdas(id),
  CONSTRAINT applications_fk_5 FOREIGN KEY (samlv2_keys_id) REFERENCES `keys`(id),
  CONSTRAINT applications_fk_6 FOREIGN KEY (samlv2_populate_lambdas_id) REFERENCES lambdas(id),
  CONSTRAINT applications_fk_7 FOREIGN KEY (access_token_signing_keys_id) REFERENCES `keys`(id),
  CONSTRAINT applications_fk_8 FOREIGN KEY (id_token_signing_keys_id) REFERENCES `keys`(id),
  CONSTRAINT applications_fk_9 FOREIGN KEY (forms_id) REFERENCES forms(id),
  CONSTRAINT applications_fk_10 FOREIGN KEY (email_verification_email_templates_id) REFERENCES email_templates(id),
  CONSTRAINT applications_fk_11 FOREIGN KEY (forgot_password_email_templates_id) REFERENCES email_templates(id),
  CONSTRAINT applications_fk_12 FOREIGN KEY (passwordless_email_templates_id) REFERENCES email_templates(id),
  CONSTRAINT applications_fk_13 FOREIGN KEY (set_password_email_templates_id) REFERENCES email_templates(id),
  CONSTRAINT applications_fk_14 FOREIGN KEY (samlv2_default_verification_keys_id) REFERENCES `keys`(id),
  CONSTRAINT applications_fk_15 FOREIGN KEY (admin_registration_forms_id) REFERENCES forms(id),
  CONSTRAINT applications_fk_16 FOREIGN KEY (samlv2_logout_keys_id) REFERENCES `keys`(id),
  CONSTRAINT applications_fk_17 FOREIGN KEY (samlv2_logout_default_verification_keys_id) REFERENCES `keys`(id),
  CONSTRAINT applications_fk_18 FOREIGN KEY (samlv2_single_logout_keys_id) REFERENCES `keys`(id),
  CONSTRAINT applications_fk_19 FOREIGN KEY (multi_factor_email_message_templates_id) REFERENCES email_templates(id),
  CONSTRAINT applications_fk_20 FOREIGN KEY (multi_factor_sms_message_templates_id) REFERENCES message_templates(id),
  CONSTRAINT applications_fk_21 FOREIGN KEY (self_service_user_forms_id) REFERENCES forms(id),
  CONSTRAINT applications_fk_22 FOREIGN KEY (themes_id) REFERENCES themes(id),
  CONSTRAINT applications_fk_23 FOREIGN KEY (email_verified_email_templates_id) REFERENCES email_templates(id),
  CONSTRAINT applications_fk_24 FOREIGN KEY (login_new_device_email_templates_id) REFERENCES email_templates(id),
  CONSTRAINT applications_fk_25 FOREIGN KEY (login_suspicious_email_templates_id) REFERENCES email_templates(id),
  CONSTRAINT applications_fk_26 FOREIGN KEY (password_reset_success_email_templates_id) REFERENCES email_templates(id),
  CONSTRAINT applications_fk_27 FOREIGN KEY (ui_ip_access_control_lists_id) REFERENCES ip_access_control_lists(id),
  CONSTRAINT applications_fk_28 FOREIGN KEY (email_update_email_templates_id) REFERENCES email_templates(id),
  CONSTRAINT applications_fk_29 FOREIGN KEY (login_id_in_use_on_create_email_templates_id) REFERENCES email_templates(id),
  CONSTRAINT applications_fk_30 FOREIGN KEY (login_id_in_use_on_update_email_templates_id) REFERENCES email_templates(id),
  CONSTRAINT applications_fk_31 FOREIGN KEY (password_update_email_templates_id) REFERENCES email_templates(id),
  CONSTRAINT applications_fk_32 FOREIGN KEY (two_factor_method_add_email_templates_id) REFERENCES email_templates(id),
  CONSTRAINT applications_fk_33 FOREIGN KEY (two_factor_method_remove_email_templates_id) REFERENCES email_templates(id),
  CONSTRAINT applications_fk_34 FOREIGN KEY (self_service_registration_validation_lambdas_id) REFERENCES lambdas(id),
  CONSTRAINT applications_fk_35 FOREIGN KEY (userinfo_populate_lambdas_id) REFERENCES lambdas(id)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;
CREATE INDEX applications_i_1 ON applications(tenants_id);

CREATE TABLE clean_speak_applications (
  applications_id            BINARY(16) NOT NULL,
  clean_speak_application_id BINARY(16) NOT NULL,
  CONSTRAINT clean_speak_applications_fk_1 FOREIGN KEY (applications_id) REFERENCES applications(id),
  CONSTRAINT clean_speak_applications_uk_1 UNIQUE (applications_id, clean_speak_application_id)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

CREATE TABLE application_roles (
  id                  BINARY(16)   NOT NULL,
  applications_id     BINARY(16)   NOT NULL,
  description         VARCHAR(255) NULL,
  insert_instant      BIGINT       NOT NULL,
  is_default          BIT(1)       NOT NULL,
  is_super_role       BIT(1)       NOT NULL,
  last_update_instant BIGINT       NOT NULL,
  name                VARCHAR(191) NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT application_roles_uk_1 UNIQUE (name, applications_id),
  CONSTRAINT application_roles_fk_1 FOREIGN KEY (applications_id) REFERENCES applications(id)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

CREATE TABLE application_oauth_scopes (
  id                  BINARY(16)   NOT NULL,
  applications_id     BINARY(16)   NOT NULL,
  data                TEXT         NOT NULL,
  insert_instant      BIGINT       NOT NULL,
  last_update_instant BIGINT       NOT NULL,
  name                VARCHAR(191) NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT application_oauth_scopes_fk_1 FOREIGN KEY (applications_id) REFERENCES applications(id),
  CONSTRAINT application_oauth_scopes_uk_1 UNIQUE (applications_id, name)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

CREATE TABLE `groups` (
  id                  BINARY(16)   NOT NULL,
  data                MEDIUMTEXT   NULL,
  insert_instant      BIGINT       NOT NULL,
  last_update_instant BIGINT       NOT NULL,
  name                VARCHAR(191) NOT NULL,
  tenants_id          BINARY(16)   NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT groups_uk_1 UNIQUE (name, tenants_id),
  CONSTRAINT groups_fk_1 FOREIGN KEY (tenants_id) REFERENCES tenants(id)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

CREATE TABLE group_application_roles (
  application_roles_id BINARY(16) NOT NULL,
  groups_id            BINARY(16) NOT NULL,
  CONSTRAINT group_application_roles_uk_1 UNIQUE (groups_id, application_roles_id),
  CONSTRAINT group_application_roles_fk_1 FOREIGN KEY (groups_id) REFERENCES `groups`(id),
  CONSTRAINT group_application_roles_fk_2 FOREIGN KEY (application_roles_id) REFERENCES application_roles(id)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

CREATE TABLE webhooks (
  id                           BINARY(16)   NOT NULL,
  connect_timeout              INTEGER      NOT NULL,
  description                  VARCHAR(255) NULL,
  data                         TEXT         NULL,
  global                       BIT(1)       NOT NULL,
  headers                      TEXT         NULL,
  http_authentication_username VARCHAR(255) NULL,
  http_authentication_password VARCHAR(255) NULL,
  insert_instant               BIGINT       NOT NULL,
  last_update_instant          BIGINT       NOT NULL,
  read_timeout                 INTEGER      NOT NULL,
  signing_keys_id              BINARY(16)   NULL,
  ssl_certificate              TEXT         NULL,
  ssl_certificate_keys_id      BINARY(16)   NULL,
  url                          TEXT         NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT webhooks_fk_1 FOREIGN KEY (ssl_certificate_keys_id) REFERENCES `keys`(id),
  CONSTRAINT webhooks_fk_2 FOREIGN KEY (signing_keys_id) REFERENCES `keys`(id)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

CREATE TABLE webhooks_tenants (
  webhooks_id BINARY(16) NOT NULL,
  tenants_id  BINARY(16) NOT NULL,
  PRIMARY KEY (webhooks_id, tenants_id),
  CONSTRAINT webhooks_tenants_fk_1 FOREIGN KEY (webhooks_id) REFERENCES webhooks(id),
  CONSTRAINT webhooks_tenants_fk_2 FOREIGN KEY (tenants_id) REFERENCES tenants(id)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

-- External Ids
CREATE TABLE external_identifiers (
  id                 VARCHAR(191) NOT NULL,
  applications_id    BINARY(16)   NULL,
  data               TEXT         NULL,
  expiration_instant BIGINT       NULL,
  insert_instant     BIGINT       NOT NULL,
  tenants_id         BINARY(16)   NOT NULL,
  type               SMALLINT     NOT NULL,
  users_id           BINARY(16)   NULL,
  PRIMARY KEY (id),
  CONSTRAINT external_identifiers_fk_1 FOREIGN KEY (users_id) REFERENCES users(id),
  CONSTRAINT external_identifiers_fk_2 FOREIGN KEY (applications_id) REFERENCES applications(id),
  CONSTRAINT external_identifiers_fk_3 FOREIGN KEY (tenants_id) REFERENCES tenants(id)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;
CREATE INDEX external_identifiers_i_1 ON external_identifiers(tenants_id, type, insert_instant);
CREATE INDEX external_identifiers_i_2 ON external_identifiers(type, users_id, applications_id);
CREATE INDEX external_identifiers_i_3 ON external_identifiers(expiration_instant);

CREATE TABLE user_registrations (
  id                   BINARY(16)   NOT NULL,
  applications_id      BINARY(16)   NOT NULL,
  authentication_token VARCHAR(255) NULL,
  clean_speak_id       BINARY(16)   NULL,
  data                 MEDIUMTEXT   NULL,
  insert_instant       BIGINT       NOT NULL,
  last_login_instant   BIGINT       NULL,
  last_update_instant  BIGINT       NOT NULL,
  timezone             VARCHAR(255) NULL,
  username             VARCHAR(191) NULL,
  username_status      SMALLINT     NOT NULL,
  users_id             BINARY(16)   NOT NULL,
  verified             BIT(1)       NOT NULL,
  verified_instant     BIGINT       NULL,
  PRIMARY KEY (id),
  CONSTRAINT user_registrations_uk_1 UNIQUE KEY (applications_id, users_id),
  CONSTRAINT user_registrations_fk_1 FOREIGN KEY (applications_id) REFERENCES applications(id),
  CONSTRAINT user_registrations_fk_2 FOREIGN KEY (users_id) REFERENCES users(id)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;
CREATE INDEX user_registrations_i_1 ON user_registrations(clean_speak_id);
# No need to create an explicit index on applications_id because it is the first key in the UNIQUE constraint
CREATE INDEX user_registrations_i_2 ON user_registrations(users_id);

CREATE TABLE user_registrations_application_roles (
  application_roles_id  BINARY(16) NOT NULL,
  user_registrations_id BINARY(16) NOT NULL,
  CONSTRAINT user_registrations_application_roles_uk_1 UNIQUE (user_registrations_id, application_roles_id),
  CONSTRAINT user_registrations_application_roles_fk_1 FOREIGN KEY (user_registrations_id) REFERENCES user_registrations(id),
  CONSTRAINT user_registrations_application_roles_fk_2 FOREIGN KEY (application_roles_id) REFERENCES application_roles(id)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

CREATE TABLE families (
  data                MEDIUMTEXT NULL,
  family_id           BINARY(16) NOT NULL,
  insert_instant      BIGINT     NOT NULL,
  last_update_instant BIGINT     NOT NULL,
  owner               BIT(1)     NOT NULL,
  role                SMALLINT   NOT NULL,
  users_id            BINARY(16) NOT NULL,
  PRIMARY KEY (family_id, users_id),
  CONSTRAINT families_fk_1 FOREIGN KEY (users_id) REFERENCES users(id)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;
CREATE INDEX families_i_1 ON families(users_id);

CREATE TABLE group_members (
  id             BINARY(16) NOT NULL,
  groups_id      BINARY(16) NOT NULL,
  data           MEDIUMTEXT NULL,
  insert_instant BIGINT     NOT NULL,
  users_id       BINARY(16) NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT group_members_uk_1 UNIQUE (groups_id, users_id),
  CONSTRAINT group_members_fk_1 FOREIGN KEY (users_id) REFERENCES users(id),
  CONSTRAINT group_members_fk_2 FOREIGN KEY (groups_id) REFERENCES `groups`(id)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;
CREATE INDEX group_members_i_1 ON group_members(users_id);
-- No need to create an explicit index on groups_id because it is the first key in the UNIQUE constraint

CREATE TABLE entity_type_permissions (
  id                  BINARY(16)   NOT NULL,
  data                TEXT         NULL,
  description         TEXT         NULL,
  entity_types_id     BINARY(16)   NOT NULL,
  insert_instant      BIGINT       NOT NULL,
  is_default          BIT(1)       NOT NULL,
  last_update_instant BIGINT       NOT NULL,
  name                VARCHAR(191) NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT entity_type_permissions_fk_1 FOREIGN KEY (entity_types_id) REFERENCES entity_types(id) ON DELETE CASCADE,
  CONSTRAINT entity_type_permissions_uk_1 UNIQUE (entity_types_id, name)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

CREATE TABLE entities (
  id                  BINARY(16)   NOT NULL,
  client_id           VARCHAR(191) NOT NULL,
  client_secret       VARCHAR(255) NOT NULL,
  data                TEXT         NULL,
  entity_types_id     BINARY(16)   NOT NULL,
  insert_instant      BIGINT       NOT NULL,
  last_update_instant BIGINT       NOT NULL,
  name                VARCHAR(255) NOT NULL,
  parent_id           BINARY(16)   NULL,
  tenants_id          BINARY(16)   NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT entities_fk_1 FOREIGN KEY (entity_types_id) REFERENCES entity_types(id) ON DELETE CASCADE,
  CONSTRAINT entities_fk_2 FOREIGN KEY (parent_id) REFERENCES entities(id) ON DELETE CASCADE,
  CONSTRAINT entities_fk_3 FOREIGN KEY (tenants_id) REFERENCES tenants(id) ON DELETE CASCADE,
  CONSTRAINT entities_uk_1 UNIQUE (client_id)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

CREATE TABLE entity_entity_grants (
  id                  BINARY(16) NOT NULL,
  data                TEXT       NULL,
  insert_instant      BIGINT     NOT NULL,
  last_update_instant BIGINT     NOT NULL,
  recipient_id        BINARY(16) NOT NULL,
  target_id           BINARY(16) NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT entity_entity_grants_fk_1 FOREIGN KEY (recipient_id) REFERENCES entities(id) ON DELETE CASCADE,
  CONSTRAINT entity_entity_grants_fk_2 FOREIGN KEY (target_id) REFERENCES entities(id) ON DELETE CASCADE,
  CONSTRAINT entity_entity_grants_uk_1 UNIQUE (recipient_id, target_id)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;


CREATE TABLE entity_entity_grant_permissions (
  entity_entity_grants_id    BINARY(16) NOT NULL,
  entity_type_permissions_id BINARY(16) NOT NULL,
  CONSTRAINT entity_entity_grant_permissions_fk_1 FOREIGN KEY (entity_entity_grants_id) REFERENCES entity_entity_grants(id) ON DELETE CASCADE,
  CONSTRAINT entity_entity_grant_permissions_fk_2 FOREIGN KEY (entity_type_permissions_id) REFERENCES entity_type_permissions(id) ON DELETE CASCADE,
  CONSTRAINT entity_entity_grant_permissions_uk_1 UNIQUE (entity_entity_grants_id, entity_type_permissions_id)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

CREATE TABLE entity_user_grants (
  id                  BINARY(16) NOT NULL,
  data                TEXT       NULL,
  entities_id         BINARY(16) NOT NULL,
  insert_instant      BIGINT     NOT NULL,
  last_update_instant BIGINT     NOT NULL,
  users_id            BINARY(16) NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT entity_user_grants_fk_1 FOREIGN KEY (entities_id) REFERENCES entities(id) ON DELETE CASCADE,
  CONSTRAINT entity_user_grants_fk_2 FOREIGN KEY (users_id) REFERENCES users(id) ON DELETE CASCADE,
  CONSTRAINT entity_user_grants_uk_1 UNIQUE (entities_id, users_id)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;
CREATE INDEX entity_user_grants_i_1 ON entity_user_grants(users_id);

CREATE TABLE entity_user_grant_permissions (
  entity_user_grants_id      BINARY(16) NOT NULL,
  entity_type_permissions_id BINARY(16) NOT NULL,
  CONSTRAINT entity_user_grant_permissions_fk_1 FOREIGN KEY (entity_user_grants_id) REFERENCES entity_user_grants(id) ON DELETE CASCADE,
  CONSTRAINT entity_user_grant_permissions_fk_2 FOREIGN KEY (entity_type_permissions_id) REFERENCES entity_type_permissions(id) ON DELETE CASCADE,
  CONSTRAINT entity_user_grant_permissions_uk_1 UNIQUE (entity_user_grants_id, entity_type_permissions_id)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

CREATE TABLE scim_external_id_groups (
  entities_id BINARY(16)   NOT NULL,
  external_id VARCHAR(255) NOT NULL,
  groups_id   BINARY(16)   NOT NULL,
  CONSTRAINT scim_external_id_groups_fk_1 FOREIGN KEY (entities_id) REFERENCES entities(id),
  CONSTRAINT scim_external_id_groups_fk_2 FOREIGN KEY (groups_id) REFERENCES `groups`(id)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;
CREATE INDEX scim_external_id_groups_i_1 ON scim_external_id_groups(entities_id, external_id);
CREATE INDEX scim_external_id_groups_i_2 ON scim_external_id_groups(entities_id, groups_id);

CREATE TABLE scim_external_id_users (
  entities_id BINARY(16)   NOT NULL,
  external_id VARCHAR(255) NOT NULL,
  users_id    BINARY(16)   NOT NULL,
  CONSTRAINT scim_external_id_users_fk_1 FOREIGN KEY (entities_id) REFERENCES entities(id),
  CONSTRAINT scim_external_id_users_fk_2 FOREIGN KEY (users_id) REFERENCES users(id)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;
CREATE INDEX scim_external_id_users_i_1 ON scim_external_id_users(entities_id, external_id);
CREATE INDEX scim_external_id_users_i_2 ON scim_external_id_users(entities_id, users_id);

CREATE TABLE user_action_logs (
  id                 BINARY(16)   NOT NULL,
  actioner_users_id  BINARY(16)   NULL,
  actionee_users_id  BINARY(16)   NOT NULL,
  comment            TEXT         NULL,
  email_user_on_end  BIT(1)       NOT NULL,
  end_event_sent     BIT(1)       NULL,
  expiry             BIGINT       NULL,
  history            TEXT         NULL,
  insert_instant     BIGINT       NOT NULL,
  localized_name     VARCHAR(191) NULL,
  localized_option   VARCHAR(255) NULL,
  localized_reason   VARCHAR(255) NULL,
  name               VARCHAR(191) NULL,
  notify_user_on_end BIT(1)       NOT NULL,
  option_name        VARCHAR(255) NULL,
  reason             VARCHAR(255) NULL,
  reason_code        VARCHAR(255) NULL,
  user_actions_id    BINARY(16)   NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT user_action_logs_fk_1 FOREIGN KEY (actioner_users_id) REFERENCES users(id),
  CONSTRAINT user_action_logs_fk_2 FOREIGN KEY (actionee_users_id) REFERENCES users(id),
  CONSTRAINT user_action_logs_fk_3 FOREIGN KEY (user_actions_id) REFERENCES user_actions(id)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;
CREATE INDEX user_action_logs_i_1 ON user_action_logs(insert_instant);
CREATE INDEX user_action_logs_i_2 ON user_action_logs(expiry, end_event_sent);

CREATE TABLE user_action_logs_applications (
  applications_id     BINARY(16) NOT NULL,
  user_action_logs_id BINARY(16) NOT NULL,
  CONSTRAINT user_action_logs_applications_fk_1 FOREIGN KEY (applications_id) REFERENCES applications(id)
    ON DELETE CASCADE,
  CONSTRAINT user_action_logs_applications_fk_2 FOREIGN KEY (user_action_logs_id) REFERENCES user_action_logs(id)
    ON DELETE CASCADE
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

CREATE TABLE user_comments (
  id             BINARY(16) NOT NULL,
  comment        TEXT       NULL,
  commenter_id   BINARY(16) NOT NULL,
  insert_instant BIGINT     NOT NULL,
  users_id       BINARY(16) NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT user_comments_fk_1 FOREIGN KEY (users_id) REFERENCES users(id),
  CONSTRAINT user_comments_fk_2 FOREIGN KEY (commenter_id) REFERENCES users(id)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;
CREATE INDEX user_comments_i_1 ON user_comments(insert_instant);
CREATE INDEX user_comments_i_2 ON user_comments(users_id);
CREATE INDEX user_comments_i_3 ON user_comments(commenter_id);

CREATE TABLE authentication_keys (
  id                         BINARY(16)   NOT NULL,
  insert_instant             BIGINT       NOT NULL,
  ip_access_control_lists_id BINARY(16)   NULL,
  last_update_instant        BIGINT       NOT NULL,
  key_manager                BIT(1)       NOT NULL,
  key_value                  VARCHAR(191) NOT NULL,
  permissions                TEXT         NULL,
  meta_data                  TEXT         NULL,
  tenants_id                 BINARY(16)   NULL,
  PRIMARY KEY (id),
  CONSTRAINT authentication_keys_fk_1 FOREIGN KEY (tenants_id) REFERENCES tenants(id),
  CONSTRAINT authentication_keys_fk_2 FOREIGN KEY (ip_access_control_lists_id) REFERENCES ip_access_control_lists(id),
  CONSTRAINT authentication_keys_uk_1 UNIQUE (key_value)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

CREATE TABLE system_configuration (
  data                LONGTEXT     NOT NULL,
  insert_instant      BIGINT       NOT NULL,
  last_update_instant BIGINT       NOT NULL,
  report_timezone     VARCHAR(255) NOT NULL
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

CREATE TABLE raw_logins (
  applications_id BINARY(16)   NULL,
  instant         BIGINT       NOT NULL,
  ip_address      VARCHAR(255) NULL,
  users_id        BINARY(16)   NOT NULL,
  CONSTRAINT raw_logins_fk_1 FOREIGN KEY (applications_id) REFERENCES applications(id),
  CONSTRAINT raw_logins_fk_2 FOREIGN KEY (users_id) REFERENCES users(id)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;
CREATE INDEX raw_logins_i_1 ON raw_logins(instant);
CREATE INDEX raw_logins_i_2 ON raw_logins(users_id, instant);

CREATE TABLE hourly_logins (
  applications_id BINARY(16) NOT NULL,
  count           INTEGER    NOT NULL,
  data            TEXT       NULL,
  hour            INTEGER    NOT NULL,
  CONSTRAINT hourly_logins_fk_1 FOREIGN KEY (applications_id) REFERENCES applications(id),
  CONSTRAINT hourly_logins_uk_1 UNIQUE (applications_id, hour)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

CREATE TABLE raw_global_daily_active_users (
  day      INTEGER    NOT NULL,
  users_id BINARY(16) NOT NULL,
  CONSTRAINT raw_global_daily_active_users_uk_1 UNIQUE (day, users_id)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

CREATE TABLE global_daily_active_users (
  count INTEGER NOT NULL,
  day   INTEGER NOT NULL,
  CONSTRAINT global_daily_active_users_uk_1 UNIQUE (day)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

CREATE TABLE raw_application_daily_active_users (
  applications_id BINARY(16) NOT NULL,
  day             INTEGER    NOT NULL,
  users_id        BINARY(16) NOT NULL,
  CONSTRAINT raw_application_daily_active_users_uk_1 UNIQUE (applications_id, day, users_id)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

CREATE TABLE application_daily_active_users (
  applications_id BINARY(16) NOT NULL,
  count           INTEGER    NOT NULL,
  day             INTEGER    NOT NULL,
  CONSTRAINT application_daily_active_users_fk_1 FOREIGN KEY (applications_id) REFERENCES applications(id),
  CONSTRAINT application_daily_active_users_uk_1 UNIQUE (applications_id, day)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

CREATE TABLE raw_global_monthly_active_users (
  month    INTEGER    NOT NULL,
  users_id BINARY(16) NOT NULL,
  CONSTRAINT raw_global_monthly_active_users_uk_1 UNIQUE (month, users_id)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

CREATE TABLE global_monthly_active_users (
  count INTEGER NOT NULL,
  month INTEGER NOT NULL,
  CONSTRAINT global_monthly_active_users_uk_1 UNIQUE (month)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

CREATE TABLE raw_application_monthly_active_users (
  applications_id BINARY(16) NOT NULL,
  month           INTEGER    NOT NULL,
  users_id        BINARY(16) NOT NULL,
  CONSTRAINT raw_application_monthly_active_users_uk_1 UNIQUE (applications_id, month, users_id)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

CREATE TABLE application_monthly_active_users (
  applications_id BINARY(16) NOT NULL,
  count           INTEGER    NOT NULL,
  month           INTEGER    NOT NULL,
  CONSTRAINT application_monthly_active_users_fk_1 FOREIGN KEY (applications_id) REFERENCES applications(id),
  CONSTRAINT application_monthly_active_users_uk_1 UNIQUE (applications_id, month)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

CREATE TABLE global_registration_counts (
  count             INTEGER NOT NULL,
  decremented_count INTEGER NOT NULL,
  hour              INTEGER NOT NULL,
  CONSTRAINT global_registration_counts_uk_1 UNIQUE (hour)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

CREATE TABLE raw_global_registration_counts (
  id                BIGINT  NOT NULL AUTO_INCREMENT,
  count             INTEGER NOT NULL,
  decremented_count INTEGER NOT NULL,
  hour              INTEGER NOT NULL,
  PRIMARY KEY (id)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

CREATE TABLE application_registration_counts (
  applications_id   BINARY(16) NOT NULL,
  count             INTEGER    NOT NULL,
  decremented_count INTEGER    NOT NULL,
  hour              INTEGER    NOT NULL,
  CONSTRAINT application_registration_counts_fk_1 FOREIGN KEY (applications_id) REFERENCES applications(id),
  CONSTRAINT application_registration_counts_uk_1 UNIQUE (applications_id, hour)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

CREATE TABLE raw_application_registration_counts (
  id                BIGINT     NOT NULL AUTO_INCREMENT,
  applications_id   BINARY(16) NOT NULL,
  count             INTEGER    NOT NULL,
  decremented_count INTEGER    NOT NULL,
  hour              INTEGER    NOT NULL,
  PRIMARY KEY (id)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

CREATE TABLE audit_logs (
  id             BIGINT       NOT NULL AUTO_INCREMENT,
  insert_instant BIGINT       NOT NULL,
  insert_user    VARCHAR(255) NOT NULL,
  message        TEXT         NOT NULL,
  data           MEDIUMTEXT   NULL,
  PRIMARY KEY (id)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;
CREATE INDEX audit_logs_i1 ON audit_logs(insert_instant);

CREATE TABLE event_logs (
  id             BIGINT     NOT NULL AUTO_INCREMENT,
  insert_instant BIGINT     NOT NULL,
  message        MEDIUMTEXT NOT NULL,
  type           SMALLINT   NOT NULL,
  PRIMARY KEY (id)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;
CREATE INDEX event_logs_i1 ON event_logs(insert_instant);

CREATE TABLE locks (
  type           VARCHAR(191) NOT NULL,
  update_instant BIGINT       NULL,
  PRIMARY KEY (type)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

CREATE TABLE master_record (
  id      BINARY(16) NOT NULL,
  instant BIGINT     NOT NULL
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

-- Refresh Tokens
CREATE TABLE refresh_tokens (
  id              BINARY(16)   NOT NULL,
  applications_id BINARY(16)   NULL,
  data            TEXT         NOT NULL,
  insert_instant  BIGINT       NOT NULL,
  start_instant   BIGINT       NOT NULL,
  tenants_id      BINARY(16)   NULL,
  token           VARCHAR(191) NULL,
  token_hash      CHAR(64)     NULL,
  token_text      TEXT         NULL,
  users_id        BINARY(16)   NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT refresh_tokens_fk_1 FOREIGN KEY (users_id) REFERENCES users(id),
  CONSTRAINT refresh_tokens_fk_2 FOREIGN KEY (applications_id) REFERENCES applications(id),
  CONSTRAINT refresh_tokens_fk_3 FOREIGN KEY (tenants_id) REFERENCES tenants(id),
  CONSTRAINT refresh_tokens_uk_1 UNIQUE (token),
  CONSTRAINT refresh_tokens_uk_2 UNIQUE (token_hash)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;
CREATE INDEX refresh_tokens_i_1 ON refresh_tokens(start_instant);
CREATE INDEX refresh_tokens_i_2 ON refresh_tokens(applications_id);
CREATE INDEX refresh_tokens_i_3 ON refresh_tokens(users_id);
CREATE INDEX refresh_tokens_i_4 ON refresh_tokens(tenants_id);

-- Previous Passwords
CREATE TABLE previous_passwords (
  insert_instant    BIGINT       NOT NULL,
  encryption_scheme VARCHAR(255) NOT NULL,
  factor            INTEGER      NOT NULL,
  password          VARCHAR(255) NOT NULL,
  salt              VARCHAR(255) NOT NULL,
  users_id          BINARY(16)   NOT NULL,
  CONSTRAINT previous_passwords_fk_1 FOREIGN KEY (users_id) REFERENCES users(id),
  CONSTRAINT previous_passwords_uk_1 UNIQUE (users_id, insert_instant)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;
# No need to create an explicit index on users_id because it is the first key in the UNIQUE constraint

CREATE TABLE version (
  version VARCHAR(255) NOT NULL
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

-- Migrations Table
CREATE TABLE migrations (
  name        VARCHAR(191) NOT NULL,
  run_instant BIGINT       NOT NULL,
  PRIMARY KEY (name)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

-- Integrations
CREATE TABLE integrations (
  data TEXT NOT NULL
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

-- Identity Providers
CREATE TABLE identity_providers (
  id                      BINARY(16)   NOT NULL,
  data                    TEXT         NOT NULL,
  enabled                 BIT(1)       NOT NULL,
  insert_instant          BIGINT       NOT NULL,
  last_update_instant     BIGINT       NOT NULL,
  name                    VARCHAR(191) NOT NULL,
  type                    VARCHAR(255) NOT NULL,
  keys_id                 BINARY(16)   NULL,
  request_signing_keys_id BINARY(16)   NULL,
  reconcile_lambdas_id    BINARY(16)   NULL,
  PRIMARY KEY (id),
  CONSTRAINT identity_providers_uk_1 UNIQUE (name),
  CONSTRAINT identity_providers_fk_1 FOREIGN KEY (keys_id) REFERENCES `keys`(id),
  CONSTRAINT identity_providers_fk_2 FOREIGN KEY (reconcile_lambdas_id) REFERENCES lambdas(id),
  CONSTRAINT identity_providers_fk_3 FOREIGN KEY (request_signing_keys_id) REFERENCES `keys`(id)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

CREATE TABLE identity_providers_applications (
  applications_id       BINARY(16) NOT NULL,
  data                  TEXT       NOT NULL,
  enabled               BIT(1)     NOT NULL,
  identity_providers_id BINARY(16) NOT NULL,
  keys_id               BINARY(16) NULL,
  CONSTRAINT identity_providers_applications_fk_1 FOREIGN KEY (applications_id) REFERENCES applications(id),
  CONSTRAINT identity_providers_applications_fk_2 FOREIGN KEY (identity_providers_id) REFERENCES identity_providers(id),
  CONSTRAINT identity_providers_applications_fk_3 FOREIGN KEY (keys_id) REFERENCES `keys`(id)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

CREATE TABLE identity_providers_tenants (
  tenants_id            BINARY(16) NOT NULL,
  data                  TEXT       NOT NULL,
  identity_providers_id BINARY(16) NOT NULL,
  CONSTRAINT identity_providers_tenants_fk_1 FOREIGN KEY (tenants_id) REFERENCES tenants(id),
  CONSTRAINT identity_providers_tenants_fk_2 FOREIGN KEY (identity_providers_id) REFERENCES identity_providers(id)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

CREATE TABLE identity_provider_links (
  data                       TEXT         NOT NULL,
  identity_providers_id      BINARY(16)   NOT NULL,
  identity_providers_user_id VARCHAR(191) NOT NULL,
  insert_instant             BIGINT       NOT NULL,
  last_login_instant         BIGINT       NOT NULL,
  tenants_id                 BINARY(16)   NOT NULL,
  users_id                   BINARY(16)   NOT NULL,
  CONSTRAINT identity_provider_links_uk_1 UNIQUE (identity_providers_id, identity_providers_user_id, tenants_id),
  CONSTRAINT identity_provider_links_fk_1 FOREIGN KEY (identity_providers_id) REFERENCES identity_providers(id),
  CONSTRAINT identity_provider_links_fk_2 FOREIGN KEY (tenants_id) REFERENCES tenants(id),
  CONSTRAINT identity_provider_links_fk_3 FOREIGN KEY (users_id) REFERENCES users(id)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;
CREATE INDEX identity_provider_links_i_1 ON identity_provider_links(users_id);

CREATE TABLE federated_domains (
  identity_providers_id BINARY(16)   NOT NULL,
  domain                VARCHAR(191) NOT NULL,
  CONSTRAINT federated_domains_fk_1 FOREIGN KEY (identity_providers_id) REFERENCES identity_providers(id),
  CONSTRAINT federated_domains_uk_1 UNIQUE (domain)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

-- Request frequencies for rate limiting
CREATE TABLE request_frequencies (
  count               INTEGER      NOT NULL,
  last_update_instant BIGINT       NOT NULL,
  request_id          VARCHAR(191) NOT NULL,
  tenants_id          BINARY(16)   NOT NULL,
  type                SMALLINT     NOT NULL,
  CONSTRAINT request_frequencies_fk_1 FOREIGN KEY (tenants_id) REFERENCES tenants(id),
  CONSTRAINT request_frequencies_uk_1 UNIQUE (tenants_id, type, request_id)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;
CREATE INDEX request_frequencies_i_1 ON request_frequencies(tenants_id, type, last_update_instant);

-- Nodes
CREATE TABLE nodes (
  id                   BINARY(16)   NOT NULL,
  data                 TEXT         NOT NULL,
  insert_instant       BIGINT       NOT NULL,
  last_checkin_instant BIGINT       NOT NULL,
  runtime_mode         VARCHAR(255) NOT NULL,
  url                  VARCHAR(255) NOT NULL,
  PRIMARY KEY (id)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

-- Connectors
CREATE TABLE connectors (
  id                      BINARY(16)   NOT NULL,
  data                    TEXT         NOT NULL,
  insert_instant          BIGINT       NOT NULL,
  last_update_instant     BIGINT       NOT NULL,
  name                    VARCHAR(191) NOT NULL,
  reconcile_lambdas_id    BINARY(16)   NULL,
  ssl_certificate_keys_id BINARY(16)   NULL,
  type                    SMALLINT     NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT connectors_uk_1 UNIQUE (name),
  CONSTRAINT connectors_fk_1 FOREIGN KEY (ssl_certificate_keys_id) REFERENCES `keys`(id),
  CONSTRAINT connectors_fk_2 FOREIGN KEY (reconcile_lambdas_id) REFERENCES lambdas(id)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

-- Identities
CREATE TABLE identities (
  id                                     BIGINT       NOT NULL AUTO_INCREMENT,
  breached_password_last_checked_instant BIGINT       NULL,
  breached_password_status               SMALLINT     NULL,
  connectors_id                          BINARY(16)   NOT NULL,
  email                                  VARCHAR(191) NULL,
  encryption_scheme                      VARCHAR(255) NOT NULL,
  factor                                 INTEGER      NOT NULL,
  insert_instant                         BIGINT       NOT NULL,
  last_login_instant                     BIGINT       NULL,
  last_update_instant                    BIGINT       NOT NULL,
  password                               VARCHAR(255) NOT NULL,
  password_change_reason                 SMALLINT     NULL,
  password_change_required               BIT(1)       NOT NULL,
  password_last_update_instant           BIGINT       NOT NULL,
  salt                                   VARCHAR(255) NOT NULL,
  status                                 SMALLINT     NOT NULL,
  tenants_id                             BINARY(16)   NOT NULL,
  username                               VARCHAR(191) NULL,
  username_index                         VARCHAR(191) NULL,
  username_status                        SMALLINT     NOT NULL,
  users_id                               BINARY(16)   NOT NULL,
  verified                               BIT(1)       NOT NULL,
  verified_instant                       BIGINT       NULL,
  PRIMARY KEY (id),
  CONSTRAINT identities_uk_1 UNIQUE (email, tenants_id),
  CONSTRAINT identities_uk_2 UNIQUE (username_index, tenants_id),
  CONSTRAINT identities_fk_1 FOREIGN KEY (tenants_id) REFERENCES tenants(id),
  CONSTRAINT identities_fk_2 FOREIGN KEY (users_id) REFERENCES users(id)
  -- No foreign key to connectors because they can be broken if a connector is removed from a tenant or deleted
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;
CREATE INDEX identities_i_1 ON identities(users_id);

CREATE TABLE instance (
  id               BINARY(16)   NOT NULL,
  activate_instant BIGINT       NULL,
  data             TEXT         NULL,
  license          TEXT         NULL,
  license_id       VARCHAR(255) NULL,
  setup_complete   BIT(1)       NOT NULL
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

-- Common breached passwords
CREATE TABLE common_breached_passwords (
  password VARCHAR(191) NOT NULL,
  PRIMARY KEY (password)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

-- Data sets
CREATE TABLE data_sets (
  name                VARCHAR(191) NOT NULL,
  last_update_instant BIGINT       NOT NULL,
  PRIMARY KEY (name)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

-- Breached Password Metrics
CREATE TABLE breached_password_metrics (
  tenants_id                    BINARY(16) NOT NULL,
  matched_exact_count           INT        NOT NULL,
  matched_sub_address_count     INT        NOT NULL,
  matched_common_password_count INT        NOT NULL,
  matched_password_count        INT        NOT NULL,
  passwords_checked_count       INT        NOT NULL,
  PRIMARY KEY (tenants_id),
  CONSTRAINT breached_password_metrics_fk_1 FOREIGN KEY (tenants_id) REFERENCES tenants(id)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

CREATE TABLE connectors_tenants (
  connectors_id BINARY(16) NOT NULL,
  data          TEXT       NOT NULL,
  sequence      SMALLINT   NOT NULL,
  tenants_id    BINARY(16) NOT NULL,
  PRIMARY KEY (connectors_id, tenants_id),
  CONSTRAINT connectors_tenants_uk_1 UNIQUE (connectors_id, tenants_id, sequence),
  CONSTRAINT connectors_tenants_fk_1 FOREIGN KEY (connectors_id) REFERENCES connectors(id),
  CONSTRAINT connectors_tenants_fk_2 FOREIGN KEY (tenants_id) REFERENCES tenants(id)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

-- Async tasks
CREATE TABLE asynchronous_tasks (
  id                  BINARY(16) NOT NULL,
  data                TEXT       NULL,
  entity_id           BINARY(16) NULL,
  insert_instant      BIGINT     NOT NULL,
  last_update_instant BIGINT     NOT NULL,
  nodes_id            BINARY(16) NULL,
  status              SMALLINT   NOT NULL,
  type                SMALLINT   NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT asynchronous_tasks_uk_1 UNIQUE (entity_id),
  CONSTRAINT asynchronous_tasks_fk_1 FOREIGN KEY (nodes_id) REFERENCES nodes(id)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

CREATE TABLE kickstart_files (
  id        BINARY(16)   NOT NULL,
  kickstart MEDIUMBLOB   NOT NULL,
  name      VARCHAR(255) NOT NULL,
  PRIMARY KEY (id)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

-- IP-to-location database
-- Note that the entire row must be less than 8k.
-- BLOB = L + 2, BIGINT = 8, INT = 4, total = 14. Max size of data is then 8178.
CREATE TABLE ip_location_database (
  data          BLOB   NOT NULL,
  last_modified BIGINT NOT NULL,
  seq           INT    NOT NULL,
  PRIMARY KEY (last_modified, seq)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

CREATE TABLE ip_location_meta_data (
  digest        VARCHAR(255) NOT NULL,
  last_modified BIGINT       NOT NULL,
  PRIMARY KEY (last_modified)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;


-- Used for bulk updating users and registrations last_update_instant
CREATE TABLE last_login_instants (
  applications_id                 BINARY(16) NULL,
  registration_last_login_instant BIGINT     NULL,
  users_id                        BINARY(16) NULL,
  user_last_login_instant         BIGINT     NULL
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;

-- Used for storing WebAuthn public key credentials
CREATE TABLE webauthn_credentials (
  id               BINARY(16) NOT NULL,
  credential_id    TEXT       NOT NULL,
  data             MEDIUMTEXT NOT NULL,
  insert_instant   BIGINT     NOT NULL,
  last_use_instant BIGINT     NOT NULL,
  tenants_id       BINARY(16) NOT NULL,
  users_id         BINARY(16) NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT webauthn_credentials_fk_1 FOREIGN KEY (tenants_id) REFERENCES tenants(id),
  CONSTRAINT webauthn_credentials_fk_2 FOREIGN KEY (users_id) REFERENCES users(id)
)
  ENGINE = innodb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_bin;
CREATE INDEX webauthn_credentials_i_1 ON webauthn_credentials(tenants_id, users_id);

--
-- Insert the initial data
--

INSERT INTO version(version)
  VALUES ('1.51.2');

-- Insert instance
INSERT INTO instance(id, setup_complete)
  VALUES (UNHEX(REPLACE(CONVERT(UUID() USING utf8mb4), '-', '')), FALSE);

-- Insert locks
INSERT INTO locks(type)
  VALUES ('UserActionEndEvent'),
    ('EmailPlus'),
    ('Family'),
    ('com.inversoft.migration.Migrator'),
    ('Reindex'),
    ('Reset'),
    ('AsyncTaskManager'),
    ('ProcessLastLoginInstants');

-- Initial master record
INSERT INTO master_record(id, instant)
  VALUES (x'00000000000000000000000000000000', 0);

-- Insert the default signing key and the 'shadow' client secret keys, increment insert_instant by 1 second each time to ensure order can be predicted
INSERT INTO `keys` (id, algorithm, insert_instant, kid, last_update_instant, name, secret, type)
  VALUES (UNHEX(REPLACE(CONVERT(UUID() USING utf8mb4), '-', '')), 'HS256', FLOOR((UNIX_TIMESTAMP(NOW(3)) - 4) * 1000), SUBSTRING(MD5(RAND()), 2, 10), FLOOR((UNIX_TIMESTAMP(NOW(3)) - 4) * 1000), 'Default signing key', TO_BASE64(SUBSTR(CONCAT(MD5(RAND()), MD5(RAND())), 3, 32)), 'HMAC'),
    (0x092dbedc30af41499c61b578f2c72f59, 'HS256', FLOOR((UNIX_TIMESTAMP(NOW(3)) - 3) * 1000), SUBSTRING(MD5(RAND()), 2, 10), FLOOR((UNIX_TIMESTAMP(NOW(3)) - 3) * 1000), 'OpenID Connect compliant HMAC using SHA-256', NULL, 'HMAC'),
    (0x4b8f1c06518e45bd9ac5d549686ae02a, 'HS384', FLOOR((UNIX_TIMESTAMP(NOW(3)) - 2) * 1000), SUBSTRING(MD5(RAND()), 2, 10), FLOOR((UNIX_TIMESTAMP(NOW(3)) - 2) * 1000), 'OpenID Connect compliant HMAC using SHA-384', NULL, 'HMAC'),
    (0xc753a44d7f2e48d3bc4ec2c16488a23b, 'HS512', FLOOR((UNIX_TIMESTAMP(NOW(3)) - 1) * 1000), SUBSTRING(MD5(RAND()), 2, 10), FLOOR((UNIX_TIMESTAMP(NOW(3)) - 1) * 1000), 'OpenID Connect compliant HMAC using SHA-512', NULL, 'HMAC');

-- Insert default theme
INSERT INTO themes(id, insert_instant, last_update_instant, name, data)
  VALUES (0x75a068fde94b451a9aeb3ddb9a3b5987, FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), 'FusionAuth', '{}');

-- Insert the default simple theme
INSERT INTO themes(id, insert_instant, last_update_instant, name, data)
  VALUES (0x3C7172915D834014BD5197C76475DC86, FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), 'FusionAuth - Simple', '{"type": "simple"}');

-- Insert some default Form Fields. These were shipped in 1.18.0 for use by Self Service Registration forms
-- Note, any changes made to these fields needs to also be reflected in FormService.ManagedFields
INSERT INTO form_fields (id, data, insert_instant, last_update_instant, name)
  VALUES (UNHEX(REPLACE(CONVERT(UUID() USING utf8mb4), '-', '')), '{"key": "user.email", "control": "text", "required": true, "type": "email", "data": {"leftAddon": "user"}}', FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), 'email'),
    (UNHEX(REPLACE(CONVERT(UUID() USING utf8mb4), '-', '')), '{"key": "user.password", "control": "password", "required": true, "type": "string", "data": {"leftAddon": "lock"}}', FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), 'password'),
    (UNHEX(REPLACE(CONVERT(UUID() USING utf8mb4), '-', '')), '{"key": "user.firstName", "control": "text", "required": false, "type": "string", "data": {"leftAddon": "info"}}', FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), 'first name'),
    (UNHEX(REPLACE(CONVERT(UUID() USING utf8mb4), '-', '')), '{"key": "user.middleName", "control": "text", "required": false, "type": "string", "data": {"leftAddon": "info"}}', FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), 'middle name'),
    (UNHEX(REPLACE(CONVERT(UUID() USING utf8mb4), '-', '')), '{"key": "user.lastName", "control": "text", "required": false, "type": "string", "data": {"leftAddon": "info"}}', FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), 'last name'),
    (UNHEX(REPLACE(CONVERT(UUID() USING utf8mb4), '-', '')), '{"key": "user.fullName", "control": "text", "required": false, "type": "string", "data": {"leftAddon": "info"}}', FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), 'full name'),
    (UNHEX(REPLACE(CONVERT(UUID() USING utf8mb4), '-', '')), '{"key": "user.birthDate", "control": "text", "required": false, "type": "date", "data": {"leftAddon": "calendar"}}', FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), 'birthdate'),
    (UNHEX(REPLACE(CONVERT(UUID() USING utf8mb4), '-', '')), '{"key": "user.mobilePhone", "control": "text", "required": false, "type": "string", "data": {"leftAddon": "mobile"}}', FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), 'mobile phone'),
    (UNHEX(REPLACE(CONVERT(UUID() USING utf8mb4), '-', '')), '{"key": "user.username", "control": "text", "required": true, "type": "string", "data": {"leftAddon": "user"}}', FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), 'username');

-- Insert form field required for registration flows that include parent/child relationships based on tenant family configuration
-- Note, any changes made to this/these fields needs to also be reflected in FormService.ManagedFields
INSERT INTO form_fields (id, data, insert_instant, last_update_instant, name)
  VALUES (UNHEX(REPLACE(CONVERT(UUID() USING utf8mb4), '-', '')), '{"key": "user.parentEmail", "control": "text", "required": false, "type": "email", "data": {"leftAddon": "user"}}', FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), '[Registration] parent email');

-- Insert new fields for default Admin User and Admin Registration forms
-- Note, any changes made to these fields needs to also be reflected in FormService.ManagedFields
INSERT INTO form_fields (id, data, insert_instant, last_update_instant, name)
  VALUES (UNHEX(REPLACE(CONVERT(UUID() USING utf8mb4), '-', '')), '{"key": "registration.preferredLanguages", "control": "select", "required": false, "type": "string", "data": {"leftAddon": "info"}}', FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), '[Admin Registration] preferred languages'),
    (UNHEX(REPLACE(CONVERT(UUID() USING utf8mb4), '-', '')), '{"key": "registration.roles", "control": "checkbox", "required": false, "type": "string", "data": {"leftAddon": "info"}}', FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), '[Admin Registration] roles'),
    (UNHEX(REPLACE(CONVERT(UUID() USING utf8mb4), '-', '')), '{"key": "registration.timezone", "control": "select", "required": false, "type": "string", "data": {"leftAddon": "info"}}', FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), '[Admin Registration] timezone'),
    (UNHEX(REPLACE(CONVERT(UUID() USING utf8mb4), '-', '')), '{"key": "registration.username", "control": "text", "required": false, "type": "string", "data": {"leftAddon": "user"}}', FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), '[Admin Registration] username'),
    (UNHEX(REPLACE(CONVERT(UUID() USING utf8mb4), '-', '')), '{"key": "user.birthDate", "control": "text", "required": false, "type": "date", "data": {"leftAddon": "calendar"}}', FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), '[Admin User] birthdate'),
    (UNHEX(REPLACE(CONVERT(UUID() USING utf8mb4), '-', '')), '{"key": "user.email", "control": "text", "required": false, "type": "email", "data": {"leftAddon": "user"}}', FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), '[Admin User] email'),
    (UNHEX(REPLACE(CONVERT(UUID() USING utf8mb4), '-', '')), '{"key": "user.firstName", "control": "text", "required": false, "type": "string", "data": {"leftAddon": "info"}}', FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), '[Admin User] first name'),
    (UNHEX(REPLACE(CONVERT(UUID() USING utf8mb4), '-', '')), '{"key": "user.fullName", "control": "text", "required": false, "type": "string", "data": {"leftAddon": "info"}}', FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), '[Admin User] full name'),
    (UNHEX(REPLACE(CONVERT(UUID() USING utf8mb4), '-', '')), '{"key": "user.imageUrl", "control": "text", "required": false, "type": "string", "data": {"leftAddon": "info"}}', FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), '[Admin User] image URL'),
    (UNHEX(REPLACE(CONVERT(UUID() USING utf8mb4), '-', '')), '{"key": "user.lastName", "control": "text", "required": false, "type": "string", "data": {"leftAddon": "info"}}', FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), '[Admin User] last name'),
    (UNHEX(REPLACE(CONVERT(UUID() USING utf8mb4), '-', '')), '{"key": "user.middleName", "control": "text", "required": false, "type": "string", "data": {"leftAddon": "info"}}', FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), '[Admin User] middle name'),
    (UNHEX(REPLACE(CONVERT(UUID() USING utf8mb4), '-', '')), '{"key": "user.mobilePhone", "control": "text", "required": false, "type": "string", "data": {"leftAddon": "mobile"}}', FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), '[Admin User] mobile phone'),
    (UNHEX(REPLACE(CONVERT(UUID() USING utf8mb4), '-', '')), '{"key": "user.password", "control": "password", "required": true, "confirm": true, "type": "string", "data": {"leftAddon": "lock"}}', FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), '[Admin User] password'),
    (UNHEX(REPLACE(CONVERT(UUID() USING utf8mb4), '-', '')), '{"key": "user.preferredLanguages", "control": "select", "required": false, "type": "string", "data": {"leftAddon": "info"}}', FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), '[Admin User] preferred languages'),
    (UNHEX(REPLACE(CONVERT(UUID() USING utf8mb4), '-', '')), '{"key": "user.timezone", "control": "select", "required": false, "type": "string", "data": {"leftAddon": "info"}}', FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), '[Admin User] timezone'),
    (UNHEX(REPLACE(CONVERT(UUID() USING utf8mb4), '-', '')), '{"key": "user.username", "control": "text", "required": false, "type": "string", "data": {"leftAddon": "user"}}', FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), '[Admin User] username');

-- Insert new fields for Default User Self Service form
INSERT INTO form_fields (id, data, insert_instant, last_update_instant, name)
  VALUES (UNHEX(REPLACE(CONVERT(UUID() USING utf8mb4), '-', '')), '{"key": "user.email", "control": "text", "required": false, "type": "email", "data": {"leftAddon": "user"}}', FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), '[Self Service User] email'),
    (UNHEX(REPLACE(CONVERT(UUID() USING utf8mb4), '-', '')), '{"key": "user.firstName", "control": "text", "required": false, "type": "string", "data": {"leftAddon": "info"}}', FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), '[Self Service User] first name'),
    (UNHEX(REPLACE(CONVERT(UUID() USING utf8mb4), '-', '')), '{"key": "user.lastName", "control": "text", "required": false, "type": "string", "data": {"leftAddon": "info"}}', FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), '[Self Service User] last name'),
    (UNHEX(REPLACE(CONVERT(UUID() USING utf8mb4), '-', '')), '{"key": "user.password", "control": "password", "required": true, "confirm": true, "type": "string", "data": {"leftAddon": "lock"}}', FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), '[Self Service User] password');

-- Forms
INSERT INTO forms (id, insert_instant, last_update_instant, name, type)
  VALUES (UNHEX(REPLACE(CONVERT(UUID() USING utf8mb4), '-', '')), FLOOR((UNIX_TIMESTAMP(NOW(3)) - 3) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) - 3) * 1000, 'Default Admin Registration provided by FusionAuth', 1),
    (UNHEX(REPLACE(CONVERT(UUID() USING utf8mb4), '-', '')), FLOOR((UNIX_TIMESTAMP(NOW(3)) - 2) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) - 2) * 1000, 'Default Admin User provided by FusionAuth', 2),
    (UNHEX(REPLACE(CONVERT(UUID() USING utf8mb4), '-', '')), FLOOR((UNIX_TIMESTAMP(NOW(3)) - 1) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) - 1) * 1000, 'Default User Self Service provided by FusionAuth', 3);

-- Note, these forms are also built in the DefaultResetService.resetManagedFormFields
-- If we modify this, we need to ensure we keep these in sync.

-- Admin Registration Edit form_steps
INSERT INTO form_steps (form_fields_id, forms_id, sequence, step)
SELECT id, (SELECT id FROM forms WHERE name = 'Default Admin Registration provided by FusionAuth'), 0, 0
  FROM form_fields
  WHERE name = '[Admin Registration] username';

INSERT INTO form_steps (form_fields_id, forms_id, sequence, step)
SELECT id, (SELECT id FROM forms WHERE name = 'Default Admin Registration provided by FusionAuth'), 1, 0
  FROM form_fields
  WHERE name = '[Admin Registration] preferred languages';

INSERT INTO form_steps (form_fields_id, forms_id, sequence, step)
SELECT id, (SELECT id FROM forms WHERE name = 'Default Admin Registration provided by FusionAuth'), 2, 0
  FROM form_fields
  WHERE name = '[Admin Registration] timezone';

INSERT INTO form_steps (form_fields_id, forms_id, sequence, step)
SELECT id, (SELECT id FROM forms WHERE name = 'Default Admin Registration provided by FusionAuth'), 3, 0
  FROM form_fields
  WHERE name = '[Admin Registration] roles';

-- Admin User Edit form_steps
-- Section 1
INSERT INTO form_steps (form_fields_id, forms_id, sequence, step)
SELECT id, (SELECT id FROM forms WHERE name = 'Default Admin User provided by FusionAuth'), 0, 0
  FROM form_fields
  WHERE name = '[Admin User] email';

INSERT INTO form_steps (form_fields_id, forms_id, sequence, step)
SELECT id, (SELECT id FROM forms WHERE name = 'Default Admin User provided by FusionAuth'), 1, 0
  FROM form_fields
  WHERE name = '[Admin User] username';

INSERT INTO form_steps (form_fields_id, forms_id, sequence, step)
SELECT id, (SELECT id FROM forms WHERE name = 'Default Admin User provided by FusionAuth'), 2, 0
  FROM form_fields
  WHERE name = '[Admin User] mobile phone';

INSERT INTO form_steps (form_fields_id, forms_id, sequence, step)
SELECT id, (SELECT id FROM forms WHERE name = 'Default Admin User provided by FusionAuth'), 3, 0
  FROM form_fields
  WHERE name = '[Admin User] password';

-- Section 2
INSERT INTO form_steps (form_fields_id, forms_id, sequence, step)
SELECT id, (SELECT id FROM forms WHERE name = 'Default Admin User provided by FusionAuth'), 0, 1
  FROM form_fields
  WHERE name = '[Admin User] birthdate';

INSERT INTO form_steps (form_fields_id, forms_id, sequence, step)
SELECT id, (SELECT id FROM forms WHERE name = 'Default Admin User provided by FusionAuth'), 1, 1
  FROM form_fields
  WHERE name = '[Admin User] first name';

INSERT INTO form_steps (form_fields_id, forms_id, sequence, step)
SELECT id, (SELECT id FROM forms WHERE name = 'Default Admin User provided by FusionAuth'), 2, 1
  FROM form_fields
  WHERE name = '[Admin User] middle name';

INSERT INTO form_steps (form_fields_id, forms_id, sequence, step)
SELECT id, (SELECT id FROM forms WHERE name = 'Default Admin User provided by FusionAuth'), 3, 1
  FROM form_fields
  WHERE name = '[Admin User] last name';

INSERT INTO form_steps (form_fields_id, forms_id, sequence, step)
SELECT id, (SELECT id FROM forms WHERE name = 'Default Admin User provided by FusionAuth'), 4, 1
  FROM form_fields
  WHERE name = '[Admin User] full name';

INSERT INTO form_steps (form_fields_id, forms_id, sequence, step)
SELECT id, (SELECT id FROM forms WHERE name = 'Default Admin User provided by FusionAuth'), 5, 1
  FROM form_fields
  WHERE name = '[Admin User] preferred languages';

INSERT INTO form_steps (form_fields_id, forms_id, sequence, step)
SELECT id, (SELECT id FROM forms WHERE name = 'Default Admin User provided by FusionAuth'), 6, 1
  FROM form_fields
  WHERE name = '[Admin User] timezone';

INSERT INTO form_steps (form_fields_id, forms_id, sequence, step)
SELECT id, (SELECT id FROM forms WHERE name = 'Default Admin User provided by FusionAuth'), 7, 1
  FROM form_fields
  WHERE name = '[Admin User] image URL';

-- Self Service User form_steps
-- Section 1
INSERT INTO form_steps (form_fields_id, forms_id, sequence, step)
SELECT id, (SELECT id FROM forms WHERE name = 'Default User Self Service provided by FusionAuth'), 0, 0
  FROM form_fields
  WHERE name = '[Self Service User] email';

INSERT INTO form_steps (form_fields_id, forms_id, sequence, step)
SELECT id, (SELECT id FROM forms WHERE name = 'Default User Self Service provided by FusionAuth'), 1, 0
  FROM form_fields
  WHERE name = '[Self Service User] first name';

INSERT INTO form_steps (form_fields_id, forms_id, sequence, step)
SELECT id, (SELECT id FROM forms WHERE name = 'Default User Self Service provided by FusionAuth'), 2, 0
  FROM form_fields
  WHERE name = '[Self Service User] last name';

INSERT INTO form_steps (form_fields_id, forms_id, sequence, step)
SELECT id, (SELECT id FROM forms WHERE name = 'Default User Self Service provided by FusionAuth'), 3, 0
  FROM form_fields
  WHERE name = '[Self Service User] password';

-- Insert default message templates
INSERT INTO message_templates (id, name, insert_instant, last_update_instant, data, type)
  VALUES (UNHEX(REPLACE(CONVERT(UUID() USING utf8mb4), '-', '')),
          'Default Two Factor Request',
          FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000),
          FLOOR(UNIX_TIMESTAMP(NOW(3))) * 1000,
          '{ "defaultTemplate": "Two Factor Code: ${code}" }',
          0);

-- Insert default tenant
INSERT INTO tenants(id, data, insert_instant, last_update_instant, name, access_token_signing_keys_id, id_token_signing_keys_id, themes_id, admin_user_forms_id)
  VALUES (UNHEX(REPLACE(CONVERT(UUID() USING utf8mb4), '-', '')),
          CONCAT(
              '{'
                '"emailConfiguration": {"host": "localhost", "port": 25, "defaultFromEmail": "change-me@example.com", "defaultFromName": "FusionAuth"},'
                '"eventConfiguration": {},'
                '"externalIdentifierConfiguration": {"authorizationGrantIdTimeToLiveInSeconds": 30, "changePasswordIdTimeToLiveInSeconds": 600, "changePasswordIdGenerator": {"length": 32, "type": "randomBytes"}, "deviceCodeTimeToLiveInSeconds": 300, "deviceUserCodeIdGenerator": {"length": 6, "type": "randomAlphaNumeric"}, "emailVerificationIdTimeToLiveInSeconds": 86400, "emailVerificationIdGenerator": {"length": 32, "type": "randomBytes"}, "emailVerificationOneTimeCodeGenerator": {"length": 6, "type": "randomAlphaNumeric"}, "externalAuthenticationIdTimeToLiveInSeconds": 300, "oneTimePasswordTimeToLiveInSeconds": 60, "passwordlessLoginTimeToLiveInSeconds": 180, "passwordlessLoginGenerator": {"length": 32, "type": "randomBytes"}, "registrationVerificationIdTimeToLiveInSeconds": 86400, "registrationVerificationIdGenerator": {"length": 32, "type": "randomBytes"}, "registrationVerificationOneTimeCodeGenerator": {"length": 6, "type": "randomAlphaNumeric"}, "samlv2AuthNRequestIdTimeToLiveInSeconds": 300, "setupPasswordIdTimeToLiveInSeconds": 86400, "setupPasswordIdGenerator": {"length": 32, "type": "randomBytes"}, "twoFactorOneTimeCodeIdGenerator":{"length": 6, "type": "randomDigits"}, "twoFactorIdTimeToLiveInSeconds": 300, "twoFactorOneTimeCodeIdTimeToLiveInSeconds": 60, "twoFactorTrustIdTimeToLiveInSeconds": 2592000},',
              '"issuer": "acme.com",'
                '"jwtConfiguration": {"enabled": true, "timeToLiveInSeconds": 3600, "refreshTokenExpirationPolicy": "Fixed", "refreshTokenRevocationPolicy":{"onLoginPrevented": true, "onPasswordChanged": true}, "refreshTokenTimeToLiveInMinutes": 43200, "refreshTokenUsagePolicy": "Reusable"},'
                '"multiFactorConfiguration": {"authenticator": {"enabled": true, "algorithm": "HmacSHA1", "codeLength": 6, "timeStep": 30}},'
                '"passwordEncryptionConfiguration": {"encryptionScheme": "salted-pbkdf2-hmac-sha256", "encryptionSchemeFactor": 24000, "modifyEncryptionSchemeOnLogin": false},'
                '"passwordValidationRules": {"maxLength": 256, "minLength": 8, "requireMixedCase": false, "requireNonAlpha": false},'
                '"state": "Active"'
                '}'
          ),
          FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000),
          FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000),
          'Default',
          (SELECT id FROM `keys` WHERE name = 'Default signing key' LIMIT 1),
          0x092dbedc30af41499c61b578f2c72f59,
          0x75a068fde94b451a9aeb3ddb9a3b5987,
          (SELECT id FROM forms WHERE name = 'Default Admin User provided by FusionAuth'));

-- Insert the applications
INSERT INTO applications(name, active, id, data, insert_instant, last_update_instant, access_token_signing_keys_id, id_token_signing_keys_id, tenants_id, admin_registration_forms_id)
  VALUES ('FusionAuth',
          TRUE,
          0x3c219e58ed0e4b18ad48f4f92793ae32,
          CONCAT(
              '{"jwtConfiguration": {"enabled": true, "timeToLiveInSeconds": 60, "refreshTokenExpirationPolicy": "SlidingWindow", "refreshTokenTimeToLiveInMinutes": 60, "refreshTokenUsagePolicy": "OneTimeUse"},',
              '"registrationConfiguration": {"type":"basic"}, "oauthConfiguration": {"authorizedRedirectURLs": ["/admin/login"], "clientId": "3c219e58-ed0e-4b18-ad48-f4f92793ae32", "clientSecret": "',
              TO_BASE64(SUBSTR(CONCAT(MD5(RAND()), MD5(RAND())), 3, 32)),
              '", "enabledGrants": ["authorization_code", "refresh_token"], "logoutURL": "/admin/single-logout", "generateRefreshTokens": true, ',
              '"clientAuthenticationPolicy": "Required", "proofKeyForCodeExchangePolicy": "Required" },',
              '"loginConfiguration": {"allowTokenRefresh": false, "generateRefreshTokens": false, "requireAuthentication": true},'
                '"unverified":{ "behavior": "Allow" },'
                '"verificationStrategy":"ClickableLink",'
                '"state": "Active"'
                '}'
          ),
          FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000),
          FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000),
          (SELECT id FROM `keys` WHERE name = 'Default signing key' LIMIT 1),
          0x092dbedc30af41499c61b578f2c72f59,
          (SELECT id FROM tenants LIMIT 1),
          (SELECT id FROM forms WHERE name = 'Default Admin Registration provided by FusionAuth'));

-- Insert the roles
INSERT INTO application_roles(id, applications_id, is_default, is_super_role, insert_instant, last_update_instant, name, description)
  VALUES (0x631ecd9d8d404c13827780cedb8236e2, 0x3c219e58ed0e4b18ad48f4f92793ae32, FALSE, TRUE, FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), 'admin', 'Global admin'),
    (0x631ecd9d8d404c13827780cedb8236e3, 0x3c219e58ed0e4b18ad48f4f92793ae32, FALSE, FALSE, FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), 'api_key_manager', 'API key manager'),
    (0x631ecd9d8d404c13827780cedb8236e4, 0x3c219e58ed0e4b18ad48f4f92793ae32, FALSE, FALSE, FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), 'application_deleter', 'Application deleter'),
    (0x631ecd9d8d404c13827780cedb8236e5, 0x3c219e58ed0e4b18ad48f4f92793ae32, FALSE, FALSE, FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), 'application_manager', 'Application manager'),
    (0x631ecd9d8d404c13827780cedb8236e6, 0x3c219e58ed0e4b18ad48f4f92793ae32, FALSE, FALSE, FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), 'audit_log_viewer', 'Audit log viewer'),
    (0x631ecd9d8d404c13827780cedb8236e7, 0x3c219e58ed0e4b18ad48f4f92793ae32, FALSE, FALSE, FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), 'email_template_manager', 'Email template manager'),
    (0x631ecd9d8d404c13827780cedb8236e8, 0x3c219e58ed0e4b18ad48f4f92793ae32, FALSE, FALSE, FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), 'report_viewer', 'Report viewer'),
    (0x631ecd9d8d404c13827780cedb8236e9, 0x3c219e58ed0e4b18ad48f4f92793ae32, FALSE, FALSE, FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), 'system_manager', 'System configuration manager'),
    (0x631ecd9d8d404c13827780cedb8236f0, 0x3c219e58ed0e4b18ad48f4f92793ae32, FALSE, FALSE, FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), 'user_action_deleter', 'User action deleter'),
    (0x631ecd9d8d404c13827780cedb8236f1, 0x3c219e58ed0e4b18ad48f4f92793ae32, FALSE, FALSE, FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), 'user_action_manager', 'User action manager'),
    (0x631ecd9d8d404c13827780cedb8236f2, 0x3c219e58ed0e4b18ad48f4f92793ae32, FALSE, FALSE, FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), 'user_deleter', 'User deleter'),
    (0x631ecd9d8d404c13827780cedb8236f3, 0x3c219e58ed0e4b18ad48f4f92793ae32, FALSE, FALSE, FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), 'user_manager', 'User manager'),
    (0x631ecd9d8d404c13827780cedb8236f4, 0x3c219e58ed0e4b18ad48f4f92793ae32, FALSE, FALSE, FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), 'webhook_manager', 'Webhook manager'),
    (0x631ecd9d8d404c13827780cedb8236f5, 0x3c219e58ed0e4b18ad48f4f92793ae32, FALSE, FALSE, FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), 'group_manager', 'Group manager'),
    (0x631ecd9d8d404c13827780cedb8236f6, 0x3c219e58ed0e4b18ad48f4f92793ae32, FALSE, FALSE, FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), 'group_deleter', 'Group deleter'),
    (0x631ecd9d8d404c13827780cedb8236f7, 0x3c219e58ed0e4b18ad48f4f92793ae32, FALSE, FALSE, FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), 'tenant_manager', 'Tenant manager'),
    (0x631ecd9d8d404c13827780cedb8236f8, 0x3c219e58ed0e4b18ad48f4f92793ae32, FALSE, FALSE, FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), 'tenant_deleter', 'Tenant deleter'),
    (0x631ecd9d8d404c13827780cedb8236f9, 0x3c219e58ed0e4b18ad48f4f92793ae32, FALSE, FALSE, FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), 'lambda_manager', 'Lambda manager'),
    (0x631ecd9d8d404c13827780cedb8236fa, 0x3c219e58ed0e4b18ad48f4f92793ae32, FALSE, FALSE, FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), 'event_log_viewer', 'Event log viewer'),
    (0x631ecd9d8d404c13827780cedb8236fb, 0x3c219e58ed0e4b18ad48f4f92793ae32, FALSE, FALSE, FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), 'key_manager', 'Key manager'),
    (0x631ecd9d8d404c13827780cedb8236fc, 0x3c219e58ed0e4b18ad48f4f92793ae32, FALSE, FALSE, FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), 'consent_deleter', 'Consent deleter'),
    (0x631ecd9d8d404c13827780cedb8236fd, 0x3c219e58ed0e4b18ad48f4f92793ae32, FALSE, FALSE, FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), 'consent_manager', 'Consent manager'),
    (0x631ecd9d8d404c13827780cedb8236fe, 0x3c219e58ed0e4b18ad48f4f92793ae32, FALSE, FALSE, FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), 'theme_manager', 'Theme manager'),
    (0x631ecd9d8d404c13827780cedb8236ff, 0x3c219e58ed0e4b18ad48f4f92793ae32, FALSE, FALSE, FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), 'reactor_manager', 'Reactor manager'),
    (0x631ecd9d8d404c13827780cedb823700, 0x3c219e58ed0e4b18ad48f4f92793ae32, FALSE, FALSE, FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), 'connector_deleter', 'Connector deleter'),
    (0x631ecd9d8d404c13827780cedb823701, 0x3c219e58ed0e4b18ad48f4f92793ae32, FALSE, FALSE, FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), 'connector_manager', 'Connector manager'),
    (0x631ecd9d8d404c13827780cedb823702, 0x3c219e58ed0e4b18ad48f4f92793ae32, FALSE, FALSE, FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), 'form_deleter', 'Form deleter'),
    (0x631ecd9d8d404c13827780cedb823703, 0x3c219e58ed0e4b18ad48f4f92793ae32, FALSE, FALSE, FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), 'form_manager', 'Form manager'),
    (0x631ecd9d8d404c13827780cedb823704, 0x3c219e58ed0e4b18ad48f4f92793ae32, FALSE, FALSE, FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), 'user_support_manager', 'User support manager'),
    (0x631ecd9d8d404c13827780cedb823705, 0x3c219e58ed0e4b18ad48f4f92793ae32, FALSE, FALSE, FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), 'user_support_viewer', 'User support viewer'),
    (0x631ecd9d8d404c13827780cedb823706, 0x3c219e58ed0e4b18ad48f4f92793ae32, FALSE, FALSE, FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), 'entity_manager', 'Entity manager'),
    (0x631ecd9d8d404c13827780cedb823707, 0x3c219e58ed0e4b18ad48f4f92793ae32, FALSE, FALSE, FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), 'messenger_deleter', 'Messenger deleter'),
    (0x631ecd9d8d404c13827780cedb823708, 0x3c219e58ed0e4b18ad48f4f92793ae32, FALSE, FALSE, FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), 'messenger_manager', 'Messenger manager'),
    (0x631ecd9d8d404c13827780cedb823709, 0x3c219e58ed0e4b18ad48f4f92793ae32, FALSE, FALSE, FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), 'message_template_deleter', 'Message template deleter'),
    (0x631ecd9d8d404c13827780cedb823710, 0x3c219e58ed0e4b18ad48f4f92793ae32, FALSE, FALSE, FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), 'message_template_manager', 'Message template manager'),
    (0x631ecd9d8d404c13827780cedb823711, 0x3c219e58ed0e4b18ad48f4f92793ae32, FALSE, FALSE, FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), 'acl_deleter', 'ACL deleter'),
    (0x631ecd9d8d404c13827780cedb823712, 0x3c219e58ed0e4b18ad48f4f92793ae32, FALSE, FALSE, FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000), 'acl_manager', 'ACL manager');

-- System configuration
INSERT INTO system_configuration(data, insert_instant, last_update_instant, report_timezone)
  VALUES ('{}',
          FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000),
          FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000),
          'America/Denver');

-- Internal API key, replace new lines with empty
INSERT INTO authentication_keys(id, key_value, insert_instant, key_manager, last_update_instant, permissions, meta_data, tenants_id)
  VALUES (UNHEX(REPLACE(CONVERT(UUID() USING utf8mb4), '-', '')),
          CONCAT('__internal_', REPLACE(TO_BASE64(SUBSTR(CONCAT(MD5(RAND()), MD5(RAND())), 3, 64)), '\n', '')),
          FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000),
          FALSE,
          FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000),
          '{"endpoints": {"/api/cache/reload": ["POST"], "/api/system/log/export": ["POST"], "/internal/webhook": ["POST"]}}',
          '{"attributes": {"description": "Internal Use Only.", "internalCacheReloader": "true", "internalLogDownloader": "true", "internalWebhook": "true"}}',
          NULL);

-- Integrations
INSERT INTO integrations(data)
  VALUES ('{}');

-- Initialize the version of the BreachPasswords data set
INSERT INTO data_sets (name, last_update_instant)
  VALUES ('BreachPasswords', 1581476456155);

-- FusionAuth Connector
INSERT INTO connectors (id, insert_instant, last_update_instant, data, name, type)
  VALUES (0xe3306678a53a496490401c96f36dda72,
          FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000),
          FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000),
          '{}', 'Default', 0);

-- Create a FusionAuth connector policy with an "run always" trigger for all existing Tenants
INSERT INTO connectors_tenants (tenants_id, connectors_id, sequence, data)
SELECT id, 0xe3306678a53a496490401c96f36dda72, 0, '{"domains":["*"]}'
  FROM tenants;

-- Initialize migrations so they don't run on new installs
INSERT INTO migrations (name, run_instant)
  VALUES ('io.fusionauth.api.migration.guice.Migration_1_8_0', 0),
    ('io.fusionauth.api.migration.guice.Migration_1_9_2', 0),
    ('io.fusionauth.api.migration.guice.Migration_1_10_0', 0),
    ('io.fusionauth.api.migration.guice.Migration_1_13_0', 0),
    ('io.fusionauth.api.migration.guice.Migration_1_15_3', 0),
    ('io.fusionauth.api.migration.guice.Migration_1_30_0', 0);
