require 'cleversafe/test_helper'

class VaultTest < MiniTest::Unit::TestCase
  def setup
    @connection = Cleversafe::Connection.new('http://test.host')
  end

  def test_path_is_escaped
    assert_equal 'test%2Fvault', Cleversafe::Vault.new(@connection, 'test/vault').path
  end
end
