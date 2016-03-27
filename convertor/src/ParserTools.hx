using stdlib.Lambda;
using stdlib.StringTools;

class ParserTools
{
	static var brackets =
	[
		"<" => ">",
		"[" => "]",
		"(" => ")",
		"{" => "}"
	];
	
	public static function findPairBracket(s:String) : Int
	{
		var stack = [ brackets.get(s.substring(0, 1)) ];
		
		for (i in 1...s.length)
		{
			var ch = s.charAt(i);
			
			if (brackets.exists(ch))
			{
				stack.push(brackets.get(ch));
			}
			else
			{
				if (ch == stack[stack.length - 1])
				{
					stack.pop();
					if (stack.length == 0) return i;
				}
			}
		}	
		
		return -1;
	}
	
	public static function findCharInThisScope(s:String, need:String) : Int
	{
		var stack = [];
		
		for (i in 0...s.length)
		{
			var ch = s.charAt(i);
			
			if (ch == need && stack.length == 0) return i;
			
			if (brackets.exists(ch))
			{
				stack.push(brackets.get(ch));
			}
			else if (ch == stack[stack.length - 1])
			{
				stack.pop();
			}
		}	
		
		return -1;
	}
}