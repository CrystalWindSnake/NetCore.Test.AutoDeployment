#!/bin/sh

# call such as:
# sh pull_cp.sh /src git@gitee.com:carson_add/CrystalWind.Study.WebApi.GithubWatcher.git

source_dir=$1
git_add=$2

is_empty_dir(){
    return $(ls -A ${source_dir}|wc -w)
}

if is_empty_dir 
then
    # echo "git clone ${git_add} ${source_dir}"
    $(git clone ${git_add} ${source_dir})
else
    echo "pull"
    $(cd ${source_dir})
    git pull
fi