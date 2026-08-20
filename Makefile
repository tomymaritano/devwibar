.PHONY: build test package open

build:
	swift build -c release --product DevWifiBar

test:
	swift test

package:
	./Scripts/package_app.sh

open: package
	open dist/DevWifiBar.app
