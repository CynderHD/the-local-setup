# Building the Local Setup

In order to change default environment variables, add repositories, or modify local setup in any meaningful way, you're going to need to build and publish a new docker image. While only leaders will need to do this, general vols may want to to customize their setup.

Note that this README is targetted only to leaders; while you can probably manage the sqldump using your local database, I'm not going to spell it out here.

## 1. SQL Dump

First, you're going to need to dump the dev database into a local sql file so it can be baked into the image.

1. If you haven't already, install `mysql` or `mariadb` locally.
1. Run `gcloud auth login`
1. Launch your cloud sql proxy, similar to if you were about to launch dbeaver.
1. Run `./sqldump.sh <root-sql-password>`.

If all goes well, you should have a brand new `dump.sql` file. Hooray!

## 2. Environment Variables

Next you'll need to set up the environment variables that'll be baked into the image's `~/env.sh`.

1. Make a copy of [.env.example](./.env.example), called `.env`
1. Make a copy of [public.env.example](./public.env.example), called `public.env`
1. Fill in the values of any `"---" # SECRET` variables. The other values are prefilled since they're not secret, but you're welcome to change them as needed.
1. **BE SURE YOU ONLY PASTE DEV SECRETS!** Purging prod secrets from the image registry ~~would~~ will be a royal pain, and the less we need to do that, the better.

## 3. Building the Image

If all is well, running `./build.sh` should build a `progressive-victory:latest` docker image. It will also build a public `progressive-victory-public:latest` image.

I recommend starting the image as a devcontainer (run `./start.sh progressive-victory[-public]:latest` in the parent directory) and verifying that the correct environment variables and whatever else are present. Otherwise, you're liable if anything goes wrong.

## 4. Publishing the Image

1. Go to your github account, and create a classic personal access token (PAT) with `read:packages` and `write:packages` permissions. Copy the resulting key and paste it into `../.access-token`.
1. Log into docker (run `./login.sh` in the parent directory). You may need to set up a local passkey store first, depending on what it says.
1. Run `./publish.sh`.

Once the publish finishes, you should notify the team that a new version of `the-local-setup` is released for them to download.
