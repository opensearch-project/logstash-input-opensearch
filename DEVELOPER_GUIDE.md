# Developer Guide

So you want to contribute code to logstash-input-opensearch? Excellent! We're glad you're here. Here's what you need to do.

## 1. Plugin Developement and Testing

### Code
- To get started, you'll need JRuby with the Bundler gem installed.

- Fork [opensearch-project/logstash-input-opensearch](https://github.com/opensearch-project/logstash-input-opensearch) and clone locally.

Example:
```bash
    git clone https://github.com/[your username]/logstash-input-opensearch.git.
```


- Install dependencies
```sh
bundle install
```

### Test

- Update your dependencies

```sh
bundle install
```

- Run tests

```sh
bundle exec rspec
```

## 2. Running your unpublished Plugin in Logstash

### 2.1 Run in a local Logstash clone

- Edit Logstash `Gemfile` and add the local plugin path, for example:
```ruby
gem "logstash-input-opensearch", :path => "/your/local/logstash-input-opensearch"
```
- Install plugin
```sh
# Logstash 2.3 and higher
bin/logstash-plugin install --no-verify

# Prior to Logstash 2.3
bin/plugin install --no-verify

```
- Run Logstash with your plugin
```sh
bin/logstash -e 'input {opensearch {}}'
```
At this point any modifications to the plugin code will be applied to this local Logstash setup. After modifying the plugin, simply rerun Logstash.

### 2.2 Run in an installed Logstash

You can use the same **2.1** method to run your plugin in an installed Logstash by editing its `Gemfile` and pointing the `:path` to your local plugin development directory or you can build the gem and install it using:

- Build your plugin gem
```sh
gem build logstash-input-opensearch.gemspec
```
- Install the plugin from the Logstash home
```sh
# Logstash 2.3 and higher
bin/logstash-plugin install --no-verify

# Prior to Logstash 2.3
bin/plugin install --no-verify

```
- Start Logstash and proceed to test the plugin