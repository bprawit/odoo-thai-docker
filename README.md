# Odoo Thai docker
Docker image for Odoo 10 that support Thai language
## Detail
Due to Odoo base docker repository not support Thai language and not prepare to install useful Odoo module auto_backup,
I build this docker image to let developer easy to getting started Odoo 10 in a minute without conflict in the config file.
This project fork from: https://github.com/odoo/docker/tree/b3d6d018f740ad2a816b5209300b875e2760085e/10.0
## How to use
I assume you already install docker and git on your machine.
### Clone this repository.
### Change to demo directory.
```
$ cd demo
```
### Start docker container.
```
docker-compose up
```