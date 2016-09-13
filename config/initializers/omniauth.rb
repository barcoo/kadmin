OmniAuth.config.logger = RailsAdmin.logger

if RailsAdmin.google_client_id.present? && RailsAdmin.google_client_secret.present?
  Rails.application.config.middleware.use OmniAuth::Builder do
    provider(:google_oauth2, RailsAdmin.google_client_id, RailsAdmin.google_client_secret)
  end
else
  RailsAdmin.logger.warn('No authorization provider given; OAuth2 authentication disabled')
end
