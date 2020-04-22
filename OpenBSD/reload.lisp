(defun reload-iked (resource os)
  (declare (ignore resource os))
  (run-as-root "/etc/rc.d/iked reload"))

(defun reload-pf.conf (resource os)
  (declare (ignore resource os))
  (run-as-root "pfctl -f /etc/pf.conf"))

(defun reload-postgresql (resource os)
  (declare (ignore resource os))
  (run-as-root "/etc/rc.d/postgresql reload"))

(defun reload-sshd (resource os)
  (declare (ignore resource os))
  (run-as-root "/etc/rc.d/sshd reload"))
