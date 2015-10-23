# Docker-Solr_Dovecot
Docker implemtation of Solr to work with Dovecot



## How to use it

```
# cd /opt
# git clone https://github.com/Branlala/Docker-Solr_Dovecot.git
# cd Docker-Solr_Dovecot
# docker build -t solr-dovecot .
```

Build process may take some minutes to succeed, it depends of you Internet Bandwidth.
When all will be done, you'll se a message like this :

```
Removing intermediate container 252636081be6
Successfully built 0cea91398543
```

Once your image is built, you'll have to do a litlle bit of configuration, first of all, edit the script named `solr_satic_ip.sh`.


```
# vi ./solr_satic_ip.sh
```

Adjust, if needed :
* The name of your network interface, in my case it's `em1`
* The name of the image, it should be `solr-dovecot` if you used the command and gave above or `mrraph/docker-solr_dovecot` if you pulled the image form the Hub
* The static IP address

Finaly, fire up the container using the script `solr_satic_ip.sh`.


```
# ./solr_satic_ip.sh
```

## Dovecot configuration to use Solr

Install the required package, in Ubuntu  :

```
# apt-get install dovecot-solr
```

Edit the following file :

```
# vi /etc/dovecot/conf.d/90-plugin.conf
```

Add the following lines at the end of the file :


```
mail_plugins = $mail_plugins fts fts_solr
plugin {
  fts = solr
  fts_solr = url=http://10.0.0.1:8983/solr/ break-imap-search
  fts_autoindex = yes
}
```


Adjust the IP address if you changed it in the script `solr_satic_ip.sh`.

Finaly, run :
```
# service dovecot restart
```
