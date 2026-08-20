cask "devwibar" do
  version "0.2.0"
  sha256 "4976e594a78d290bde49fd36dd1490b8480a82665272c8fb6f0b1586ed89d6cd"

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
