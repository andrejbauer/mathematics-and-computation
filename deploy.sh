#!/bin/bash
echo "Deploying math.andrej.com."
git checkout master
git pull
bundle exec jekyll build
echo "Synching with the server."
rsync --recursive --links --delete _site/ andrej@lisa.andrej.com:/var/www/mathematics-and-computation/
