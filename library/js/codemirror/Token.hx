package js.codemirror;

typedef Token =
{
	/**
	 * The character (on the given line) at which the token starts.
	 */
	var start : Int;
	
	/**
	 * The character at which the token ends.
	 */
	var end : Int;
	
	/**
	 * The token's string.
	 */
	var string : String;
	
	/**
	 * The token type the mode assigned to the token,
	 * such as <code>"keyword"</code> or <code>"comment"</code>
	 * (may also be null).
	 */
	var type : String;
	
	/**
	 * The mode's state at the end of this token.
	 */
	var state : Dynamic;
}