#!/bin/bash

git pull origin master
RAILS_ENV=production rake db:migrate
RAILS_ENV=production rake assets:precompile
if [ $1 -eq 1 ]; then
  rails s -e production -b 128.199.232.38 -p 3000
fi
