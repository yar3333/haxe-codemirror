using stdlib.Lambda;
using stdlib.StringTools;

class Params
{
	public static function paramToType(s:String) : String
	{
		var n = s.indexOf(":");
		if (n >= 0)
		{
			return Types.toHaxeTypeTrivial(s.substring(0, n), s.substring(n + 1).trim());
		}
		return Types.toHaxeTypeTrivial("", s.trim());
	}
	
	public static function parseParams(s:String) : Array<Param>
	{
		s = s.trim(", ");
		if (s == "") return [];
		
		var ID = "[_a-z][_a-z0-9]*";
		
		var reName = new EReg("^([?]?)\\s*(" + ID + ")", "i");
		
		if (reName.match(s))
		{
			s = reName.matchedRight();
			
			var name = reName.matched(2);
			var type = { name:"", optional:reName.matched(1) == "?" };
			
			var reTypePref = new EReg("^\\s*[:]\\s*", "i");
			if (reTypePref.match(s))
			{
				s = reTypePref.matchedRight();
				
				if (s.startsWith("{"))
				{
					var n = ParserTools.findPairBracket(s);
					if (n > 0)
					{
						type.name = "{ " + parseParams(s.substring(1, n)).map.fn
											(
												(_.type.optional ? "?" : "") + _.name + ":" + _.type.name
											)
											.join(", ")
								 + " }";
						s = n + 1 < s.length ? s.substring(n + 1) : "";
					}
				}
				else
				{
					var n = ParserTools.findCharInThisScope(s, ",");
					if (n < 0) n = s.length;
					var t = Types.toHaxeType(name, s.substring(0, n));
					type.name = t.name;
					type.optional = type.optional || t.optional;
					
					s = n + 1 < s.length ? s.substring(n + 1) : "";
				}
			}
			
			if (type.name == "")
			{
				type = Types.toHaxeType(name, "");
			}
			
			return [ { name:name, type:type } ].concat(parseParams(s));
		}
		
		return [];
	}
	
	public static function toString(params:Array<Param>) : String
	{
		return params.map.fn((_.type.optional ? "?" : "") + _.name + ":" + _.type.name).join(", ");
	}
}