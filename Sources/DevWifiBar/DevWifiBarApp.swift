import AppKit
import SwiftUI

@main
struct DevWifiBarApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        MenuBarExtra {
            MenuPanelView()
                .environmentObject(appDelegate.state)
        } label: {
            ObservedStatusIcon(state: appDelegate.state)
        }
        .menuBarExtraStyle(.window)
    }
}

struct ObservedStatusIcon: View {
    @ObservedObject var state: AppState

    var body: some View {
        StatusIcon(snapshot: state.snapshot)
            .onAppear { state.start() }
    }
}

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    let state = AppState()

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        state.start()
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        false
    }
}
