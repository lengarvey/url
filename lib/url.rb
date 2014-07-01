require 'uri'

module URI
  class RFC3986_Parser # :nodoc:
    # Non validating splitting regular expression for RFC3986
    RFC3986_URI_SPLIT = Regexp.new '\A(([^:/?#]+):)?(//([^/?#]*))?([^?#]*)(\?([^#]*))?(#(.*))?\z'
    QUERY_RESERVED = /[\[\] \/!'()\*%]/

    def non_validating_split(uri) #:nodoc:
      uri =~ RFC3986_URI_SPLIT

      scheme    = $2
      authority = $4
      path      = $5
      query     = $7
      fragment  = $9

      [scheme, authority, path, query, fragment]
    end

    def percent_encode(str) # :nodoc:
      tmp = ''
      str.each_byte do |uc|
        tmp << sprintf('%%%02X', uc)
      end
      tmp
    end

    def parse(uri, retry_parse = true) # :nodoc:
      begin
        scheme, userinfo, host, port,
          registry, path, opaque, query, fragment = self.split(uri)

        if scheme && URI.scheme_list.include?(scheme.upcase)
          URI.scheme_list[scheme.upcase].new(scheme, userinfo, host, port,
                                             registry, path, opaque, query,
                                             fragment, self)
        else
          Generic.new(scheme, userinfo, host, port,
                      registry, path, opaque, query,
                      fragment, self)
        end
      rescue URI::InvalidURIError => e
        if retry_parse
          parse(naive_escape(uri), false)
        else
          raise
        end
      end
    end

    private

    # will only attempt to escape the query string
    def naive_escape(uri) # :nodoc: #
      scheme, authority, path, query, fragment = non_validating_split(uri)
      query.gsub!(QUERY_RESERVED) { percent_encode($&) }
      "#{scheme}://#{authority}#{path}?#{query}##{fragment}"
    end

  end # class Parser
end # module URI
