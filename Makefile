ARTIFACT_NAME = svgo-test-suite
OXYGEN_ICONS_VERSION = 5.116

clean:
	rm -rf dist
	rm -rf $(ARTIFACT_NAME)
	rm -f oxygen-icons-*.tar.xz
	rm -f W3C_SVG_11_TestSuite.tar.gz

fetch-w3c-test-suite:
	mkdir -p $(ARTIFACT_NAME)/W3C_SVG_11_TestSuite
	wget https://www.w3.org/Graphics/SVG/Test/20110816/archives/W3C_SVG_11_TestSuite.tar.gz --no-clobber
	tar -tf W3C_SVG_11_TestSuite.tar.gz | grep -E '^svg/.+\.svgz?$$' > filter.txt
	tar -C $(ARTIFACT_NAME)/W3C_SVG_11_TestSuite -xf W3C_SVG_11_TestSuite.tar.gz -T filter.txt
	rm filter.txt

fetch-oxygen-icons:
	mkdir -p $(ARTIFACT_NAME)
	wget https://download.kde.org/stable/frameworks/$(OXYGEN_ICONS_VERSION)/oxygen-icons-$(OXYGEN_ICONS_VERSION).0.tar.xz --no-clobber
	tar -tf oxygen-icons-$(OXYGEN_ICONS_VERSION).0.tar.xz | grep -E '(\.svgz?$$|/COPYING.*|/AUTHORS$$)' > filter.txt
	tar -C $(ARTIFACT_NAME) -xf oxygen-icons-$(OXYGEN_ICONS_VERSION).0.tar.xz -T filter.txt
	rm filter.txt

normalize:
	find $(ARTIFACT_NAME) -type l -delete
	find $(ARTIFACT_NAME) -type f -name "*.svgz" -exec sh -c '7z e -so {} > $$(echo {} | sed s/\.svgz$$/\.svg/)' \; -delete
	find $(ARTIFACT_NAME) -type f -exec bash -c 'if [ $$(file -bi {} | sed -e "s/.* charset=//") == 'utf-16le' ]; then echo "$$(iconv -f utf-16le -t utf-8 {})" > {}; fi' \;

deduplicate:
	@find $(ARTIFACT_NAME) -type f | while read FILE; \
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
	tar czf dist/$(ARTIFACT_NAME).tar.gz $(ARTIFACT_NAME)/*

build:
	make fetch-w3c-test-suite
	make fetch-oxygen-icons
	make normalize
	make deduplicate
	make package
