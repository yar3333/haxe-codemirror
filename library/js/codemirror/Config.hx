package js.codemirror;

typedef Config =
{
	var value : haxe.extern.EitherType<String, CodeMirror.Doc>;
	var mode : haxe.extern.EitherType<String, object>;
	@:optional var lineSeparator : String;
	var theme : String;
	var indentUnit : Int;
	var smartIndent : Bool;
	var tabSize : Int;
	var indentWithTabs : Bool;
	var electricChars : Bool;
	var specialChars : RegExp;
	var specialCharPlaceholder : String->Element;
	var rtlMoveVisually : Bool;
	var keyMap : String;
	var extraKeys : object;
	var lineWrapping : Bool;
	var lineNumbers : Bool;
	var firstLineNumber : Int;
	var lineNumberFormatter : Int->String;
	var gutters : Array<String>;
	var fixedGutter : Bool;
	var scrollbarStyle : String;
	var coverGutterNextToScrollbar : Bool;
	var inputStyle : String;
	var readOnly : haxe.extern.EitherType<Bool, String>;
	var showCursorWhenSelecting : Bool;
	var lineWiseCopyCut : Bool;
	var undoDepth : Int;
	var historyEventDelay : Int;
	var tabindex : Int;
	var autofocus : Bool;
	var dragDrop : Bool;
	var allowDropFileTypes : Array<String>;
	var cursorBlinkRate : Float;
	var cursorScrollMargin : Float;
	var cursorHeight : Float;
	var resetSelectionOnContextMenu : Bool;
	var pollInterval : Float;
	var flattenSpans : Bool;
	var addModeClass : Bool;
	var maxHighlightLength : Float;
	var viewportMargin : Int;
}
