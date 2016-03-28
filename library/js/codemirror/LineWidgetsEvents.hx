package js.codemirror;

import haxe.Constraints;
import haxe.extern.EitherType;
import js.html.Element;
import js.html.TextAreaElement;

class LineWidgetsEvents
{
	/**
	 * Fired whenever the editor re-adds the widget to the DOM.
	 *       This will happen once right after the widget is added (if it is
	 *       scrolled into view), and then again whenever it is scrolled out
	 *       of view and back in again, or when changes to the editor options
	 *       or the line the widget is on require the widget to be
	 *       redrawn.
	 */
	public static inline function on_redraw(target:LineWidgets, callb:->Void) : Dynamic return target.on("redraw", callb);
}
