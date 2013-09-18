module Cleversafe
  module Errors
    class Base < RuntimeError; end
    class NotFound < Base; end
    class VaultMisconfigured < Base; end
  end
end
