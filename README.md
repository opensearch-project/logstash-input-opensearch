[![Build and Test logstash-input-opensearch plugin](https://github.com/opensearch-project/logstash-input-opensearch/actions/workflows/CI.yml/badge.svg)](https://github.com/opensearch-project/logstash-input-opensearch/actions/workflows/CI.yml)
![PRs welcome!](https://img.shields.io/badge/PRs-welcome!-success)
# Logstash Input OpenSearch

- [Welcome!](#welcome)
- [Project Resources](#project-resources)
- [Configuration for Logstash Input OpenSearch Plugin](#configuration-for-logstash-input-opensearch-plugin)
- [Code of Conduct](#code-of-conduct)
- [License](#license)
- [Copyright](#copyright)

## Welcome!

**logstash-input-opensearch** is a community-driven, open source fork logstash-input-elasticsearch licensed under the [Apache v2.0 License](LICENSE.txt). For more information, see [opensearch.org](https://opensearch.org/).

The logstash-input-opensearch plugin helps to read the search query results performed on an OpenSearch cluster. This is useful for replaying test logs, reindexing, etc. This helps users to periodically schedule ingestion using cron syntax (using `schedule` configuration setting) or by running the query one time to load data into Logstash.

## Project Resources

* [Project Website](https://opensearch.org/)
* [Documentation](https://opensearch.org/docs/clients/logstash/index/)
* [Developer Guide](DEVELOPER_GUIDE.md)
* Need help? Try [Forums](https://discuss.opendistrocommunity.dev/)
* [Project Principles](https://opensearch.org/#principles)
* [Contributing to OpenSearch](CONTRIBUTING.md)
* [Maintainer Responsibilities](MAINTAINERS.md)
* [Release Management](RELEASING.md)
* [Admin Responsibilities](ADMINS.md)
* [Security](SECURITY.md)

## Configuration for Logstash Input OpenSearch Plugin

To run the Logstash Input OpenSearch plugin, add following configuration in your logstash.conf file.
```
input {
    opensearch {
        hosts       => ["hostname:port"]   
        user        => "admin"
        password    => "admin"
        index       => "logstash-logs-%{+YYYY.MM.dd}"
        query       => "{ "query": { "match_all": {}} }"
    }
}
```

Using the above configuration, the `match_all` query filter is triggered and data is loaded once.

`schedule` setting can be used to periodically schedule ingestion using cron syntax.

Example: `schedule => "* * * * *"` Adding this to the above configuration loads the data every minute. 

## Code of Conduct

This project has adopted the [Amazon Open Source Code of Conduct](CODE_OF_CONDUCT.md). For more information see the [Code of Conduct FAQ](https://aws.github.io/code-of-conduct-faq), or contact [opensource-codeofconduct@amazon.com](mailto:opensource-codeofconduct@amazon.com) with any additional questions or comments.

## License

This project is licensed under the [Apache v2.0 License](LICENSE.txt).

## Copyright

Copyright OpenSearch Contributors. See [NOTICE](NOTICE.txt) for details.
