# Copyright OpenSearch Contributors
# SPDX-License-Identifier: Apache-2.0

module OpenSearchHelper
  def self.get_host_port
    if ENV["INTEGRATION"] == "true" || ENV["SECURE_INTEGRATION"] == "true"
      "integration:9200"
    else
      "localhost:9200" # for local running integration specs outside docker
    end
  end

  def self.get_client(options)
    require 'opensearch/transport/transport/http/faraday' # supports user/password options
    host, port = get_host_port.split(':')
    host_opts = { host: host, port: port, scheme: 'http' }
    ssl_opts = {}

    if options[:ca_file]
      ssl_opts = { ca_file: options[:ca_file], version: 'TLSv1.2', verify: false }
      host_opts[:scheme] = 'https'
    end

    if options[:user] && options[:password]
      host_opts[:user] = options[:user]
      host_opts[:password] = options[:password]
    end

    OpenSearch::Client.new(hosts: [host_opts],
                              transport_options: { ssl: ssl_opts },
                              transport_class: OpenSearch::Transport::Transport::HTTP::Faraday)
  end

  def self.doc_type
    "_doc"
  end

  def self.index_doc(opensearch, params)
    type = doc_type
    params[:type] = doc_type unless type.nil?
    opensearch.index(params)
  end
end