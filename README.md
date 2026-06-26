# The Local Setup

Local setup is hard. Thankfully, this repo does most of it for you!

If anything isn't working, reach out to a tech leader for assistance.

## Prerequisites

- **Docker:** If you're on a sane operating system, you should be able to install docker via [Docker Desktop](https://docs.docker.com/desktop). Otherwise, you can install the [Docker Engine](https://docs.docker.com/engine/install/) as a CLI-only tool.
- **Bash or Cmd:** If you're on windows, you should be able to run the `*.bat` files with either Powershell or Cmd. If you're on MacOS or Linux, you should be able to run the `*.sh` files with whatever terminal emulator you use.
- **SSH:** If you haven't set up an SSH key for PV yet, see the [SSH README](./pv/.ssh/README.md) for details on how to do that.

## Setup

I'm going to refer to all scripts here as `*.sh`, but just know that there's a `*.bat` alternative for Windows users.

To download and start the container, make sure docker is running (you can test by running `docker ps` in your terminal), then run `./start.sh`. This will create a container which runs indefinitely, which is great for attaching into as a devcontainer.

**Note:** This container will keep running until you kill it. You can kill it in the Docker Desktop, or by running `docker compose down -t 0`. You'll need that `-t 0` or the command will never finish!

## Usage

Once the container is running, you can trivially run `./attach.sh` in your terminal to attach into the docker container. From there, all your favorite repositories are just a `cd pv/the-<repo>` away! You can exit back out via `exit`.

The repos are also symlinked to [./pv/pv/](./pv/pv/), and you can open that folder in whichever editor you'd like to edit the files as usual. You still have to run commands (`git pull`, `pnpm dev`, etc.) in an attached terminal, but such is life.

If you use [VSCode](https://code.visualstudio.com/), you can run `code pv.code-workspace` in this directory to launch a workspace preconfigured with all the repositories.

### Configuring Environment Variables

If you need to adjust any environment variables, such as the-website's target API, you can edit run `vim ~/.bashrc` while attached into the docker container. If you're unfamiliar with vim, see [this cheatsheet](https://vim.rtorr.com/) for help. Once you're done, save and run `source ~/.bashrc` to get the new values into your terminal. Note that any other attached terminals will continue using the old values until you source them!

## SSH Keys

If you've already created a PV ssh key on your github account, paste the private and public keys in this folder, named `id_pv` and `id_pv.pub` respectively.

If you haven't, follow [this guide](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account) to create your keys. You don't need to add them to any SSH keyring or agent; just create the files, add your public key to your PV github account, and copy the files into this folder.

## Building new Images

If you're not a tech leader, you can safely ignore this section. Have fun coding!

Otherwise, I hope hell isn't too warm for you.

First, create a `.env` file from the `.env.example` template, and fill it out. This will bake any provided environment variables into the docker image, **SO BE SURE YOU ONLY PASTE DEV SECRETS!** Purging prod secrets from the image repository ~~would~~ will be a royal pain.

Second, run `gcloud auth login`, and then `./sqldump.sh`.

Second, run `./build.sh`, followed by the usual `./start.sh` and `./attach.sh`. Make sure you can still run all repositories locally, and that they work as expected.

If all looks good, run `./publish.sh`. Make sure your git credentials are correct! The publish will fail if you don't have sufficient permissions. If the publish succeeds, you should be free to notify the team that a new version is published.
