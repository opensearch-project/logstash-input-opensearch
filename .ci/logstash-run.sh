#!/bin/bash
set -ex

export PATH=$BUILD_DIR/gradle/bin:$PATH

wait_for_es() {

  SERVICE_URL="http://integration:9200"
  if [[ "$SECURE_INTEGRATION" == "true" ]]; then
    SERVICE_URL="https://integration:9200 -k -u admin:admin"
  fi
  count=10
  while ! curl -s $SERVICE_URL >/dev/null && [[ $count -ne 0 ]]; do
    count=$(( $count - 1 ))
    [[ $count -eq 0 ]] && return 1
    sleep 20
  done
  echo $(curl -s $SERVICE_URL | python -c "import sys, json; print(json.load(sys.stdin)['version']['number'])")
}

if [[ "$INTEGRATION" != "true" ]]; then
  bundle exec rspec -fd spec/inputs -t ~integration -t ~secure_integration
else
  if [[ "$SECURE_INTEGRATION" == "true" ]]; then
    extra_tag_args="--tag secure_integration"
  else
    extra_tag_args="--tag ~secure_integration --tag integration"
  fi

  echo "Waiting for cluster to respond..."
  VERSION=$(wait_for_es)
  echo "Cluster $VERSION is Up!"
  bundle exec rspec -fd $extra_tag_args --tag version:$VERSION spec/inputs/integration
fi
