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
