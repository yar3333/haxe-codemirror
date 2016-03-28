package js.codemirror;

import haxe.Constraints;
import haxe.extern.EitherType;
import js.html.Element;
import js.html.TextAreaElement;

class MarkedRangeEvents
{
	/**
	 * Fired when the cursor enters the marked range. From this
	 *       event handler, the editor state may be inspected
	 *       but <em>not</em> modified, with the exception that the range on
	 *       which the event fires may be cleared.
	 */
	public static inline function on_beforeCursorEnter(target:MarkedRange, callb:->Void) : Dynamic return target.on("beforeCursorEnter", callb);
	
	/**
	 * Fired when the range is cleared, either through cursor
	 *       movement in combination
	 *       with <a href="#mark_clearOnEnter"><code>clearOnEnter</code></a>
	 *       or through a call to its <code>clear()</code> method. Will only
	 *       be fired once per handle. Note that deleting the range through
	 *       text editing does not fire this event, because an undo action
	 *       might bring the range back into existence. <code>from</code>
	 *       and <code>to</code> give the part of the document that the range
	 *       spanned when it was cleared.
	 */
	public static inline function on_clear(target:MarkedRange, callb:{ line:Int, ch:Int }->{ line:Int, ch:Int }->Void) : Dynamic return target.on("clear", callb);
	
	/**
	 * Fired when the last part of the marker is removed from the
	 *       document by editing operations.
	 */
	public static inline function on_hide(target:MarkedRange, callb:->Void) : Dynamic return target.on("hide", callb);
	
	/**
	 * Fired when, after the marker was removed by editing, a undo
	 *       operation brought the marker back.
	 */
	public static inline function on_unhide(target:MarkedRange, callb:->Void) : Dynamic return target.on("unhide", callb);
}
