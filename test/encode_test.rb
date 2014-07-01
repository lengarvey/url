require 'minitest/autorun'
require 'url'

class TestUri < Minitest::Test
  def test_that_it_splits
    uri = "http://example.com/go/to/widgets?a[b]=1#hello"

    scheme, authority, path, query, fragment = URI::RFC3986_Parser.new.safe_split uri

    assert_equal scheme, 'http'
    assert_equal authority, 'example.com'
    assert_equal path, '/go/to/widgets'
    assert_equal query, 'a[b]=1'
    assert_equal fragment, 'hello'
  end

  def test_that_it_escapes
    uri = "http://user:1234@example.com/go/to/widgets?a[b]=1&test=hello world&x=/#hello"

    escaped = URI::RFC3986_Parser.new.escape(uri)

    assert_equal "", escaped

  end
end
