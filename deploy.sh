#!/bin/bash
echo "Deploying math.andrej.com."
bundle exec jekyll build
rsync --recursive --links --delete --verbose _site/ andrej@lisa.andrej.com:/var/www/mathematics-and-computation/
