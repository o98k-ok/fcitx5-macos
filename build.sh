#!/bin/bash

function help() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  html                  Build html template"
    echo "  prepare               Prepare for fcitx5-macos build"
    echo "  fm, fcitx5-macos      Build fcitx5-macos"
    echo "  install               Install fcitx5-macos"
    echo "  clean                 Clean build files"
    echo "  -h, --help            Show this help message"
    exit 0
}

if [[ $# -eq 0 ]]; then
    help
fi

while [[ $# -gt 0 ]]; do
    case $1 in
        clean)
            echo "cleaning build files"
            rm -rf build
            shift
            ;;
        html)
            echo "building html template"
            cd fcitx5-webview
            pnpm run build
            cd ..
            shift
            ;;
        prepare)
            echo "preparing for fcitx5-macos build"
            ./scripts/install-deps.sh
            npm i -g pnpm
            pnpm --prefix=fcitx5-webview i
            shift
            ;;
        fm|fcitx5-macos)
            echo "starting fcitx5-macos build"
            cmake -B build/$(uname -m) -G Ninja -DCMAKE_BUILD_TYPE=Debug
            cmake --build build/$(uname -m) 
            shift
            ;;
        install)
            echo "installing fcitx5-macos"
            sudo cmake --install build/$(uname -m)
            shift
            ;;
        -h|--help)
            help
            ;;
        *)
            help
            ;;
    esac
done