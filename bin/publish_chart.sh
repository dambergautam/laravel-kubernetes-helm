#!/usr/bin/env bash


DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd );

DIR_ROOT="${DIR/\/bin/}";

export ENVIRONMENT_LOCAL="local";
export ENVIRONMENT_TEST="tst";



#
# Apply chart into the test environment with the testing container image or
# production one based on the current branch. The replica set used in the
# previous release will stick around after the release has been completed, this
# is a known bug.
#


ENV_CHART_NAME="laravel";
VERSION_NUMBER="0.1.0"

echo "Waiting for update to complete, this may take a couple of minutes...";
helm upgrade \
    --kube-context="${ENV_CHART_NAME}" \
    --install \
    --values "${DIR_ROOT}/chart/values.yaml" \
    --set image.tag="${VERSION_NUMBER}" \
    --set database.password="laravel_password" \
    --wait \
    "${ENV_CHART_NAME}" \
    "${DIR_ROOT}/chart";

echo "Helm chart applied successfully.";
