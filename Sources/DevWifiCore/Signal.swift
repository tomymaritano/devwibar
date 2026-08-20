/// Wi-Fi signal quality thresholds, matching the `devwifi` CLI.
public enum SignalQuality: String, Sendable, Equatable, CaseIterable {
    case excellent = "Excellent"
    case good = "Good"
    case fair = "Fair"
    case weak = "Weak"
    case veryWeak = "Very Weak"

    /// Classify an RSSI value in dBm using the same cutoffs as `devwifi`.
    public static func from(dbm: Int) -> SignalQuality {
        if dbm >= -50 { return .excellent }
        if dbm >= -60 { return .good }
        if dbm >= -70 { return .fair }
        if dbm >= -80 { return .weak }
        return .veryWeak
    }

    /// Menu-bar bar count from 0 (none) to 3 (full).
    public var barLevel: Int {
        switch self {
        case .excellent: return 3
        case .good: return 2
        case .fair: return 1
        case .weak, .veryWeak: return 0
        }
    }
}

/// Map RSSI to 0...1. −30 dBm is 100%, −90 dBm is 0%.
public func rssiToPercent(_ dbm: Int) -> Double {
    let clamped = min(max(dbm, -90), -30)
    return Double(clamped + 90) / 60.0
}

/// Inverse of `rssiToPercent`, matching `devwifi`'s `percentToDbm`.
public func percentToDbm(_ percent: Double) -> Int {
    Int(((percent / 2.0) - 100.0).rounded())
}
