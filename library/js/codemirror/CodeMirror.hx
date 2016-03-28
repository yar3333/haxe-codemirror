package js.codemirror;

import haxe.Constraints;
import haxe.extern.EitherType;
import js.html.Element;
import js.html.TextAreaElement;

@:native("CodeMirror")
extern class CodeMirror extends Doc
{
	static var version : String;
	static var defaults : Config;
	
	function new(place:Element, ?options:Config) : Void;
	
	/**
	 * Tells you whether the editor currently has focus.
	 */
	function hasFocus() : Bool;
	
	/**
	 * Used to find the target position for horizontal cursor
	 *       motion. <code>start</code> is a <code>{line, ch}</code>
	 *       object, <code>amount</code> an integer (may be negative),
	 *       and <code>unit</code> one of the
	 *       string <code>"char"</code>, <code>"column"</code>,
	 *       or <code>"word"</code>. Will return a position that is produced
	 *       by moving <code>amount</code> times the distance specified
	 *       by <code>unit</code>. When <code>visually</code> is true, motion
	 *       in right-to-left text will be visual rather than logical. When
	 *       the motion was clipped by hitting the end or start of the
	 *       document, the returned value will have a <code>hitSide</code>
	 *       property set to true.
	 */
	function findPosH(start:{ line:Int, ch:Int }, amount:Int, unit:String, visually:Bool) : { line:Int, ch:Int, ?hitSide:Bool };
	
	/**
	 * Similar to <a href="#findPosH"><code>findPosH</code></a>,
	 *       but used for vertical motion. <code>unit</code> may
	 *       be <code>"line"</code> or <code>"page"</code>. The other
	 *       arguments and the returned value have the same interpretation as
	 *       they have in <code>findPosH</code>.
	 */
	function findPosV(start:{ line:Int, ch:Int }, amount:Int, unit:String) : { line:Int, ch:Int, ?hitSide:Bool };
	
	/**
	 * Returns the start and end of the 'word' (the stretch of
	 *       letters, whitespace, or punctuation) at the given position.
	 */
	function findWordAt(pos:{ line:Int, ch:Int }) : { anchor:{ line:Int, ch:Int }, head:{ line:Int, ch:Int } };
	
	/**
	 * Change the configuration of the editor. <code>option</code>
	 *       should the name of an <a href="#config">option</a>,
	 *       and <code>value</code> should be a valid value for that
	 *       option.
	 */
	function setOption(option:String, value:Dynamic) : Void;
	
	/**
	 * Retrieves the current value of the given option for this
	 *       editor instance.
	 */
	function getOption(option:String) : Dynamic;
	
	/**
	 * Attach an additional <a href="#keymaps">key map</a> to the
	 *       editor. This is mostly useful for addons that need to register
	 *       some key handlers without trampling on
	 *       the <a href="#option_extraKeys"><code>extraKeys</code></a>
	 *       option. Maps added in this way have a higher precedence than
	 *       the <code>extraKeys</code>
	 *       and <a href="#option_keyMap"><code>keyMap</code></a> options,
	 *       and between them, the maps added earlier have a lower precedence
	 *       than those added later, unless the <code>bottom</code> argument
	 *       was passed, in which case they end up below other key maps added
	 *       with this method.
	 */
	function addKeyMap(map:Dynamic, bottom:Bool) : Void;
	
	/**
	 * Disable a keymap added
	 *       with <a href="#addKeyMap"><code>addKeyMap</code></a>. Either
	 *       pass in the key map object itself, or a string, which will be
	 *       compared against the <code>name</code> property of the active
	 *       key maps.
	 */
	function removeKeyMap(map:Dynamic) : Void;
	
	/**
	 * Enable a highlighting overlay. This is a stateless mini-mode
	 *       that can be used to add extra highlighting. For example,
	 *       the <a href="../demo/search.html">search addon</a> uses it to
	 *       highlight the term that's currently being
	 *       searched. <code>mode</code> can be a <a href="#option_mode">mode
	 *       spec</a> or a mode object (an object with
	 *       a <a href="#token"><code>token</code></a> method).
	 *       The <code>options</code> parameter is optional. If given, it
	 *       should be an object. Currently, only the <code>opaque</code>
	 *       option is recognized. This defaults to off, but can be given to
	 *       allow the overlay styling, when not <code>null</code>, to
	 *       override the styling of the base mode entirely, instead of the
	 *       two being applied together.
	 */
	function addOverlay(mode:EitherType<String, Dynamic>, ?options:Dynamic) : Void;
	
	/**
	 * Pass this the exact value passed for the <code>mode</code>
	 *       parameter to <a href="#addOverlay"><code>addOverlay</code></a>,
	 *       or a string that corresponds to the <code>name</code> property of
	 *       that value, to remove an overlay again.
	 */
	function removeOverlay(mode:EitherType<String, Dynamic>) : Void;
	
	/**
	 * Register an event handler for the given event type (a
	 *       string) on the editor instance. There is also
	 *       a <code>CodeMirror.on(object, type, func)</code> version
	 *       that allows registering of events on any object.
	 */
	function on(type:String, func:Function) : Void;
	
	/**
	 * Remove an event handler on the editor instance. An
	 *       equivalent <code>CodeMirror.off(object, type,
	 *       func)</code> also exists.
	 */
	function off(type:String, func:Function) : Void;
	
	/**
	 * Retrieve the currently active document from an editor.
	 */
	function getDoc() : Doc;
	
	/**
	 * Attach a new document to the editor. Returns the old
	 *       document, which is now no longer associated with an editor.
	 */
	function swapDoc(doc:Doc) : Doc;
	
	/**
	 * Sets the gutter marker for the given gutter (identified by
	 *       its CSS class, see
	 *       the <a href="#option_gutters"><code>gutters</code></a> option)
	 *       to the given value. Value can be either <code>null</code>, to
	 *       clear the marker, or a DOM element, to set it. The DOM element
	 *       will be shown in the specified gutter next to the specified
	 *       line.
	 */
	function setGutterMarker(line:EitherType<Int, LineHandle>, gutterID:String, value:Element) : LineHandle;
	
	/**
	 * Remove all gutter markers in
	 *       the <a href="#option_gutters">gutter</a> with the given ID.
	 */
	function clearGutter(gutterID:String) : Void;
	
	/**
	 * Returns the line number, text content, and marker status of
	 *       the given line, which can be either a number or a line handle.
	 *       The returned object has the structure <code>{line, handle, text,
	 *       gutterMarkers, textClass, bgClass, wrapClass, widgets}</code>,
	 *       where <code>gutterMarkers</code> is an object mapping gutter IDs
	 *       to marker elements, and <code>widgets</code> is an array
	 *       of <a href="#addLineWidget">line widgets</a> attached to this
	 *       line, and the various class properties refer to classes added
	 *       with <a href="#addLineClass"><code>addLineClass</code></a>.
	 */
	function lineInfo(line:EitherType<Int, LineHandle>) : Dynamic;
	
	/**
	 * Puts <code>node</code>, which should be an absolutely
	 *       positioned DOM node, into the editor, positioned right below the
	 *       given <code>{line, ch}</code> position.
	 *       When <code>scrollIntoView</code> is true, the editor will ensure
	 *       that the entire node is visible (if possible). To remove the
	 *       widget again, simply use DOM methods (move it somewhere else, or
	 *       call <code>removeChild</code> on its parent).
	 */
	function addWidget(pos:{ line:Int, ch:Int }, node:Element, scrollIntoView:Bool) : Void;
	
	/**
	 * Programmatically set the size of the editor (overriding the
	 *       applicable <a href="#css-resize">CSS
	 *       rules</a>). <code>width</code> and <code>height</code>
	 *       can be either numbers (interpreted as pixels) or CSS units
	 *       (<code>"100%"</code>, for example). You can
	 *       pass <code>null</code> for either of them to indicate that that
	 *       dimension should not be changed.
	 */
	function setSize(width:EitherType<Float, String>, height:EitherType<Float, String>) : Void;
	
	/**
	 * Scroll the editor to a given (pixel) position. Both
	 *       arguments may be left as <code>null</code>
	 *       or <code>undefined</code> to have no effect.
	 */
	function scrollTo(x:Float, y:Float) : Void;
	
	/**
	 * Get an <code>{left, top, width, height, clientWidth,
	 *       clientHeight}</code> object that represents the current scroll
	 *       position, the size of the scrollable area, and the size of the
	 *       visible area (minus scrollbars).
	 */
	function getScrollInfo() : { left:Dynamic, top:Dynamic, width:Dynamic, height:Dynamic, clientWidth:Dynamic, clientHeight:Dynamic };
	
	/**
	 * Scrolls the given position into view. <code>what</code> may
	 *       be <code>null</code> to scroll the cursor into view,
	 *       a <code>{line, ch}</code> position to scroll a character into
	 *       view, a <code>{left, top, right, bottom}</code> pixel range (in
	 *       editor-local coordinates), or a range <code>{from, to}</code>
	 *       containing either two character positions or two pixel squares.
	 *       The <code>margin</code> parameter is optional. When given, it
	 *       indicates the amount of vertical pixels around the given area
	 *       that should be made visible as well.
	 */
	function scrollIntoView(what:{ line:Int, ch:Int }) : Void;
	
	/**
	 * Returns an <code>{left, top, bottom}</code> object
	 *       containing the coordinates of the cursor position.
	 *       If <code>mode</code> is <code>"local"</code>, they will be
	 *       relative to the top-left corner of the editable document. If it
	 *       is <code>"page"</code> or not given, they are relative to the
	 *       top-left corner of the page. If <code>mode</code>
	 *       is <code>"window"</code>, the coordinates are relative to the
	 *       top-left corner of the currently visible (scrolled)
	 *       window. <code>where</code> can be a boolean indicating whether
	 *       you want the start (<code>true</code>) or the end
	 *       (<code>false</code>) of the selection, or, if a <code>{line,
	 *       ch}</code> object is given, it specifies the precise position at
	 *       which you want to measure.
	 */
	function cursorCoords(where:EitherType<Bool, { line:Int, ch:Int }>, mode:String) : { left:Dynamic, top:Dynamic, bottom:Dynamic };
	
	/**
	 * Returns the position and dimensions of an arbitrary
	 *       character. <code>pos</code> should be a <code>{line, ch}</code>
	 *       object. This differs from <code>cursorCoords</code> in that
	 *       it'll give the size of the whole character, rather than just the
	 *       position that the cursor would have when it would sit at that
	 *       position.
	 */
	function charCoords(pos:{ line:Int, ch:Int }, ?mode:String) : { left:Dynamic, right:Dynamic, top:Dynamic, bottom:Dynamic };
	
	/**
	 * Given an <code>{left, top}</code> object, returns
	 *       the <code>{line, ch}</code> position that corresponds to it. The
	 *       optional <code>mode</code> parameter determines relative to what
	 *       the coordinates are interpreted. It may
	 *       be <code>"window"</code>, <code>"page"</code> (the default),
	 *       or <code>"local"</code>.
	 */
	function coordsChar(object:{ left:Dynamic, top:Dynamic }, ?mode:String) : { line:Int, ch:Int };
	
	/**
	 * Computes the line at the given pixel
	 *       height. <code>mode</code> can be one of the same strings
	 *       that <a href="#coordsChar"><code>coordsChar</code></a>
	 *       accepts.
	 */
	function lineAtHeight(height:Float, ?mode:String) : Float;
	
	/**
	 * Computes the height of the top of a line, in the coordinate
	 *       system specified by <code>mode</code>
	 *       (see <a href="#coordsChar"><code>coordsChar</code></a>), which
	 *       defaults to <code>"page"</code>. When a line below the bottom of
	 *       the document is specified, the returned value is the bottom of
	 *       the last line in the document.
	 */
	function heightAtLine(line:EitherType<Int, LineHandle>, ?mode:String) : Float;
	
	/**
	 * Returns the line height of the default font for the editor.
	 */
	function defaultTextHeight() : Float;
	
	/**
	 * Returns the pixel width of an 'x' in the default font for
	 *       the editor. (Note that for non-monospace fonts, this is mostly
	 *       useless, and even for monospace fonts, non-ascii characters
	 *       might have a different width).
	 */
	function defaultCharWidth() : Float;
	
	/**
	 * Returns a <code>{from, to}</code> object indicating the
	 *       start (inclusive) and end (exclusive) of the currently rendered
	 *       part of the document. In big documents, when most content is
	 *       scrolled out of view, CodeMirror will only render the visible
	 *       part, and a margin around it. See also
	 *       the <a href="#event_viewportChange"><code>viewportChange</code></a>
	 *       event.
	 */
	function getViewport() : { from:Float, to:Float };
	
	/**
	 * If your code does something to change the size of the editor
	 *       element (window resizes are already listened for), or unhides
	 *       it, you should probably follow up by calling this method to
	 *       ensure CodeMirror is still looking as intended. See also
	 *       the <a href="#addon_autorefresh">autorefresh addon</a>.
	 */
	function refresh() : Void;
	
	/**
	 * Gets the inner mode at a given position. This will return
	 *       the same as <a href="#getMode"><code>getMode</code></a> for
	 *       simple modes, but will return an inner mode for nesting modes
	 *       (such as <code>htmlmixed</code>).
	 */
	function getModeAt(pos:{ line:Int, ch:Int }) : Dynamic;
	
	/**
	 * Retrieves information about the token the current mode found
	 *       before the given position (a <code>{line, ch}</code> object).
	 *       If <code>precise</code> is true, the token will be guaranteed to be accurate based on recent edits. If false or
	 *       not specified, the token will use cached state information, which will be faster but might not be accurate if
	 *       edits were recently made and highlighting has not yet completed.
	 */
	function getTokenAt(pos:{ line:Int, ch:Int }, ?precise:Bool) : Token;
	
	/**
	 * This is similar
	 *       to <a href="#getTokenAt"><code>getTokenAt</code></a>, but
	 *       collects all tokens for a given line into an array. It is much
	 *       cheaper than repeatedly calling <code>getTokenAt</code>, which
	 *       re-parses the part of the line before the token for every call.
	 */
	function getLineTokens(line:Int, ?precise:Bool) : Array<{ start:Dynamic, end:Dynamic, string:Dynamic, type:Dynamic, state:Dynamic }>;
	
	/**
	 * This is a (much) cheaper version
	 *       of <a href="#getTokenAt"><code>getTokenAt</code></a> useful for
	 *       when you just need the type of the token at a given position,
	 *       and no other information. Will return <code>null</code> for
	 *       unstyled tokens, and a string, potentially containing multiple
	 *       space-separated style names, otherwise.
	 */
	function getTokenTypeAt(pos:{ line:Int, ch:Int }) : String;
	
	/**
	 * Fetch the set of applicable helper values for the given
	 *       position. Helpers provide a way to look up functionality
	 *       appropriate for a mode. The <code>type</code> argument provides
	 *       the helper namespace (see
	 *       <a href="#registerHelper"><code>registerHelper</code></a>), in
	 *       which the values will be looked up. When the mode itself has a
	 *       property that corresponds to the <code>type</code>, that
	 *       directly determines the keys that are used to look up the helper
	 *       values (it may be either a single string, or an array of
	 *       strings). Failing that, the mode's <code>helperType</code>
	 *       property and finally the mode's name are used.
	 */
	function getHelpers(pos:{ line:Int, ch:Int }, type:String) : Array<Helper>;
	
	/**
	 * Returns the first applicable helper value.
	 *       See <a href="#getHelpers"><code>getHelpers</code></a>.
	 */
	function getHelper(pos:{ line:Int, ch:Int }, type:String) : Helper;
	
	/**
	 * Returns the mode's parser state, if any, at the end of the
	 *       given line number. If no line number is given, the state at the
	 *       end of the document is returned. This can be useful for storing
	 *       parsing errors in the state, or getting other kinds of
	 *       contextual information for a line. <code>precise</code> is defined
	 *       as in <code>getTokenAt()</code>.
	 */
	function getStateAfter(?line:Int, ?precise:Bool) : Dynamic;
	
	/**
	 * CodeMirror internally buffers changes and only updates its
	 *       DOM structure after it has finished performing some operation.
	 *       If you need to perform a lot of operations on a CodeMirror
	 *       instance, you can call this method with a function argument. It
	 *       will call the function, buffering up all changes, and only doing
	 *       the expensive update after the function returns. This can be a
	 *       lot faster. The return value from this method will be the return
	 *       value of your function.
	 */
	function operation(func:Void->Dynamic) : Dynamic;
	
	/**
	 * Adjust the indentation of the given line. The second
	 *       argument (which defaults to <code>"smart"</code>) may be one of:
	 *         <dl>
	 *           <dt><code><strong>"prev"</strong></code></dt>
	 *           <dd>Base indentation on the indentation of the previous line.</dd>
	 *           <dt><code><strong>"smart"</strong></code></dt>
	 *           <dd>Use the mode's smart indentation if available, behave
	 *           like <code>"prev"</code> otherwise.</dd>
	 *           <dt><code><strong>"add"</strong></code></dt>
	 *           <dd>Increase the indentation of the line by
	 *           one <a href="#option_indentUnit">indent unit</a>.</dd>
	 *           <dt><code><strong>"subtract"</strong></code></dt>
	 *           <dd>Reduce the indentation of the line.</dd>
	 *           <dt><code><strong>&lt;integer></strong></code></dt>
	 *           <dd>Add (positive number) or reduce (negative number) the
	 *           indentation by the given amount of spaces.</dd>
	 *         </dl>
	 */
	function indentLine(line:Int, ?dir:EitherType<String, Int>) : Void;
	
	/**
	 * Switches between overwrite and normal insert mode (when not
	 *       given an argument), or sets the overwrite mode to a specific
	 *       state (when given an argument).
	 */
	function toggleOverwrite(?value:Bool) : Void;
	
	/**
	 * Tells you whether the editor's content can be edited by the
	 *       user.
	 */
	function isReadOnly() : Bool;
	
	/**
	 * Runs the <a href="#commands">command</a> with the given name on the editor.
	 */
	function execCommand(name:String) : Void;
	
	/**
	 * Give the editor focus.
	 */
	function focus() : Void;
	
	/**
	 * Returns the input field for the editor. Will be a textarea
	 *       or an editable div, depending on the value of
	 *       the <a href="#option_inputStyle"><code>inputStyle</code></a>
	 *       option.
	 */
	function getInputField() : Element;
	
	/**
	 * Returns the DOM node that represents the editor, and
	 *       controls its size. Remove this from your tree to delete an
	 *       editor instance.
	 */
	function getWrapperElement() : Element;
	
	/**
	 * Returns the DOM node that is responsible for the scrolling
	 *       of the editor.
	 */
	function getScrollerElement() : Element;
	
	/**
	 * Fetches the DOM node that contains the editor gutters.
	 */
	function getGutterElement() : Element;
	/**
	 * The method provides another way to initialize an editor. It
	 *         takes a textarea DOM node as first argument and an optional
	 *         configuration object as second. It will replace the textarea
	 *         with a CodeMirror instance, and wire up the form of that
	 *         textarea (if any) to make sure the editor contents are put
	 *         into the textarea when the form is submitted. The text in the
	 *         textarea will provide the content for the editor. A CodeMirror
	 *         instance created this way has three additional methods:
	 *         <dl>
	 *           <dt id="save"><code><strong>cm.save</strong>()</code></dt>
	 *           <dd>Copy the content of the editor into the textarea.</dd>
	 * 
	 *           <dt id="toTextArea"><code><strong>cm.toTextArea</strong>()</code></dt>
	 *           <dd>Remove the editor, and restore the original textarea (with
	 *           the editor's current content).</dd>
	 * 
	 *           <dt id="getTextArea"><code><strong>cm.getTextArea</strong>() → TextAreaElement</code></dt>
	 *           <dd>Returns the textarea that the instance was based on.</dd>
	 *         </dl>
	 */
	static function fromTextArea(textArea:TextAreaElement, ?config:Config) : CodeMirror;
	
	/**
	 * If you want to define extra methods in terms of the
	 *       CodeMirror API, it is possible to
	 *       use <code>defineExtension</code>. This will cause the given
	 *       value (usually a method) to be added to all CodeMirror instances
	 *       created from then on.
	 */
	static function defineExtension(name:String, value:Dynamic) : Void;
	
	/**
	 * Like <a href="#defineExtenstion"><code>defineExtension</code></a>,
	 *       but the method will be added to the interface
	 *       for <a href="#Doc"><code>Doc</code></a> objects instead.
	 */
	static function defineDocExtension(name:String, value:Dynamic) : Void;
	
	/**
	 * Similarly, <code>defineOption</code> can be used to define new options for
	 *       CodeMirror. The <code>updateFunc</code> will be called with the
	 *       editor instance and the new value when an editor is initialized,
	 *       and whenever the option is modified
	 *       through <a href="#setOption"><code>setOption</code></a>.
	 */
	static function defineOption(name:String, default:Dynamic, updateFunc:Function) : Void;
	
	/**
	 * If your extension just needs to run some
	 *       code whenever a CodeMirror instance is initialized,
	 *       use <code>CodeMirror.defineInitHook</code>. Give it a function as
	 *       its only argument, and from then on, that function will be called
	 *       (with the instance as argument) whenever a new CodeMirror instance
	 *       is initialized.
	 */
	static function defineInitHook(func:Function) : Void;
	
	/**
	 * Registers a helper value with the given <code>name</code> in
	 *       the given namespace (<code>type</code>). This is used to define
	 *       functionality that may be looked up by mode. Will create (if it
	 *       doesn't already exist) a property on the <code>CodeMirror</code>
	 *       object for the given <code>type</code>, pointing to an object
	 *       that maps names to values. I.e. after
	 *       doing <code>CodeMirror.registerHelper("hint", "foo",
	 *       myFoo)</code>, the value <code>CodeMirror.hint.foo</code> will
	 *       point to <code>myFoo</code>.
	 */
	static function registerHelper(type:String, name:String, value:Helper) : Void;
	
	/**
	 * Acts
	 *       like <a href="#registerHelper"><code>registerHelper</code></a>,
	 *       but also registers this helper as 'global', meaning that it will
	 *       be included by <a href="#getHelpers"><code>getHelpers</code></a>
	 *       whenever the given <code>predicate</code> returns true when
	 *       called with the local mode and editor.
	 */
	static function registerGlobalHelper(type:String, name:String, predicate:Dynamic->CodeMirror->Void, value:Helper) : Void;
	
	/**
	 * A constructor for the <code>{line, ch}</code> objects that
	 *       are used to represent positions in editor documents.
	 */
	static function Pos(line:Int, ?ch:Int) : Void;
	
	/**
	 * Utility function that computes an end position from a change
	 *       (an object with <code>from</code>, <code>to</code>,
	 *       and <code>text</code> properties, as passed to
	 *       various <a href="#event_change">event handlers</a>). The
	 *       returned position will be the end of the changed
	 *       range, <em>after</em> the change is applied.
	 */
	static function changeEnd(change:Dynamic) : { line:Int, ch:Int };
}
