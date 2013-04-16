require 'cleversafe/test_helper'

class ObjectTest < MiniTest::Unit::TestCase
  def setup
    @vault = Cleversafe::Vault.new(Cleversafe::Connection.new, 'test')
  end

  def test_name_is_required
    assert_raises ArgumentError do
      Cleversafe::Object.new(@vault, '')
    end
  end
end
