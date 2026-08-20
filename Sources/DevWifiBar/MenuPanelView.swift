import AppKit
import DevWifiCore
import SwiftUI

struct MenuPanelView: View {
    @EnvironmentObject private var state: AppState
    @EnvironmentObject private var layout: WidgetLayoutStore
    @State private var editingWidgets = false

    var body: some View {
        Group {
            if editingWidgets {
                WidgetPickerView(layout: layout) {
                    editingWidgets = false
                }
                .environmentObject(state)
            } else {
                panel
            }
        }
    }

    private var panel: some View {
        VStack(alignment: .leading, spacing: 0) {
            HeaderView(snapshot: state.snapshot)
                .padding(.horizontal, 14)
                .padding(.top, 12)
                .padding(.bottom, 10)

            ForEach(layout.visible) { widget in
                divider
                widgetView(widget)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
            }

            divider

            FooterView(
                launchAtLogin: $state.launchAtLoginEnabled,
                canManageLogin: LaunchAtLogin.isBundled,
                onLaunchAtLogin: state.toggleLaunchAtLogin,
                onWidgets: { editingWidgets = true },
                onQuit: { NSApplication.shared.terminate(nil) }
            )
            .padding(.horizontal, 14)
            .padding(.top, 8)
            .padding(.bottom, 10)
        }
        .frame(width: Theme.panelWidth)
        .background(Theme.background)
    }

    @ViewBuilder
    private func widgetView(_ widget: PanelWidget) -> some View {
        switch widget {
        case .signal:
            SignalSection(wifi: state.snapshot.wifi)
        case .traffic:
            TrafficSection(
                snapshot: state.snapshot,
                downloadHistory: state.downloadHistory,
                uploadHistory: state.uploadHistory
            )
        case .radar:
            AISection(traffic: state.aiTraffic, diagnosis: state.aiDiagnosis, selectedApp: $state.selectedAIApp)
        case .network:
            NetworkSection(
                snapshot: state.snapshot,
                copiedField: state.copiedField,
                onCopy: state.copy
            )
        case .latency:
            LatencySection(latencyMs: state.snapshot.latencyMs, history: state.latencyHistory)
        case .metric:
            MetricSection(wifi: state.snapshot.wifi)
        case .combined:
            CombinedSection(snapshot: state.snapshot, downloadHistory: state.downloadHistory)
        }
    }

    private var divider: some View {
        Rectangle()
            .fill(Theme.divider)
            .frame(height: 1)
    }
}
