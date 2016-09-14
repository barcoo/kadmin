module RailsAdmin
  module Errors
    class Authorization < RailsAdmin::Error
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
