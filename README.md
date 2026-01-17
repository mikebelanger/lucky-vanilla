# PoC - very WIP

This is just a PoC to show how The [Lucky](https://luckyframework.org) could be used in conjunction with [custom elements](https://developer.mozilla.org/en-US/docs/Web/API/Web_components/Using_custom_elements) and good 'ol server-side rendering. The only "sugar" is that the custom element definitions are written in Typescript.

Very WIP, expect things to break.  I'm also using [Podman](https://podman.io), and its using actual pods too. It might be possible to run with Docker, but not without some modifications to the build scripts.

### Setting up the project

Ensure you have a recent version of [Podman](podman.io). Once you do, assuming you're on Linux/OS X:
1. Clone this repo
2. cd into it
3. For development, do `sh dev.sh`
4. For production, do `sh prod.sh`
5. To stop, Ctrl+C out of the log session you're in, and do either:

```sh
podman pod stop vanilla_app_dev # To stop development
```
or
```sh
podman pod stop vanilla_app_prod # To stop production
```

To remove it all:

```sh
podman pod rm vanilla_app_dev # To remove development
```

or

```sh
podman pod rm vanilla_app_prod # To remove production
```
