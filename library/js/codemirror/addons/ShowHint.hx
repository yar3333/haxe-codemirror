package js.codemirror.addons;

import haxe.extern.EitherType;

typedef Completions =
{
	var list : Array<EitherType<String, Completion>>;
	var from : Position;
	var to : Position;
	@:optional var selectedHint : Int;
}

typedef HintFunction = EitherType<CodeMirror->HintOptions->Completions, CodeMirror->HintOptions->js.Promise<Completions>>;

typedef Completion =
{
	@:optional var text : String;
	@:optional var displayText : String;
	@:optional var className : String;
	@:optional var render : js.html.Element->Completions->EitherType<String, Completion>->Void;
	@:optional var hint : HintFunction;
	@:optional var from : Position;
	@:optional var to : Position;
}

typedef HintOptions =
{
	/**
	 * Add "async = true" for hinting function to have callback-mode function.
	 * Add "supportsSelection = true" for hinting function to show hinting even text selected.
	 */
	@:optional var hint : HintFunction;
	
	@:optional var completeSingle : Bool;
	@:optional var alignWithWord : Bool;
	@:optional var closeOnUnfocus : Bool;
	@:optional var customKeys : Dynamic;
	@:optional var extraKeys : Dynamic;
	
	@:optional var shown : Void->Void;
	@:optional var select : EitherType<Completion, String>->js.html.Element->Void;
	@:optional var pick : EitherType<Completion, String>->js.html.Element->Void;
	@:optional var close : Void->Void;
}

extern class ShowHint
{
	static inline function showHint(cm:CodeMirror, ?options:HintOptions) : Void (cast cm).showHint(options);
}