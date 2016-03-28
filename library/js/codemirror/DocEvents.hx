package js.codemirror;

import haxe.Constraints;
import haxe.extern.EitherType;
import js.html.Element;
import js.html.TextAreaElement;

class DocEvents
{
	/**
	 * Fired whenever a change occurs to the
	 *       document. <code>changeObj</code> has a similar type as the
	 *       object passed to the
	 *       editor's <a href="#event_change"><code>"change"</code></a>
	 *       event.
	 */
	public static inline function on_change(target:Doc, callb:Doc->Dynamic->Void) : Dynamic return target.on("change", callb);
	
	/**
	 * See the <a href="#event_beforeChange">description of the
	 *       same event</a> on editor instances.
	 */
	public static inline function on_beforeChange(target:Doc, callb:Doc->Dynamic->Void) : Dynamic return target.on("beforeChange", callb);
	
	/**
	 * Fired whenever the cursor or selection in this document
	 *       changes.
	 */
	public static inline function on_cursorActivity(target:Doc, callb:Doc->Void) : Dynamic return target.on("cursorActivity", callb);
	
	/**
	 * Equivalent to
	 *       the <a href="#event_beforeSelectionChange">event by the same
	 *       name</a> as fired on editor instances.
	 */
	public static inline function on_beforeSelectionChange(target:Doc, callb:Doc->{ head:Dynamic, anchor:Dynamic }->Void) : Dynamic return target.on("beforeSelectionChange", callb);
}
