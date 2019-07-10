#!/bin/bash

rsearch() {
  for d in */; do
    ( cd "$d"
    for file in $(ls); do
      if [[ -f $file ]]; then
        reading
      fi
    done)
  done
}

reading() {
  while IFS= read -r line; do
    if [[ $file == "dependencies" ]]; then
      dependencies $line
    elif [[ $file == "url" ]]; then
      url $line
    fi
  done < $file
}

url() {
  if [[ -e $(echo "$line" | egrep -o '[^\/]*$') ]]; then
    cd $(echo "$line" | egrep -o '[^\/]*$') && git pull
    if [[ True ]]; then
      cd ..
      build
    else :
    fi
  else
    git clone $line
    build
  fi
}

dependencies() {
  if [[ $1 == "update" ]]; then
    :
  else
    apt install $line
  fi
}

build() {
  while IFS= read -r line; do
    $line
  done < "build"
}

main() {
  #rsearch "dependecies"
  rsearch "url"
  #rsearch "build"
}

main
