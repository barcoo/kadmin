# frozen_string_literal: true

module Kadmin
  # Glue class so that authentication can be added as route constraints
  class AuthConstraint
    include Kadmin::Concerns::AuthorizedUser

    def matches?(request)
      return true unless Kadmin::Auth.config.enabled?

      return with(request) do
        logged_in? && authorized?
      end
    end

    def with(request)
      @request = request
      return yield
    ensure
      @request = nil
    end

    def request
      return @request
    end

    def session
      return request.session
    end
  end
end
