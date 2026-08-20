#if os(macOS)
import CoreLocation
import Foundation

@MainActor
public final class LocationGate: NSObject, CLLocationManagerDelegate {
    public static let shared = LocationGate()

    private let manager = CLLocationManager()

    private override init() {
        super.init()
        manager.delegate = self
    }

    public var isAuthorized: Bool {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        default:
            return false
        }
    }

    public func requestIfNeeded() {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
}
#endif
