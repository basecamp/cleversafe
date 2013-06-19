require 'cleversafe/test_helper'

class HttpClientTest < MiniTest::Unit::TestCase
  def test_url_for
    client = Cleversafe::HttpClient.new('http://example.com')

    assert_equal 'http://example.com/',    client.url_for('')
    assert_equal 'http://example.com/',    client.url_for('/')
    assert_equal 'http://example.com/a/b', client.url_for('/a/b')
    assert_equal 'http://example.com/a/b', client.url_for('a/b')
    assert_equal 'http://example.com/a/b', client.url_for('a', 'b')
  end
end
