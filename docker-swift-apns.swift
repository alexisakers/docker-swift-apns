import Foundation
import Files

// MARK: Utilities

extension String {

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

        return self[assignmentOperatorRange.upperBound ..< endIndex]

    }

}

extension Pipe {

    func readText() -> String? {
        let data = fileHandleForReading.readDataToEndOfFile()
        return String(data: data, encoding: .utf8)
    }

}


// MARK: - Model

enum BuildError: Error {

    case invalidArguments
    case invalidArgument(String)
    case invalidCommand(String)
    case dockerError(String)

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

    var shouldPrintUsage: Bool {

        switch self {
        case .dockerError(_):
            return false
        default:
            return true
        }

    }

    var log: String? {

        switch self {
        case .dockerError(let log):
            return log
        default:
            return nil
        }

    }

}

struct BuildArguments {
    let curlVersion: String
    let nghttp2Version: String
    let swiftVersion: String
    let imageTag: String
}


// MARK: - CLI

extension CommandLine {

    static func parseArguments() throws -> BuildArguments {

        guard arguments.count >= 6 else {
            throw BuildError.invalidArguments
        }

        let command = arguments[1]

        guard command == "build" else {
            throw BuildError.invalidCommand(command)
        }

        let curlVersionFlag = arguments[2]
        let nghttp2VersionFlag = arguments[3]
        let swiftVersionFlag = arguments[4]
        let imageTagFlag = arguments[5]

        guard let curlVersion = curlVersionFlag.value(forFlag: "curl") else {
            throw BuildError.invalidArgument(curlVersionFlag)
        }

        guard let nghttp2Version = nghttp2VersionFlag.value(forFlag: "nghttp2") else {
            throw BuildError.invalidArgument(nghttp2VersionFlag)
        }

        guard let swiftVersion = swiftVersionFlag.value(forFlag: "swift") else {
            throw BuildError.invalidArgument(swiftVersionFlag)
        }

        guard let imageTag = imageTagFlag.value(forFlag: "tag") else {
            throw BuildError.invalidArgument(swiftVersionFlag)
        }

        return BuildArguments(curlVersion: curlVersion,
                              nghttp2Version: nghttp2Version,
                              swiftVersion: swiftVersion,
                              imageTag: imageTag)

    }

    static func printUsage() {

        print()
        print("Available commands:")
        print()

        print("\t build \t Build a swift-apns Docker image")

        print()
        print("Required parameters:")
        print()

        print("\t --curl=<curl version> \t The version of libcurl to bundle in the image")
        print("\t --nghttp2=<nghttp2 version> \t The version of libnghttp2 to bundle in the image")
        print("\t --swift=<swift version> \t The version of the Swift language to bundle in the image")

        print()
        print("🌍  For more information, visit https://github.com/alexaubry/swift-apns-docker")

    }

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

func createDockerfile(in workingDirectory: Folder,
                      with arguments: BuildArguments) throws {

    let template = try workingDirectory.file(named: "DockerfileTemplate")

    var body = try template.readAsString()
    body = body.replacingOccurrences(of: "{CURL_VERSION}", with: arguments.curlVersion)
    body = body.replacingOccurrences(of: "{HTTP2_VERSION}", with: arguments.nghttp2Version)
    body = body.replacingOccurrences(of: "{SWIFT_VERSION}", with: arguments.swiftVersion)

    let dockerfile = try workingDirectory.createFileIfNeeded(withName: "Dockerfile")
    try dockerfile.write(string: body)

}

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
    let workingDirectory = FileSystem().currentFolder
    let imageName = buildArgs.imageTag

    print("👉  Creating Dockerfile")
    try createDockerfile(in: workingDirectory, with: buildArgs)

    print("👉  Building Docker image '\(imageName)'")

    try execute(bashCommand: "docker",
                arguments: ["build", ".", "-t", buildArgs.imageTag]) 

    print("✅  Swift APNS image '\(imageName)' successfully built!")

} catch {
    CommandLine.fail(error: error)
}
