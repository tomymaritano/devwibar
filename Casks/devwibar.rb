cask "devwibar" do
  version "0.2.1"
  sha256 "2c35375ddc75ee491c8533856a189f0630a0ce9a80efb6b2a34efac6ad69d297"

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
end
