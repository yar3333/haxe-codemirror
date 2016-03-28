# codemirror haxe library #

Externs for [CodeMirror](http://codemirror.net/) (js-based text editor).


## Example

HTML:
```html
<!DOCTYPE html>
<html>
	<head>
		<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.13.2/codemirror.css">
		<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.13.2/codemirror.js"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.13.2/mode/javascript/javascript.js"></script>
	</head>
	<body>
		<script src="bin/test.js"></script>
	</body>
<html>
```

Haxe:
```haxe
import js.Browser;
import js.codemirror.*;

class Main
{
    static function main()
	{
		var cm = new CodeMirror(Browser.document.body,
		{
			value: "function myScript() { return 100; }\n",
			mode:  "javascript"
		});
	}
}
```
