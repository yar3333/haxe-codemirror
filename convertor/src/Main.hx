import htmlparser.HtmlNodeElement;
import hant.Log;
import haxe.io.Path;
import htmlparser.HtmlDocument;
import htmlparser.HtmlParser;
import stdlib.Debug;
import stdlib.Regex;
import sys.FileSystem;
import sys.io.File;
import tjson.TJSON;
using stdlib.Lambda;
using stdlib.StringTools;

typedef Element =
{
    var config: String;
    var events: String;
    var commands: String;
    var styling: String;
    var api: String;
}

class Main
{
	static function main()
	{
		var jsonFile = "bin/manual.json";
		
		var text = File.getContent(jsonFile);
		var elements : Array<Element> = TJSON.parse(text);
		
		Debug.assert(elements.length == 1, "elements.length = " + elements.length);
		
		processConfig(elements[0].config, "../library/js/codemirror/Config.hx");
	}
	
	static function processConfig(text:String, destFile:String)
	{
		var doc = new HtmlDocument("<root>" + text + "</root>");
		
		var options = [];
		
		var dtNodes = doc.find(">root>dl>dt");
		var ddNodes = doc.find(">root>dl>dd");
		
		var i = 0; while (i < dtNodes.length)
		{
			var dt = dtNodes[i];
			var dd = ddNodes[i];
			
			var nameAndTypeNodes = dt.find(">code");
			if (nameAndTypeNodes.length > 0)
			{
				var nameAndType = nameAndTypeNodes[0].innerText.trim();
				var re = ~/^([a-z_][_a-z0-9]*)\s*[:]\s*(.*)$/i;
				if (re.match(nameAndType))
				{
					options.push
					({
						name: re.matched(1),
						type: toHaxeType(re.matched(1), re.matched(2)),
						desc: dd.innerHTML
					});
				}
			}
			
			i++;
		}
		
		if (!FileSystem.exists(Path.directory(destFile)))
		{
			FileSystem.createDirectory(Path.directory(destFile));
		}
		
		File.saveContent
		(
			destFile,
			  "package js.codemirror;\n"
			+ "\n"
			+ "typedef Config =\n"
			+ "{\n"
			+ options.map.fn
			(
				(_.desc != null && _.desc != "" ? "\t/**\n\t * " + _.desc.replace("\n", "\n\t * ") + "\n\t */\n" : "")
				+ "\t" + (_.type.optional ? "@:optional " : "") + "var " + _.name + " : " + _.type.name + ";\n"
			).join("\t\n")
			+ "}\n"
		);
	}
	
	static function toHaxeType(name:String, type:String) : { name:String, optional:Bool }
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
	
	static function toHaxeTypeTrivial(name:String, type:String) : String
	{
		type = type.replace(String.fromCharCode(0xC2) + String.fromCharCode(0xA0), " ");
		type = type.replace(String.fromCharCode(0xE2) + String.fromCharCode(0x86) + String.fromCharCode(0x92), "->");
		
		return switch (type)
		{
			case "array": "Array";
			case "string", "char": "String";
			case "integer": "Int";
			case "number": "Float";
			case "boolean": "Bool";
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
						type = params.map(paramToType).join("->") + "->" + toHaxeTypeTrivial(name, re.matched(2));
					}
				}
				
				type;
		};
	}
	
	static function paramToType(s:String) : String
	{
		var n = s.indexOf(":");
		if (n >= 0)
		{
			return toHaxeTypeTrivial(s.substring(0, n), s.substring(n + 1).trim());
		}
		return toHaxeTypeTrivial("", s.trim());
	}
}