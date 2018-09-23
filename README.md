<img src="https://raw.githubusercontent.com/alexaubry/docker-swift-apns/master/.github/apns-logo.png" width="181" height="181"/>

# Swift APNS for Docker

[![Build Status](https://travis-ci.org/alexaubry/docker-swift-apns.svg?branch=master)](https://travis-ci.org/alexaubry/docker-swift-apns)

Swift APNS for Docker is a collection of Docker images containing all the dependencies required to build an [Apple Push Provider](https://developer.apple.com/library/content/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/APNSOverview.html) in Swift.

These images are compatible with any environment supporting Docker, including [Heroku](https://devcenter.heroku.com/articles/container-registry-and-runtime).

## Contents

Each image comes with:

- Ubuntu 16.04
- The full Swift toolchain
- `libcurl` compiled with HTTP/2 support

## Supported Images

| Image Tag                              | Swift  | libcurl  | libnghttp2 |
|----------------------------------|--------|---------|-------------|
| aleksaubry/swift-apns:4.0.2   | 4.0.2  | 7.56.1  | 1.27.0      |
| aleksaubry/swift-apns:4.0.3   | 4.0.3  | 7.57.0  | 1.28.0      |
| aleksaubry/swift-apns:4.1      | 4.1     | 7.59.0  | 1.31.0      |
| aleksaubry/swift-apns:4.2      | 4.2     | 7.61.1  | 1.33.0      |

&#x1F6E3;  [Support Roadmap](ROADMAP.md)

&#x1F30E;  Please visit the project's [Docker Hub repo](https://hub.docker.com/r/aleksaubry/swift-apns/) for a full list of tags.

## Docker Instructions

Swift APNS allows you to create Docker containers for your APNS provider server.

All you have to do to get started is specify one of the images listed above as your container's base image at the top of its `Dockerfile`:

```dockerfile
FROM aleksaubry/swift-apns:<version>
```

&#x1F4D6;  More guides and tutorials are available in the [Wiki](https://github.com/alexaubry/docker-swift-apns/wiki).

## Authors

Alexis Aubry, me@alexaubry.fr

You can find me on Twitter: [@_alexaubry](https://twitter.com/_alexaubry)

## License

This project is available under the MIT License. See [LICENSE](LICENSE) for more information.

&#x1F433;
