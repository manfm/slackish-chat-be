#!/bin/bash --login

rvm requirements
rvm install 2.2.1
rvm use 2.2.1
rvm rubygems current

gem install rails
