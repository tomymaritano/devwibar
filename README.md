# DevWifiBar

Tiny native macOS 14+ menu bar app that keeps **Wi-Fi and network stats** visible.

A live signal icon in the menu bar. Click it for a compact panel: SSID, signal quality, live RX/TX, IP, gateway, DNS, and latency. Same idea as the [`devwifi`](https://github.com/tomymaritano/devwifi) CLI — native Swift, no Node, no Electron.

```
brew tap tomymaritano/tap
brew install --cask devwibar
```

Until the first GitHub Release is published, build from source (below). The cask template lives in [`Casks/devwibar.rb`](Casks/devwibar.rb).

## What you see

- **Menu bar icon** — three bars that follow RSSI (or empty when Wi-Fi is off)
- **Header** — network name, last update, quality badge
- **Signal** — progress bar from RSSI (−30 dBm = 100%, −90 dBm = 0%) using the same Excellent / Good / Fair / Weak cutoffs as `devwifi`
- **Traffic** — live download sparkline, Mbps, and byte totals
- **Network** — IP, gateway, DNS (with Cloudflare / Google / Quad9 / OpenDNS labels), latency to 1.1.1.1. Click IP, gateway, or DNS to copy
- **Footer** — Open at login, Quit

No Dock icon. The app is a `LSUIElement` accessory.

## Install

### From source (today)

Requires macOS 14+ and Swift 6.

```bash
git clone https://github.com/tomymaritano/devwibar.git
cd devwibar
./Scripts/package_app.sh
open dist/DevWifiBar.app
```

The first launch is ad-hoc signed. If Gatekeeper blocks it: right-click the app → Open.

### Homebrew (after the first release)

```bash
brew tap tomymaritano/tap
brew install --cask devwibar
```

## Permissions

Apple requires **Location** to read the current SSID and BSSID via CoreWLAN. DevWifiBar asks once on launch.

Without Location, the panel still shows RSSI, IP, traffic, DNS, and latency. The network name appears as “Wi-Fi” until you allow it.

System Settings → Privacy & Security → Location Services → DevWifiBar.

## How it works

Readings use native APIs, not the deprecated `airport` CLI and not the Node `devwifi` process.

| Data | Source |
| --- | --- |
| SSID, RSSI, channel, BSSID | CoreWLAN |
| SSID permission | CoreLocation |
| Path up/down | Network.framework (`NWPathMonitor`) |
| RX / TX bytes | `getifaddrs` interface counters |
| IP / gateway / DNS | `ipconfig`, `route`, `SCDynamicStore` |
| Latency | `ping` to 1.1.1.1 |

`DevWifiCore` holds the models and readers. `DevWifiBar` is the menu bar UI.

## Development

```bash
swift test
swift build -c release --product DevWifiBar
make package          # dist/DevWifiBar.app + zip
UNIVERSAL=1 make package   # arm64 + x86_64
```

GitHub Actions (`macos-14`) runs tests and uploads the packaged app on every push.

## Homebrew tap

v1 is not in core Homebrew. Publish a GitHub Release with `DevWifiBar-<version>.zip`, then add [`Casks/devwibar.rb`](Casks/devwibar.rb) to [`tomymaritano/homebrew-tap`](https://github.com/tomymaritano/homebrew-tap) with the zip SHA-256.

## Phase 2 (not in v1)

Password reveal, QR share, speed test, DNS switching, device scan, and alerts stay in the [`devwifi`](https://github.com/tomymaritano/devwifi) CLI / dashboard for now.

## License

MIT
