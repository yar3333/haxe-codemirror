package js.codemirror;

class LineEvents
{
	/**
	 * Will be fired when the line object is deleted. A line object
	 *       is associated with the <em>start</em> of the line. Mostly useful
	 *       when you need to find out when your <a href="#setGutterMarker">gutter
	 *       markers</a> on a given line are removed.
	 */
	public static inline function on_delete(target:Line, callb:->Void) : Dynamic return target.on("delete", callb);
	
	/**
	 * Fires when the line's text content is changed in any way
	 *       (but the line is not deleted outright). The <code>change</code>
	 *       object is similar to the one passed
	 *       to <a href="#event_change">change event</a> on the editor
	 *       object.
	 */
	public static inline function on_change(target:Line, callb:LineHandle->Dynamic->Void) : Dynamic return target.on("change", callb);
}
