(resource 'group "tunnel"
          :gid 7800
          :ensure :present)
(resource 'user "tunnel"
          :uid 7800
          :gid 7800
          :home "/home/tunnel"
          :shell "/bin/null-shell"
          :ensure :present)
(resource 'directory "/home/tunnel"
          :owner "root"
          :group "tunnel"
          :mode #o750
          :ensure :present)
(resource 'directory "/home/tunnel/.ssh"
          :owner "root"
          :group "tunnel"
          :mode #o750
          :ensure :present)
(static-file "/home/tunnel/.ssh/authorized_keys"
             :owner "root"
             :group "wheel"
             :mode #o644)
