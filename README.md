<img src="https://raw.githubusercontent.com/alexaubry/docker-swift-apns/master/.github/apns-logo.png" width="181" height="181"/>

# Swift APNS for Docker

[![Build Status](https://travis-ci.org/alexaubry/docker-swift-apns.svg?branch=master)](https://travis-ci.org/alexaubry/docker-swift-apns)

Swift APNS for Docker is a collection of Docker images containing all the dependencies required to build an [Apple Push Provider](https://developer.apple.com/library/content/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/APNSOverview.html) in Swift.

These images are compatible with any environment supporting Docker, including [Heroku](https://devcenter.heroku.com/articles/container-registry-and-runtime).

## Contents

- Swift (based on the [official Docker image](https://hub.docker.com/_/swift/))
- `libcurl` compiled with HTTP/2 support

## Images

| Image Tag                   | Swift | libcurl | libnghttp2 |
|-----------------------------|-------|---------|------------|
| aleksaubry/swift-apns:3.0.2 | 3.0.2 | 7.54.0  | 1.22.0     |
| aleksaubry/swift-apns:3.1.0 | 3.1.0 | 7.54.0  | 1.22.0     |

## Docker Instructions

Getting started with the Swift APNS images is very easy!

Just set an image tag listed above to the base image in your project's Dockerfile:

```dockerfile
FROM aleksaubry/swift-apns:<version>
```

&#x1F4D6;  More guides are available in the [Wiki](https://github.com/alexaubry/docker-swift-apns/wiki).

## Contributing

Contributions are very welcome and appreciated! Please submit your pull requests to the `master` branch.

## License

This project is licensed under the [MIT License](LICENSE.md).

## Acknowledgements

This project uses other great open-source libraries:

- [Files](https://github.com/JohnSundell/Files) by **@johnsundell**
- [ShellOut](https://github.com/JohnSundell/ShellOut) by **@johnsundell**
- [Marathon](https://github.com/JohnSundell/Marathon) by **@johnsundell**

&#x1F433;