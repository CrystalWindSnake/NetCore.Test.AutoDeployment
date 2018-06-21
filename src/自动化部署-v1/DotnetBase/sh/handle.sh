#!/bin/sh

# call such as:
# sh handle.sh /src pjname /published cw.myweb.dll
src_dir=$1
pj_name=$2
publish_dir=$3
dll_name=$4

cd ${src_dir}/${pj_name}
/usr/bin/dotnet publish -o $publish_dir -c release

cd $publish_dir
/usr/bin/dotnet $dll_name