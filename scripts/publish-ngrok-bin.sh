#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/.."

for platform in $(cat scripts/platforms.txt)
do
  echo "Publishing packages/ngrok-bin-$platform..."
  pushd "packages/ngrok-bin-$platform"
  npm publish -bin-$platform --access public
  popd
done

pushd packages/ngrok-bin
npm publish --access public
popd