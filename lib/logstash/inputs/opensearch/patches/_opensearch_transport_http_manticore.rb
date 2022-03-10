# Copyright OpenSearch Contributors
# SPDX-License-Identifier: Apache-2.0

# encoding: utf-8
require "opensearch"
require "opensearch/transport/transport/http/manticore"


  # elasticsearch-transport 7.2.0 - 7.14.0 had a bug where setting http headers
  #   ES::Client.new ..., transport_options: { headers: { 'Authorization' => ... } }
  # would be lost https://github.com/elastic/elasticsearch-ruby/issues/1428
  #
  # NOTE: needs to be idempotent as filter OpenSearch plugin might apply the same patch!
  #
  # @private
module OpenSearch
  module Transport
    module Transport
      module HTTP
        class Manticore

          def apply_headers(request_options, options)
            headers = (options && options[:headers]) || {}
            headers[CONTENT_TYPE_STR] = find_value(headers, CONTENT_TYPE_REGEX) || DEFAULT_CONTENT_TYPE

              # this code is necessary to grab the correct user-agent header
              # when this method is invoked with apply_headers(@request_options, options)
              # from https://github.com/opensearch-project/opensearch-ruby/blob/main/opensearch-transport/lib/opensearch/transport/transport/http/manticore.rb#L122-L123
              transport_user_agent = nil
              if (options && options[:transport_options] && options[:transport_options][:headers])
                transport_headers = options[:transport_options][:headers]
                transport_user_agent = find_value(transport_headers, USER_AGENT_REGEX)
              end

            headers[USER_AGENT_STR] = transport_user_agent || find_value(headers, USER_AGENT_REGEX) || user_agent_header
            headers[ACCEPT_ENCODING] = GZIP if use_compression?
            (request_options[:headers] ||= {}).merge!(headers) # this line was changed
          end
          
        end
      end
    end
  end
end