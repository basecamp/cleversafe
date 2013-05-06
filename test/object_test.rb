require 'cleversafe/test_helper'

class ObjectTest < MiniTest::Unit::TestCase
  def setup
    connection = Cleversafe::Connection.new('http://test.host')
    @vault = Cleversafe::Vault.new(connection, 'test_vault')
  end

  def test_name_is_required
    assert_raises ArgumentError do
      Cleversafe::Object.new(@vault, '')
    end
  end
end
