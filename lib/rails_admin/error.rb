module RailsAdmin
  # Base class for all gem errors
  class Error < StandardError
  end
end

require 'rails_admin/errors/authorization'
