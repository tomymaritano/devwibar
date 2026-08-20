import Foundation

/// Modular cards in the menu panel, and matching system widgets.
public enum PanelWidget: String, CaseIterable, Codable, Identifiable, Sendable {
    case signal
    case traffic
    case radar
    case network
    case latency
    case metric
    case combined

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .signal: return "Signal"
        case .traffic: return "History"
        case .radar: return "On the link"
        case .network: return "Network"
        case .latency: return "Latency"
        case .metric: return "Metric"
        case .combined: return "Combined"
        }
    }

    public var summary: String {
        switch self {
        case .signal: return "Quality bar, RSSI, and channel."
        case .traffic: return "RX/TX sparkline with session totals."
        case .radar: return "Whether lag is Wi-Fi or an LLM."
        case .network: return "IP, gateway, DNS, latency."
        case .latency: return "Ping sparkline to 1.1.1.1."
        case .metric: return "One number: quality and RSSI."
        case .combined: return "Signal, traffic, and ping in one block."
        }
    }

    /// v0.1 stack. Extra densities stay off until added.
    public static let defaultOrder: [PanelWidget] = [.signal, .traffic, .radar, .network]

    public static let defaultHidden: Set<PanelWidget> = [.latency, .metric, .combined]

    public static func sanitized(order: [PanelWidget], hidden: Set<PanelWidget>) -> (order: [PanelWidget], hidden: Set<PanelWidget>) {
        var seen = Set<PanelWidget>()
        var cleaned: [PanelWidget] = []
        for widget in order where seen.insert(widget).inserted {
            cleaned.append(widget)
        }
        var nextHidden = hidden
        for widget in PanelWidget.allCases where seen.insert(widget).inserted {
            cleaned.append(widget)
            if defaultHidden.contains(widget) {
                nextHidden.insert(widget)
            }
        }
        return (cleaned, nextHidden.intersection(Set(PanelWidget.allCases)))
    }
}
