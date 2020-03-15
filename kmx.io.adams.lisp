(in-package :cl-user)

(asdf:load-system :adams :force t)

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
          :packages '("emacs:no_x11" "git" "rsync" "sbcl" "texinfo" "texlive_texmf-full")
          (resource 'file "/root/test"
                    :content "toto=tata"
                    :owner "root"
                    :group "wheel")
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
                    :ensure :present))

(with-host "vu.kmx.io"
  (sync *host*))
