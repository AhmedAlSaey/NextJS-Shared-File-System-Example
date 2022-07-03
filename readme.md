# Static Tweet

Completely customizable static tweet for Next.js applications.

This project is built from a [Next.js example](https://github.com/lfades/static-tweet) that uses ISR. The main purpose of this repository is not to demonstrate the features in it, but rather demonstrate how we can use a shared file system in order to serve multiple deployed containers using a shared folder for the generated ISR pages. This will help us having a single point of truth for our pages in order to invalidate them easily on demand.

## Demo

https://static-tweet.vercel.app/1238918791947522049

## How to use


To have full access to all Twitter elements, like videos and polls, you'll need a Twitter API Token, once you have it, copy the [`.env.local.example`](.env.local.example) file in the root directory to `.env.local` (which will be ignored by Git):

```bash
cp .env.local.example .env.local
```

Then add your API token to `.env.local`, it should look like this:

```bash
TWITTER_API_TOKEN=...
```

For polls, make sure that you have **Tweets and Users** from **Twitter Labs** enabled for your app. It's required to get access to polls metadata.

You will find 2 branches in this repository.


The branch `using-host-volumes` demonstrates how we can use docker's host volumes as a shared file system for the generated static pages. This type of volumes need manual initialization by the first container using the volume with the generated SSG.

The branch `using-named-volumes` demonstrates how we can use docker's named volumes as a shared file system for the generated static pages. This type of volumes is automatically initialized by the first container using it by moving the content of the virtual file system to it. ANy containers using the volume later on use the initialized version of it, which is exactly what we need in our use case.

Both branches have different Dockerfiles to use. The default one is a simple Dockerfile that can be easily understood and modified, the other is a production-optimized Dockerfile using multi-layered deployments.

To use the default Dockerfile:
```bash
docker-compose up --build --force-recreate 
```

To use the production-optimized Dockerfile:
```bash
docker-compose -f docker-compose.production.yml up --build --force-recreate
```