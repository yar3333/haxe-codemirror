using stdlib.Lambda;
using stdlib.StringTools;

class Comments
{
	public static function makeComment(s:String) : String
	{
		return s != null && s != "" ? "\t/**\n\t * " + s.replace("\n", "\n\t * ") + "\n\t */\n" : "";
	}
}