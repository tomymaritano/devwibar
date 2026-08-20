import Foundation

#if os(macOS)
import CoreWLAN
#endif

public struct WifiReader: Sendable {
    public init() {}

    public func read() -> WifiInfo {
        #if os(macOS)
        guard let interface = CWWiFiClient.shared().interface() else {
            return .unavailable
        }

        let powerOn = interface.powerOn()
        let ssid = interface.ssid()
        let rssi = interface.rssiValue()
        let channel = interface.wlanChannel()?.channelNumber
        let rate = interface.transmitRate()
        let associated = rssi != 0 || ssid != nil

        return WifiInfo(
            ssid: ssid,
            rssi: associated ? Int(rssi) : nil,
            channel: channel,
            bssid: interface.bssid(),
            transmitRateMbps: rate > 0 ? rate : nil,
            interfaceName: interface.interfaceName ?? "en0",
            powerOn: powerOn,
            connected: powerOn && associated
        )
        #else
        return .unavailable
        #endif
    }
}
