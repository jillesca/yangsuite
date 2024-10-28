# one-container-alternative

This is an alternative way to use Yangsuite using only a single container instead of three. It is intended for _experimentation_ on a **local machine** and not as a direct replacement of the existing Yangsuite Docker implementation.

## Advantages

- Fewer points of failure: One container for all Yangsuite requirements.
- No user input required: Configuration settings are pre-set.
- No Docker Compose needed: Only Docker commands are used.
  Not all the Yangusite features were implemented in this container.

## Limitations

- No `HTTPs` support for accessing the Yangsuite Front-end.
- No Backup cron job.
- No `nginx` server.
- No support for certificates.

Volumes are used to store the Yangsuite `ys-data` directory, where settings and data are stored.

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

To start Yangsuite and begin using it, run:

```bash
make run
```

Then visit <http://localhost:8480>, accept the EULA and use `developer/developer` to enter Yangsuite.

## Development

`uwsgi` is used as `http` server, you can open ports on the [uwsgi ini file](config/build-assets/uwsgi.ini#L24)

You can pass the environment variables `YS_ADMIN_USER`, `YS_ADMIN_PASS` and `YS_ADMIN_EMAIL`, to do so, adjust the `make build` command, so they are set at build time.

You can watch Yangsuite logs using:

```bash
make debug
```

See the other options available in the [Makefile](./Makefile)
