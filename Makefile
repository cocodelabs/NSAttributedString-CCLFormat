tests: test-podspec test-osx

test-osx:
	xcodebuild -workspace NSAttributedString+CCLFormat.xcworkspace -scheme Tests test | xcpretty -c; exit ${PIPESTATUS[0]}

test-podspec:
	pod lib lint

