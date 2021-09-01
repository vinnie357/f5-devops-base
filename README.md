# f5-devops-base
f5-devops-base dev container based on ubuntu

size about 492MB

## tools:

- git
- jq
- curl
- wget
- zsh
- oh-my-bash/zsh
- python3

build local to test:
```bash
IMAGE_NAME="f5-devops-base"
docker build -t ${IMAGE_NAME} .
# test your build locally
docker run --rm -it ${IMAGE_NAME} bash
```
if successful tag and push to registry:
```bash
REGISTRY="vinnie357"
IMAGE_NAME="f5-devops-base"
IMAGE_TAG="latest"
# https://docs.docker.com/engine/reference/commandline/tag/
# alernatively you can build a new image and tag to preseve local
docker build -t ${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG} .
# !login to your registry!
# note: docker desktop may also log you in
docker push ${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}
```


## lint

https://github.com/hadolint/hadolint

```bash
docker run --rm -i hadolint/hadolint < Dockerfile
```