
Deploy using your favorite cloud provider.

Make sure to pass following environment variables:

| environment variable  | description | example                           |
|-----------------------|------------|------------------------------------|
| DOMAIN                | the domain | example.com                        |
| AUHORIZED_KEYS_BASE64 | base64 encoded .ssh/authorized_keys file | AAAA |


## Deploy using docker 
Example:
```
docker run
    --detach \
    --restart always \
    --publish 80:80 \
    --publish 443:443 \
    --publish 22:22 \ 
    --env DOMAIN=example.com \
    --env AUHORIZED_KEYS_BASE64=AAAA \
    eunts/frwd:latest
```


# Usage

1. Run a local server such as
   ```
   python3 -m http.server 8000
   ```
2. Connect
   ```
   ssh -R 9000:8000 your-domain.com
   ```
3. Browse to https://9000.your-domain.com