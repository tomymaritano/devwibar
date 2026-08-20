import AppKit
import Combine
import SwiftUI

@MainActor
final class StatusBarController: NSObject {
    private let state: AppState
    private let statusItem: NSStatusItem
    private let popover: NSPopover
    private var cancellables = Set<AnyCancellable>()

    init(state: AppState) {
        self.state = state
        self.statusItem = NSStatusBar.system.statusItem(withLength: 24)
        self.popover = NSPopover()
        super.init()
        configurePopover()
        configureStatusItem()
        observeSnapshot()
    }

    private func configurePopover() {
        let host = NSHostingController(rootView: MenuPanelView().environmentObject(state))
        host.sizingOptions = [.intrinsicContentSize]
        popover.contentViewController = host
        popover.behavior = .transient
        popover.animates = true
    }

    private func configureStatusItem() {
        statusItem.isVisible = true
        guard let button = statusItem.button else { return }
        button.image = BrandMark.menuBarImage(for: state.snapshot, aiActive: state.aiTraffic.activeCount > 0)
        button.imagePosition = .imageOnly
        button.imageScaling = .scaleProportionallyDown
        button.toolTip = "DevWifiBar"
        button.target = self
        button.action = #selector(togglePopover)
        button.sendAction(on: [.leftMouseUp])
    }

    private func observeSnapshot() {
        Publishers.CombineLatest(state.$snapshot, state.$aiTraffic)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] snapshot, traffic in
                guard let button = self?.statusItem.button else { return }
                button.image = BrandMark.menuBarImage(for: snapshot, aiActive: traffic.activeCount > 0)
                button.toolTip = traffic.activeCount > 0
                    ? "DevWifiBar · \(traffic.activeCount) AI on link"
                    : "DevWifiBar"
            }
            .store(in: &cancellables)
    }

    @objc private func togglePopover() {
        guard let button = statusItem.button else { return }
        if popover.isShown {
            popover.performClose(nil)
        } else {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            popover.contentViewController?.view.window?.makeKey()
        }
    }
}
