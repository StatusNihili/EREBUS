# EREBUS Build Session Workflow

## Starting an EREBUS session

Before performing LFS build work:

1. Change to the EREBUS project directory.
2. Ensure `/bin/sh` points to Bash.
3. Ensure the EREBUS build filesystem is mounted at `/mnt/lfs`.
4. Set `LFS=/mnt/lfs`.
5. Verify the environment before continuing.

Normal startup commands:

```bash
cd ~/Projects/EREBUS
./scripts/start-erebus.sh
export LFS=/mnt/lfs
```

Verification commands:

```bash
readlink -f /bin/sh
findmnt /mnt/lfs
echo "$LFS"
```

Expected state:

- `/bin/sh` resolves to `/usr/bin/bash`
- `/mnt/lfs` is mounted from the EREBUS build image
- `LFS=/mnt/lfs`

## Ending an EREBUS session

Run:

```bash
cd ~/Projects/EREBUS
./scripts/stop-erebus.sh
```

This unmounts the EREBUS build filesystem and restores Ubuntu's normal `/bin/sh` link to Dash.

Expected final state:

```text
/bin/sh -> /usr/bin/dash
```

## Migration note

During the project rename, `start-erebus.sh` accepts the legacy local project path `~/Projects/erebOS` and legacy image filename `erebOS-lfs.img` as fallbacks. Once the local directory and image are renamed, the new EREBUS names will be used automatically.

## Important

Do not perform LFS build operations unless the EREBUS filesystem is mounted and `LFS` is set correctly.

## Host Bash configuration

Ubuntu's `/etc/bash.bashrc` is temporarily moved to `/etc/bash.bashrc.NOUSE` during active LFS build sessions to prevent host shell configuration from contaminating the sterile LFS environment.

The EREBUS start and stop scripts handle this automatically.
