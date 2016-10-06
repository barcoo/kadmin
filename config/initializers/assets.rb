# Load engine assets
# While loading images by extensions seem to work, loading JS and (S)CSS by extension seems
# to cause issues, although loading them by filename is fine. Go figure.
Rails.application.config.assets.precompile += %w(select2.css select2-bootstrap.css select2.js)
Rails.application.config.assets.precompile += Dir.glob("#{Kadmin::Engine.root}/app/assets/**/*").reject { |fn| File.directory?(fn) }
