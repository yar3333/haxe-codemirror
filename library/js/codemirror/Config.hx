package js.codemirror;

import js.html.Element;

typedef Config =
{
	/**
	 * The starting value of the editor. Can be a string, or
	 *       a <a href="#api_doc">document object</a>.
	 */
	@:optional var value : haxe.extern.EitherType<String, Doc>;
	
	/**
	 * The mode to use. When not given, this will default to the
	 *       first mode that was loaded. It may be a string, which either
	 *       simply names the mode or is
	 *       a <a href="http://en.wikipedia.org/wiki/MIME">MIME</a> type
	 *       associated with the mode. Alternatively, it may be an object
	 *       containing configuration options for the mode, with
	 *       a <code>name</code> property that names the mode (for
	 *       example <code>{name: "javascript", json: true}</code>). The demo
	 *       pages for each mode contain information about what configuration
	 *       parameters the mode supports. You can ask CodeMirror which modes
	 *       and MIME types have been defined by inspecting
	 *       the <code>CodeMirror.modes</code>
	 *       and <code>CodeMirror.mimeModes</code> objects. The first maps
	 *       mode names to their constructors, and the second maps MIME types
	 *       to mode specs.
	 */
	@:optional var mode : haxe.extern.EitherType<String, Dynamic>;
	
	/**
	 * Explicitly set the line separator for the editor. By default
	 *       (value <code>null</code>), the document will be split on CRLFs
	 *       as well as lone CRs and LFs, and a single LF will be used as
	 *       line separator in all output (such
	 *       as <a href="#getValue"><code>getValue</code></a>). When a
	 *       specific string is given, lines will only be split on that
	 *       string, and output will, by default, use that same
	 *       separator.
	 */
	@:optional var lineSeparator : String;
	
	/**
	 * The theme to style the editor with. You must make sure the
	 *       CSS file defining the corresponding <code>.cm-s-[name]</code>
	 *       styles is loaded (see
	 *       the <a href="../theme/"><code>theme</code></a> directory in the
	 *       distribution). The default is <code>"default"</code>, for which
	 *       colors are included in <code>codemirror.css</code>. It is
	 *       possible to use multiple theming classes at once—for
	 *       example <code>"foo bar"</code> will assign both
	 *       the <code>cm-s-foo</code> and the <code>cm-s-bar</code> classes
	 *       to the editor.
	 */
	@:optional var theme : String;
	
	/**
	 * How many spaces a block (whatever that means in the edited
	 *       language) should be indented. The default is 2.
	 */
	@:optional var indentUnit : Int;
	
	/**
	 * Whether to use the context-sensitive indentation that the
	 *       mode provides (or just indent the same as the line before).
	 *       Defaults to true.
	 */
	@:optional var smartIndent : Bool;
	
	/**
	 * The width of a tab character. Defaults to 4.
	 */
	@:optional var tabSize : Int;
	
	/**
	 * Whether, when indenting, the first N*<code>tabSize</code>
	 *       spaces should be replaced by N tabs. Default is false.
	 */
	@:optional var indentWithTabs : Bool;
	
	/**
	 * Configures whether the editor should re-indent the current
	 *       line when a character is typed that might change its proper
	 *       indentation (only works if the mode supports indentation).
	 *       Default is true.
	 */
	@:optional var electricChars : Bool;
	
	/**
	 * A regular expression used to determine which characters
	 *       should be replaced by a
	 *       special <a href="#option_specialCharPlaceholder">placeholder</a>.
	 *       Mostly useful for non-printing special characters. The default
	 *       is <code>/[\u0000-\u0019\u00ad\u200b-\u200f\u2028\u2029\ufeff]/</code>.
	 */
	@:optional var specialChars : RegExp;
	
	/**
	 * A function that, given a special character identified by
	 *       the <a href="#option_specialChars"><code>specialChars</code></a>
	 *       option, produces a DOM node that is used to represent the
	 *       character. By default, a red dot (<span style="color: red">•</span>)
	 *       is shown, with a title tooltip to indicate the character code.
	 */
	@:optional var specialCharPlaceholder : String->Element;
	
	/**
	 * Determines whether horizontal cursor movement through
	 *       right-to-left (Arabic, Hebrew) text is visual (pressing the left
	 *       arrow moves the cursor left) or logical (pressing the left arrow
	 *       moves to the next lower index in the string, which is visually
	 *       right in right-to-left text). The default is <code>false</code>
	 *       on Windows, and <code>true</code> on other platforms.
	 */
	@:optional var rtlMoveVisually : Bool;
	
	/**
	 * Configures the key map to use. The default
	 *       is <code>"default"</code>, which is the only key map defined
	 *       in <code>codemirror.js</code> itself. Extra key maps are found in
	 *       the <a href="../keymap/"><code>key map</code></a> directory. See
	 *       the <a href="#keymaps">section on key maps</a> for more
	 *       information.
	 */
	@:optional var keyMap : String;
	
	/**
	 * Can be used to specify extra key bindings for the editor,
	 *       alongside the ones defined
	 *       by <a href="#option_keyMap"><code>keyMap</code></a>. Should be
	 *       either null, or a valid <a href="#keymaps">key map</a> value.
	 */
	@:optional var extraKeys : Dynamic;
	
	/**
	 * Whether CodeMirror should scroll or wrap for long lines.
	 *       Defaults to <code>false</code> (scroll).
	 */
	@:optional var lineWrapping : Bool;
	
	/**
	 * Whether to show line numbers to the left of the editor.
	 */
	@:optional var lineNumbers : Bool;
	
	/**
	 * At which number to start counting lines. Default is 1.
	 */
	@:optional var firstLineNumber : Int;
	
	/**
	 * A function used to format line numbers. The function is
	 *       passed the line number, and should return a string that will be
	 *       shown in the gutter.
	 */
	@:optional var lineNumberFormatter : Int->String;
	
	/**
	 * Can be used to add extra gutters (beyond or instead of the
	 *       line number gutter). Should be an array of CSS class names, each
	 *       of which defines a <code>width</code> (and optionally a
	 *       background), and which will be used to draw the background of
	 *       the gutters. <em>May</em> include
	 *       the <code>CodeMirror-linenumbers</code> class, in order to
	 *       explicitly set the position of the line number gutter (it will
	 *       default to be to the right of all other gutters). These class
	 *       names are the keys passed
	 *       to <a href="#setGutterMarker"><code>setGutterMarker</code></a>.
	 */
	@:optional var gutters : Array<String>;
	
	/**
	 * Determines whether the gutter scrolls along with the content
	 *       horizontally (false) or whether it stays fixed during horizontal
	 *       scrolling (true, the default).
	 */
	@:optional var fixedGutter : Bool;
	
	/**
	 * Chooses a scrollbar implementation. The default
	 *       is <code>"native"</code>, showing native scrollbars. The core
	 *       library also provides the <code>"null"</code> style, which
	 *       completely hides the
	 *       scrollbars. <a href="#addon_simplescrollbars">Addons</a> can
	 *       implement additional scrollbar models.
	 */
	@:optional var scrollbarStyle : String;
	
	/**
	 * When <a href="#option_fixedGutter"><code>fixedGutter</code></a>
	 *       is on, and there is a horizontal scrollbar, by default the
	 *       gutter will be visible to the left of this scrollbar. If this
	 *       option is set to true, it will be covered by an element with
	 *       class <code>CodeMirror-gutter-filler</code>.
	 */
	@:optional var coverGutterNextToScrollbar : Bool;
	
	/**
	 * Selects the way CodeMirror handles input and focus. The core
	 *       library defines the <code>"textarea"</code>
	 *       and <code>"contenteditable"</code> input models. On mobile
	 *       browsers, the default is <code>"contenteditable"</code>. On
	 *       desktop browsers, the default is <code>"textarea"</code>.
	 *       Support for IME and screen readers is better in
	 *       the <code>"contenteditable"</code> model. The intention is to
	 *       make it the default on modern desktop browsers in the
	 *       future.
	 */
	@:optional var inputStyle : String;
	
	/**
	 * This disables editing of the editor content by the user. If
	 *       the special value <code>"nocursor"</code> is given (instead of
	 *       simply <code>true</code>), focusing of the editor is also
	 *       disallowed.
	 */
	@:optional var readOnly : haxe.extern.EitherType<Bool, String>;
	
	/**
	 * Whether the cursor should be drawn when a selection is
	 *       active. Defaults to false.
	 */
	@:optional var showCursorWhenSelecting : Bool;
	
	/**
	 * When enabled, which is the default, doing copy or cut when
	 *       there is no selection will copy or cut the whole lines that have
	 *       cursors on them.
	 */
	@:optional var lineWiseCopyCut : Bool;
	
	/**
	 * The maximum number of undo levels that the editor stores.
	 *       Note that this includes selection change events. Defaults to
	 *       200.
	 */
	@:optional var undoDepth : Int;
	
	/**
	 * The period of inactivity (in milliseconds) that will cause a
	 *       new history event to be started when typing or deleting.
	 *       Defaults to 1250.
	 */
	@:optional var historyEventDelay : Int;
	
	/**
	 * The <a href="http://www.w3.org/TR/html401/interact/forms.html#adef-tabindex">tab
	 *       index</a> to assign to the editor. If not given, no tab index
	 *       will be assigned.
	 */
	@:optional var tabindex : Int;
	
	/**
	 * Can be used to make CodeMirror focus itself on
	 *       initialization. Defaults to off.
	 *       When <a href="#fromTextArea"><code>fromTextArea</code></a> is
	 *       used, and no explicit value is given for this option, it will be
	 *       set to true when either the source textarea is focused, or it
	 *       has an <code>autofocus</code> attribute and no other element is
	 *       focused.
	 */
	@:optional var autofocus : Bool;
	
	/**
	 * Controls whether drag-and-drop is enabled. On by default.
	 */
	@:optional var dragDrop : Bool;
	
	/**
	 * When set (default is <code>null</code>) only files whose
	 *       type is in the array can be dropped into the editor. The strings
	 *       should be MIME types, and will be checked against
	 *       the <a href="https://w3c.github.io/FileAPI/#dfn-type"><code>type</code></a>
	 *       of the <code>File</code> object as reported by the browser.
	 */
	@:optional var allowDropFileTypes : Array<String>;
	
	/**
	 * Half-period in milliseconds used for cursor blinking. The default blink
	 *       rate is 530ms. By setting this to zero, blinking can be disabled. A
	 *       negative value hides the cursor entirely.
	 */
	@:optional var cursorBlinkRate : Float;
	
	/**
	 * How much extra space to always keep above and below the
	 *       cursor when approaching the top or bottom of the visible view in
	 *       a scrollable document. Default is 0.
	 */
	@:optional var cursorScrollMargin : Float;
	
	/**
	 * Determines the height of the cursor. Default is 1, meaning
	 *       it spans the whole height of the line. For some fonts (and by
	 *       some tastes) a smaller height (for example <code>0.85</code>),
	 *       which causes the cursor to not reach all the way to the bottom
	 *       of the line, looks better
	 */
	@:optional var cursorHeight : Float;
	
	/**
	 * Controls whether, when the context menu is opened with a
	 *       click outside of the current selection, the cursor is moved to
	 *       the point of the click. Defaults to <code>true</code>.
	 */
	@:optional var resetSelectionOnContextMenu : Bool;
	
	/**
	 * Indicates how quickly CodeMirror should poll its input
	 *       textarea for changes (when focused). Most input is captured by
	 *       events, but some things, like IME input on some browsers, don't
	 *       generate events that allow CodeMirror to properly detect it.
	 *       Thus, it polls. Default is 100 milliseconds.
	 */
	@:optional var pollInterval : Float;
	
	/**
	 * By default, CodeMirror will combine adjacent tokens into a
	 *       single span if they have the same class. This will result in a
	 *       simpler DOM tree, and thus perform better. With some kinds of
	 *       styling (such as rounded corners), this will change the way the
	 *       document looks. You can set this option to false to disable this
	 *       behavior.
	 */
	@:optional var flattenSpans : Bool;
	
	/**
	 * When enabled (off by default), an extra CSS class will be
	 *       added to each token, indicating the
	 *       (<a href="#innerMode">inner</a>) mode that produced it, prefixed
	 *       with <code>"cm-m-"</code>. For example, tokens from the XML mode
	 *       will get the <code>cm-m-xml</code> class.
	 */
	@:optional var addModeClass : Bool;
	
	/**
	 * When highlighting long lines, in order to stay responsive,
	 *       the editor will give up and simply style the rest of the line as
	 *       plain text when it reaches a certain position. The default is
	 *       10 000. You can set this to <code>Infinity</code> to turn off
	 *       this behavior.
	 */
	@:optional var maxHighlightLength : Float;
	
	/**
	 * Specifies the amount of lines that are rendered above and
	 *       below the part of the document that's currently scrolled into
	 *       view. This affects the amount of updates needed when scrolling,
	 *       and the amount of work that such an update does. You should
	 *       usually leave it at its default, 10. Can be set
	 *       to <code>Infinity</code> to make sure the whole document is
	 *       always rendered, and thus the browser's text search works on it.
	 *       This <em>will</em> have bad effects on performance of big
	 *       documents.
	 */
	@:optional var viewportMargin : Int;
}
