# Miniconda Container

*Simple non-root user Miniconda environment, with support for multiple architectures.*

[![Badge License]][License] 
[![Badge Issues]][Issues] 

## Features

- Installs the latest version of Miniconda.
- Sets up a non-root user (default: `app`) with `sudo` privileges (for debug purposes).
- The `base` Conda environment is automatically activated upon login.
- Supports `linux/amd64` and `linux/arm64` architectures.
- Includes `git`, `curl`, `sudo`, and `gosu`.

## Build

To build the multi-platform Docker image, you can use:

```bash
docker buildx build \
  --platform linux/amd64 \
  -t c127/miniconda:latest \
  .
```
This script uses `docker buildx` and will tag the image as `c127/miniconda:latest`.

## How to Run

You can run the container using the following command:

```bash
docker run -it --rm \
  -e PUID=$(id -u) \
  -e PGID=$(id -g) \
  -e APP_USER=myuser \
  -e APP_PASS=mypassword \
  -v $HOME:/app \
  c127/miniconda:latest
```

This will start an interactive `bash` session within the container, with the Miniconda `base` environment activated for the specified user.

### Environment Variables

The following environment variables can be configured when running the container:

- `PUID`: Process User ID for the in-container user. Defaults to `1000`.
- `PGID`: Process Group ID for the in-container user. Defaults to `1000`.
- `APP_USER`: The username for the in-container user. Defaults to `app` (as set in the [Dockerfile](Dockerfile)).
- `APP_PASS`: The password for the `APP_USER`. **Warning**: The default password (`RT2fEDayXh4zVQBtr7WwCHgd`) set in the [Dockerfile](Dockerfile) is for debugging purposes only. Please override this with a secure password for any production or sensitive use.

### Volumes

Use volumes to persist data on host computer and keep fast your environment (Recommended)

- `Main Volume`: For conda environments & packages and home for user data `/app`.

## Inside the Container

Once the container is running, you will be logged in as the user defined by `APP_USER`. The Miniconda `base` environment is automatically sourced via the [source/app-start](source/app-start) script, which is called by the [source/entrypoint](source/entrypoint) script.

You can immediately start using `conda` commands:
```bash
conda info
conda install numpy
conda create -n workspace python=3.9
conda activate workspace
```
The user also has `sudo` privileges, using the password provided via the `APP_PASS` environment variable.

## Dockerfile Breakdown

The [Dockerfile](Dockerfile) performs these key steps:
1.  Uses `debian:bullseye-slim` as the base image.
2.  Sets essential environment variables, including `CONDA_INSTALL_PATH`, `APP_USER`, and `APP_PASS`.
3.  Installs necessary packages like `curl`, `bash`, `sudo`, `git`, and `gosu`.
4.  Copies the [source/entrypoint](source/entrypoint) and [source/app-start](source/app-start) scripts into the image.
5.  Sets `/usr/local/bin/entrypoint` as the `ENTRYPOINT`.

The [source/entrypoint](source/entrypoint) script handles:
-   Creation of the user and group based on `PUID`, `PGID`, and `APP_USER`.
-   Installation of Miniconda for the appropriate architecture (`TARGETARCH`).
-   Initialization of `conda` for the `bash` shell.
-   Setting the user's password and granting `sudo` access.
-   Execution of the [source/app-start](source/app-start) script.

The [source/app-start](source/app-start) script:
-   Activates the `base` Conda environment.
-   Starts an interactive `bash` shell.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

<!----------------------------------------------------------------------------->
[License]: LICENSE
[Issues]: https://github.com/c127dev/dck-miniconda/issues

<!----------------------------------{ Badges }--------------------------------->

[Badge License]: https://img.shields.io/github/license/c127dev/dck-miniconda
[Badge Issues]: https://img.shields.io/github/issues/c127dev/dck-miniconda