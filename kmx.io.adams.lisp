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
          :packages '("emacs:no_x11"
                      "git"
                      "nginx"
                      "postgresql-server"
                      "rsync"
                      "ruby-2.5.7"
                      "sbcl"
                      "texinfo"
                      "texlive_texmf-full")
          (resource 'file "/etc/ssh/sshd_config"
                    :owner "root"
                    :group "wheel"
                    :mode #o644
                    :content (read-file "vu.kmx.io/etc/ssh/sshd_config"))
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
          (resource 'file "/etc/git-auth.conf"
                    :owner "root"
                    :group "git"
                    :mode #o640
                    :content (read-file "vu.kmx.io/etc/git-auth.conf"))
          (resource 'directory "/home/git"
                    :owner "git"
                    :group "git"
                    :mode #o700)
          (resource 'directory "/home/git/.ssh"
                    :owner "git"
                    :group "git"
                    :mode #o700)
          (resource 'file "/home/git/.ssh/authorized_keys"
                    :owner "root"
                    :group "git"
                    :mode #o640
                    :content (read-file "vu.kmx.io/home/git/.ssh/authorized_keys")
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
                    :content (read-file "vu.kmx.io/etc/nginx/nginx.conf"))
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
----------)
          (resource 'file "/var/postgresql/data/pg_hba.conf"
                    :owner "_postgresql"
                    :group "_postgresql"
                    :mode #o600
                    :content #>---------->
# TYPE  DATABASE        USER            ADDRESS                 METHOD

# superusers
local   all             postgres                                peer
local   all             dx                                      peer
local   all             zor                                     peer

# deployments
local   conference-staging conference-staging                   peer
local   conference      conference                              peer

# "local" is for Unix domain socket connections only
#local   all             all                                     scram-sha-256
# IPv4 local connections:
#host    all             all             127.0.0.1/32            scram-sha-256
# IPv6 local connections:
#host    all             all             ::1/128                 scram-sha-256
# Allow replication connections from localhost, by a user with the
# replication privilege.
#local   replication     all                                     scram-sha-256
#host    replication     all             127.0.0.1/32            scram-sha-256
#host    replication     all             ::1/128                 scram-sha-256
----------))

(with-host "vu.kmx.io"
  (sync *host*))
