#!/bin/bash

# 用法：./build.sh [stable|sabr]
# tag 取自 image 裡 yt-dlp 的實際版本；sabr 另外補 commit，因為分支的 version.py 不會跟著 commit 跳版號
channel=${1:-stable}
case "$channel" in
	stable)
		ytdlpSpec="yt-dlp[default]"
		tagPrefix=""
		commitSuffix=""
		;;
	sabr)
		# release 已經被拿掉，只能裝 git 分支
		ytdlpSpec="yt-dlp[default] @ git+https://github.com/bashonly/yt-dlp@feat/youtube/sabr"
		tagPrefix="sabr-"
		sabrCommit=$(git ls-remote https://github.com/bashonly/yt-dlp refs/heads/feat/youtube/sabr | cut -c1-7) || exit 1
		commitSuffix="-$sabrCommit"
		;;
	*)
		echo "Usage: ./build.sh [stable|sabr]"
		exit 1
		;;
esac

clear

echo "Remove latest docker image"
latestVersion=$(cat .latestVersion)
docker image rm -f jun112561/dotnet_with_yt-dlp:$latestVersion

echo
echo "Start build '$channel' from $ytdlpSpec"
docker build --no-cache --progress=plain --build-arg YTDLP_SPEC="$ytdlpSpec" -t jun112561/dotnet_with_yt-dlp:build . || exit 1

version=$(docker run --rm jun112561/dotnet_with_yt-dlp:build yt-dlp --version) || exit 1
image="jun112561/dotnet_with_yt-dlp:$tagPrefix$version$commitSuffix"
docker tag jun112561/dotnet_with_yt-dlp:build "$image" || exit 1
docker image rm jun112561/dotnet_with_yt-dlp:build
echo "$tagPrefix$version$commitSuffix" > .latestVersion
echo "Tagged '$image'"
echo "StreamRecordTools/Dockerfile 的 FROM 記得改成 $image"

echo
echo 'Show now ffmpeg version'
docker run --rm "$image" ffmpeg -version | grep "ffmpeg version"

echo
echo 'Show now yt-dlp version'
docker run --rm "$image" yt-dlp --version

echo
echo 'Show now streamlink version'
docker run --rm "$image" streamlink --version

echo
echo 'Start run yt-dlp download to test it can normal download video'
docker run --rm "$image" yt-dlp -f ba+bv https://www.youtube.com/watch\?v=3eN5PsgWRwM

echo
read -e -p 'If everything is ok. Please press any key to push this image'
docker push "$image"
