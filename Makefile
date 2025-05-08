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

fetch-wikimedia-large:
	wget "https://upload.wikimedia.org/wikipedia/commons/a/a1/Spain_languages-de.svg" --no-clobber --directory-prefix=$(ARTIFACT_NAME)/wikimedia-large
	wget "https://upload.wikimedia.org/wikipedia/commons/d/d1/Saariston_Rengastie_route_labels.svg" --no-clobber --directory-prefix=$(ARTIFACT_NAME)/wikimedia-large
	wget "https://upload.wikimedia.org/wikipedia/commons/5/5a/Mapa_do_Brasil_por_c%C3%B3digo_DDD.svg" --no-clobber --directory-prefix=$(ARTIFACT_NAME)/wikimedia-large
	wget "https://upload.wikimedia.org/wikipedia/commons/c/c1/Propane_flame_contours-en.svg" --no-clobber --directory-prefix=$(ARTIFACT_NAME)/wikimedia-large
	wget "https://upload.wikimedia.org/wikipedia/commons/f/ff/1_42_polytope_7-cube.svg" --no-clobber --directory-prefix=$(ARTIFACT_NAME)/wikimedia-large
	wget "https://upload.wikimedia.org/wikipedia/commons/2/2e/Germany_%28%2Bdistricts_%2Bmunicipalities%29_location_map_2013.svg" --no-clobber --directory-prefix=$(ARTIFACT_NAME)/wikimedia-large
	wget "https://upload.wikimedia.org/wikipedia/commons/7/7f/Italy_-_Regions_and_provinces.svg" --no-clobber --directory-prefix=$(ARTIFACT_NAME)/wikimedia-large
	wget "https://upload.wikimedia.org/wikipedia/commons/6/60/Aegean_sea_Anatolia_and_Armenian_highlands_regions_large_topographic_basemap.svg" --no-clobber --directory-prefix=$(ARTIFACT_NAME)/wikimedia-large

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
	make fetch-wikimedia-large
	make normalize
	make deduplicate
	make package
