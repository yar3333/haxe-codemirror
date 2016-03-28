using stdlib.Lambda;
using stdlib.StringTools;

class Types
{
	public static function toHaxeType(name:String, type:String) : HaxeType
	{
		var types = type.split("|").map(std.StringTools.trim).filter.fn(_ != "");
		var optional = types.has("null");
		types = types.filter.fn(_ != "null").map.fn(toHaxeTypeTrivial(name, _));
		return { name:toHaxeTypeInner(name, types), optional:optional };
	}
	
	static function toHaxeTypeInner(name:String, types:Array<String>)
	{
		if (types.length == 1) return types[0];
		var t = types.pop();
		return "haxe.extern.EitherType<" + toHaxeTypeInner(name, types) + ", " + t + ">";
	}
	
	public static function toHaxeTypeTrivial(name:String, type:String) : String
	{
		type = Utf8Tools.fix(type);
		type = type.trim();
		
		if (type.startsWith("CodeMirror.")) type = type.substring("CodeMirror.".length);
		
		return switch (type)
		{
			case "(...args)": "Function";
			case "array": "Array";
			case "string", "char": "String";
			case "integer": "Int";
			case "number": "Float";
			case "boolean": "Bool";
			case "object", "any": "Dynamic";
			case _:
				if (type.startsWith("{") && type.endsWith("}"))
				{
					return "{ " + Params.parseParams(type.substring(1, type.length - 1)).map.fn((_.type.optional ? "?" : "") + _.name + ":" + _.type.name).join(", ") + " }";
				}
				
				var start = -1;
				if ((start=type.indexOf("<")) >= 0)
				{
					var end = ParserTools.findPairBracket(type, start);
					if (end >= 0)
					{
						type = toHaxeTypeTrivial(name, type.substring(0, start)) + "<" + toHaxeType("", type.substring(start + 1, end)).name + type.substring(end);
					}
				}
				
				if (type.startsWith("function"))
				{
					var re = ~/^function\s*[(]([^)]*)[)]\s*->\s*(.*)$/i;
					if (re.match(type))
					{
						var params = re.matched(1).trim().split(",").map.fn(_.trim()).filter.fn(_ != "");
						type = params.map(Params.paramToType).join("->") + "->" + toHaxeTypeTrivial(name, re.matched(2));
					}
				}
				
				type;
		};
	}
}