import hant.Log;
import htmlparser.HtmlDocument;
import htmlparser.HtmlNodeElement;
import stdlib.Debug;
import sys.FileSystem;
import sys.io.File;
import tjson.TJSON;
using stdlib.Lambda;
using stdlib.StringTools;

class Main
{
	static function main()
	{
		var destDir = "../library/js/codemirror";
		
		if (!FileSystem.exists(destDir))
		{
			FileSystem.createDirectory(destDir);
		}
		
		processConfig("bin/config.json", destDir);
		processEvents("bin/events.json", destDir);
		processApi("bin/api.json", destDir);
	}
	
	static function jsonToHtml(jsonFile:String) : String
	{
		var text = File.getContent(jsonFile);
		var elements : Array<{ data:String }> = TJSON.parse(text);
		
		Debug.assert(elements.length == 1, "elements.length = " + elements.length);
		
		return elements[0].data;
	}
	
	static function processConfig(jsonFile:String, destDir:String)
	{
		Log.start("CONFIG");
		
		var doc = new HtmlDocument("<root>" + jsonToHtml(jsonFile) + "</root>");
		
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
						type: Types.toHaxeType(re.matched(1), re.matched(2)),
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
				  Comments.makeComment(_.desc)
				+ "\t" + (_.type.optional ? "@:optional " : "") + "var " + _.name + " : " + _.type.name + ";\n"
			).join("\t\n")
			+ "}\n"
		);
		
		Log.finishSuccess();
	}
	
	static function processEvents(jsonFile:String, destDir:String)
	{
		Log.start("EVENTS");
		
		var doc = new HtmlDocument("<root>" + jsonToHtml(jsonFile) + "</root>");
		
		var dlNodes = doc.find(">root>dl");
		Debug.assert(dlNodes.length == 5, "dlNodes.length = " + dlNodes.length);
		
		processEventsInner("EditorEvents", "Editor", dlNodes[0], destDir);
		processEventsInner("DocEvents", "Doc", dlNodes[1], destDir);
		processEventsInner("LineEvents", "Line", dlNodes[2], destDir);
		processEventsInner("MarkedRangeEvents", "MarkedRange", dlNodes[3], destDir);
		processEventsInner("LineWidgetsEvents", "LineWidgets", dlNodes[4], destDir);
		
		Log.finishSuccess();
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
			
			var re = ~/^([_a-z][_a-z0-9]*(?:\s*,\s*[_a-z][_a-z0-9]*)*)\s*[(]([^)]*)[)]$/i;
			if (re.match(def))
			{
				var names = re.matched(1).split(",").map(std.StringTools.trim).filter.fn(_ != "");
				var params = Params.parseParams(re.matched(2));
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
				  Comments.makeComment(_.desc)
				+ "\tpublic static inline function on_" + _.name
					+ "(target:" + targetType + ", callb:" + _.params.map.fn((_.type.optional ? "?" : "") + _.type.name).join("->") + "->Void) : Dynamic"
					+ " return target.on(\"" + _.name + "\", callb);\n"
			).join("\t\n")
			+ "}\n"
		);
		
		Log.finishSuccess();
	}
	
	static function processApi(jsonFile:String, destDir:String)
	{
		Log.start("API");
		
		var doc = new HtmlDocument("<root>" + jsonToHtml(jsonFile) + "</root>", true);
		
		var options = [];
		
		var dtNodes = [];
		var ddNodes = [];
		
		for (node in doc.find(">root>*"))
		{
			Log.echo("NODE " + node.name + " " + node.attributes);
			for (node in node.children)
			{
				Log.echo("\tNODE " + node.name + " " + node.attributes);
			}
		}
		
		var dlNodes = doc.find(">root>dl");
		Debug.assert(dlNodes.length == 11, "dlNodes.length = " + dlNodes.length);
		
		for (dlNode in dlNodes)
		{
			var i = 0; while (i < dlNode.children.length)
			{
				if (dlNode.children[i].name == "dt")
				{
					dtNodes.push(dlNode.children[i]);
					if (i + 1 < dlNode.children.length && dlNode.children[i + 1].name == "dd")
					{
						i++;
						ddNodes.push(dlNode.children[i]);
					}
					else
					{
						ddNodes.push(new HtmlNodeElement("dd", []));
					}
				}
				i++;
			}
		}
		
		Debug.assert(dtNodes.length == ddNodes.length, "dtNodes.length = " + dtNodes.length + " <> ddNodes.length = " + ddNodes.length);
		
		var i = 0; while (i < dtNodes.length)
		{
			var dt = dtNodes[i];
			var dd = ddNodes[i];
			
			var defs = dt.find(">code");
			if (defs.length > 0)
			{
				var def = Utf8Tools.fix(defs[0].innerText.trim());
				
				var reFuncName = ~/^([a-z_][_a-z0-9]*[.][a-z_][_a-z0-9]*)\s*[(]/i;
				if (reFuncName.match(def))
				{
					var name = reFuncName.matched(1);
					var startParams = reFuncName.matchedPos().len;
					var endParams = ParserTools.findPairBracket(def, startParams - 1);
					Debug.assert(endParams > 0);
					var params = def.substring(startParams, endParams);
					
					var retType = def.substring(endParams + 1).trim();
					if (retType.startsWith("->")) retType = retType.substring("->".length);
					
					var option =
					{
						name: name,
						params: Params.parseParams(params),
						retType: Types.toHaxeType(name, retType != "" ? retType : "Void"),
						desc: dd.innerHTML.trim()
					};
					
					options.push(option);
					
					Log.echo(option.name);
				}
				else
				{
					Log.echo("ERROR parsing '" + def + "'");
				}
			}
			
			i++;
		}
		
		File.saveContent
		(
			destDir + "/Doc.hx",
			  "package js.codemirror;\n"
			+ "\n"
			+ "class Doc\n"
			+ "{\n"
			+ options.filter.fn(_.name.startsWith("doc.")).map.fn(toExternMethodString(_)).join("\t\n")
			+ "}\n"
		);
		
		File.saveContent
		(
			destDir + "/CodeMirror.hx",
			  "package js.codemirror;\n"
			+ "\n"
			+ "class CodeMirror extends Doc\n"
			+ "{\n"
			+ options.filter.fn(_.name.startsWith("cm.")).map.fn(toExternMethodString(_)).join("\t\n")
			+ options.filter.fn(_.name.startsWith("CodeMirror.")).map.fn(toExternMethodString(_, "static")).join("\t\n")
			+ "}\n"
		);
		
		Log.finishSuccess();
	}
	
	static function toExternMethodString(m:Method, prefix="") : String
	{
		return Comments.makeComment(m.desc)
			 + "\t" + (prefix != "" ? prefix + " " : "")
			 + "function " + m.name.split(".")[1] + "(" + Params.toString(m.params) + ") : " + m.retType.name + ";\n";
	}
}