#!/bin/bash

#UPSTREAM=${1:-'@{u}'} for some reason this throws exception only in script
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse @{u})
#BASE=$(git merge-base @ "$UPSTREAM")

file_find() {
  for d in */; do
    #spawns subshell for each iteration
    ( cd "$d"
    for file in $(ls); do
      if [[ -f $file ]]; then
        reading
      fi
    done)
  done
}

reading() {
  #IFS removes trailing whitespace
  while IFS= read -r line; do
    if [[ $file == "dependencies" ]]; then
      dependencies $line
    elif [[ $file == "url" ]]; then
      git_url $line
    fi
  done < $file
}

git_url() {
  #greps only the repo name from url
  NAME=$(echo "$line" | egrep -o '[^\/]*$')

  if [[ -e $NAME ]]; then
    cd $NAME
    #compares Local and remote branch
    if [ "$LOCAL" = "$REMOTE" ]; then
      echo "$NAME Up-to-date"
    else
      cd ..
      build
    fi
  else
    git clone $line
    build
  fi
}

#TODO
dependencies() {
  if [True]; then
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
  #file_find "dependecies"
  file_find "url"
}

main
