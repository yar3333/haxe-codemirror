package js.codemirror;

typedef BookmarkOptions =
{
	/**
	 * Can be used to display a DOM node at the current location of the bookmark (analogous to the replacedWith option to markText).
	 */
	var widget : js.html.Element;
    
	/**
	 * By default, text typed when the cursor is on top of the bookmark will end up to the right of the bookmark. Set this option to true to make it go to the left instead.
	 */
	var insertLeft : Bool;
    
	/**
	 * See the corresponding option to markText.
	 */
	var shared : Bool;
    
	/**
	 * As with markText, this determines whether mouse events on the widget inserted for this bookmark are handled by CodeMirror. The default is false.
	 */
	var handleMouseEvents : Bool;
}