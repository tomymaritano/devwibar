# Homebrew cask template for a future GitHub Release.
# After publishing v0.1.0, copy this file into tomymaritano/homebrew-tap
# as Casks/devwibar.rb and replace :no_check with the zip SHA-256.
#
#   brew tap tomymaritano/tap
#   brew install --cask devwibar

cask "devwibar" do
  version "0.1.0"
  sha256 :no_check

  url "https://github.com/tomymaritano/devwibar/releases/download/v#{version}/DevWifiBar-#{version}.zip"
  name "DevWifiBar"
  desc "Menu bar Wi-Fi and network stats for macOS"
  homepage "https://github.com/tomymaritano/devwibar"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :sonoma"

  app "DevWifiBar.app"

  zap trash: [
    "~/Library/Preferences/com.tomymaritano.devwibar.plist",
  ]
end
