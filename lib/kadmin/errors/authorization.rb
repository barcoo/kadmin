module Kadmin
  module Errors
    class Authorization < Kadmin::Error
      attr_reader :resource, :user, :reason

      def initialize(resource, user, reason)
        @resource = resource
        @user = user
        @reason = reason

        super("#{@user} is unauthorized to access #{@resource} => #{@reason}")
      end
    end
  end
end
