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
	static var brackets =
	[
		"<" => ">",
		"[" => "]",
		"(" => ")",
		"{" => "}"
	];
	
	static function main()
	{
		var jsonFile = "bin/manual.json";
		
		var text = File.getContent(jsonFile);
		var elements : Array<Element> = TJSON.parse(text);
		
		Debug.assert(elements.length == 1, "elements.length = " + elements.length);
		
		var destDir = "../library/js/codemirror";
		
		if (!FileSystem.exists(destDir))
		{
			FileSystem.createDirectory(destDir);
		}
		
		processConfig(elements[0].config, destDir);
		processEvents(elements[0].events, destDir);
	}
	
	static function processConfig(text:String, destDir:String)
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
		
		File.saveContent
		(
			destDir + "/Config.hx",
			  "package js.codemirror;\n"
			+ "\n"
			+ "typedef Config =\n"
			+ "{\n"
			+ options.map.fn
			(
				  makeComment(_.desc)
				+ "\t" + (_.type.optional ? "@:optional " : "") + "var " + _.name + " : " + _.type.name + ";\n"
			).join("\t\n")
			+ "}\n"
		);
	}
	
	static function processEvents(text:String, destDir:String)
	{
		var doc = new HtmlDocument("<root>" + text + "</root>");
		
		var dlNodes = doc.find(">root>dl");
		Debug.assert(dlNodes.length == 5, "dlNodes.length = " + dlNodes.length);
		
		processEventsInner("EditorEvents", "Editor", dlNodes[0], destDir);
		processEventsInner("DocEvents", "Doc", dlNodes[1], destDir);
		processEventsInner("LineEvents", "Line", dlNodes[2], destDir);
		processEventsInner("MarkedRangeEvents", "MarkedRange", dlNodes[3], destDir);
		processEventsInner("LineWidgetsEvents", "LineWidgets", dlNodes[4], destDir);
	}
	
	static function processEventsInner(className:String, targetType:String, node:HtmlNodeElement, destDir:String)
	{
		Log.start(className);
		
		var options = [];
		
		var dtNodes = node.find(">dt");
		var ddNodes = node.find(">dd");
		
		var i = 0; while (i < dtNodes.length)
		{
			var dt = dtNodes[i];
			var dd = ddNodes[i];
			
			var def = dt.innerText;
			def = def.replace('"', "").trim();
			
			Log.echo("def = " + def);
			
			var re = ~/^([_a-z][_a-z0-9]*(?:\s*,\s*[_a-z][_a-z0-9]*)*)\s*[(]([^)]*)[)]$/i;
			if (re.match(def))
			{
				var names = re.matched(1).split(",").map(std.StringTools.trim).filter.fn(_ != "");
				var params = parseParams(re.matched(2));
				for (name in names)
				{
					options.push
					({
						name: name,
						params: params,
						desc: dd.innerHTML
					});
				}
			}
			
			i++;
		}
		
		File.saveContent
		(
			destDir + "/" + className + ".hx",
			  "package js.codemirror;\n"
			+ "\n"
			+ "class " + className+"\n"
			
			+ "{\n"
			+ options.map.fn
			(
				  makeComment(_.desc)
				+ "\tpublic static inline function on_" + _.name
					+ "(target:" + targetType + ", callb:" + _.params.map.fn((_.type.optional ? "?" : "") + _.type.name).join("->") + "->Void) : Dynamic"
					+ " return target.on(\"" + _.name + "\", callb);\n"
			).join("\t\n")
			+ "}\n"
		);
		
		Log.finishSuccess();
	}
	
	static function makeComment(s:String) : String
	{
		return s != null && s != "" ? "\t/**\n\t * " + s.replace("\n", "\n\t * ") + "\n\t */\n" : "";
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
	
	static function parseParams(s:String) : Array<{ name:String, type:{ name:String, optional:Bool} }>
	{
		s = s.ltrim(", ");
		if (s == "") return [];
		
		var ID = "[_a-z][_a-z0-9]*";
		
		var reName = new EReg("^" + ID, "i");
		
		if (reName.match(s))
		{
			s = reName.matchedRight();
			
			var name = reName.matched(0);
			var type = { name:"Dynamic", optional:false };
			
			var reTypePref = new EReg("^\\s*[:]\\s*", "i");
			if (reTypePref.match(s))
			{
				s = reTypePref.matchedRight();
				
				if (s.startsWith("{"))
				{
					var n = findPairBracket(s);
					if (n > 0)
					{
						type =
						{
							name:"{ " + parseParams(s.substring(1, n)).map.fn
							(
								(_.type.optional ? "?" : "") + _.name + ":" + _.type.name
							)
							.join(", ") + " }",
							optional:false
						};
						
						s = n + 1 < s.length ? s.substring(n + 1) : "";
					}
				}
				else
				{
					var n = findCharInThisScope(s, ",");
					if (n < 0) n = s.length;
					type = toHaxeType(name, s.substring(0, n));
					
					s = n + 1 < s.length ? s.substring(n + 1) : "";
				}
			}
			
			return [ { name:name, type:type } ].concat(parseParams(s));
		}
		
		return [];
	}
	
	static function findPairBracket(s:String) : Int
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
	
	static function findCharInThisScope(s:String, need:String) : Int
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