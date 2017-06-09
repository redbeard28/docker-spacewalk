Dockerfile - Spacewalk
======================

### Change answer.txt file ###
Please, change conf/answer.txt file to your needs.

### Build ###
```
root@redbeard28:~# git clone https://github.com/redbeard28/docker-spacewalk /opt/dredbeard28-spacewalk
root@redbeard28:~# docker build --rm -t redbeard28/spacewalk /opt/redbeard28
```

### Run ###
```
root@redbeard28:~# docker run --privileged=true -d --name="spacewalk" spacewalk
```
```
root@redbeard28:~# docker inspect -f '{{ .NetworkSettings.IPAddress }}' spacewalk
172.16.1.40
```

## Nginx - Reverse proxy ###
Generating Self-signed Certificate
```
root@redbeard28:~# mkdir /etc/nginx/ssl
root@redbeard28:~# cd /etc/nginx/ssl
```

```
root@redbeard28:~# openssl genrsa -des3 -out spacewalk.key 1024
Generating RSA private key, 1024 bit long modulus
..........................................................++++++
......................................................++++++
e is 65537 (0x10001)
Enter pass phrase for spacewalk.key:
Verifying - Enter pass phrase for spacewalk.key:
root@redbeard28:~# openssl req -new -key spacewalk.key -out spacewalk.csr
Enter pass phrase for spacewalk.key:
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:FR
State or Province Name (full name) [Some-State]:Centre
Locality Name (eg, city) []:CHARTRES
Organization Name (eg, company) [Internet Widgits Pty Ltd]:mydomain.io
Organizational Unit Name (eg, section) []:System Team
Common Name (e.g. server FQDN or YOUR name) []:spacewalk.mydomain.io
Email Address []:redbeard28@mydomain.io

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
An optional company name []:
```

```
root@redbeard28:~# cp spacewalk.key spacewalk.key.bak
root@redbeard28:~# openssl rsa -in spacewalk.key.bak -out spacewalk.key
Enter pass phrase for spacewalk.key.bak:
writing RSA key
```

```
root@redbeard28:~# openssl x509 -req -days 365 -in spacewalk.csr -signkey spacewalk.key -out spacewalk.crt
Signature ok
subject=/C=FR/ST=Centre/L=CHARTRES/O=mydomain.io/OU=System Team/CN=spacewalk.mydomain.io/emailAddress=redbeard28@mydomain.io
Getting Private key
```

```
root@redbeard28:~# cat /etc/nginx/nginx.conf
## Nginx ##
user nginx;
pid logs/nginx.pid;
error_log logs/error.log;
access_log off;
 
worker_processes 2;
events {
    worker_connections 1024;
    use epoll;
}

http {
    include mime.types;
    default_type application/octet-stream;
    types_hash_max_size 2048;
    server_names_hash_bucket_size 64;
    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
    '$status $body_bytes_sent "$http_referer" '
    '"$http_user_agent" "$http_x_forwarded_for"';
 
    ## TCP options
    tcp_nodelay on;
    tcp_nopush on;

    # Virtualhost
    server {
        listen  80;
        listen  443;
        server_name spacewalk.mydomain.io;

	# SSL
	ssl on;
	ssl_certificate			ssl/spacewalk.crt;
	ssl_certificate_key		ssl/spacewalk.key;
	ssl_protocols			SSLv3 TLSv1;
	ssl_prefer_server_ciphers	on;
	ssl_ciphers			ALL:!ADH:!EXPORT56:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv3:+EXP:HIGH:!aNULL:!MD5;

        location / {
            proxy_set_header Host $host;
            proxy_set_header X-Forwarded-Host $host;
            proxy_set_header X-Forwarded-Server $host;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_pass https://localhost:443;
            client_max_body_size 10M;
        }
    }
}
```
```
root@redbeard28:~# service nginx restart 
```



# Run docker behind a proxy !
Source documentation from docker website...

First, create a systemd drop-in directory for the docker service:
```bash
mkdir /etc/systemd/system/docker.service.d
```

Now create a file called /etc/systemd/system/docker.service.d/http-proxy.conf that adds the HTTP_PROXY environment variable:
```bash
[Service]
Environment="HTTP_PROXY=http://proxy.example.com:80/"
```

For HTTPS create a file called /etc/systemd/system/docker.service.d/https-proxy.conf that adds the HTTPS_PROXY environment variable:
```bash
[Service]
Environment="HTTPS_PROXY=http://proxy.example.com:80/"
```

If you have internal Docker registries that you need to contact without proxying you can specify them via the NO_PROXY environment variable:
/etc/systemd/system/docker.service.d/no-proxy.conf
```bash
[Service]
Environment="NO_PROXY=localhost,127.0.0.0/8,10.20.*,docker-registry.somecorporation.com"
```

Flush changes:
```bash
$ sudo systemctl daemon-reload
```

Verify that the configuration has been loaded:
```bash
$ sudo systemctl show --property Environment docker
Environment=HTTP_PROXY=http://proxy.example.com:80/
```

Restart Docker:
```bash
$ sudo systemctl restart docker
```

# Run docker **container** behind a proxy !
Put an ENV in the Dockerfile

```bash
ENV http_proxy "http://X.X.X.X:3128"
ENV https_proxy "http://X.X.X.X:3128"
```