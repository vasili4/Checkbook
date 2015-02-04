#!/bin/sh

ssh checkbook@web10000 'cd /var/www/html/sites/default; drush --nocolor cc all'

echo "Drupal Cache cleared"

exit 0
