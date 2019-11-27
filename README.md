# tivok-api

The API monolith for the Tivok event-management platform.



## Prerequisites

Docker is required to build the project for use with [tivok-compose](https://github.com/hellerphilipp/tivok-compose). Also, node.js and npm need to be installed on the system.



## Building the image

The service is only supposed to be used using [tivok-compose](https://github.com/hellerphilipp/tivok-compose).

After cloning the repo, please build this image using:

```bash
docker build -t docker.pkg.github.com/hellerphilipp/tivok-api/tivok-api:0.1 .
```



## Versioning

All Cleap-projects use [SemVer](http://semver.org/) for versioning. For released versions, see the [tags on this repository](https://github.com/hellerphilipp/tivok-api/releases).
