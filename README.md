# frwd
Just another **nearly zero configuration** ngrok ssh alternative.  
With automatic https, http and tcp support.

## Setup
Deploy using your favorite cloud provider.

Make sure to pass following environment variables

| environment variable   | required | description                               | example         |
|------------------------|----------|-------------------------------------------|-----------------|
| DOMAIN                 | yes      | the domain                                | example.com     |
| AUTHORIZED_KEYS_BASE64 | yes      | base64 encoded .ssh/authorized_keys file  | AAAA            |
| MIN_PORT               | no       | minimum remote port to listen on          | 1024 (default)  |
| MAX_PORT               | no       | maximum remote port to listen on          | 2048 (default)  |

> frwd will automatically fetch https certificates on demand by using [Let's Encrypt](https://letsencrypt.org).
> The more ports available the more certificates might be created. 

```shell
docker run  \
    --detach \
    --restart always \
    --name frwd \
    --network=host \
    --env DOMAIN=example.com \
    --env AUTHORIZED_KEYS_BASE64=AAAA \
    --env MIN_PORT=1024 \
    --env MAX_PORT=2048 \
    --volume /frwd_data:/data \
    eunts/frwd:latest
```

## A note about persistence
To keep *frwd* from regenerating and reissuing certificates use a named volume for the docker command:
```shell
docker run ... --volume /frwd_data:/data ....
```


# Usage

1. Run a local server such as
   ```
   python3 -m http.server 8000
   ```
2. Connect
   ```
   ssh -R 9000:127.0.0.1:8000 frwd@example.com
   ```
3. Browse to [https://9000.example.com](https://9000.example.com), [http://9000.example.com](http://9000.example.com) or [http://example.com:9000](http://example.com:9000)


# Little helper
Utilize this `.sh` file to spin up tunnels fast:
[frwd.sh](frwd.sh).
