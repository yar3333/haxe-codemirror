package js.codemirror;

import haxe.Constraints;
import haxe.extern.EitherType;
import js.html.Element;
import js.html.TextAreaElement;

class EditorEvents
{
	/**
	 * Fires every time the content of the editor is changed.
	 *       The <code>changeObj</code> is a <code>{from, to, text, removed,
	 *       origin}</code> object containing information about the changes
	 *       that occurred as second argument. <code>from</code>
	 *       and <code>to</code> are the positions (in the pre-change
	 *       coordinate system) where the change started and ended (for
	 *       example, it might be <code>{ch:0, line:18}</code> if the
	 *       position is at the beginning of line #19). <code>text</code> is
	 *       an array of strings representing the text that replaced the
	 *       changed range (split by line). <code>removed</code> is the text
	 *       that used to be between <code>from</code> and <code>to</code>,
	 *       which is overwritten by this change. This event is
	 *       fired <em>before</em> the end of
	 *       an <a href="#operation">operation</a>, before the DOM updates
	 *       happen.
	 */
	public static inline function on_change(target:Editor, callb:CodeMirror->Dynamic->Void) : Dynamic return target.on("change", callb);
	
	/**
	 * Like the <a href="#event_change"><code>"change"</code></a>
	 *       event, but batched per <a href="#operation">operation</a>,
	 *       passing an array containing all the changes that happened in the
	 *       operation. This event is fired after the operation finished, and
	 *       display changes it makes will trigger a new operation.
	 */
	public static inline function on_changes(target:Editor, callb:CodeMirror->Array<Dynamic>->Void) : Dynamic return target.on("changes", callb);
	
	/**
	 * This event is fired before a change is applied, and its
	 *       handler may choose to modify or cancel the change.
	 *       The <code>changeObj</code> object
	 *       has <code>from</code>, <code>to</code>, and <code>text</code>
	 *       properties, as with
	 *       the <a href="#event_change"><code>"change"</code></a> event. It
	 *       also has a <code>cancel()</code> method, which can be called to
	 *       cancel the change, and, <strong>if</strong> the change isn't
	 *       coming from an undo or redo event, an <code>update(from, to,
	 *       text)</code> method, which may be used to modify the change.
	 *       Undo or redo changes can't be modified, because they hold some
	 *       metainformation for restoring old marked ranges that is only
	 *       valid for that specific change. All three arguments
	 *       to <code>update</code> are optional, and can be left off to
	 *       leave the existing value for that field
	 *       intact. <strong>Note:</strong> you may not do anything from
	 *       a <code>"beforeChange"</code> handler that would cause changes
	 *       to the document or its visualization. Doing so will, since this
	 *       handler is called directly from the bowels of the CodeMirror
	 *       implementation, probably cause the editor to become
	 *       corrupted.
	 */
	public static inline function on_beforeChange(target:Editor, callb:CodeMirror->Dynamic->Void) : Dynamic return target.on("beforeChange", callb);
	
	/**
	 * Will be fired when the cursor or selection moves, or any
	 *       change is made to the editor content.
	 */
	public static inline function on_cursorActivity(target:Editor, callb:CodeMirror->Void) : Dynamic return target.on("cursorActivity", callb);
	
	/**
	 * Fired after a key is handled through a
	 *       key map. <code>name</code> is the name of the handled key (for
	 *       example <code>"Ctrl-X"</code> or <code>"'q'"</code>),
	 *       and <code>event</code> is the DOM <code>keydown</code>
	 *       or <code>keypress</code> event.
	 */
	public static inline function on_keyHandled(target:Editor, callb:CodeMirror->String->Event->Void) : Dynamic return target.on("keyHandled", callb);
	
	/**
	 * Fired whenever new input is read from the hidden textarea
	 *       (typed or pasted by the user).
	 */
	public static inline function on_inputRead(target:Editor, callb:CodeMirror->Dynamic->Void) : Dynamic return target.on("inputRead", callb);
	
	/**
	 * Fired if text input matched the
	 *       mode's <a href="#option_electricChars">electric</a> patterns,
	 *       and this caused the line's indentation to change.
	 */
	public static inline function on_electricInput(target:Editor, callb:CodeMirror->Int->Void) : Dynamic return target.on("electricInput", callb);
	
	/**
	 * This event is fired before the selection is moved. Its
	 *       handler may inspect the set of selection ranges, present as an
	 *       array of <code>{anchor, head}</code> objects in
	 *       the <code>ranges</code> property of the <code>obj</code>
	 *       argument, and optionally change them by calling
	 *       the <code>update</code> method on this object, passing an array
	 *       of ranges in the same format. The object also contains
	 *       an <code>origin</code> property holding the origin string passed
	 *       to the selection-changing method, if any. Handlers for this
	 *       event have the same restriction
	 *       as <a href="#event_beforeChange"><code>"beforeChange"</code></a>
	 *       handlers — they should not do anything to directly update the
	 *       state of the editor.
	 */
	public static inline function on_beforeSelectionChange(target:Editor, callb:CodeMirror->{ ranges:Dynamic, origin:Dynamic, update:Dynamic }->Void) : Dynamic return target.on("beforeSelectionChange", callb);
	
	/**
	 * Fires whenever the <a href="#getViewport">view port</a> of
	 *       the editor changes (due to scrolling, editing, or any other
	 *       factor). The <code>from</code> and <code>to</code> arguments
	 *       give the new start and end of the viewport.
	 */
	public static inline function on_viewportChange(target:Editor, callb:CodeMirror->Float->Float->Void) : Dynamic return target.on("viewportChange", callb);
	
	/**
	 * This is signalled when the editor's document is replaced
	 *       using the <a href="#swapDoc"><code>swapDoc</code></a>
	 *       method.
	 */
	public static inline function on_swapDoc(target:Editor, callb:CodeMirror->Doc->Void) : Dynamic return target.on("swapDoc", callb);
	
	/**
	 * Fires when the editor gutter (the line-number area) is
	 *       clicked. Will pass the editor instance as first argument, the
	 *       (zero-based) number of the line that was clicked as second
	 *       argument, the CSS class of the gutter that was clicked as third
	 *       argument, and the raw <code>mousedown</code> event object as
	 *       fourth argument.
	 */
	public static inline function on_gutterClick(target:Editor, callb:CodeMirror->Int->String->Event->Void) : Dynamic return target.on("gutterClick", callb);
	
	/**
	 * Fires when the editor gutter (the line-number area)
	 *       receives a <code>contextmenu</code> event. Will pass the editor
	 *       instance as first argument, the (zero-based) number of the line
	 *       that was clicked as second argument, the CSS class of the
	 *       gutter that was clicked as third argument, and the raw
	 *       <code>contextmenu</code> mouse event object as fourth argument.
	 *       You can <code>preventDefault</code> the event, to signal that
	 *       CodeMirror should do no further handling.
	 */
	public static inline function on_gutterContextMenu(target:Editor, callb:CodeMirror->Int->String->Event: Event->Void) : Dynamic return target.on("gutterContextMenu", callb);
	
	/**
	 * Fires whenever the editor is focused.
	 */
	public static inline function on_focus(target:Editor, callb:CodeMirror->Void) : Dynamic return target.on("focus", callb);
	
	/**
	 * Fires whenever the editor is unfocused.
	 */
	public static inline function on_blur(target:Editor, callb:CodeMirror->Void) : Dynamic return target.on("blur", callb);
	
	/**
	 * Fires when the editor is scrolled.
	 */
	public static inline function on_scroll(target:Editor, callb:CodeMirror->Void) : Dynamic return target.on("scroll", callb);
	
	/**
	 * Fires when the editor tries to scroll its cursor into view.
	 *       Can be hooked into to take care of additional scrollable
	 *       containers around the editor. When the event object has
	 *       its <code>preventDefault</code> method called, CodeMirror will
	 *       not itself try to scroll the window.
	 */
	public static inline function on_scrollCursorIntoView(target:Editor, callb:CodeMirror->Event->Void) : Dynamic return target.on("scrollCursorIntoView", callb);
	
	/**
	 * Will be fired whenever CodeMirror updates its DOM display.
	 */
	public static inline function on_update(target:Editor, callb:CodeMirror->Void) : Dynamic return target.on("update", callb);
	
	/**
	 * Fired whenever a line is (re-)rendered to the DOM. Fired
	 *       right after the DOM element is built, <em>before</em> it is
	 *       added to the document. The handler may mess with the style of
	 *       the resulting element, or add event handlers, but
	 *       should <em>not</em> try to change the state of the editor.
	 */
	public static inline function on_renderLine(target:Editor, callb:CodeMirror->LineHandle->Element->Void) : Dynamic return target.on("renderLine", callb);
	
	/**
	 * Fired when CodeMirror is handling a DOM event of this type.
	 *       You can <code>preventDefault</code> the event, or give it a
	 *       truthy <code>codemirrorIgnore</code> property, to signal that
	 *       CodeMirror should do no further handling.
	 */
	public static inline function on_mousedown(target:Editor, callb:CodeMirror->Event->Void) : Dynamic return target.on("mousedown", callb);
	
	/**
	 * Fired when CodeMirror is handling a DOM event of this type.
	 *       You can <code>preventDefault</code> the event, or give it a
	 *       truthy <code>codemirrorIgnore</code> property, to signal that
	 *       CodeMirror should do no further handling.
	 */
	public static inline function on_dblclick(target:Editor, callb:CodeMirror->Event->Void) : Dynamic return target.on("dblclick", callb);
	
	/**
	 * Fired when CodeMirror is handling a DOM event of this type.
	 *       You can <code>preventDefault</code> the event, or give it a
	 *       truthy <code>codemirrorIgnore</code> property, to signal that
	 *       CodeMirror should do no further handling.
	 */
	public static inline function on_touchstart(target:Editor, callb:CodeMirror->Event->Void) : Dynamic return target.on("touchstart", callb);
	
	/**
	 * Fired when CodeMirror is handling a DOM event of this type.
	 *       You can <code>preventDefault</code> the event, or give it a
	 *       truthy <code>codemirrorIgnore</code> property, to signal that
	 *       CodeMirror should do no further handling.
	 */
	public static inline function on_contextmenu(target:Editor, callb:CodeMirror->Event->Void) : Dynamic return target.on("contextmenu", callb);
	
	/**
	 * Fired when CodeMirror is handling a DOM event of this type.
	 *       You can <code>preventDefault</code> the event, or give it a
	 *       truthy <code>codemirrorIgnore</code> property, to signal that
	 *       CodeMirror should do no further handling.
	 */
	public static inline function on_keydown(target:Editor, callb:CodeMirror->Event->Void) : Dynamic return target.on("keydown", callb);
	
	/**
	 * Fired when CodeMirror is handling a DOM event of this type.
	 *       You can <code>preventDefault</code> the event, or give it a
	 *       truthy <code>codemirrorIgnore</code> property, to signal that
	 *       CodeMirror should do no further handling.
	 */
	public static inline function on_keypress(target:Editor, callb:CodeMirror->Event->Void) : Dynamic return target.on("keypress", callb);
	
	/**
	 * Fired when CodeMirror is handling a DOM event of this type.
	 *       You can <code>preventDefault</code> the event, or give it a
	 *       truthy <code>codemirrorIgnore</code> property, to signal that
	 *       CodeMirror should do no further handling.
	 */
	public static inline function on_keyup(target:Editor, callb:CodeMirror->Event->Void) : Dynamic return target.on("keyup", callb);
	
	/**
	 * Fired when CodeMirror is handling a DOM event of this type.
	 *       You can <code>preventDefault</code> the event, or give it a
	 *       truthy <code>codemirrorIgnore</code> property, to signal that
	 *       CodeMirror should do no further handling.
	 */
	public static inline function on_cut(target:Editor, callb:CodeMirror->Event->Void) : Dynamic return target.on("cut", callb);
	
	/**
	 * Fired when CodeMirror is handling a DOM event of this type.
	 *       You can <code>preventDefault</code> the event, or give it a
	 *       truthy <code>codemirrorIgnore</code> property, to signal that
	 *       CodeMirror should do no further handling.
	 */
	public static inline function on_copy(target:Editor, callb:CodeMirror->Event->Void) : Dynamic return target.on("copy", callb);
	
	/**
	 * Fired when CodeMirror is handling a DOM event of this type.
	 *       You can <code>preventDefault</code> the event, or give it a
	 *       truthy <code>codemirrorIgnore</code> property, to signal that
	 *       CodeMirror should do no further handling.
	 */
	public static inline function on_paste(target:Editor, callb:CodeMirror->Event->Void) : Dynamic return target.on("paste", callb);
	
	/**
	 * Fired when CodeMirror is handling a DOM event of this type.
	 *       You can <code>preventDefault</code> the event, or give it a
	 *       truthy <code>codemirrorIgnore</code> property, to signal that
	 *       CodeMirror should do no further handling.
	 */
	public static inline function on_dragstart(target:Editor, callb:CodeMirror->Event->Void) : Dynamic return target.on("dragstart", callb);
	
	/**
	 * Fired when CodeMirror is handling a DOM event of this type.
	 *       You can <code>preventDefault</code> the event, or give it a
	 *       truthy <code>codemirrorIgnore</code> property, to signal that
	 *       CodeMirror should do no further handling.
	 */
	public static inline function on_dragenter(target:Editor, callb:CodeMirror->Event->Void) : Dynamic return target.on("dragenter", callb);
	
	/**
	 * Fired when CodeMirror is handling a DOM event of this type.
	 *       You can <code>preventDefault</code> the event, or give it a
	 *       truthy <code>codemirrorIgnore</code> property, to signal that
	 *       CodeMirror should do no further handling.
	 */
	public static inline function on_dragover(target:Editor, callb:CodeMirror->Event->Void) : Dynamic return target.on("dragover", callb);
	
	/**
	 * Fired when CodeMirror is handling a DOM event of this type.
	 *       You can <code>preventDefault</code> the event, or give it a
	 *       truthy <code>codemirrorIgnore</code> property, to signal that
	 *       CodeMirror should do no further handling.
	 */
	public static inline function on_dragleave(target:Editor, callb:CodeMirror->Event->Void) : Dynamic return target.on("dragleave", callb);
	
	/**
	 * Fired when CodeMirror is handling a DOM event of this type.
	 *       You can <code>preventDefault</code> the event, or give it a
	 *       truthy <code>codemirrorIgnore</code> property, to signal that
	 *       CodeMirror should do no further handling.
	 */
	public static inline function on_drop(target:Editor, callb:CodeMirror->Event->Void) : Dynamic return target.on("drop", callb);
}
