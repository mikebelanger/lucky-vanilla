# PoC - very WIP

This is just a PoC to show how The [Lucky](https://luckyframework.org) could be used in conjunction with custom elements and server-side rendering. I'm just using "plain" typescript files to write custom element definitions, and those custom elements in turn can call the backend to populate them with their HTML.  Very WIP, expect things to break.

# Vanilla splitting

This is a project written using [Lucky](https://luckyframework.org). Enjoy!

### Setting up the project

This project uses Podman for its setup. Ensure you have a recent version of [Podman](podman.io). Once you do, assuming you're on Linux/OS X:
1. Clone this repo
2. cd into it
3. For development, do `sh dev.sh`
4. For production, do `sh prod.sh`

### Learning Lucky

Lucky uses the [Crystal](https://crystal-lang.org) programming language. You can learn about Lucky from the [Lucky Guides](https://luckyframework.org/guides/getting-started/why-lucky).
