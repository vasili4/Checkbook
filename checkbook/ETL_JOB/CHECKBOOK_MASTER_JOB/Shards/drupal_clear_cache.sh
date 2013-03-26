#!/bin/sh

ssh checkbook@web1 'cd /var/www/html/sites/default; drush --nocolor cc all'
ssh checkbook@web2 'cd /var/www/html/sites/default; drush --nocolor cc all'
ssh checkbook@web3 'cd /var/www/html/sites/default; drush --nocolor cc all'

echo "Drupal Cache cleared"

exit 0
