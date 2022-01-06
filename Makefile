format:
	swift format \
		--configuration .swift-format.json \
		--ignore-unparsable-files \
		--in-place \
		--recursive \
		.

lint:
	swift format lint \
		--configuration .swift-format.json \
		--ignore-unparsable-files \
		--recursive \
		.

test:
	swift test --parallel --enable-code-coverage

coverage: test
	xcrun llvm-cov export \
    	-format=lcov \
    	-instr-profile=.build/arm64-apple-macosx/debug/codecov/default.profdata \
    	.build/arm64-apple-macosx/debug/WaniKaniPackageTests.xctest/Contents/MacOS/WaniKaniPackageTests \
    	> lcov.info

.PHONY: format lint test coverage
