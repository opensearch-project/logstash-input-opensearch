# encoding: utf-8
require "logstash/devutils/rspec/spec_helper"
require "logstash/plugin"
require "logstash/inputs/opensearch"
require_relative "../../../spec/opensearch_helper"

describe LogStash::Inputs::OpenSearch do

  let(:config)   { { 'hosts' => [OpenSearchHelper.get_host_port],
                     'index' => 'logs',
                     'query' => '{ "query": { "match": { "message": "Not found"} }}' } }
  let(:plugin) { described_class.new(config) }
  let(:event)  { LogStash::Event.new({}) }
  let(:client_options) { Hash.new }

  before(:each) do
    @es = OpenSearchHelper.get_client(client_options)
    # Delete all templates first.
    # Clean OpenSearch of data before we start.
    @es.indices.delete_template(:name => "*")
    # This can fail if there are no indexes, ignore failure.
    @es.indices.delete(:index => "*") rescue nil
    10.times do
      OpenSearchHelper.index_doc(@es, :index => 'logs', :body => { :response => 404, :message=> 'Not Found'})
    end
    @es.indices.refresh
  end

  after(:each) do
    @es.indices.delete_template(:name => "*")
    @es.indices.delete(:index => "*") rescue nil
  end

  shared_examples 'an opensearch index plugin' do
    before(:each) do
      plugin.register
    end

    it 'should retrieve json event from opensearch' do
      queue = []
      plugin.run(queue)
      event = queue.pop
      expect(event).to be_a(LogStash::Event)
      expect(event.get("response")).to eql(404)
    end
  end

  describe 'against an unsecured opensearch', :integration => true do
    before(:each) do
      plugin.register
    end

    it_behaves_like 'an opensearch index plugin'
  end

  describe 'against a secured opensearch', :secure_integration => true do
    let(:user) { ENV['USER'] || 'admin' }
    let(:password) { ENV['PASSWORD'] || 'admin' }
    let(:ca_file) { "spec/fixtures/test_certs/ca.crt" }

    let(:client_options) { { :ca_file => ca_file, :user => user, :password => password } }

    let(:config) { super().merge('user' => user, 'password' => password, 'ssl' => true, 'ca_file' => ca_file) }

    it_behaves_like 'an opensearch index plugin'

    context "incorrect auth credentials" do

      let(:config) do
        super().merge('user' => 'archer', 'password' => 'b0gus!')
      end

      let(:queue) { [] }

      it "fails to run the plugin" do
        expect { plugin.register }.to raise_error OpenSearch::Transport::Transport::Errors::Unauthorized
      end
    end

  end
end
