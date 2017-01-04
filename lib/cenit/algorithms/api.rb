module Cenit
  module Api
    class << self

      def base_url(opts = {})
        url = "#{Cenit.host}/api/#{opts[:version] || 'v2'}/#{opts[:namespace] || 'setup'}/#{opts[:model] || opts[:data_type] || 'algorithm'}"
        if (id = opts[:id])
          url += "/#{id}"
        end
        if (action = opts[:action])
          url += "/#{action}"
        end
        url
      end

      def headers
        headers = { 'Content-Type' => 'application/json' }
        if (token = Cenit.access_token) && (key = Cenit.access_key)
          headers['X-User-Access-Key'] = key
          headers['X-User-Access-Token'] = token
        end
        headers
      end
    end
  end
end
