require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  config.enable_reloading = false
  config.eager_load = true

  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  # config.require_master_key = true
  # config.public_file_server.enabled = false
  # config.assets.css_compressor = :sass

  # Do not fall back to assets pipeline if a precompiled asset is missed.
  config.assets.compile = true
  config.serve_static_assets = true

  # config.asset_host = "neighborfoodapp.com"

  # config.action_dispatch.x_sendfile_header = "X-Sendfile"
  # config.action_dispatch.x_sendfile_header = "X-Accel-Redirect"

  config.active_storage.service = :cloudinary

  # config.assume_ssl = true
  config.force_ssl = true

  config.logger = ActiveSupport::Logger.new(STDOUT)
    .tap  { |logger| logger.formatter = ::Logger::Formatter.new }
    .then { |logger| ActiveSupport::TaggedLogging.new(logger) }

  config.log_tags = [ :request_id ]
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  # config.cache_store = :mem_cache_store
  # config.active_job.queue_adapter = :resque
  # config.active_job.queue_name_prefix = "neighborfood_production"

  config.action_mailer.perform_caching = false
  # config.action_mailer.raise_delivery_errors = false

  config.i18n.fallbacks = true
  config.active_support.report_deprecations = false
  config.active_record.dump_schema_after_migration = false

  # ✅ Allow your custom domain AND any *.herokuapp.com host
  config.hosts.clear
  config.hosts << "neighborfoodapp.com"
  config.hosts << "www.neighborfoodapp.com"
  config.hosts << /.*\.herokuapp\.com/

  # Skip DNS rebinding protection for the health check endpoint.
  config.host_authorization = { exclude: ->(request) { request.path == "/up" } }
end
