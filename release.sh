#!/usr/bin/env bash
set -e

echo_green() {
    echo -e "\e[0;32m${@}\e[0m"
}

echo_yellow() {
    echo -e "\e[0;93m${@}\e[0m"
}

rebuild() {
    local chart=$1
    mkdir -p dist/
    version=$(helm inspect chart $chart | grep version | sed 's/.*: //')
    echo_green "Building version $version for $chart"

    helm package -d dist $chart 
    helm repo index --merge docs/index.yaml dist --url https://n0rad.github.io/charts/

    mv dist/* docs/
    rmdir dist
}

if [ -z $1 ]; then
    for d in *; do
        [ $d == "docs" ] && continue
        [ -d $d ] || continue 

        # echo_green $d

        version=$(helm inspect chart $d | grep version | sed 's/.*: //')
        if [ -f docs/$d-$version.tgz ]; then
            # echo_yellow "version $version already exists for $d. Not rebuilding it"
            continue
        fi

        rebuild $d

    done
else
    rebuild $1
fi