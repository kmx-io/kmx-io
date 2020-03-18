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
                    :content #>---------->
# kmx.io/conference.kmx.io
thibpoullain       git-upload-pack  'kmx.io/conference.kmx.io.git'
thibpoullain       git-receive-pack 'kmx.io/conference.kmx.io.git'
thodg              git-upload-pack  'kmx.io/conference.kmx.io.git'
thodg              git-receive-pack 'kmx.io/conference.kmx.io.git'
zor                git-upload-pack  'kmx.io/conference.kmx.io.git'
zor                git-receive-pack 'kmx.io/conference.kmx.io.git'
conference-staging git-upload-pack  'kmx.io/conference.kmx.io.git'
conference         git-upload-pack  'kmx.io/conference.kmx.io.git'

# thodg/config
thodg git-upload-pack  'thodg/config.git'
thodg git-receive-pack 'thodg/config.git'
----------)
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
                    :content #>---------->
# devs

environment="GIT_AUTH_ID=thibpoullain" ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCxdEtUFP/7GnXLMq1K+Qp2be/iX2cX4sc/W9ET3AHDs+WNgvoRvWMUDBoR7jGl3UgA4IUI9L409r2IqVHZ0YZDPrZxQXJjFGfFFHqaj0wMZbAY0OUsHEye2SVYRoJrglCI1CLaFVCLJxOto3AEgKmk+SSVdaz0NNgn8pKfbDyUrQP73P1uAzvTTR8k13tqYiUj5gLbXQyeF/KK26EDbrwO2MuA6XbRy5aZM3gnCc1mBg7+cVqc9r6cGKJnQzjfjMF0kFxqjXBOLMgtu7Rdv9s6HP7m+sk+9/5Uy8DCSLd23va11w4zXBdVumH99f7rFrbqSNiMV+LBmpjX2P3JOuzS6Aglq05wpScZeP17LxFtA8VwPxMScBsA3ejjmk/raJpBHyiVw1Rpd1Cfr41tX8Rzc2EOUZrsMb+0G3vUzj8UXuREQT8XTSi12BtgEl5lbgCZRQLvVK4rwH9djtC+j/82zvit4z95DZH9HwRYkS96kk90vBl381krMd74qwVaJ7ZjWB1fMBVDgHt1tBCL6eUFXRlkbC2lDYYAfP/fxiC8vKRJC7WHXxJ5N3Hoz9ZW1kfRahOhD1BgdiVg3jgaTrc2T40JD+DZLTrOL5SDSF2jCClQVd+EblBX1/++/HjwXGsom4rYIGohncK77oalk06KEExeRrdrevDGy/TcPtMNdQ== thibpoullain@github.com

environment="GIT_AUTH_ID=thodg" ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDOI/z1eKGPZ0RcrYP7y8g/nurnEhESIRz2ZrIo+dx8uuETeqMCqBLgVqnC6Qgd5BrVX0eSUkPk7HyXhsJrvOt2Y9m10/rRmmcXi6+NezMLKYow3JigmjR+WmUtJFqDXUQn7wj3LLRwpuDyGEuR+0rC85AcYXy7Ho8kZ/k0zFZqE9JXNaJ2XrXpMsNb9aCjBR5rD8p34yPAlhaO7613XEyvr4TVV7+hcVxS9Y6PYtegIB3yqVL3QebkQDor8h2snUuj0DqxfHlslmBPeoQN1REVv+x01OPiO+rxFG7leOA37uxUmCS9RsUvS5zwZZzmpj5GRSYEc5rhNl0LrXKbr1yV dx@x1

environment="GIT_AUTH_ID=thodg" ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5W5HJbaxzzuDFbvp7V1T3HTluAn3lrHNYfga3HygfMBKd6JvqQWOpfEooYMcemhUgtbLMdT1SCPVJ+4joCgr9qCqPkpBOnbDxybHQd+D2rFmPvv5zo0AiY+pX8sMHhh1rK7/wNerAEmi3MFBlY/496zOi2LbiKLjmRC1YBMHD+3dejZ6abQ/TjKE2lzV/dVGmCr/1ALBPB9LWISc/5RDB+/29MbgoGcc4EN5MmoxIezT5PKMbWv/+hAmrNjqm6GMIEKauAegPjRIzNIgPPrvA08FFd8xKo7JnXmtALKNLUI4rnl0y9uHS1Ry29FQeFRKgvneAx4AU1uprcWttGlZb dx@m3

environment="GIT_AUTH_ID=thodg" ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCX1F7giPdvf/HKeljt1LL2Mjk0a12T5SE7VxccQlgKCBqlc1HYlUv25f1TyvuxFUWDRMhhbLQlqgOmWeIN022Lxu3Oq3ZYHnA8nqO/3NK5eIynUiz7TYAerBKWNxq3ClFDI8BhV03qY/Fd5fsLPxbyRJMJ+d6lwrkhIL06T+IXC6k43dHDAG2ssE1Hkd4HkaKGJ7cZBQNHW0HpYmar+p19rXifJEQ069Wblz7sdv8LPIjN/8Fay0GMGM+/Kyc03TtHPuvPAd5I7mIkN2Ii7/+Yu0oPGVsrx7qzqex3JoF/UtBMcABKtKzJ2W+VxsyNyit8nwvF7V6Wa+SVXIR4AowxmtslNZlVARVm80FmFkfH9m8KcGKLmAExX0AYmByWU11M/tdUMQhUe+x2sx/u81hj2s08v1GOXRCKAMSBZbiiPrKXmjjyBx4yZgVDkyGl7gl53rCBu1mYkmSKaiec0u8Mh/SZagDLYFG43Di2yp+Pov+dCj+l+RD+kZLls0PI0jd3R17U9Xkha0A+qPuJiHymV0GXDD3UiyycWIIFkxpRBN196clQVNRK68GVt6eiC783e5vxXggIJ0zAp13Qqz0oy32r2a3gIVjZ85ysJQ8GAzyc07OTYnGY4ub5UarGDu2NTUfYCvyWZkbNTnIhSoIxDarin8fUHCsfMGC940Ezow== dx@t60.kmx.io

environment="GIT_AUTH_ID=thodg" ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC/kIEZNP12nCyWXPm94Hg157Wb37MW7po6aEWAgxpoevKpBO3HgGZylvCvKpMij++TJ3H6ciGJLUGH2hvvez33pcKgPwK/L9I1V74HOTPcGitawucMhp39WsfzXySf6kmU3pE+zP71spUp8XNJq7pN30eDEZtDj4n3wBh4BcK/HHz8Xmhb9q3abH+70O/zT08OVhO37Ar/gBUhS7FHBHaa8tvnARzfnUwivSnmA1dfAUbWwmTbZsSHd6gaL4h9AtyntJQLWxNYOfPc5lTvXMoSWs2qMsFaKtV3n209F/vcqUOhpJ9bssLtEnhOcBQ4+CQWpZj+ZLe7+m48MEu26RHjAO7o0j/Uy1CyHWYQZ8aNEDg4oqVZKbCOPuuw4Q0UmdzjxbVzsELYuCRafjFKJO3ESLhAqSSdX5+JQZarR8eqNQe9/ZX9IkY/2ErGRzk8Y8FwHPXwRA+WTzoW5vJTjZP84gJJPQE0k8QSTUvWJMMl1ufTvwbBIR2DUfDGi4LsR8U= dx@amd.local

environment="GIT_AUTH_ID=thodg" ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDfcNAZpNpvOTpJJh4+H4KYv8jhxCMMRYwtOd46Sv06G82x4lmBO3InauEfSXK7qc9/2HvoFkdFHtO/uGSuY3cp42k6TI1I00l7o5ByO2Ofsg6I+BhKjXAtmfCcfs6GbEvEYbkUSyyj67U/vSchNjTVv8uyEEpOYEspi59/U3o+/XxLobxWt35IovaJETmbf55feBOZtbc2mzI7Zr4Qm63sDtmq6O6ipPqs99F+uRKgT0gF9e+C/6RXSa0sV9GqFqWIXpV0qJ9yhwJbrBkBCVUIT9huQwgkGBzSkd5NbMnuGoLEOWTZdaCxHXqBj5Vdv9Gg4Rt2TKYFoplv6B0i3JCR dx@amd

environment="GIT_AUTH_ID=thodg" ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAEAQCzflF3uuvW5IPdClqr7X4ZG5sceYXzuNVJBaBm/4gPTdXo3I5Zk+lu2xEbECNwxrvcdgb7J64mJLlKykqiRi/yPDdOluZ6kDX2bBdPKvvM30Vh0YlGgDBTX5/8be9w01lN66vfk5oE5bkVdLy5q4NS/VHy+pfSEWJaoKxN2hLBLzSoh+a1/XnPy8CfPGvppvg+Ss+aiVuSLGW6N7b10acSiiyk4A9dYQCoCdX0Ihhl3i4e0Sqv+eIbdeHDDmOsTtZSOI+Lxui7WlUdeoIi8cp3kRjxVfQ/mZL8lDCakOg12og0G0ABY0yqN/pbBu32VrQWiKUExPrjMC0pvFlrWlUBvYEXgpx+5zcpz/aNu1KHBRqdEePOTSUH0DR6bLriuKilll8nl9q0VTIxVY1dBCZoSaV+a2QnEQu7HoMyCO4T0JzaaDiGVibhuGsEoj8p/HQezv3XKFTv70gWdL9+um5YaZPk10qF1WyP+B0TbmC/F2txUTdIfzasPXxp6du5KtnkdFMnU05CIpd+cG9FcyAePFpmVhD6lJ59iS0zYkOkRXgo8N9jijn/T2IPsS2/kYejfeTjQw4rUcNmWl9pYBrEA1WUbjhmaB23FAITDn6pN6hq24fu386OcBXvoZdRRdnRrhJ5KYix+vA6zseUhYIqGubQNWF9OqSh/YuBGrg3WNoUPEg+HL5oVZxtRTk6sTig+Upksa3nv4H1qX2NWsfptsdJvYeadeRcEhd4ib8eWgVQf/lh0y0CsLVB/gJOVjejm1vuXEgBez9eywdj9kYh0qznMvhvv1JLNru1qDqxiHFPebLbZyS5jHpNDPvgEHAxb22C94lC/INOtdREAe27+KUOo0MAm8p/lMXCpJiHb9jsuX/lqSDZNwKMHi1p9g9TwFslWiMu9FpfIHL884o/rUJppaaZ2PV0CkQWjigpz3ukyr18RPVMjlHnWe6ePpgZP7bbSwBgOPEqvucHsbZGeeEGrEiNjFraZejgu3RP6Z1hQGv2Xi87IxbRb0vKdVLvbrK7ETXS710c45k4+tGtpxGeImtEgnKZnQDzI8kQKgXsRZ0NJjQJAFeCk9+bohZyqa0UIuxISTPt8qzWx6f3lWTYrUVAR9QdRKA006SKA5hw8J/Y/eRF2bwJnhBZSYnYUXxQ9Cvq7WkzlFbqOIFN9PCQM4XuhIsaBjOaRkmJMrJO1NTMyRsnlkOdagIVNuQas0L+ln7hE11pQa5RN4RKQow3Xm/CzSHgK+yliMwsDkfQAKMC2BHoHE0Zme7POQniPZwC4ZuFfh7U0N1hd448U4oprHJaKh9ru1tgPbqAHm5hKp9MefILhNp6CrxTYw4/1y5tkNIRv6UVkSQNY1cL dx@x1.local

environment="GIT_AUTH_ID=thodg" ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDb5aYa+B33vRq0osV5Lukq2JFR44R+ow3Blq0fUFoPl8lKSddBDGVkMBcdJdv5op6A4ZvMKGiG4alHOos1ZbY0Sd3j/rTEfRkuQixte9jw+2pSUOA4BU6yhUnozzlKnY9BUQxom+H9+DCnspoK+NJx4v47eVJ9bGekvGhbD22JfuwPlfrTEepph0LWNHv/ssujG11CQar3X9SKMzG+GjBfYnLyMH7zyycnpz1zRFb/S5Is5wO0Ya5esuNaWDcGbpcf8xyfu1aN1L1GAplc7fhHjHj2zLowOUq7QiOPlb/1a7Xiyh/ByHcJJYQlLsbQbBxJ7hX/bKZC1xlXiDXscOc//ItmuM3eWP7ajdMIEWq7yqyMVgQag4+H6LnHVO0Bm96ZkMr3X4bav2Ym6jz7AgyTK/0jN8vqiY91f6mdl8bmzmwcH1rKhUFAFUoXVqqSDzrjxVENG1QODBfZsK1VSK5o/3lrHy3CPte1to9VmF7oIFTG0h3/wEeGEUea4pFKv3c= dx@reed.kmx.io

environment="GIT_AUTH_ID=zor" ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAvX+OuJKeHvBScLxig8OieDQ3gAIDl2EBsym42/kPPyB7NZnD5o/NEL/jj3Mymly7vkft3o5/3hohF3PzyadSAdh5w1O9B1sWM2Tpp2nW8EP+LI13y+3EHFBpeVp5kFx7MILNCMWpqit8xBOxKp3MUpdS7rja1AGAEZdLh3o/g8cFxKp678asAEMViDMOmAcBXdNknZtQH2cnJ60EyVWvtgoimvuAl+A+h9Eknn44noX3SGeCPztiGLJJGeM6fgg2yF7T4st+NaqYhczFonE0qjcz/sDlvvEOt5uBgaf9mzRWetZXip6fadI+zKay56FCtrusYW4YXj/u/0NwBRrUcQ== zor@github.com/mrzor.keys

# deploy

environment="GIT_AUTH_ID=conference-staging" ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDIZCbeUE9dfw478VMNWz+ytrZcz6MZgIG+6lINDr1Wy2CCSoNZH1NOJC7QbInF6jjZc0wPuxTxbRAV7M9nFecbaAmYbcd94EFWd1Qr9eBz1NBSB74QUAro0oUvq26S8MT3tUB/cVommWQx48lAM07rruv/0mWuv+fZ95q54f4E16Pf+d4HbSVRDsrsWOfkUOUf4SERM80L395AGultCdg+qLdcCH0bOydhiR+jE8qq1w3D6Mm/O4/B1FSVkEIRgB0t2a7ND1sr7VSW8AWqHVuqD0tq5ZwjInHU2IxTCCvvFbc/fWmf1IA7iDbMA+lhTQ/+ndEQ9qgpeQyEHxDWkQYTc0gyGkknmKuTSr5pgEkiAshTr0UKH8QJkYsVE284DKlECSLWTw4Swt4GMGVd6SH+bRvwd56/TGgSoKL8ql8KYJ6UPvSaLHpz0N8+Tq6HBGbzZjaPASRB13+d1zI7ftGHCsh3tdMnnjb611m3Sg0dCytohjMWx3yFvDoVMCtZxPk= conference-staging@vu

environment="GIT_AUTH_ID=conference" ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDdfnJePSMqMObD48W8RtnLFqiltgtB3UD3poOnqNsoCYrG7YJpEkRBxVxckiAtaBu2TNfFMReUQt8uMuryppsEP4ZX2uzA7afjGzKbjR1J5KydQLCGTPDYuJ8eUMYP2F5ASNcu4VxRCKerRbNEe9byaNlR2jG8u1iZJIlrt8baqlyoBfOIkM060IgFm2zXRAAYmNxe1oUaGUU1TDHE2EX+uBG+GLpdS/IsNwQaI/7zhmrDzp/q0pE4ZzkA6o0kLCXwrB+u7yx9ZQq2Ib4h9JjNEzxCFjsLDVgkRzYsnzLiKwQ/QMgPGJ10jy5GjnckOxz8kWtITx1uqrS/ZdYIWA5ZMTMz8HjCWkqEZG6xoDYDgeaXJr7jZ+wwJD83LL54ayUZmAf5ibzoWNiCJirc119dgiAsmksAbyDWT2bhO1H1j12W3QKQTMJEUIgW2v9g+240KR/309B7+2p9XhERTVvxMzOJogDcXLwIEqPQUwBgnrS2Ay5DDOiY0NKIKl8g6ns= conference@vu
----------)
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
