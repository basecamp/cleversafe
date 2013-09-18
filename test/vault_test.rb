require 'cleversafe/test_helper'

class VaultTest < MiniTest::Unit::TestCase
  def setup
    @connection = Cleversafe::Connection.new('http://test.host')
  end

  def test_path_is_escaped
    assert_equal 'test%2Fvault', Cleversafe::Vault.new(@connection, 'test/vault').path
  end
  
  def test_vault_is_configured_correctly
    stub_request(:put, "http://test.host/assets").with(:body => "foo").to_return(:status => 405, :body => "", :headers => {})
    vault = Cleversafe::Vault.new(@connection, 'assets')
    error = assert_raises(Cleversafe::Errors::VaultMisconfigured) { vault.create_object('foo') }
    assert_equal 'Vault has not been added to accessers.', error.message
  end
end
