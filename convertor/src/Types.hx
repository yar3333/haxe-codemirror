using stdlib.Lambda;
using stdlib.StringTools;

class Types
{
	public static function toHaxeType(name:String, type:String) : { name:String, optional:Bool }
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
		type = type.replace(String.fromCharCode(0xC2) + String.fromCharCode(0xA0), " ");
		type = type.replace(String.fromCharCode(0xE2) + String.fromCharCode(0x86) + String.fromCharCode(0x92), "->");
		
		if (type.startsWith("CodeMirror.")) type = type.substring("CodeMirror.".length);
		
		return switch (type)
		{
			case "array": "Array";
			case "string", "char": "String";
			case "integer": "Int";
			case "number": "Float";
			case "boolean": "Bool";
			case "object": "Dynamic";
			case _:
				if (type.indexOf("<") >= 0)
				{
					type = ~/[_a-z][_a-z0-9]*/ig.map(type, function(re) return toHaxeTypeTrivial("", re.matched(0)));
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