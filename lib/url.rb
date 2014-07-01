require "uri"

module URI
  class RFC3986_Parser
    RFC33986_URI_SPLIT = Regexp.new '\A(([^:/?#]+):)?(//([^/?#]*))?([^?#]*)(\?([^#]*))?(#(.*))?\z'

    QUERY_RESERVED = /[\[\] \/]/

    def safe_split(uri)
      uri =~ RFC33986_URI_SPLIT

      scheme    = $2
      authority = $4
      path      = $5
      query     = $7
      fragment  = $9

      [scheme, authority, path, query, fragment]
    end

    def escape(uri)
      scheme, authority, path, query, fragment = safe_split(uri)
      query.gsub!(QUERY_RESERVED) { percent_encode($&) }
      "#{scheme}://#{authority}#{path}?#{query}##{fragment}"
    end

    private

    def percent_encode(str)
      tmp = ''
      str.each_byte do |uc|
        tmp << sprintf('%%%02X', uc)
      end
      tmp
    end

  end
end
