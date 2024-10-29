# one-container-alternative

This is an alternative way to install YANG Suite using only a single container instead of three.

This alternative is intended for _experimentation_ on a **local machine** and not as a direct replacement of the existing YANG Suite Docker implementation.

## Advantages

- Fewer points of failure. One container for all YANG Suite requirements.
- No user input required. Configuration settings are preset.
- No Docker Compose needed. Only Docker commands are used.
- `nginx` server removed.
- Self-signed (dummy) or user provided certificates can be used.

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

## Development

`uwsgi` is used as `http` server for YANG Suite front end, you can open ports on the [uwsgi ini file.](config/build-assets/uwsgi.ini#L24)

You can pass the environment variables `YS_ADMIN_USER`, `YS_ADMIN_PASS` and `YS_ADMIN_EMAIL`, to do so, adjust the `make build` command, so they are set at build time.

You can watch YANG Suite logs using:

```bash
make debug
```

See the other options available in the [Makefile.](./Makefile)
