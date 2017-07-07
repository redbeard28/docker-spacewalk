Modify vars ansible file
-------------

## What is inside
```bash
proxy_env:
  http_proxy: "{{ vault_proxy_url }}"
  https_proxy: "{{ vault_proxy_url }}"
  host: "{{ vault_proxy_ip }}"
  port: "{{ vault_proxy_port }}"
  no_proxy: "{{ vault_no_proxy }}"

pushit: 'false'
```

    proxy_env => used if vault not empty.
    
    pushit => push to docker hub or local registry