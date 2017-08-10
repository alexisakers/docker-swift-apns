import Foundation

// MARK: Utilities

extension String {

    /// Extracts the value in the flag.
    func value(forFlag flag: String) -> String? {

        guard let flagMarkerRange = range(of: "--") else {
            return nil
        }

        guard let assignmentOperatorRange = range(of: "=") else {
            return nil
        }

        let flagName = self[flagMarkerRange.upperBound ..< assignmentOperatorRange.lowerBound]

        guard flagName == flag else {
            return nil
        }

        let value = self[assignmentOperatorRange.upperBound ..< endIndex]
        return String(value)

    }

}

extension Pipe {

    /// Get the text from the file handle.
    func readText() -> String? {
        let data = fileHandleForReading.readDataToEndOfFile()
        return String(data: data, encoding: .utf8)
    }

}


// MARK: - Model

///
/// The errors that can occur when building the image.
///

enum BuildError: Error {

    case invalidArguments
    case invalidArgument(String)
    case invalidCommand(String)
    case dockerError(String)

    /// The message to print.
    var message: String {

        switch self {
        case .invalidArguments:
            return "The arguments passed to the command line are not valid."

        case .invalidArgument(let arg):
            return "The argument '\(arg)' is not valid."

        case .invalidCommand(let cmd):
            return "Unknown command '\(cmd)'"

        case .dockerError:
            return "The Docker daemon returned an error."

        }

    }

    /// Whether the script should print the CLI usage on failure.
    var shouldPrintUsage: Bool {

        switch self {
        case .dockerError(_):
            return false
        default:
            return true
        }

    }

    /// Additionnal logging informations for debugging.
    var log: String? {

        switch self {
        case .dockerError(let log):
            return log
        default:
            return nil
        }

    }

}

///
/// The informations necessary to build an image.
///

struct BuildArguments {
    
    /// The version of libcurl to vendor.
    let curlVersion: String
    
    /// The version of libnghttp2 to vendor.
    let nghttp2Version: String
    
    /// The Swift branch to use.
    let swiftBranch: String

    /// The Swift version to use.
    let swiftVersion: String

    /// The Docker tag to associate with the built image.
    let imageTag: String
    
}


// MARK: - CLI

extension CommandLine {

    /// Get the build arguments from argv.
    static func parseArguments() throws -> BuildArguments {

        guard arguments.count >= 7 else {
            throw BuildError.invalidArguments
        }

        let command = arguments[1]

        guard command == "build" else {
            throw BuildError.invalidCommand(command)
        }

        let curlVersionFlag = arguments[2]
        let nghttp2VersionFlag = arguments[3]
        let swiftBranchFlag = arguments[4]
        let swiftVersionFlag = arguments[5]
        let imageTagFlag = arguments[6]

        guard let curlVersion = curlVersionFlag.value(forFlag: "curl") else {
            throw BuildError.invalidArgument(curlVersionFlag)
        }

        guard let nghttp2Version = nghttp2VersionFlag.value(forFlag: "nghttp2") else {
            throw BuildError.invalidArgument(nghttp2VersionFlag)
        }

        guard let swiftBranch = swiftBranchFlag.value(forFlag: "swift-branch") else {
            throw BuildError.invalidArgument(swiftVersionFlag)
        }

        guard let swiftVersion = swiftVersionFlag.value(forFlag: "swift-version") else {
            throw BuildError.invalidArgument(swiftVersionFlag)
        }

        guard let imageTag = imageTagFlag.value(forFlag: "tag") else {
            throw BuildError.invalidArgument(swiftVersionFlag)
        }

        return BuildArguments(curlVersion: curlVersion,
                              nghttp2Version: nghttp2Version,
                              swiftBranch: swiftBranch,
                              swiftVersion: swiftVersion,
                              imageTag: imageTag)

    }

    /// Prints the usage of the script.
    static func printUsage() {

        let usage =
        """

        Available commands:

        \t build \t Build a swift-apns Docker image

        Required parameters:

        \t --curl=<curl version> \t The version of libcurl to bundle in the image
        \t --nghttp2=<nghttp2 version> \t The version of libnghttp2 to bundle in the image
        \t --swift-branch=<swift branch> \t The branch to the Swift version to bundle in the image
        \t --swift-version=<swift version> \t The version of the Swift language to bundle in the image"
        \t --tag=<image tag> \t The tag to use to identify the image

        🌍  For more information, visit https://github.com/alexaubry/swift-apns-docker
        """

        print(usage)


    }

    /// Prints an error and exit with a 1 code.
    static func fail(error: Error) {

        var shouldPrintUsage = true
        var message = "Unknown error (\(error.localizedDescription))"
        var log: String? = nil

        if let buildError = error as? BuildError {
            message = buildError.message
            shouldPrintUsage = buildError.shouldPrintUsage
            log = buildError.log

        } else if let localizedError = error as? LocalizedError {
            message = localizedError.errorDescription ?? message

        }

        print("💥  \(message)")

        if let printableLog = log {
            print(printableLog)
        }

        if shouldPrintUsage {
            print("👉  Usage")
            printUsage()
        }

        exit(1)

    }

}


// MARK: - Dockerfile

/// Executes a bash command and throws on failure.
func execute(bashCommand: String, arguments: [String]) throws {

    let args = arguments.joined(separator: " ")
    let command = "cd . && \(bashCommand) \(args)"
    let process = Process()

    process.launchPath = "/bin/bash"
    process.arguments = ["-c", command]

    let standardErrorPipe = Pipe()
    process.standardOutput = FileHandle.standardOutput
    process.standardError = standardErrorPipe

    process.launch()
    process.waitUntilExit()

    if process.terminationStatus == 0 {
        return
    }

    if let error = standardErrorPipe.readText() {
        throw BuildError.dockerError(error)
    }

}


// MARK: - Script

do {

    let buildArgs = try CommandLine.parseArguments()
    let imageName = buildArgs.imageTag

    print("👉  Building Docker image '\(imageName)'")

    try execute(bashCommand: "docker",
                arguments: ["build", ".",
                            "-t", imageName,
                            "--build-arg", "SWIFT_BRANCH=\(buildArgs.swiftBranch)",
                            "--build-arg", "SWIFT_VERSION=\(buildArgs.swiftVersion)",
                            "--build-arg", "HTTP2_VERSION=\(buildArgs.nghttp2Version)",
                            "--build-arg", "CURL_VERSION=\(buildArgs.curlVersion)"])

    print("✅  Swift APNS image '\(imageName)' was built successfully!")

} catch {
    CommandLine.fail(error: error)
}
