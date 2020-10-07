#!/usr/bin/env sh

# set access log location from optional ENV var
if [ ! -n "$SERVER_ACCESS_LOG" ] ; then
  SERVER_ACCESS_LOG='/dev/stdout'
fi

# set error log location from optional ENV var
if [ ! -n "$SERVER_ERROR_LOG" ] ; then
  SERVER_ERROR_LOG='/dev/stderr'
fi

# set server name from optional ENV var
if [ ! -n "$SERVER_NAME" ] ; then
  SERVER_NAME='localhost'
fi


if [ -n "$PROXY_HOST" ] ; then

  cp /etc/nginx/proxy.template /etc/nginx/conf.d/default.conf
  sed -i "s|\${PROXY_HOST}|${PROXY_HOST}|" /etc/nginx/conf.d/default.conf
  sed -i "s|\${PROXY_SSL_PORT}|${PROXY_SSL_PORT}|" /etc/nginx/conf.d/default.conf
  sed -i "s|\${PROXY_PORT}|${PROXY_PORT}|" /etc/nginx/conf.d/default.conf
  sed -i "s|\${SERVER_NAME}|${SERVER_NAME}|" /etc/nginx/conf.d/default.conf

  # Remove the ssl section if a SSL port isnt specified
  if [ ! -n "$PROXY_SSL_PORT" ] ; then
    sed -i '/^##START_SSL_UPSTREAM##/,/^##END_SSL_UPSTREAM##/{/^##START_SSL_UPSTREAM##/!{/^##END_SSL_UPSTREAM##/!d}}' /etc/nginx/conf.d/default.conf
    sed -i '/^##START_SSL_SERVER##/,/^##END_SSL_SERVER##/{/^##START_SSL_SERVER##/!{/^##END_SSL_SERVER##/!d}}' /etc/nginx/conf.d/default.conf
    sed -i 's/^##[^#]*##$//g' /etc/nginx/conf.d/default.conf
  else
    else lets just remove the comment blocks and make it pretty.
    sed -i 's/^##[^#]*##$//g' /etc/nginx/conf.d/default.conf
  fi

fi

if [ -n "$SERVER_REDIRECT" ] ; then
  # set redirect code from optional ENV var
  # allowed Status Codes are: 301, 302, 303, 307, 308
  expr match "$SERVER_REDIRECT_CODE" '30[12378]$' > /dev/null || SERVER_REDIRECT_CODE='301'

  # set redirect code from optional ENV var for POST requests
  expr match "$SERVER_REDIRECT_POST_CODE" '30[12378]$' > /dev/null || SERVER_REDIRECT_POST_CODE=$SERVER_REDIRECT_CODE

  # set redirect code from optional ENV var for PUT, PATCH and DELETE requests
  expr match "$SERVER_REDIRECT_PUT_PATCH_DELETE_CODE" '30[12378]$' > /dev/null || SERVER_REDIRECT_PUT_PATCH_DELETE_CODE=$SERVER_REDIRECT_CODE

  # set redirect path from optional ENV var
  if [ ! -n "$SERVER_REDIRECT_PATH" ] ; then
    SERVER_REDIRECT_PATH='$request_uri'
  fi

  # set redirect scheme from optional ENV var
  if [ ! -n "$SERVER_REDIRECT_SCHEME" ] ; then
    SERVER_REDIRECT_SCHEME='$redirect_scheme'
  fi

  cp /etc/nginx/redirect.template /etc/nginx/conf.d/default.conf
  sed -i "s|\${SERVER_REDIRECT}|${SERVER_REDIRECT}|" /etc/nginx/conf.d/default.conf
  sed -i "s|\${SERVER_NAME}|${SERVER_NAME}|" /etc/nginx/conf.d/default.conf
  sed -i "s|\${SERVER_REDIRECT_CODE}|${SERVER_REDIRECT_CODE}|" /etc/nginx/conf.d/default.conf
  sed -i "s|\${SERVER_REDIRECT_POST_CODE}|${SERVER_REDIRECT_POST_CODE}|" /etc/nginx/conf.d/default.conf
  sed -i "s|\${SERVER_REDIRECT_PUT_PATCH_DELETE_CODE}|${SERVER_REDIRECT_PUT_PATCH_DELETE_CODE}|" /etc/nginx/conf.d/default.conf
  sed -i "s|\${SERVER_REDIRECT_PATH}|${SERVER_REDIRECT_PATH}|" /etc/nginx/conf.d/default.conf
  sed -i "s|\${SERVER_REDIRECT_SCHEME}|${SERVER_REDIRECT_SCHEME}|" /etc/nginx/conf.d/default.conf
fi

ln -sfT "$SERVER_ACCESS_LOG" /var/log/nginx/access.log
ln -sfT "$SERVER_ERROR_LOG" /var/log/nginx/error.log

echo "Configuration complete, generated /etc/nginx/conf.d/default.conf with the following content:"
cat /etc/nginx/conf.d/default.conf

exec nginx -g 'daemon off;'
