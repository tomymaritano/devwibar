import Foundation

public enum Format {
    public static func mbps(_ value: Double) -> String {
        if value.isNaN || value.isInfinite || value < 0 {
            return "—"
        }
        if value < 0.05 {
            return "0 Mbps"
        }
        if value < 10 {
            return String(format: "%.2f Mbps", value)
        }
        if value < 100 {
            return String(format: "%.1f Mbps", value)
        }
        return String(format: "%.0f Mbps", value)
    }

    public static func latency(_ ms: Double?) -> String {
        guard let ms, ms >= 0, !ms.isNaN else { return "—" }
        return "\(Int(ms.rounded())) ms"
    }

    public static func bytes(_ value: UInt64) -> String {
        let units = ["B", "KB", "MB", "GB", "TB"]
        var size = Double(value)
        var unit = 0
        while size >= 1024, unit < units.count - 1 {
            size /= 1024
            unit += 1
        }
        if unit == 0 {
            return "\(value) B"
        }
        return String(format: "%.2f %@", size, units[unit])
    }

    public static func rssi(_ dbm: Int?) -> String {
        guard let dbm else { return "—" }
        return "\(dbm) dBm"
    }

    public static func channel(_ channel: Int?) -> String {
        guard let channel, channel > 0 else { return "—" }
        return "Channel \(channel)"
    }

    public static func updated(from date: Date, now: Date = Date()) -> String {
        let seconds = now.timeIntervalSince(date)
        if seconds < 3 { return "Updated just now" }
        if seconds < 60 { return "Updated \(Int(seconds))s ago" }
        let minutes = Int(seconds / 60)
        if minutes < 60 { return "Updated \(minutes)m ago" }
        return "Updated \(minutes / 60)h ago"
    }

    public static func percent(_ value: Double) -> String {
        let clamped = min(max(value, 0), 1)
        return "\(Int((clamped * 100).rounded()))%"
    }
}
