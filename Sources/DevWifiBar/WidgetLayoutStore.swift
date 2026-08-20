import Combine
import DevWifiCore
import Foundation

@MainActor
final class WidgetLayoutStore: ObservableObject {
    @Published private(set) var order: [PanelWidget]
    @Published private(set) var hidden: Set<PanelWidget>

    private let defaults: UserDefaults
    private let orderKey = "devwibar.widgets.order"
    private let hiddenKey = "devwibar.widgets.hidden"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        let storedOrder = (defaults.array(forKey: orderKey) as? [String] ?? []).compactMap(PanelWidget.init(rawValue:))
        let storedHidden = Set((defaults.array(forKey: hiddenKey) as? [String] ?? []).compactMap(PanelWidget.init(rawValue:)))
        let sanitized: (order: [PanelWidget], hidden: Set<PanelWidget>)
        if storedOrder.isEmpty {
            sanitized = PanelWidget.sanitized(order: PanelWidget.defaultOrder, hidden: PanelWidget.defaultHidden)
        } else {
            sanitized = PanelWidget.sanitized(order: storedOrder, hidden: storedHidden)
        }
        order = sanitized.order
        hidden = sanitized.hidden
    }

    var visible: [PanelWidget] {
        order.filter { !hidden.contains($0) }
    }

    func isVisible(_ widget: PanelWidget) -> Bool {
        !hidden.contains(widget)
    }

    func setVisible(_ widget: PanelWidget, visible: Bool) {
        if visible {
            hidden.remove(widget)
        } else {
            hidden.insert(widget)
        }
        persist()
    }

    func move(from offsets: IndexSet, to destination: Int) {
        order.move(fromOffsets: offsets, toOffset: destination)
        persist()
    }

    func moveUp(_ widget: PanelWidget) {
        guard let index = order.firstIndex(of: widget), index > 0 else { return }
        order.swapAt(index, index - 1)
        persist()
    }

    func moveDown(_ widget: PanelWidget) {
        guard let index = order.firstIndex(of: widget), index < order.count - 1 else { return }
        order.swapAt(index, index + 1)
        persist()
    }

    private func persist() {
        defaults.set(order.map(\.rawValue), forKey: orderKey)
        defaults.set(hidden.map(\.rawValue).sorted(), forKey: hiddenKey)
    }
}
