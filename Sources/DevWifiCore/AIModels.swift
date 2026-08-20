import Foundation

public struct AIFlow: Equatable, Sendable, Identifiable {
    public var app: String
    public var host: String
    public var provider: String
    public var downloadMbps: Double?
    public var uploadMbps: Double?
    public var bytesIn: UInt64
    public var bytesOut: UInt64

    public init(
        app: String,
        host: String = "",
        provider: String = "",
        downloadMbps: Double? = nil,
        uploadMbps: Double? = nil,
        bytesIn: UInt64 = 0,
        bytesOut: UInt64 = 0
    ) {
        self.app = app
        self.host = host
        self.provider = provider
        self.downloadMbps = downloadMbps
        self.uploadMbps = uploadMbps
        self.bytesIn = bytesIn
        self.bytesOut = bytesOut
    }

    public var id: String { app }

    public var monogram: String {
        String(app.prefix(1)).uppercased()
    }

    public var isStreaming: Bool {
        (downloadMbps ?? 0) >= 2 || (uploadMbps ?? 0) >= 1
    }

    public var statusLabel: String {
        isStreaming ? "streaming" : "on link"
    }

    public var detail: String {
        if let downloadMbps, downloadMbps >= 0.05 {
            return Format.mbps(downloadMbps)
        }
        if !host.isEmpty, !AICatalog.isIPAddress(host) {
            return host
        }
        if !provider.isEmpty {
            return provider
        }
        return "connected"
    }
}

public struct AITrafficSnapshot: Equatable, Sendable {
    public var flows: [AIFlow]
    public var updatedAt: Date
    public var hasBandwidth: Bool

    public init(flows: [AIFlow] = [], updatedAt: Date = Date(timeIntervalSince1970: 0), hasBandwidth: Bool = false) {
        self.flows = flows
        self.updatedAt = updatedAt
        self.hasBandwidth = hasBandwidth
    }

    public static let empty = AITrafficSnapshot()

    public var activeCount: Int { flows.count }

    public var topFlows: [AIFlow] { Array(flows.prefix(3)) }

    public var primaryApp: String? { flows.first?.app }
}

public struct ProcessByteCounters: Equatable, Sendable {
    public var bytesIn: UInt64
    public var bytesOut: UInt64

    public init(bytesIn: UInt64, bytesOut: UInt64) {
        self.bytesIn = bytesIn
        self.bytesOut = bytesOut
    }
}

public struct LsofConnection: Equatable, Sendable {
    public var process: String
    public var host: String

    public init(process: String, host: String) {
        self.process = process
        self.host = host
    }
}

public struct NettopProcess: Equatable, Sendable {
    public var process: String
    public var pid: Int
    public var bytesIn: UInt64
    public var bytesOut: UInt64

    public init(process: String, pid: Int, bytesIn: UInt64, bytesOut: UInt64) {
        self.process = process
        self.pid = pid
        self.bytesIn = bytesIn
        self.bytesOut = bytesOut
    }
}
