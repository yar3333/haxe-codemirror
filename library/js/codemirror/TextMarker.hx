package js.codemirror;

@:native("CodeMirror.TextMarker")
extern class TextMarker
{
	function clear() : Void;
	
	function find(?side:Int) : { from:Position, to:Position };
	
	/*
	 * Call if you've done something that might change the size of the marker
	 * (for example changing the content of a replacedWith node),
	 * and want to cheaply update the display.
	 */
	function changed() : Void;
}
