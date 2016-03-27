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
	}
	
	static function processEvents(jsonFile:String, destDir:String)
	{
		var doc = new HtmlDocument("<root>" + jsonToHtml(jsonFile) + "</root>");
		
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
}