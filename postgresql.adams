(resource 'group "postgres"
          :gid 7200
          :ensure :present)
(resource 'user "postgres"
          :gid 7200
          :uid 7200
          :ensure :present)
(static-file "/var/postgresql/data/pg_hba.conf"
             :owner "root"
             :group "_postgresql"
             :mode #o640
             :after #'reload-postgresql)
