module Kadmin
  module Auth
    class UnauthorizedError < Kadmin::Error
      # Attempts to translate message, if not found returns message as a string
      def message
        I18n.t(@message, default: @message)
      end

      def title
        I18n.t('kadmin.auth.unauthorized')
      end
    end
  end
end
