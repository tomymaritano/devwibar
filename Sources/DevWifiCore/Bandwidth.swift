import Foundation

public struct ByteCounters: Equatable, Sendable {
    public var rx: UInt64
    public var tx: UInt64

    public init(rx: UInt64, tx: UInt64) {
        self.rx = rx
        self.tx = tx
    }
}

public struct BandwidthSample: Equatable, Sendable {
    public var downloadMbps: Double
    public var uploadMbps: Double
    public var elapsed: TimeInterval

    public init(downloadMbps: Double, uploadMbps: Double, elapsed: TimeInterval) {
        self.downloadMbps = downloadMbps
        self.uploadMbps = uploadMbps
        self.elapsed = elapsed
    }
}

/// Difference between two interface counters, including a 32-bit wrap.
public func bytesDelta(previous: UInt64, current: UInt64) -> UInt64 {
    if current >= previous {
        return current - previous
    }

    let max32 = UInt64(UInt32.max)
    if previous <= max32, current <= max32 {
        return (max32 - previous) + current + 1
    }

    return 0
}

/// Convert a byte delta over `seconds` into megabits per second.
public func megabitsPerSecond(bytes: UInt64, seconds: TimeInterval) -> Double {
    guard seconds > 0 else { return 0 }
    return (Double(bytes) * 8.0) / (seconds * 1_000_000.0)
}

/// Keep the last `width` values, scaled to 0...1 for sparkline rendering.
public func normalizeSparkline(_ values: [Double], width: Int) -> [Double] {
    let recent = Array(values.suffix(max(width, 0)))
    let peak = recent.max() ?? 0
    guard peak > 0 else { return recent.map { _ in 0 } }
    return recent.map { max($0 / peak, 0) }
}

public func bandwidthSample(
    previous: ByteCounters,
    current: ByteCounters,
    elapsed: TimeInterval
) -> BandwidthSample {
    let rx = bytesDelta(previous: previous.rx, current: current.rx)
    let tx = bytesDelta(previous: previous.tx, current: current.tx)
    return BandwidthSample(
        downloadMbps: megabitsPerSecond(bytes: rx, seconds: elapsed),
        uploadMbps: megabitsPerSecond(bytes: tx, seconds: elapsed),
        elapsed: elapsed
    )
}
