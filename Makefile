SWIFT_FORMAT_BIN := swift format
GIT_REPO_TOPLEVEL := $(shell git rev-parse --show-toplevel)
SWIFT_FORMAT_CONFIG_FILE := $(GIT_REPO_TOPLEVEL)/.swift-format.json

format:
	$(SWIFT_FORMAT_BIN) \
		--configuration $(SWIFT_FORMAT_CONFIG_FILE) \
		--ignore-unparsable-files \
		--in-place \
		--recursive \
		.

lint:
	$(SWIFT_FORMAT_BIN) lint \
		--configuration $(SWIFT_FORMAT_CONFIG_FILE) \
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
