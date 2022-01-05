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

.PHONY: format lint
