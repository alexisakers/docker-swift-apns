# Updates to Swift APNS for Docker

## v2.0.1 - August 10, 2017

- Release Swift 4.0 beta 5 image
- Deprecate Swift 4.0 beta 4 image
- Migrate tests to Swift 4
- Fix version comparison in tests

## v2.0 — July 29, 2017

This release focuses on refining the Docker images and the build process.

### Images

- Use Ubuntu 16.04 as base image. Do not rely on a prebuilt Swift image, as its release schedule may not match the project's.
- Fix a file permission bug in the Swift tarball that caused the CoreFoundation module not to be world-readable.
- Add Swift 3.1.1 and Swift 4.0 beta 4 images.

### Build Process

- Update Dockerfile to use ARGs for Swift versions. A single Dockerfile is now shared and reused to build multiple Swift versions.
- Do not use external dependencies in the script to make it a standalone file and simplify the CI process.
- Migrate script to Swift 4.

### Documentation

- Add formal support roadmap.
- Simplify and clarify instructions in README.

## v1.0 — May 15, 2017

- Initial release