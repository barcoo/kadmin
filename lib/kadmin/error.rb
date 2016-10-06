module Kadmin
  # Base class for all gem errors
  class Error < StandardError
  end
end

require 'kadmin/errors/authorization'
