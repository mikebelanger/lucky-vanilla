# Vanilla Expense Tracker

## What

Vanilla Splits is a web-based expense tracker which is designed for two people to split monthly expenses. Each user can log into the application, and enter the expenses they want to split for a given month.  At the end of the month, the application will email each user the total expenses for that month, and who owes who how much.

## Why

There's two main motivations for this application:

-  Split expenses between myself and a roommate. I've used Google Sheets to track expenses before this. While Google Sheets is easier to get started, I've found it more awkward to automate, and more error-prone.
- An excuse to test out some cool technologies. Namely, the [Lucky web framework](https://luckyframework.org), [Caddy](https://caddyserver.com/), [Podman](https://podman.io), [Pico.css](https://picocss.com/), [Bun](https://bun.dev), [Custom elements](https://developer.mozilla.org/en-US/docs/Web/API/Web_components/Using_custom_elements) and good 'ol vanilla javascript. 
- Eventually, incorporate [View Transitions.](https://developer.mozilla.org/en-US/docs/Web/API/View_Transition_API) on the frontend, and something called [Quadlets](https://www.redhat.com/en/blog/quadlet-podman) on the backend.

## Limitations

- Cannot support splitting expenses between more than **two** people.
- Will not fully run on [Safari](https://www.apple.com/safari/) or any WebKit-based browser as they [do not support extended elements.](https://github.com/WebKit/standards-positions/issues/97)
- Current mail adapter is a version of [Mailersend](https://mailersend.com) [that I forked](https://github.com/mikebelanger/carbon_mailersend_adapter). I don't actively maintain this fork, at least fully.

## Setting up the project yourself

Ensure you have a recent version of [Podman](https://podman.io). Once you do, assuming you're on Linux/OS X:
1. Clone this repo
2. cd into it
3. For development, do `sh dev.sh`.
4. For production, do `sh prod.sh`.
5. Ctrl+C to exit out of the logs.

If you're on Windows, the best bet I can give you is to install WSL and spin up a popular Linux distro, and the do the above steps.

### Stopping the containers
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
