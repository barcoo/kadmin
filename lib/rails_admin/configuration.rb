module RailsAdmin
  class Configuration
    # @return [Logger] An instance of a Ruby compatible logger
    attr_accessor :logger

    # @return [String] the path the engine is mounted at (used for authentication routes)
    attr_accessor :mount_path

    def initialize
      @mount_path = '/admin'
      @logger = Rails.logger
    end
  end
end
