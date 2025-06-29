#!/usr/bin/env bash

# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
# Not using "-x" because we aren't debugging.
set -Eeuo pipefail

# We get unbound var err if we don't set arg
arg="${1:-}"

echo "$helm_password" | helm registry login -u "$helm_username" --password-stdin "$helm_host"

#helm lint devopscoop/*
helm lint devopscoop/app

#for chart in devopscoop/*; do
for chart in devopscoop/app; do
  chart_name=$(echo "$chart" | cut -d/ -f2)
  chart_version=$(grep '^version: ' "${chart}/Chart.yaml" | cut -d' ' -f 2)

  helm package "${chart}"

  # If chart already exists in the chart repository, don't push.
  if helm pull "oci://ghcr.io/devopscoop/charts/${chart_name}" --version "${chart_version}" &> /dev/null; then
    echo -e "\e[31mWARNING: Chart ${chart_name} version ${chart_version} already exists in the repository.\nThis means that the chart's code has not changed, or you forgot to update the version in Chart.yaml.\e[0m"
  else
    if [[ $arg == 'push' ]]; then
      helm push "${chart_name}-${chart_version}.tgz" "oci://ghcr.io/devopscoop/charts"
    fi
  fi
done
