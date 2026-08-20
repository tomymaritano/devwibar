import AppKit
import DevWifiCore
import SwiftUI

struct MenuPanelView: View {
    @EnvironmentObject private var state: AppState

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HeaderView(snapshot: state.snapshot)
                .padding(.horizontal, 14)
                .padding(.top, 12)
                .padding(.bottom, 10)

            divider

            SignalSection(wifi: state.snapshot.wifi)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)

            divider

            TrafficSection(
                snapshot: state.snapshot,
                downloadHistory: state.downloadHistory,
                uploadHistory: state.uploadHistory
            )
            .padding(.horizontal, 14)
            .padding(.vertical, 10)

            divider

            AISection(traffic: state.aiTraffic, diagnosis: state.aiDiagnosis, selectedApp: $state.selectedAIApp)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)

            divider

            NetworkSection(
                snapshot: state.snapshot,
                copiedField: state.copiedField,
                onCopy: state.copy
            )
            .padding(.horizontal, 14)
            .padding(.vertical, 10)

            divider

            FooterView(
                launchAtLogin: $state.launchAtLoginEnabled,
                canManageLogin: LaunchAtLogin.isBundled,
                onLaunchAtLogin: state.toggleLaunchAtLogin,
                onQuit: { NSApplication.shared.terminate(nil) }
            )
            .padding(.horizontal, 14)
            .padding(.top, 8)
            .padding(.bottom, 10)
        }
        .frame(width: Theme.panelWidth)
        .background(Theme.background)
    }

    private var divider: some View {
        Rectangle()
            .fill(Theme.divider)
            .frame(height: 1)
    }
}
