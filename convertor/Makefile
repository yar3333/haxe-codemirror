build:
	haxelib run downloader \
		--output-directory bin/output \
		--cache-directory bin/cache \
		--product-url "http://codemirror.net/doc/manual.html" \
		--product-html-property "config:>article>section#config" \
		--product-html-property "events:>article>section#events" \
		--product-html-property "commands:>article>section#commands" \
		--product-html-property "styling:>article>section#styling" \
		--product-html-property "api:>article>section#api" \
		--output-json-file bin/manual.json
	neko bin/convertor.n
