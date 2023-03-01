# frwd
Just another **nearly zero configuration** ngrok ssh alternative.  
With automatic https, http and tcp support.

## Setup
1. Deploy using your favorite cloud provider.

Make sure to pass following environment variables

| environment variable     | required | description                               | example         | default  |
|--------------------------|----------|-------------------------------------------|-----------------|----------|
| `DOMAIN`                 | yes      | the domain                                | `example.com`   |          |
| `AUTHORIZED_KEYS_BASE64` | yes      | base64 encoded .ssh/authorized_keys file  | `AAAA`          |          |
| `SSHD_PORT`              | no       | the sshd port frwd listen on           | `2222`          | `2222`   |

> frwd will automatically fetch https certificates on demand by using [Let's Encrypt](https://letsencrypt.org).
> The more ports available the more certificates might be created.

```shell
docker run  \
  --detach \
  --restart unless-stopped \
  --name frwd \
  --network host \
  --env DOMAIN=example.com \
  --env AUTHORIZED_KEYS_BASE64=AAAA \
  --env SSHD_PORT=2222 \
  --volume /frwd_data:/data \
  eunts/frwd:latest
```
2. Point your domain to the ip address of your server running the docker container.

3. Download and adjust the helper [frwd.sh](frwd.sh).

4. Run `frwd.sh <LOCAL-PORT> [REMOTE-PORT]`.

## A note about networking
In theory you could use the `publish` option of docker:
```shell
docker run ... --publish 80:80 --publish 443:443 --publish 2222:2222 ...
```
However this will disable the tcp functionalty.
It is not advised to publish all ports you want to use for tcp mode!
Docker starts one process for every port that is published.
Instead use the `--network host` option so all ports *frwd* listens on get exposed directly.  
Notice that this could conflict with your sshd setting.

## A note about persistence
To keep *frwd* from regenerating and reissuing certificates use a named volume for the docker command:
```shell
docker run ... --volume /frwd_data:/data ....
```

# Usage without [frwd.sh](frwd.sh)

1. Run a local server such as
```
python3 -m http.server 8000
```
2. Connect
```
ssh -P 2222 -R 9000:127.0.0.1:8000 frwd@example.com
```
3. Browse to `https://9000.example.com`, `http://9000.example.com` or `http://example.com:9000`
