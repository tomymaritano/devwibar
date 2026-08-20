.PHONY: build test package open widgets

build:
	swift build -c release --product DevWifiBar

test:
	swift test

package:
	./Scripts/package_app.sh

widgets:
	xcodegen generate
	xcodebuild -project DevWifiBar.xcodeproj -scheme DevWifiBarWidgets -configuration Release -derivedDataPath .build/xcode build

open: package
	open dist/DevWifiBar.app
