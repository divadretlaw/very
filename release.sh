#!/bin/sh

set -e

tag=$1

# Cleanup
rm -rf .build/output

# Build
swift build -c release --arch arm64 --arch x86_64

mkdir -p .build/output

cp .build/apple/Products/Release/very .build/output/very

cd .build/output

# Zip
zip very.zip very

# SHA256

shasum=`shasum -a 256 very.zip | cut -f1 -d' '`

gh release delete "$tag" --yes || true
gh release create "$tag" -t "$tag" -n ""
gh release upload "$tag" very.zip

git clone git@github.com:divadretlaw/homebrew-tap.git
cd homebrew-tap

sed "s/{{SHASUM}}/$shasum/" Templates/very.rb | sed "s/{{TAG}}/$tag/" > Formula/very.rb

git add Formula/very.rb
git commit -m "Update very"
git push

cd ..
rm -rf homebrew-tap