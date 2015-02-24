require 'cleversafe/test_helper'

class ObjectTest < Minitest::Test
  def setup
    connection = Cleversafe::Connection.new('http://test.host')
    @vault = Cleversafe::Vault.new(connection, 'test_vault')
  end

  def test_name_is_required
    assert_raises ArgumentError do
      Cleversafe::Object.new(@vault, '')
    end
  end

  def test_path_is_escaped
    object = Cleversafe::Object.new(@vault, 'foo/bar[1].png')
    assert_equal 'test_vault/foo%2Fbar%5B1%5D.png', object.path
  end
end
