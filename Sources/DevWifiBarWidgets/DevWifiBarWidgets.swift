import SwiftUI
import WidgetKit

@main
struct DevWifiBarWidgets: WidgetBundle {
    var body: some Widget {
        MetricWidget()
        SignalWidget()
        TrafficWidget()
        CombinedWidget()
        LatencyWidget()
        RadarWidget()
        NetworkWidget()
    }
}
