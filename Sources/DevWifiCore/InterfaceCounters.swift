import Foundation

#if os(macOS)
import Darwin
#endif

public struct InterfaceCounters: Sendable {
    public init() {}

    public func read(interfaceName: String) -> ByteCounters? {
        #if os(macOS)
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0, let first = ifaddr else { return nil }
        defer { freeifaddrs(ifaddr) }

        var rx: UInt64 = 0
        var tx: UInt64 = 0
        var found = false
        var pointer: UnsafeMutablePointer<ifaddrs>? = first

        while let current = pointer {
            let name = String(cString: current.pointee.ifa_name)
            if name == interfaceName,
               let addr = current.pointee.ifa_addr,
               addr.pointee.sa_family == UInt8(AF_LINK),
               let data = current.pointee.ifa_data
            {
                let stats = data.assumingMemoryBound(to: if_data.self).pointee
                rx += UInt64(stats.ifi_ibytes)
                tx += UInt64(stats.ifi_obytes)
                found = true
            }
            pointer = current.pointee.ifa_next
        }

        return found ? ByteCounters(rx: rx, tx: tx) : nil
        #else
        return nil
        #endif
    }
}
