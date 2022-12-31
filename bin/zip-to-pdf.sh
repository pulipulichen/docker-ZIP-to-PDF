#!/bin/bash

if [ ! -f "$1" ]; then
  echo "$1 does not exist."
  exit
fi

# ------------------

# 先確認有沒有git
if ! command -v git &> /dev/null
then
  echo "git could not be found"
  xdg-open https://git-scm.com/downloads &
  exit
fi

# 再確認有沒有node
if ! command -v node &> /dev/null
then
  echo "node could not be found"
  xdg-open https://nodejs.org/en/download/ &
  exit
fi

# ---------------
# 安裝或更新專案

PROJECT_NAME=docker-ZIP-to-PDF

if [ -d "/tmp/${PROJECT_NAME}" ];
then
  cd "/tmp/${PROJECT_NAME}"
  git reset --hard
  git pull --force
else
	# echo "$DIR directory does not exist."
  cd /tmp
  git clone "https://github.com/pulipulichen/${PROJECT_NAME}.git"
  cd "/tmp/${PROJECT_NAME}"
fi

# -----------------
# 執行指令

for var in "$@"
do
  if [ ! -f "${var}" ]; then
    echo "$1 does not exist."
    continue
  fi
  node "/tmp/${PROJECT_NAME}/index.js" "${var}"
done
