import SwiftUI

struct SparklineView: View {
    let values: [Double]
    var color: Color = Theme.teal

    var body: some View {
        GeometryReader { geo in
            let peak = max(values.max() ?? 0, 0.001)
            let count = max(values.count, 1)
            let spacing: CGFloat = 1.5
            let barWidth = max(1, (geo.size.width - spacing * CGFloat(count - 1)) / CGFloat(count))

            if values.isEmpty {
                Capsule()
                    .fill(Color.white.opacity(0.08))
                    .frame(width: geo.size.width, height: 3)
                    .frame(maxHeight: .infinity, alignment: .bottom)
            } else {
                HStack(alignment: .bottom, spacing: spacing) {
                    ForEach(Array(values.enumerated()), id: \.offset) { _, value in
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
