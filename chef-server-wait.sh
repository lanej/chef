#!/bin/sh

echo 'Waiting for chef-server to boot...'

# For some reason, the server will return a file early with a 200 OK but it's HTML.
until curl -Ok -vvvs https://chef-server:444/knife_admin_key.tar.gz 2>&1 | grep application/zip ; do
	printf '.'
	sleep 5
done

tar xvfz knife_admin_key.tar.gz
