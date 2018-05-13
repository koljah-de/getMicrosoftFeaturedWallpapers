#!/bin/bash
# getMicrosoftFeaturedWallpapers by koljah
# https://github.com/koljah-de/getMicrosoftFeaturedWallpapers
# Microsoft Featured Wallpapers: https://support.microsoft.com/en-us/help/17780/featured-wallpapers

if [ -n "$(curl -s --head http://kbdevstorage1.blob.core.windows.net/asset-blobs/ | head -n1 | cut -d ' ' -f2)" ]; then
  base_url="http://kbdevstorage1.blob.core.windows.net/asset-blobs/"
elif [ -n "$(curl -s --head http://msegceporticoprodassets.blob.core.windows.net/asset-blobs/ | head -n1 | cut -d ' ' -f2)" ]; then
  base_url="http://msegceporticoprodassets.blob.core.windows.net/asset-blobs/"
else
  echo "The website is not reachable."
  exit 1
fi

mkdir -v -p ./MSFeaturedWallpapers
cd ./MSFeaturedWallpapers

get_picture () {
  url_head="$(curl -s --head "${base_url}${1}_en_1")"
  if [[ $(echo "$url_head" | head -n1 | cut -d ' ' -f2) -eq 200 ]] && echo "$url_head" | grep "Content-Type: image/jpeg" > /dev/null 2>&1; then
    wget -cnv -O "${1}_en_1.jpg" "${base_url}${1}_en_1"
    while [ $? -ne 0 ]; do
      wget -cnv -O "${1}_en_1.jpg" "${base_url}${1}_en_1"
    done
  fi
}

i=18897
while [ $i -le 19987 ]; do
  par_max=$((i + $(nproc)*15))
  if [ $par_max -ge 19987 ]; then
    par_max=19988
  fi
  for ((i; i < $par_max; i++)); do
    get_picture "$i" &
  done
  wait
done

get_picture "20036"

exit 0