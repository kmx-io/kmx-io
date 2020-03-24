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
          (resource 'file "/usr/local/bin/genpassword"
                    :owner "root"
                    :group "wheel"
                    :mode #o755
                    :content (read-file "OpenBSD/usr/local/bin/genpassword"))
          ;; Thomas de Grivel (kmx.io)
          (resource 'group "dx"
                    :gid 19256
                    :ensure :present)
          (resource 'user "dx"
                    :uid 19256
                    :gid 19256
                    :home "/home/dx"
                    :ensure :present)
          ;; Thibaut Poullain
          (resource 'group "vrizzt"
                    :gid 5000
                    :ensure :present)
          (resource 'user "vrizzt"
                    :uid 5000
                    :gid 5000
                    :ensure :present)
          ;; William Ribeiro (CapSens) -> port 7000,8000
          (resource 'group "wilrib"
                    :gid 6000
                    :ensure :present)
          (resource 'user "wilrib"
                    :gid 6000
                    :uid 6000
                    :home "/home/wilrib"
                    :ensure :present)
          ;; git
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
                    :content (read-file "vu.kmx.io/home/git/.ssh/authorized_keys"))
          ;; Nginx
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
          ;; PostgreSQL
          (resource 'file "/var/postgresql/data/pg_hba.conf"
                    :owner "_postgresql"
                    :group "_postgresql"
                    :mode #o600
                    :content (read-file "vu.kmx.io/var/postgresql/data/pg_hba.conf"))
          ;; Deploy scripts
          (resource 'directory "/home/scripts"
                    :owner "root"
                    :group "wheel"
                    :mode #o755)
          (resource 'file "/home/scripts/deploy"
                    :owner "root"
                    :group "wheel"
                    :mode #o755
                    :content (read-file "vu.kmx.io/home/scripts/deploy"))
          (resource 'file "/home/scripts/prepare"
                    :owner "root"
                    :group "wheel"
                    :mode #o755
                    :content (read-file "vu.kmx.io/home/scripts/prepare"))
          (resource 'file "/home/scripts/start"
                    :owner "root"
                    :group "wheel"
                    :mode #o755
                    :content (read-file "vu.kmx.io/home/scripts/start"))
          (resource 'file "/home/scripts/start_"
                    :owner "root"
                    :group "wheel"
                    :mode #o755
                    :content (read-file "vu.kmx.io/home/scripts/start_"))
          ;; Conference-staging
          (resource 'group "conference-staging"
                    :gid 3000
                    :ensure :present)
          (resource 'user "conference-staging"
                    :uid 3000
                    :gid 3000
                    :home "/home/conference-staging"
                    :shell "/bin/ksh"
                    :ensure :present)
          (resource 'file "/etc/nginx/available/conference-staging.kmx.io.conf"
                    :owner "root"
                    :group "wheel"
                    :mode #o644
                    :content (read-file "vu.kmx.io/etc/nginx/available/conference-staging.kmx.io.conf"))
          ;; Conference
          (resource 'group "conference"
                    :gid 3001
                    :ensure :present)
          (resource 'user "conference"
                    :uid 3001
                    :gid 3001
                    :home "/home/conference"
                    :shell "/bin/ksh"
                    :ensure :present)
          (resource 'file "/etc/nginx/available/conference.kmx.io.conf"
                    :owner "root"
                    :group "wheel"
                    :mode #o644
                    :content (read-file "vu.kmx.io/etc/nginx/available/conference.kmx.io.conf"))
          ;; seuldanslenoir-staging
          (resource 'group "seuldanslenoir-staging"
                    :gid 3002
                    :ensure :present)
          (resource 'user "seuldanslenoir-staging"
                    :uid 3002
                    :gid 3002
                    :home "/home/seuldanslenoir-staging"
                    :shell "/bin/ksh"
                    :ensure :present)
          (resource 'directory "/var/www/seuldanslenoir-staging"
                    :owner "seuldanslenoir-staging"
                    :group "www"
                    :mode #o755
                    :ensure :present)
          (resource 'file "/etc/nginx/available/seuldanslenoir-staging.conf"
                    :owner "root"
                    :group "wheel"
                    :mode #o644
                    :content (read-file "vu.kmx.io/etc/nginx/available/seuldanslenoir-staging.conf")))

(with-host "vu.kmx.io"
  (sync *host*))
