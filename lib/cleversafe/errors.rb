module Cleversafe
  module Error
    class Base < RuntimeError; end
    class NotFound < Base; end
  end
end
