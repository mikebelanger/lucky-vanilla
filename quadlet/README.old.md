# Kube-based Podman Quadlet Deployment

## How the Pods YAML was generated

The pod was created with `podman play kube` during development. To (re-)generate the YAML from a running pod:

```bash
podman kube generate vanilla_app_dev -f output_name.yml
```

The file `output_name.yml` is a Kubernetes-style Pod spec that declares 4 containers (api, db, frontend, scheduler) and their hostPath volumes.

## How Quadlet installs it

The `.kube` Quadlet file (`dev_vanilla.kube`) wraps the YAML and adds runtime options:

```
[Kube]
Yaml=./vanilla_app_dev.yml
PublishPort=8888:8888

[Install]
WantedBy=default.target

[Unit]
After=remote-fs.target
```

To install:

```bash
# Copy the files to the Quadlet directory
cd kube
podman quadlet install dev_vanilla.kube vanilla_app_dev.yml

# Start the pod
systemctl --user start dev_vanilla

# Check status
systemctl --user status dev_vanilla

# View logs for individual containers
podman logs -f vanilla_app_dev-vanilladbdev
podman logs -f vanilla_app_dev-vanillaapidev
```

The `.kube` and `.yml` files must always be kept together — Quadlet loads the YAML relative to the `.kube` file's location.

## SELinux policy

Fedora with SELinux enforcing blocks Crystal's JIT (`execmem`) and other operations by default. The fix is a custom policy module.

### Generating the policy

1. Run the pod and let SELinux block the denials.
2. Convert the denials into a policy module:

```bash
sudo audit2allow -a -M vanilla_pod
sudo semodule -i vanilla_pod.pp
```

This grants permissions for `execmem`, `dac_override`, `name_connect`, and any other denials the app triggers.

### Re-applying on a fresh system

```bash
# Ensure the base policies are installed
sudo dnf install selinux-policy-targeted container-selinux

# Reload the module (requires the .pp file)
sudo semodule -i vanilla_pod.pp
```

To list loaded modules:

```bash
semodule -l | grep vanilla
```

### Notes

- If `semodule -l` returns no output, the SELinux policy store is missing/corrupt — reinstall `selinux-policy-targeted` and `container-selinux`.
- For production, pre-compile the Lucky binary to avoid needing `execmem`, which eliminates the need for a custom SELinux module altogether.
- HostPath volumes get the `container_file_t:s0` label automatically when Podman mounts them with `:z`.

## File permissions

Because the pod mounts the project directory into the containers (`/app`), the container's umask often sets the executable bit on every file it touches or writes. This causes git to show every file as "modified" with a mode change (`100644` → `100755`), even though the content is identical.

To prevent git from noticing these mode changes:

```bash
git config core.filemode false
```

To restore the original permissions instead:

```bash
find . -type f -not -path './.git/*' -not -path '*/node_modules/*' -exec chmod 644 {} +
```
