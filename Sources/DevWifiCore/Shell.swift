import Foundation

enum Shell {
    static func run(_ launchPath: String, _ arguments: [String], timeout: TimeInterval? = nil) -> String {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: launchPath)
        process.arguments = arguments
        let stdout = Pipe()
        process.standardOutput = stdout
        process.standardError = FileHandle.nullDevice
        do {
            try process.run()
        } catch {
            return ""
        }

        if let timeout {
            let deadline = Date().addingTimeInterval(timeout)
            while process.isRunning, Date() < deadline {
                Thread.sleep(forTimeInterval: 0.04)
            }
            if process.isRunning {
                process.terminate()
                process.waitUntilExit()
                return ""
            }
        } else {
            process.waitUntilExit()
        }

        let data = stdout.fileHandleForReading.readDataToEndOfFile()
        return String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }
}
