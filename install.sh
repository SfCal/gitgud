#!/bin/bash

rsearch() {
  for d in */; do
    ( cd "$d"
    for file in $(ls); do
      if [[ $file == "$1" ]]; then
        reading "$1" "$file"
      fi
    done)
  done
}

reading() {
  while IFS= read -r line; do
    if [[ $1 == "url" ]]; then
      url $line
    elif [[ $1 == "dependencies" ]]; then
      dependencies $line
    elif [[ $1 == "build" ]]; then
      build $line
    fi
  done < $file
}

url() {
  if [[ -e $(echo "$line" | egrep -o '[^\/]*$') ]]; then
    cd $(echo "$line" | egrep -o '[^\/]*$') && git pull
  else
    git clone $line
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
  $line
}

main() {
  rsearch "dependecies"
  rsearch "url"
  rsearch "build"
}

main
