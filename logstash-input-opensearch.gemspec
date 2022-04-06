# Copyright OpenSearch Contributors
# SPDX-License-Identifier: Apache-2.0

signing_key_path = "gem-private_key.pem"

Gem::Specification.new do |s|

  s.name            = 'logstash-input-opensearch'
  s.version         = '1.0.0'
  s.licenses        = ['Apache License (2.0)']
  s.summary         = "Reads query results from an OpenSearch cluster"
  s.description     = "This gem is a Logstash plugin required to be installed on top of the Logstash core pipeline using $LS_HOME/bin/logstash-plugin install gemname. This gem is not a stand-alone program"
  s.authors         = ["Elastic", "OpenSearch Contributors"]
  s.email           = 'opensearch@amazon.com'
  s.homepage        = "https://opensearch.org/"
  s.require_paths = ["lib"]

  # Files
  s.files = Dir["lib/**/*","spec/**/*","*.gemspec","*.md","CONTRIBUTORS","Gemfile","LICENSE","NOTICE.TXT", "vendor/jar-dependencies/**/*.jar", "vendor/jar-dependencies/**/*.rb", "VERSION", "docs/**/*"]

  # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  if $PROGRAM_NAME.end_with?("gem") && ARGV == ["build", __FILE__] && File.exist?(signing_key_path)
    s.signing_key = signing_key_path
    s.cert_chain  = ['certs/opensearch-rubygems.pem']
  end

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { "logstash_plugin" => "true", "logstash_group" => "input" }

  # Gem dependencies
  s.add_runtime_dependency "logstash-core-plugin-api", ">= 1.60", "<= 2.99"
  s.add_runtime_dependency 'logstash-mixin-ecs_compatibility_support', '~> 1.3'
  s.add_runtime_dependency 'logstash-mixin-event_support', '~> 1.0'
  s.add_runtime_dependency "logstash-mixin-validator_support", '~> 1.0'

  s.add_runtime_dependency 'tzinfo'
  s.add_runtime_dependency 'tzinfo-data'
  s.add_runtime_dependency 'rufus-scheduler'
  s.add_runtime_dependency 'manticore', ">= 0.7.1"

  s.add_runtime_dependency 'opensearch-ruby'

  s.add_development_dependency 'logstash-codec-plain'
  s.add_development_dependency 'faraday', "~> 1"
  s.add_development_dependency 'logstash-devutils'
  s.add_development_dependency 'timecop'
  s.add_development_dependency 'cabin', ['~> 0.6']
  s.add_development_dependency 'webrick'
end
