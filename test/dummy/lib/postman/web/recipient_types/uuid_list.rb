module Postman
  module Web
    module RecipientTypes
      class UuidList < Postman::Web::RecipientType
        TEXT_ID = 'uuid'.freeze

        def initialize
          super(TEXT_ID)
        end

        # @param Array<String> Expects an array of UUID strings.
        def validate_recipients!(recipients)
          errors = []
          recipients.each do |recipient|
            errors << recipient unless uuid?(recipient)
          end

          raise(Error, "Recipients should be a list of UUIDs => #{errors}") unless errors.empty?

          return true
        end

        # Cannot use proper UUID matching as we must support different UUID lengths, compositions, etc.
        # Just make sure it's a non empty string until we figure out something else.
        def uuid?(recipient)
          recipient.is_a?(String) && recipient.present?
        end
        private :uuid?

        class Error < Postman::Web::Error; end

        def self.register
          superclass.register(TEXT_ID, self)
        end
      end
    end
  end
end
