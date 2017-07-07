Modify vault file
------

## Create your vault file
```bash
ansible-vault create PATH_TO/secrets/xxx-secrets.yml
```

**ATTENTION**: replace xxx with the name of your var site contenent.

## Inside the vault secrets file
```bash
###### SPECIFICS ########
vault_proxy_url: http://IP:PORT
vault_proxy_ip: IP
vault_proxy_port: PORT
vault_no_proxy: localhost,127.0.0.0/8
vault_docker_registry_server: Nothing if docker hub
vault_registry_user: docker_login
vault_registry_passwd: docker_passwd
vault_registry_email: exemple@imagine.com

###### SPACEWALK VARS #########
vault_spacewalk_admin_email: postmaster@imagine.com
vault_spacewalk_ssl_org: NAME_OFFICE
vault_spacewalk_ssl_org_unit: MY_ENTITY
vault_spacewalk_ssl_set_city: MY_CITY
vault_spacewalk_ssl_set_state: MY_STATE
vault_spacewalk_ssl_set_country: MY_COUNTRY
vault_spacewalk_ssl_password: MY_SSLPASS
vault_spacewalk_ssl_set_email: postmaster@imagine.com
vault_spacewalk_ssl_config_sslvhost: Y
vault_spacewalk_db_backend: postgresql
vault_spacewalk_db_name: spaceschema
vault_spacewalk_db_user: spaceuser
vault_spacewalk_db_password: spacepw
vault_spacewalk_db_host: localhost
vault_spacewalk_db_port: 5432
vault_spacewalk_enable_tftp: Y
```

## Explanation
    vault_proxy_* => evrything about your proxy office

    vault_no_proxy => no proxy for those internal IP
    
    vault_docker_registry_server => Put nothing if no local register

