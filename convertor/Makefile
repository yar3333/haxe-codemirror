DOWNLOADER_OPTIONS  = --output-directory bin/output
DOWNLOADER_OPTIONS += --cache-directory bin/cache
DOWNLOADER_OPTIONS += --product-url "http://codemirror.net/doc/manual.html"
DOWNLOADER_OPTIONS += --output-json-file $@

JSON  = bin/config.json
JSON += bin/events.json
JSON += bin/commands.json
JSON += bin/styling.json
JSON += bin/api.json

build: $(JSON)
	neko bin/convertor.n

bin/config.json:
	haxelib run downloader $(DOWNLOADER_OPTIONS) --product-html-property "data:>article>section#config"

bin/events.json:
	haxelib run downloader $(DOWNLOADER_OPTIONS) --product-html-property "data:>article>section#events"

bin/commands.json:
	haxelib run downloader $(DOWNLOADER_OPTIONS) --product-html-property "data:>article>section#commands"

bin/styling.json:
	haxelib run downloader $(DOWNLOADER_OPTIONS) --product-html-property "data:>article>section#styling"

bin/api.json:
	haxelib run downloader $(DOWNLOADER_OPTIONS) --product-html-property "data:>article>section#api"
