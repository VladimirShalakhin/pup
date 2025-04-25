#!/bin/sh
# Configure path for NGINX
if [ "$NGINX_INSTALL" == "1" ]; then sed -i "s|#NGINX_PHP_PATH#|$NGINX_PHP_PATH|g" /etc/nginx/conf.d/default.conf; fi
# Install Composer deps
if [ -f ${APP_DIR}/composer.json ] && [ ! -d ${APP_DIR}/vendor ] && [ -f ${NGINX_PHP_PATH}/index.php ]; then { \
  echo "Running Composer Dependencies Installation";
  if [ -f ${APP_DIR}/composer.lock ]; then rm ${APP_DIR}/composer.lock; fi;
  echo $(composer -n install);
  echo "Composer Dependencies Installation Finished";
}; fi
#php artisan migrate