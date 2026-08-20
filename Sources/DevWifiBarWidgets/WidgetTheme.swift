import SwiftUI

enum WidgetTheme {
    static let teal = Color(red: 0.18, green: 0.83, blue: 0.75)
    static let background = Color(red: 0.07, green: 0.07, blue: 0.08)
    static let secondary = Color.white.opacity(0.55)
}

struct WidgetBrandMark: View {
    var offline: Bool = false

    var body: some View {
        Canvas { context, size in
            let rect = CGRect(origin: .zero, size: size).insetBy(dx: size.width * 0.08, dy: size.height * 0.10)
            let w = rect.width
            let h = rect.height
            let origin = CGPoint(x: rect.midX, y: rect.maxY - h * 0.22)
            let ink = WidgetTheme.teal.opacity(offline ? 0.35 : 1)

            let bar = CGRect(x: rect.minX + w * 0.12, y: rect.maxY - h * 0.16, width: w * 0.76, height: h * 0.13)
            context.fill(Path(roundedRect: bar, cornerRadius: bar.height / 2), with: .color(ink))

            let stroke = max(1.7, w * 0.13)
            for radius in [w * 0.22, w * 0.40, w * 0.58] {
                var arc = Path()
                arc.addArc(center: origin, radius: radius, startAngle: .degrees(210), endAngle: .degrees(330), clockwise: false)
                context.stroke(arc, with: .color(ink), style: StrokeStyle(lineWidth: stroke, lineCap: .round))
            }
        }
        .accessibilityHidden(true)
    }
}

struct WidgetSparkline: View {
    let values: [Double]
    var color: Color = WidgetTheme.teal

    var body: some View {
        GeometryReader { geo in
            let peak = max(values.max() ?? 0, 0.001)
            let count = max(values.count, 1)
            let spacing: CGFloat = 1.2
            let barWidth = max(1, (geo.size.width - spacing * CGFloat(count - 1)) / CGFloat(count))

            if values.isEmpty {
                Capsule()
                    .fill(Color.white.opacity(0.08))
                    .frame(width: geo.size.width, height: 3)
                    .frame(maxHeight: .infinity, alignment: .bottom)
            } else {
                HStack(alignment: .bottom, spacing: spacing) {
                    ForEach(Array(values.suffix(18).enumerated()), id: \.offset) { _, value in
                        Capsule()
                            .fill(color.opacity(0.9))
                            .frame(
                                width: barWidth,
                                height: max(2, geo.size.height * CGFloat(value / peak))
                            )
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height, alignment: .bottom)
            }
        }
    }
}

struct WidgetChrome<Content: View>: View {
    var title: String
    var subtitle: String?
    var offline: Bool = false
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                WidgetBrandMark(offline: offline)
                    .frame(width: 16, height: 16)
                Text(title)
                    .font(.system(size: 12, weight: .semibold))
                Spacer()
                if let subtitle {
                    Text(subtitle)
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(WidgetTheme.teal)
                }
            }
            content()
        }
        .padding(14)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(WidgetTheme.background)
    }
}
