import XCTest
@testable import DevWifiCore

final class BandwidthTests: XCTestCase {
    func testDeltaNoWrap() {
        XCTAssertEqual(bytesDelta(previous: 100, current: 250), 150)
    }

    func testDelta32BitWrap() {
        let previous = UInt64(UInt32.max) - 10
        let current: UInt64 = 4
        XCTAssertEqual(bytesDelta(previous: previous, current: current), 15)
    }

    func testDeltaResetOnLargeWrap() {
        XCTAssertEqual(bytesDelta(previous: UInt64.max, current: 10), 0)
    }

    func testMbpsFromBytes() {
        // 1_250_000 bytes in 1s = 10 Mbps
        XCTAssertEqual(megabitsPerSecond(bytes: 1_250_000, seconds: 1), 10, accuracy: 0.001)
        XCTAssertEqual(megabitsPerSecond(bytes: 1_250_000, seconds: 0), 0)
    }

    func testBandwidthSample() {
        let previous = ByteCounters(rx: 0, tx: 0)
        let current = ByteCounters(rx: 2_500_000, tx: 125_000)
        let sample = bandwidthSample(previous: previous, current: current, elapsed: 2)
        XCTAssertEqual(sample.downloadMbps, 10, accuracy: 0.001)
        XCTAssertEqual(sample.uploadMbps, 0.5, accuracy: 0.001)
    }

    func testNormalizeSparkline() {
        XCTAssertEqual(normalizeSparkline([1, 2, 4], width: 3), [0.25, 0.5, 1])
        XCTAssertEqual(normalizeSparkline([0, 0, 0], width: 3), [0, 0, 0])
        XCTAssertEqual(normalizeSparkline([1, 2, 3, 4], width: 2), [0.75, 1])
    }

    func testWifiDisplayName() {
        XCTAssertEqual(WifiInfo(powerOn: false).displayName, "Wi-Fi Off")
        XCTAssertEqual(WifiInfo(powerOn: true, connected: false).displayName, "Disconnected")
        XCTAssertEqual(WifiInfo(ssid: nil, powerOn: true, connected: true).displayName, "Wi-Fi")
        XCTAssertEqual(WifiInfo(ssid: "HomeOffice", powerOn: true, connected: true).displayName, "HomeOffice")
    }
}
