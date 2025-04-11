clean:
	rm -rf dist
	rm -rf svgo-test-suite
	rm -f oxygen-icons-*.tar.xz
	rm -f W3C_SVG_11_TestSuite.tar.gz

fetch-w3c-test-suite:
	mkdir -p svgo-test-suite/W3C_SVG_11_TestSuite
	wget https://www.w3.org/Graphics/SVG/Test/20110816/archives/W3C_SVG_11_TestSuite.tar.gz --no-clobber
	tar -tf W3C_SVG_11_TestSuite.tar.gz | grep -E '^svg/.+\.svgz?$$' > filter.txt
	tar -C svgo-test-suite/W3C_SVG_11_TestSuite -xf W3C_SVG_11_TestSuite.tar.gz -T filter.txt
	rm filter.txt

fetch-oxygen-icons:
	mkdir -p svgo-test-suite
	wget https://download.kde.org/stable/frameworks/5.113/oxygen-icons-5.113.0.tar.xz --no-clobber
	tar -tf oxygen-icons-5.113.0.tar.xz | grep -E '(\.svgz?$$|/COPYING.*|/AUTHORS$$)' > filter.txt
	tar -C svgo-test-suite -xf oxygen-icons-5.113.0.tar.xz -T filter.txt
	rm filter.txt

normalize:
	find svgo-test-suite -type l -delete
	find svgo-test-suite -type f -name "*.svgz" -exec sh -c '7z e -so {} > $$(echo {} | sed s/\.svgz$$/\.svg/)' \; -delete
	find svgo-test-suite -type f -exec bash -c 'if [ $$(file -bi {} | sed -e "s/.* charset=//") == 'utf-16le' ]; then echo "$$(iconv -f utf-16le -t utf-8 {})" > {}; fi' \;

deduplicate:
	@find svgo-test-suite -type f | while read FILE; \
	do \
		HASH=$$(sha1sum $$FILE | awk "{ print \$$1 }"); \
		if echo $$HASHES | grep $$HASH -q; then \
			rm $$FILE; \
		else \
			HASHES="$$HASHES $$HASH"; \
		fi; \
	done;

package:
	mkdir -p dist
	tar czf dist/svgo-test-suite.tar.gz svgo-test-suite/*

build:
	make fetch-w3c-test-suite
	make fetch-oxygen-icons
	make normalize
	make deduplicate
	make package
