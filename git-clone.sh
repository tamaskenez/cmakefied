#!/bin/bash -e
#
# git-clones the specified package and copies our CMake files into the clone.
#
# Usage:
#
#     git-clone.sh [--dir=<DIR>] imgui|Box2D|combinations
#
# where
#
#     <DIR> is the the parent directory of the clone
#     The default dir is the parent dir of this repo so the package's repo
#     will be a sibling of the cmakefied directory.
#

cd "$(dirname $0)/.."
deps_dir=$PWD
cd - >/dev/null

cd "$(dirname $0)"
cmakefied_dir=$PWD
cd - >/dev/null

gitit () {
    url="$1"
    name="$2"
    branch="$3"
    dir="$deps_dir/$name"
    if [[ ! -d "$dir" ]]; then
        echo -e "\n-- Cloning [$name]: git clone $url $dir"
        git clone "$url" "$dir"
        if [[ -n "$branch" ]]; then
            cd "$dir"
            git checkout "$branch"
            cd - >/dev/null
        fi
    else
        cd "$dir"
        echo -e "\n-- Updating [$name]: cd $dir && git pull --ff-only"
        if [[ -n "$branch" ]]; then
            git checkout "$branch"
        fi
        git fetch --all -p
        git pull --ff-only
        cd - >/dev/null
    fi
    cp -Rv "$cmakefied_dir/$2"/* "$dir"
}

while [[ $# > 0 ]]; do
    if [[ $1 =~ --dir=(.*) ]]; then
        deps_dir="${BASH_REMATCH[1]}"
        shift
        continue
    fi
    case $1 in
        imgui)
            gitit "https://github.com/ocornut/imgui.git" $1
            ;;
        Box2D)
            gitit "https://github.com/erincatto/Box2D.git" $1
            ;;
        combinations)
            gitit "https://github.com/HowardHinnant/combinations.git" $1
            ;;
        *)
            echo "Invalid package: $1" >&2
            exit 1
            ;;
    esac
    shift
done
