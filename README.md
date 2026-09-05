# The Local Setup

Local setup is hard. Thankfully, this repo does most of it for you!

If anything isn't working, check out the [FAQ](#faq). If that doesn't solve your problem, please reach out to a tech leader for assistance!

## Prerequisites

- **WSL:** If you're on Windows, you need to have set up [WSL](https://learn.microsoft.com/en-us/windows/wsl/install).
- **Docker:** Install docker via [Docker Desktop](https://docs.docker.com/desktop). Don't install docker engine (the `docker` package on linux). You'll have to install it from Docker's website or the AUR.
- **Bash or Cmd:** If you're on windows, you should be able to run the `*.bat` files with either Powershell or Cmd. If you're on MacOS or Linux, you should be able to run the `*.sh` files with whatever terminal emulator you use. They do have a shebang for `/usr/bin/env bash`, so nixos users may need special setup for that.
- **SSH:** If you haven't set up an SSH key or PAT for PV yet, see the [Setting up SSH](#setting-up-ssh) for details on how to do that.

## Setup

I'm going to refer to all scripts here as `*.sh`, but just know that there's a `*.bat` alternative for Windows users.

1. Make sure docker is running. You can test by running `docker ps` in your terminal; if it doesn't fail, you're good to go!
2. Verify that `~/.ssh/id_pv` and `~/.ssh/id_pv.pub` exist. If they don't, or you're not sure, see [Setting up SSH](#setting-up-ssh).
3. Verify that your Github Personal Access Token exists in [.access-token](.access-token). If it doesn't, see [Setting up a Github PAT](#setting-up-a-github-pat).
4. Copy [home-template](./home-template) and rename it to [home](./home).
    - Configure the [.gitconfig](./home/.gitconfig) with your PV Github username and email.
    - Feel free to update any other configs as you see fit! I'd recommend against removing anything from [install.sh](./home/install.sh) or [.bashrc](./home/.bashrc) unless you're confident in what you're doing though.
5. Run `./login.sh YourGithubUsername`. This will authenticate you with the Github Container Repository so you can pull down the container image. If it fails, you may have misconfigured your PAT or SSH key.
6. Run `./start.sh [public|private]`. This will create a container which runs indefinitely, which is great for attaching into as a devcontainer. Use `public` if you don't have access to [the-api](https://github.com/Progressive-Victory/the-api), `private` otherwise.

**Note:** This container will keep running until you kill it. You can kill it in the Docker Desktop, or by running `docker rm -f the-local-setup`.

**Note 2:** This container will not start on boot. To restart the container, run `./start.sh [public|private]` again.

### Setting up SSH

If you've already created a PV ssh key on your github account, all you have to do is rename them `id_pv` and `id_pv.pub` respectively. Make sure they're in `~/.ssh/`! That'll be `/home/<username>/.ssh/` for linux users, `/Users/<username>/.ssh/` for MacOS users, and `C:\Users\<username>\.ssh\` for Windows users (or `D:\`, or `E:\`, etc.).

If you haven't, follow [this guide](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account) to create your keys. Make sure the keys are named `id_pv[.pub]` on your local computer, or rename them if they're not.

### Setting up a Github PAT

You'll need a Github PAT (Personal Access Token) to be able to download the container image, since it's private.

1. Log into your PV github, and go to Settings
2. Go to 'Credentials', then 'Personal access tokens (classic)'
3. Generate a new token, and add the `read:packages` scope.
4. Copy the resulting keystring and paste it into [.access-token](./.access-token) (you may need to create the file).

If all of that is done properly, running `./login.sh` should succeed.

## Usage

Once the container is running, you can trivially run `./attach.sh` in your terminal to attach into the docker container. From there, all your favorite repositories are just a `cd pv/the-<repo>` away! You can exit back out via `exit`.

The repos are also symlinked to [./pv/](./pv/), and you can open that folder in whichever editor you'd like to edit the files as usual. You still have to run commands (`git pull`, `pnpm dev`, etc.) in an attached terminal, but such is life.

If you use [VSCode](https://code.visualstudio.com/), you can run `code pv.code-workspace` in this directory to launch a workspace preconfigured with all the repositories.

### Configuring Environment Variables

If you need to adjust any environment variables, such as the-website's target API, you can edit run `vim ~/.bashrc` while attached into the docker container. If you're unfamiliar with vim, see [this cheatsheet](https://vim.rtorr.com/) for help. Once you're done, save and run `source ~/.bashrc` to get the new values into your terminal. Note that any other attached terminals will continue using the old values until you source them!

### Shortcuts

Shortcuts for the main repositories exist as command-line flags for the `./attach.sh` scripts. You can use the following:

- `./attach.sh api [run]`
- `./attach.sh bot [run|deploy]`
- `./attach.sh contracts`
- `./attach.sh website [run]`

The first argument determines the repo to enter. Passing `run` automatically runs `pnpm dev` in that directory, and passing `deploy` runs `pnpm dev-deploy`.

You can also run `./attach.sh db` to connect directly to the local database.

#### Examples

```bash
# automatically move to the API repo
./attach.sh api

# automatically run `pnpm dev` in the website repo
./attach.sh website run

# connect to the local instance of the database
./attach.sh db
```

## Building new Images

If you're not a tech leader, you can safely ignore this section. Have fun coding!

Otherwise, I hope hell isn't too warm for you.

See the [build README](./build/README.md) for instructions on how to build and publish new images.

## FAQ
