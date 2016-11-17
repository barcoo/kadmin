module Kadmin
  class Configuration
    # @return [Logger] An instance of a Ruby compatible logger
    attr_accessor :logger

    # @return [String] the path the engine is mounted at (used for authentication routes)
    attr_accessor :mount_path

    # @return [Array<Kadmin::Navigation::Section, Kadmin::Navigation::Link>] list of admin links or sections
    attr_accessor :navbar_items

    def initialize
      @mount_path = '/admin'
      @logger = Rails.logger
      @navbar_links = []
    end
  end
end
