using stdlib.StringTools;

class Utf8Tools
{
	public static function fix(s:String) : String
	{
		s = s.replace(String.fromCharCode(0xC2) + String.fromCharCode(0xA0), " ");
		s = s.replace(String.fromCharCode(0xE2) + String.fromCharCode(0x86) + String.fromCharCode(0x92), "->");
		return s;
	}
}