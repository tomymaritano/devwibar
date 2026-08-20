cask "devwibar" do
  version "0.1.0"
  sha256 "5f11bed3adb242a2b1c04caeec2c575dee69a26e322dbee5886ce494eb5a7df4"

  url "https://github.com/tomymaritano/devwibar/releases/download/v#{version}/DevWifiBar-#{version}.zip"
  name "DevWifiBar"
  desc "Menu bar Wi-Fi stats and LLM connection radar for macOS"
  homepage "https://github.com/tomymaritano/devwibar"

  livecheck do
    url :homepage
    strategy :github_latest
  end

  depends_on macos: :sonoma

  app "DevWifiBar.app"

  zap trash: [
    "~/Library/Preferences/com.tomymaritano.devwibar.plist",
  ]

  caveats <<~EOS
    DevWifiBar is ad-hoc signed. If Gatekeeper blocks it, right-click
    the app and choose Open.
  EOS
end
