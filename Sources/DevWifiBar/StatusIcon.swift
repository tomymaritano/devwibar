import DevWifiCore
import SwiftUI

struct StatusIcon: View {
    let snapshot: NetworkSnapshot

    var body: some View {
        WifiBarsIcon(level: barLevel, offline: !snapshot.wifi.powerOn || !snapshot.wifi.connected)
            .frame(width: 16, height: 12)
            .accessibilityLabel(accessibilityLabel)
    }

    private var barLevel: Int {
        if !snapshot.wifi.connected || !snapshot.wifi.powerOn {
            return 0
        }
        return snapshot.wifi.quality?.barLevel ?? 0
    }

    private var accessibilityLabel: String {
        if !snapshot.wifi.powerOn {
            return "DevWifiBar, Wi-Fi off"
        }
        if !snapshot.wifi.connected {
            return "DevWifiBar, disconnected"
        }
        let name = snapshot.wifi.displayName
        let quality = snapshot.wifi.quality?.rawValue ?? "unknown"
        return "DevWifiBar, \(name), \(quality)"
    }
}

struct WifiBarsIcon: View {
    let level: Int
    var offline: Bool = false

    var body: some View {
        Canvas { context, size in
            let bars = 3
            let gap = size.width * 0.12
            let barWidth = (size.width - gap * CGFloat(bars - 1)) / CGFloat(bars)
            for index in 0..<bars {
                let height = size.height * CGFloat(index + 1) / CGFloat(bars)
                let x = CGFloat(index) * (barWidth + gap)
                let rect = CGRect(x: x, y: size.height - height, width: barWidth, height: height)
                let active = !offline && index <= level
                context.fill(
                    Path(roundedRect: rect, cornerRadius: 1),
                    with: .color(active ? .primary : .primary.opacity(0.22))
                )
            }
        }
    }
}
