#!/usr/bin/env bash 

base_path=`cd "$(dirname "$0")"; pwd`
cd $base_path
bundle
RAILS_ENV=production rake assets:precompile
bundle exec unicorn -l 0.0.0.0:3000 -E production
