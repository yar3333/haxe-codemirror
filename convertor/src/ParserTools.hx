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
	
	public static function findPairBracket(s:String, start=0) : Int
	{
		var stack = [ brackets.get(s.substr(start, 1)) ];
		
		for (i in (start + 1)...s.length)
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
	
	public static function findCharInThisScope(s:String, need:String, start=0) : Int
	{
		var stack = [];
		
		for (i in start...s.length)
		{
			var ch = s.charAt(i);
			
			if (need.indexOf(ch) >= 0  && stack.length == 0) return i;
			
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