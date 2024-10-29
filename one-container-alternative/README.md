# one-container-alternative

This is an alternative way to install YANG Suite using only a single container instead of three.

This alternative is intended for _experimentation_ and not as a direct replacement of the existing YANG Suite Docker implementation.

## Advantages

- Fewer points of failure. One container for all YANG Suite requirements.
- No user input required. Configuration settings are preset.
- No Docker Compose needed. Only Docker commands are used.
- `nginx` server removed.
- Users can provide their own certificates; otherwise, a self-signed (dummy) certificate will be used.

## Limitations

- No Backup cron job.

## Prerequisites

- Docker
- Make

## Build

To start building the container, go to `one-container-alternative` directory first.

```bash
cd one-container-alternative
```

> [!IMPORTANT]
> The rest of the commands assume you are executing the commands from inside the `one-container-alternative` directory.

Then run:

```bash
make build
```

## Run

To start YANG Suite and begin using it, run:

```bash
make run
```

Then visit <https://localhost:8480>, accept the EULA, and use `developer/developer` to enter YANG Suite.

The named volume `yangsuite-one-container-data` is used to store the YANG Suite `ys-data` directory, where settings and data are stored.

You can also do `make stop` and `make start`, to `stop` and `start` the container respectively.

## Using Custom Certificates

You can provide your own SSL certificates by creating a `certificate` directory and placing inside it. The [container will look](/one-container-alternative/build-assets/pick_certificate.sh#L5) for `.crt` and `.key` files in this directory. If both files are found, they will be used for HTTPS. If no user-provided certificates are found, the container [will fall back to using self-signed](/one-container-alternative/build-assets/pick_certificate.sh#L21) (dummy) certificates.

Steps to Use Custom Certificates.

- Create a `certificate` directory (inside the `one-container-alternative` directory).
- Place your `.crt` and `.key` files in the `certificate` directory.
- Only one `.crt` and `.key` files are allowed.
- Ensure the filenames have the `.crt` and `.key` extensions.
- Run the container using the `make run` command.

## Development

`daphne` is used as `http` server, `twisted` is used for managing the secure communication for YANG Suite front end.

You can pass the environment variables `YS_ADMIN_USER`, `YS_ADMIN_PASS` and `YS_ADMIN_EMAIL`, to do so, adjust the `make build` command, so they are set at build time, and pass them as `build-arg`.

You can watch YANG Suite Front end logs using:

> [!TIP]
> This is handy when you run along `run`, for example `make run follow`. Use `Ctrl + C` to stop the logs.

```bash
make follow
```

You can watch YANG Suite internal logs using:

```bash
make debug
```

See the other options available in the [Makefile.](./Makefile)
