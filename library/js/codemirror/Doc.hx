package js.codemirror;

import haxe.Constraints;
import haxe.extern.EitherType;
import js.html.Element;
import js.html.TextAreaElement;

@:native("CodeMirror.Doc")
extern class Doc
{
	/**
	 * Get the current editor content. You can pass it an optional
	 *       argument to specify the string to be used to separate lines
	 *       (defaults to <code>"\n"</code>).
	 */
	function getValue(?separator:String) : String;
	
	/**
	 * Set the editor content.
	 */
	function setValue(content:String) : Void;
	
	/**
	 * Get the text between the given points in the editor, which
	 *       should be <code>{line, ch}</code> objects. An optional third
	 *       argument can be given to indicate the line separator string to
	 *       use (defaults to <code>"\n"</code>).
	 */
	function getRange(from:Position, to:Position, ?separator:String) : String;
	
	/**
	 * Replace the part of the document between <code>from</code>
	 *       and <code>to</code> with the given string. <code>from</code>
	 *       and <code>to</code> must be <code>{line, ch}</code>
	 *       objects. <code>to</code> can be left off to simply insert the
	 *       string at position <code>from</code>. When <code>origin</code>
	 *       is given, it will be passed on
	 *       to <a href="#event_change"><code>"change"</code> events</a>, and
	 *       its first letter will be used to determine whether this change
	 *       can be merged with previous history events, in the way described
	 *       for <a href="#selection_origin">selection origins</a>.
	 */
	function replaceRange(replacement:String, from:Position, to:Position, ?origin:String) : Void;
	
	/**
	 * Get the content of line <code>n</code>.
	 */
	function getLine(n:Int) : String;
	
	/**
	 * Get the number of lines in the editor.
	 */
	function lineCount() : Int;
	
	/**
	 * Get the first line of the editor. This will
	 *       usually be zero but for <a href="#linkedDoc_from">linked sub-views</a>,
	 *       or <a href="#api_doc">documents</a> instantiated with a non-zero
	 *       first line, it might return other values.
	 */
	function firstLine() : Int;
	
	/**
	 * Get the last line of the editor. This will
	 *       usually be <code>doc.lineCount() - 1</code>,
	 *       but for <a href="#linkedDoc_from">linked sub-views</a>,
	 *       it might return other values.
	 */
	function lastLine() : Int;
	
	/**
	 * Fetches the line handle for the given line number.
	 */
	function getLineHandle(num:Int) : LineHandle;
	
	/**
	 * Given a line handle, returns the current position of that
	 *       line (or <code>null</code> when it is no longer in the
	 *       document).
	 */
	function getLineNumber(handle:LineHandle) : Int;
	
	/**
	 * Iterate over the whole document, or if <code>start</code>
	 *       and <code>end</code> line numbers are given, the range
	 *       from <code>start</code> up to (not including) <code>end</code>,
	 *       and call <code>f</code> for each line, passing the line handle.
	 *       This is a faster way to visit a range of line handlers than
	 *       calling <a href="#getLineHandle"><code>getLineHandle</code></a>
	 *       for each of them. Note that line handles have
	 *       a <code>text</code> property containing the line's content (as a
	 *       string).
	 */
	@:overload(function(f:LineHandle->Void):Void{})
	function eachLine(start:Int, end:Int, f:LineHandle->Void) : Void;
	
	/**
	 * Set the editor content as 'clean', a flag that it will
	 *       retain until it is edited, and which will be set again when such
	 *       an edit is undone again. Useful to track whether the content
	 *       needs to be saved. This function is deprecated in favor
	 *       of <a href="#changeGeneration"><code>changeGeneration</code></a>,
	 *       which allows multiple subsystems to track different notions of
	 *       cleanness without interfering.
	 */
	function markClean() : Void;
	
	/**
	 * Returns a number that can later be passed
	 *       to <a href="#isClean"><code>isClean</code></a> to test whether
	 *       any edits were made (and not undone) in the meantime.
	 *       If <code>closeEvent</code> is true, the current history event
	 *       will be ‘closed’, meaning it can't be combined with further
	 *       changes (rapid typing or deleting events are typically
	 *       combined).
	 */
	function changeGeneration(?closeEvent:Bool) : Int;
	
	/**
	 * Returns whether the document is currently clean — not
	 *       modified since initialization or the last call
	 *       to <a href="#markClean"><code>markClean</code></a> if no
	 *       argument is passed, or since the matching call
	 *       to <a href="#changeGeneration"><code>changeGeneration</code></a>
	 *       if a generation value is given.
	 */
	function isClean(?generation:Int) : Bool;
	
	/**
	 * Get the currently selected code. Optionally pass a line
	 *       separator to put between the lines in the output. When multiple
	 *       selections are present, they are concatenated with instances
	 *       of <code>lineSep</code> in between.
	 */
	function getSelection(?lineSep:String) : String;
	
	/**
	 * Returns an array containing a string for each selection,
	 *       representing the content of the selections.
	 */
	function getSelections(?lineSep:String) : String;
	
	/**
	 * Replace the selection(s) with the given string. By default,
	 *       the new selection ends up after the inserted text. The
	 *       optional <code>select</code> argument can be used to change
	 *       this—passing <code>"around"</code> will cause the new text to be
	 *       selected, passing <code>"start"</code> will collapse the
	 *       selection to the start of the inserted text.
	 */
	function replaceSelection(replacement:String, ?select:String) : Void;
	
	/**
	 * The length of the given array should be the same as the
	 *       number of active selections. Replaces the content of the
	 *       selections with the strings in the array.
	 *       The <code>select</code> argument works the same as
	 *       in <a href="#replaceSelection"><code>replaceSelection</code></a>.
	 */
	function replaceSelections(replacements:Array<String>, ?select:String) : Void;
	
	/**
	 * Retrieve one end of the <em>primary</em>
	 *       selection. <code>start</code> is an optional string indicating
	 *       which end of the selection to return. It may
	 *       be <code>"from"</code>, <code>"to"</code>, <code>"head"</code>
	 *       (the side of the selection that moves when you press
	 *       shift+arrow), or <code>"anchor"</code> (the fixed side of the
	 *       selection). Omitting the argument is the same as
	 *       passing <code>"head"</code>. A <code>{line, ch}</code> object
	 *       will be returned.
	 */
	function getCursor(?start:String) : Position;
	
	/**
	 * Retrieves a list of all current selections. These will
	 *       always be sorted, and never overlap (overlapping selections are
	 *       merged). Each object in the array contains <code>anchor</code>
	 *       and <code>head</code> properties referring to <code>{line,
	 *       ch}</code> objects.
	 */
	function listSelections() : Array<{ anchor:Position, head:Position }>;
	
	/**
	 * Return true if any text is selected.
	 */
	function somethingSelected() : Bool;
	
	/**
	 * Set the cursor position. You can either pass a
	 *       single <code>{line, ch}</code> object, or the line and the
	 *       character as two separate parameters. Will replace all
	 *       selections with a single, empty selection at the given position.
	 *       The supported options are the same as for <a href="#setSelection"><code>setSelection</code></a>.
	 */
	function setCursor(pos:Position) : Void;
	
	/**
	 * Set a single selection range. <code>anchor</code>
	 *       and <code>head</code> should be <code>{line, ch}</code>
	 *       objects. <code>head</code> defaults to <code>anchor</code> when
	 *       not given. These options are supported:
	 *       <dl>
	 *         <dt id="selection_scroll"><code><strong>scroll</strong>: boolean</code></dt>
	 *         <dd>Determines whether the selection head should be scrolled
	 *         into view. Defaults to true.</dd>
	 *         <dt id="selection_origin"><code><strong>origin</strong>: string</code></dt>
	 *         <dd>Determines whether the selection history event may be
	 *         merged with the previous one. When an origin starts with the
	 *         character <code>+</code>, and the last recorded selection had
	 *         the same origin and was similar (close
	 *         in <a href="#option_historyEventDelay">time</a>, both
	 *         collapsed or both non-collapsed), the new one will replace the
	 *         old one. When it starts with <code>*</code>, it will always
	 *         replace the previous event (if that had the same origin).
	 *         Built-in motion uses the <code>"+move"</code> origin. User input uses the <code>"+input"</code> origin.</dd>
	 *         <dt id="selection_bias"><code><strong>bias</strong>: number</code></dt>
	 *         <dd>Determine the direction into which the selection endpoints
	 *         should be adjusted when they fall inside
	 *         an <a href="#mark_atomic">atomic</a> range. Can be either -1
	 *         (backward) or 1 (forward). When not given, the bias will be
	 *         based on the relative position of the old selection—the editor
	 *         will try to move further away from that, to prevent getting
	 *         stuck.</dd>
	 *       </dl>
	 */
	function setSelection(anchor:Position, ?head:Position, ?options:Dynamic) : Void;
	
	/**
	 * Sets a new set of selections. There must be at least one
	 *       selection in the given array. When <code>primary</code> is a
	 *       number, it determines which selection is the primary one. When
	 *       it is not given, the primary index is taken from the previous
	 *       selection, or set to the last range if the previous selection
	 *       had less ranges than the new one. Supports the same options
	 *       as <a href="#setSelection"><code>setSelection</code></a>.
	 */
	function setSelections(ranges:Array<{ anchor:Dynamic, head:Dynamic }>, ?primary:Int, ?options:Dynamic) : Void;
	
	/**
	 * Adds a new selection to the existing set of selections, and
	 *       makes it the primary selection.
	 */
	function addSelection(anchor:Position, ?head:Position) : Void;
	
	/**
	 * Similar
	 *       to <a href="#setSelection"><code>setSelection</code></a>, but
	 *       will, if shift is held or
	 *       the <a href="#setExtending">extending</a> flag is set, move the
	 *       head of the selection while leaving the anchor at its current
	 *       place. <code>to</code> is optional, and can be passed to ensure
	 *       a region (for example a word or paragraph) will end up selected
	 *       (in addition to whatever lies between that region and the
	 *       current anchor). When multiple selections are present, all but
	 *       the primary selection will be dropped by this method.
	 *       Supports the same options as <a href="#setSelection"><code>setSelection</code></a>.
	 */
	function extendSelection(from:Position, ?to:Position, ?options:Dynamic) : Void;
	
	/**
	 * An equivalent
	 *       of <a href="#extendSelection"><code>extendSelection</code></a>
	 *       that acts on all selections at once.
	 */
	function extendSelections(heads:Array<Position>, ?options:Dynamic) : Void;
	
	/**
	 * Applies the given function to all existing selections, and
	 *       calls <a href="#extendSelections"><code>extendSelections</code></a>
	 *       on the result.
	 */
	function extendSelectionsBy(f:{ anchor:Dynamic, head:Dynamic }->Position, ?options:Dynamic) : Void;

	/**
	 * Sets or clears the 'extending' flag, which acts similar to
	 *       the shift key, in that it will cause cursor movement and calls
	 *       to <a href="#extendSelection"><code>extendSelection</code></a>
	 *       to leave the selection anchor in place.
	 */
	function setExtending(value:Bool) : Void;
	
	/**
	 * Get the value of the 'extending' flag.
	 */
	function getExtending() : Bool;
	
	/**
	 * Retrieve the editor associated with a document. May
	 *       return <code>null</code>.
	 */
	function getEditor() : CodeMirror;
	
	/**
	 * Create an identical copy of the given doc.
	 *       When <code>copyHistory</code> is true, the history will also be
	 *       copied. Can not be called directly on an editor.
	 */
	function copy(copyHistory:Bool) : Doc;
	
	/**
	 * Create a new document that's linked to the target document.
	 *       Linked documents will stay in sync (changes to one are also
	 *       applied to the other) until <a href="#unlinkDoc">unlinked</a>.
	 *       These are the options that are supported:
	 *         <dl>
	 *           <dt id="linkedDoc_sharedHist"><code><strong>sharedHist</strong>: boolean</code></dt>
	 *           <dd>When turned on, the linked copy will share an undo
	 *           history with the original. Thus, something done in one of
	 *           the two can be undone in the other, and vice versa.</dd>
	 *           <dt id="linkedDoc_from"><code><strong>from</strong>: integer</code></dt>
	 *           <dt id="linkedDoc_to"><code><strong>to</strong>: integer</code></dt>
	 *           <dd>Can be given to make the new document a subview of the
	 *           original. Subviews only show a given range of lines. Note
	 *           that line coordinates inside the subview will be consistent
	 *           with those of the parent, so that for example a subview
	 *           starting at line 10 will refer to its first line as line 10,
	 *           not 0.</dd>
	 *           <dt id="linkedDoc_mode"><code><strong>mode</strong>: string|object</code></dt>
	 *           <dd>By default, the new document inherits the mode of the
	 *           parent. This option can be set to
	 *           a <a href="#option_mode">mode spec</a> to give it a
	 *           different mode.</dd>
	 *         </dl>
	 */
	function linkedDoc(options:Dynamic) : Doc;
	
	/**
	 * Break the link between two documents. After calling this,
	 *       changes will no longer propagate between the documents, and, if
	 *       they had a shared history, the history will become
	 *       separate.
	 */
	function unlinkDoc(doc:Doc) : Void;
	
	/**
	 * Will call the given function for all documents linked to the
	 *       target document. It will be passed two arguments, the linked document
	 *       and a boolean indicating whether that document shares history
	 *       with the target.
	 */
	function iterLinkedDocs(f:Doc->Bool->Void) : Void;
	
	/**
	 * Undo one edit (if any undo events are stored).
	 */
	function undo() : Void;
	
	/**
	 * Redo one undone edit.
	 */
	function redo() : Void;
	
	/**
	 * Undo one edit or selection change.
	 */
	function undoSelection() : Void;
	
	/**
	 * Redo one undone edit or selection change.
	 */
	function redoSelection() : Void;
	
	/**
	 * Returns an object with <code>{undo, redo}</code> properties,
	 *       both of which hold integers, indicating the amount of stored
	 *       undo and redo operations.
	 */
	function historySize() : { undo:Int, redo:Int };
	
	/**
	 * Clears the editor's undo history.
	 */
	function clearHistory() : Void;
	
	/**
	 * Get a (JSON-serializable) representation of the undo history.
	 */
	function getHistory() : Dynamic;
	
	/**
	 * Replace the editor's undo history with the one provided,
	 *       which must be a value as returned
	 *       by <a href="#getHistory"><code>getHistory</code></a>. Note that
	 *       this will have entirely undefined results if the editor content
	 *       isn't also the same as it was when <code>getHistory</code> was
	 *       called.
	 */
	function setHistory(history:Dynamic) : Void;
	
	/**
	 * Can be used to mark a range of text with a specific CSS
	 *       class name. <code>from</code> and <code>to</code> should
	 *       be <code>{line, ch}</code> objects.
	 *       The method will return an object that represents the marker
	 *       (with constructor <code>CodeMirror.TextMarker</code>), which
	 *       exposes three methods:
	 *       <code><strong>clear</strong>()</code>, to remove the mark,
	 *       <code><strong>find</strong>()</code>, which returns
	 *       a <code>{from, to}</code> object (both holding document
	 *       positions), indicating the current position of the marked range,
	 *       or <code>undefined</code> if the marker is no longer in the
	 *       document, and finally <code><strong>changed</strong>()</code>,
	 *       which you can call if you've done something that might change
	 *       the size of the marker (for example changing the content of
	 *       a <a href="#mark_replacedWith"><code>replacedWith</code></a>
	 *       node), and want to cheaply update the display.
	 */
	function markText(from:Position, to:Position, ?options:MarkTextOptions) : TextMarker;
	
	/**
	 * Inserts a bookmark, a handle that follows the text around it
	 *       as it is being edited, at the given position. A bookmark has two
	 *       methods <code>find()</code> and <code>clear()</code>. The first
	 *       returns the current position of the bookmark, if it is still in
	 *       the document, and the second explicitly removes the bookmark.
	 *       The options argument is optional.
	 */
	function setBookmark(pos:Position, ?options:BookmarkOptions) : TextMarker;
	
	/**
	 * Returns an array of all the bookmarks and marked ranges
	 *       found between the given positions.
	 */
	function findMarks(from:Position, to:Position) : Array<TextMarker>;
	
	/**
	 * Returns an array of all the bookmarks and marked ranges
	 *       present at the given position.
	 */
	function findMarksAt(pos:Position) : Array<TextMarker>;
	
	/**
	 * Returns an array containing all marked ranges in the document.
	 */
	function getAllMarks() : Array<TextMarker>;
	
	/**
	 * Set a CSS class name for the given line. <code>line</code>
	 *       can be a number or a line handle. <code>where</code> determines
	 *       to which element this class should be applied, can can be one
	 *       of <code>"text"</code> (the text element, which lies in front of
	 *       the selection), <code>"background"</code> (a background element
	 *       that will be behind the selection), <code>"gutter"</code> (the
	 *       line's gutter space), or <code>"wrap"</code> (the wrapper node
	 *       that wraps all of the line's elements, including gutter
	 *       elements). <code>class</code> should be the name of the class to
	 *       apply.
	 */
	function addLineClass(line:EitherType<Int, LineHandle>, where:String, klass:String) : LineHandle;
	
	/**
	 * Remove a CSS class from a line. <code>line</code> can be a
	 *       line handle or number. <code>where</code> should be one
	 *       of <code>"text"</code>, <code>"background"</code>,
	 *       or <code>"wrap"</code>
	 *       (see <a href="#addLineClass"><code>addLineClass</code></a>). <code>class</code>
	 *       can be left off to remove all classes for the specified node, or
	 *       be a string to remove only a specific class.
	 */
	function removeLineClass(line:EitherType<Int, LineHandle>, where:String, klass:String) : LineHandle;
	
	/**
	 * Adds a line widget, an element shown below a line, spanning
	 *       the whole of the editor's width, and moving the lines below it
	 *       downwards. <code>line</code> should be either an integer or a
	 *       line handle, and <code>node</code> should be a DOM node, which
	 *       will be displayed below the given line. <code>options</code>,
	 *       when given, should be an object that configures the behavior of
	 *       the widget. The following options are supported (all default to
	 *       false):
	 *         <dl>
	 *           <dt><code><strong>coverGutter</strong>: boolean</code></dt>
	 *           <dd>Whether the widget should cover the gutter.</dd>
	 *           <dt><code><strong>noHScroll</strong>: boolean</code></dt>
	 *           <dd>Whether the widget should stay fixed in the face of
	 *           horizontal scrolling.</dd>
	 *           <dt><code><strong>above</strong>: boolean</code></dt>
	 *           <dd>Causes the widget to be placed above instead of below
	 *           the text of the line.</dd>
	 *           <dt><code><strong>handleMouseEvents</strong>: boolean</code></dt>
	 *           <dd>Determines whether the editor will capture mouse and
	 *           drag events occurring in this widget. Default is false—the
	 *           events will be left alone for the default browser handler,
	 *           or specific handlers on the widget, to capture.</dd>
	 *           <dt><code><strong>insertAt</strong>: integer</code></dt>
	 *           <dd>By default, the widget is added below other widgets for
	 *           the line. This option can be used to place it at a different
	 *           position (zero for the top, N to put it after the Nth other
	 *           widget). Note that this only has effect once, when the
	 *           widget is created.
	 *         </dd></dl>
	 *       Note that the widget node will become a descendant of nodes with
	 *       CodeMirror-specific CSS classes, and those classes might in some
	 *       cases affect it. This method returns an object that represents
	 *       the widget placement. It'll have a <code>line</code> property
	 *       pointing at the line handle that it is associated with, and the following methods:
	 *         <dl>
	 *           <dt id="widget_clear"><code><strong>clear</strong>()</code></dt><dd>Removes the widget.</dd>
	 *           <dt id="widget_changed"><code><strong>changed</strong>()</code></dt><dd>Call
	 *           this if you made some change to the widget's DOM node that
	 *           might affect its height. It'll force CodeMirror to update
	 *           the height of the line that contains the widget.</dd>
	 *         </dl>
	 */
	function addLineWidget(line:EitherType<Int, LineHandle>, node:Element, ?options:Dynamic) : LineWidget;
	
	/**
	 * Gets the (outer) mode object for the editor. Note that this
	 *       is distinct from <code>getOption("mode")</code>, which gives you
	 *       the mode specification, rather than the resolved, instantiated
	 *       <a href="#defineMode">mode object</a>.
	 */
	function getMode() : Dynamic;
	
	/**
	 * Returns the preferred line separator string for this
	 *       document, as per the <a href="#option_lineSeparator">option</a>
	 *       by the same name. When that option is <code>null</code>, the
	 *       string <code>"\n"</code> is returned.
	 */
	function lineSeparator() : Void;
	
	/**
	 * Calculates and returns a <code>{line, ch}</code> object for a
	 *       zero-based <code>index</code> who's value is relative to the start of the
	 *       editor's text. If the <code>index</code> is out of range of the text then
	 *       the returned object is clipped to start or end of the text
	 *       respectively.
	 */
	function posFromIndex(index:Int) : Position;
	
	/**
	 * The reverse of <a href="#posFromIndex"><code>posFromIndex</code></a>.
	 */
	function indexFromPos(object:Position) : Int;
}
