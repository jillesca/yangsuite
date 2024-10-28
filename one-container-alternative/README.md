# one-container-alternative

This is an alternative way to install YANG Suite using only a single container instead of three.

This alternative is intended for _experimentation_ on a **local machine** and not as a direct replacement of the existing YANG Suite Docker implementation.

## Advantages

- Fewer points of failure: One container for all YANG Suite requirements.
- No user input required: Configuration settings are preset.
- No Docker Compose needed: Only Docker commands are used.

## Limitations

- No `HTTPs` support for accessing the YANG Suite Front end.
- No Backup cron job.
- No `nginx` server.
- No support for certificates.

## Prerequisites

- Docker
- Make

## Build

> [!IMPORTANT]
> The rest of the commands assume you are executing the commands from inside the `one-container-alternative` directory.

```bash
cd one-container-alternative
```

Then run:

```bash
make build
```

## Run

To start YANG Suite and begin using it, run:

```bash
make run
```

Then visit <http://localhost:8480>, accept the EULA, and use `developer/developer` to enter YANG Suite.

Volumes are used to store the YANG Suite `ys-data` directory, where settings and data are stored.

## Development

`uwsgi` is used as `http` server, you can open ports on the [uwsgi ini file.](config/build-assets/uwsgi.ini#L24)

You can pass the environment variables `YS_ADMIN_USER`, `YS_ADMIN_PASS` and `YS_ADMIN_EMAIL`, to do so, adjust the `make build` command, so they are set at build time.

You can watch YANG Suite logs using:

```bash
make debug
```

See the other options available in the [Makefile.](./Makefile)
