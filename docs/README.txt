README
======

This directory should be used to place project specfic documentation including
but not limited to project notes, generated API/phpdoc documentation, or
manual files generated or hand written.  Ideally, this directory would remain
in your development environment only and should not be deployed with your
application to it's final production location.


Setting Up Your VHOST
=====================

The following is a sample VHOST you might want to consider for your project.

NameVirtualHost *:443
NameVirtualHost *:80

<VirtualHost *:80>
ServerName zend.local
DocumentRoot /home/richard/projects/zend-blank-project/public
SetEnv APPLICATION_ENV development
</VirtualHost>

<VirtualHost *:443>
ServerName sdpshop.local
DocumentRoot /home/richard/projects/zend-blank-project/public
SetEnv APPLICATION_ENV development
SSLEngine on

 SSLCertificateFile /etc/apache2/ssl/server.crt
 SSLCertificateKeyFile /etc/apache2/ssl/server.key
        #SSLCertificateFile /etc/apache2/ssl/apache.pem
</VirtualHost>