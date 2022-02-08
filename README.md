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

> frwd will automatically fetch https certificates on demand by using [Let's Encrypt](https://letsencrypt.org).
> The more ports available the more certificates might be created. 

```shell
docker run  \
    --detach \
    --restart always \
    --name frwd \
    --network host \
    --env DOMAIN=example.com \
    --env AUTHORIZED_KEYS_BASE64=AAAA \
    --volume /frwd_data:/data \
    eunts/frwd:latest
```

## A note about persistence
To keep *frwd* from regenerating and reissuing certificates use a named volume for the docker command:
```shell
docker run ... --volume /frwd_data:/data ....
```

## A note about networking
In theory you could use the publish option of docker:
```shell
docker run --publish 80:80 --publish 443:443 --publish 22:22
```
This, however, will drop the tcp functionalty.  
Instead of publishing all ports that you want to use for tcp mode the `--network host` option can be used to automatically 
expose all ports frwd listens on. Notice that this could conflict with your sshd setting.


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
