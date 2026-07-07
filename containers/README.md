# Quadlet scripts

## Local development

To begin development, start with building the local containers using `build.sh`:

```sh
./containers/dev/scripts/build.sh
```

That should automatically launch the pod too. Visit `localhost:8888` on a browser.

To see what's going on inside the containers, you can do:

```
podman pod logs -f --color --names vanilla-dev
```

Alternatively, you can view those containers using [Podman Desktop](https://podman-desktop.io/), or my personal favorite, [Lazyjournal](https://github.com/Lifailon/lazyjournal).

Subsequent runs can be done with:

```sh
podman pod start vanilla-dev
```

to stop:

```sh
podman pod stop vanilla-dev
```
