(in-package :cl-user)

(asdf:load-system :adams :force t)

(asdf:load-system :cl-heredoc)
(set-dispatch-macro-character #\# #\> #'cl-heredoc:read-heredoc)

(in-package :adams-user)

(setf (debug-p :shell) t)
(setf (debug-p :sb-shell) nil)
(adams:clear-resources)
(adams:clear-probed)

(resource 'host "ams.kmx.io"
          :user "root"
          :hostname "ams"
          :packages '("emacs:no_x11" "git" "rsync" "sbcl" "texinfo" "texlive_texmf-full")
          (resource 'group "dx"
                    :gid 19256)
          (resource 'user "dx"
                    :uid 19256
                    :gid 19256
                    :home "/home/dx"))

(resource 'host "vu.kmx.io"
          :user "root"
          :hostname "vu"
          :packages '("emacs:no_x11" "git" "nginx" "rsync" "sbcl" "texinfo" "texlive_texmf-full")
          (resource 'group "dx"
                    :gid 19256
                    :ensure :present)
          (resource 'user "dx"
                    :uid 19256
                    :gid 19256
                    :home "/home/dx"
                    :ensure :present)
          (resource 'group "git"
                    :gid 7000
                    :ensure :present)
          (resource 'user "git"
                    :uid 7000
                    :gid 7000
                    :home "/home/git"
                    :shell "/usr/local/bin/git-auth"
                    :ensure :present)
          (resource 'group "conference-staging"
                    :gid 3000
                    :ensure :present)
          (resource 'user "conference-staging"
                    :uid 3000
                    :gid 3000
                    :home "/home/conference-staging"
                    :shell "/bin/ksh"
                    :ensure :present)
          (resource 'group "conference"
                    :gid 3001
                    :ensure :present)
          (resource 'user "conference"
                    :uid 3001
                    :gid 3001
                    :home "/home/conference"
                    :shell "/bin/ksh"
                    :ensure :present)
          (resource 'directory "/etc/nginx"
                    :owner "root"
                    :group "wheel"
                    :mode #o755)
          (resource 'file "/etc/nginx/nginx.conf"
                    :owner "root"
                    :group "wheel"
                    :mode #o644
                    :content #>---------->
# Take note of http://wiki.nginx.org/Pitfalls

user  www;
worker_processes  1;

#load_module "modules/ngx_stream_module.so";

error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;
#error_log  syslog:server=unix:/dev/log,severity=notice;

#pid        logs/nginx.pid;

worker_rlimit_nofile 1024;
events {
    worker_connections  800;
}


http {
    include       mime.types;
    default_type  application/octet-stream;
    index         index.html index.htm;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  logs/access.log  main;
    #access_log  syslog:server=unix:/dev/log,severity=notice main;

    #tcp_nopush     on;

    #keepalive_timeout  0;
    keepalive_timeout  65;

    #gzip  on;

    server_tokens off;

    include enabled/*.conf;
}
----------)
          (resource 'directory "/etc/nginx/enabled"
                    :owner "root"
                    :group "wheel"
                    :mode #o755)
          (resource 'directory "/etc/nginx/available"
                    :owner "root"
                    :group "wheel"
                    :mode #o755)
          (resource 'file "/etc/nginx/available/conference-staging.kmx.io.conf"
                    :owner "root"
                    :group "wheel"
                    :mode #o644
                    :content #>---------->
server {
    listen  80;
    listen  [::]:80;
    server_name conference-staging.kmx.io;
    return 301 "https://conference-staging.kmx.io/";
}
server {
    listen  443 ssl;
    listen  [::]:443 ssl;
    server_name  conference-staging.kmx.io;
    root         /var/www/conference-staging;

    access_log  logs/conference-staging.access.log  main;

    error_page  404              /404.html;
    error_page   500 502 503 504  /500.html;

    location @rails {
        proxy_pass   http://127.0.0.1:15000;
    }

    try_files $uri @rails;

    location ~ /\. {
        deny  all;
    }

    include ssl.conf;
}
----------)
          (resource 'file "/etc/nginx/available/conference.kmx.io.conf"
                    :owner "root"
                    :group "wheel"
                    :mode #o644
                    :content #>---------->
server {
    listen       80;
    listen       [::]:80;
    server_name conference.kmx.io;
    return 301 "https://conference.kmx.io/";
}
server {
    listen       443 ssl;
    listen       [::]:443 ssl;
    server_name  conference.kmx.io;
    root         /var/www/conference;

    access_log  logs/conference.access.log  main;

    error_page  404              /404.html;
    error_page   500 502 503 504  /500.html;

    location @rails {
        proxy_pass   http://127.0.0.1:15001;
    }

    try_files $uri @rails;

    location ~ /\. {
        deny  all;
    }

    include ssl.conf;
}
----------)
          (resource 'directory "/home/scripts"
                    :owner "root"
                    :group "wheel"
                    :mode #o755)
          (resource 'file "/home/scripts/deploy"
                    :owner "root"
                    :group "wheel"
                    :mode #o755
                    :content #>---------->#!/bin/sh
set -e

. ./config

cd "${SITE}"

git fetch
git reset --hard "origin/${BRANCH}"

echo "$(git rev-parse HEAD) deploy [preparing]" >> ../deploy.log

export SECRET_KEY_BASE=$(head -n 1 ../.secret-key-base)

/home/scripts/prepare

echo "$(git rev-parse HEAD) deploy" >> ../deploy.log
bundle25 exec rails restart
----------)
          (resource 'file "/home/scripts/prepare"
                    :owner "root"
                    :group "wheel"
                    :mode #o755
                    :content #>---------->#!/bin/sh
set -e

bundle25
bundle-audit25 --update

yarn
yarn audit

bundle25 exec rake db:dump
bundle25 exec rake db:migrate

bundle25 exec rake assets:clobber assets:precompile

rsync -aL public/. "/var/www/$USER/"
----------)
          (resource 'file "/home/scripts/start"
                    :owner "root"
                    :group "wheel"
                    :mode #o755
                    :content #>---------->#!/bin/sh
exec nohup /home/scripts/start_ &
----------)
          (resource 'file "/home/scripts/start_"
                    :owner "root"
                    :group "wheel"
                    :mode #o755
                    :content #>---------->#!/bin/sh
set -e

. ./config
cd "${SITE}"

echo "$(git rev-parse HEAD) start [preparing]" >> ../deploy.log

export SECRET_KEY_BASE=$(head -n 1 ../.secret-key-base)

/home/scripts/prepare

echo "$(git rev-parse HEAD) start" >> ../deploy.log
bundle25 exec puma -b "tcp://127.0.0.1:${PORT}"
echo "$(git rev-parse HEAD) stop" >> ../deploy.log
----------))

(with-host "vu.kmx.io"
  (sync *host*))
