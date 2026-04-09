package org.generator

import java.io.File
import java.io.BufferedReader
import java.io.InputStreamReader
import java.util.concurrent.TimeUnit
import java.io.FileReader
import org.eclipse.xtext.generator.IFileSystemAccess2
import java.io.PrintWriter

class ExecutionEngine {
	def static void main(String[] args) {
		ConfigurationManager.loadFixedConfig
		//testPDFcreation
		testPDFcreationFromCharSequence
	}
	
	def static void testPDFcreationFromCharSequence(){
		GVexecuteCommand(exampleGraph,"C:/temp/outputgraph.pdf")
	}
	
	def static CharSequence exampleGraph ()
	'''
	graph {
	    a -- b;
	    b -- c;
	    a -- c;
	    d -- c;
	    e -- c;
	    e -- a;
	}'''
	
	def static void testPDFcreation(){
		ConfigurationManager.loadFixedConfig
		var out=executeCommand ("f:\\inpath\\dot.exe -Tpdf -oF:\\Aeclipse\\workspace\\aDSL\\runtime-EclipseXtext\\AgriDSL\\src-gen\\testOperationSpaceEval20171112.AgriDSL\\_Ferrari_Ferrari2_\\graph2.pdf F:\\Aeclipse\\workspace\\aDSL\\runtime-EclipseXtext\\AgriDSL\\src-gen\\testOperationSpaceEval20171112.AgriDSL\\_Ferrari_Ferrari2_\\graph.txt")
		System.out.println(out.key+" "+out.value)
		
		var out2=executeCommand ("f:/inpath/dot.exe -Tpdf -oF:/Aeclipse/workspace/aDSL/runtime-EclipseXtext/AgriDSL/src-gen/testOperationSpaceEval20171112.AgriDSL/_Ferrari_Ferrari2_/graph1.pdf F:/Aeclipse/workspace/aDSL/runtime-EclipseXtext/AgriDSL/src-gen/testOperationSpaceEval20171112.AgriDSL/_Ferrari_Ferrari2_/graph.txt")
		System.out.println(out2.key+" "+out2.value)
		
		var out3=executeCommand ("f:/inpath/dot.exe -Tpdf -oF:\\Aeclipse\\workspace\\aDSL\\runtime-EclipseXtext\\AgriDSL\\src-gen\\testOperationSpaceEval20171112.AgriDSL\\_Ferrari_Ferrari2_\\graph3.pdf F:\\Aeclipse\\workspace\\aDSL\\runtime-EclipseXtext\\AgriDSL\\src-gen\\testOperationSpaceEval20171112.AgriDSL\\_Ferrari_Ferrari2_\\graph.txt")
		System.out.println(out3.key+" "+out3.value)
		
		var out4=executeCommand ("f:/inpath/dot.exe -Tpdf -otestOperationSpaceEval20171112.AgriDSL\\_Ferrari_Ferrari2_\\graph3.pdf testOperationSpaceEval20171112.AgriDSL\\_Ferrari_Ferrari2_\\graph.txt")
		System.out.println(out4.key+" "+out4.value)	
		
		var out5=UMLexecuteCommand("F:\\Aeclipse\\plant\\samplePlant.txt")
		System.out.println(out5.key+" "+out5.value)			
	}

	// Stores the source and executes GNUplot
	def static Pair<String,Integer> GNUplotExecuteCommand (CharSequence inputseq, String outputfileSource){ // inputseq contains the outputfile and outputformat
		FileOperations.generateFile(outputfileSource,inputseq)
		return GNUplotExecuteCommand(inputseq)
	}

	def static Pair<String,Integer> GNUplotExecuteCommand (CharSequence inputseq){ // inputseq contains the outputfile and outputformat
		var tempfileName = ConfigurationManager.lookupValue("tempgnuplotfile")
		var gnuplotPath  = ConfigurationManager.lookupValue("gnuplotpath")
		FileOperations.generateFile(tempfileName,inputseq)
		return executeCommand(gnuplotPath + " " + tempfileName)
	}

	def static Pair<String,Integer> GVexecuteCommand(CharSequence inputseq, String outputfile){ // plots a GraphViz specification (from charseq) to a PDF plot
		var tempfileName2 = ConfigurationManager.lookupValue("tempFile2")
		FileOperations.generateFile(tempfileName2,inputseq)
		return GVexecuteCommand(tempfileName2,outputfile)
	} 
	
	def static Pair<String,Integer> GVexecuteCommand(String inputfile, String outputfile){ // plots a GraphViz specification (from file) to a PDF plot
		var graphvizPath=   	ConfigurationManager.lookupValue("graphvizPath")
		return executeCommand(graphvizPath+" -Tpdf -o"+outputfile+" "+inputfile)	
	}
	
	def static Pair<String,Integer> UMLexecuteCommand(String inputfile){ // plots a PlantUML specification to a SVG plot. Outputfile is inputfile with .svg extension
		// java -jar plant.jar -tsvg seqdiagram.txt
		var javapathUMLplant=   ConfigurationManager.lookupValue("javapathUMLplant")
		var plantJar=   		ConfigurationManager.lookupValue("plantJar")
		var commandPNG=javapathUMLplant+" -jar "+plantJar+" -tpng "+inputfile
		var commandSVG=javapathUMLplant+" -jar "+plantJar+" -tsvg "+inputfile
		executeCommand(commandPNG)
		System.out.println(commandSVG)		
		return executeCommand(commandSVG)
	}
	
	def static Pair<String,Integer> executeCommand(String command){ // returns the output string and exit value
		var Runtime r=		Runtime.runtime
		var windowsCmd=		ConfigurationManager.lookupValue("windowsCommand")
		var windowsCmdC=	ConfigurationManager.lookupValue("windowsCommandC")
		var environment=	ConfigurationManager.lookupValue("environment")
		var javaExecEngine= ConfigurationManager.lookupValue("javaExecEngine")
		var tempfile=		ConfigurationManager.lookupValue("tempFile")
		
		if(javaExecEngine=="process"){
			var outputStr=""
			var Process p=r.exec(windowsCmdC+command, null, new File(environment))
			p.waitFor
			var BufferedReader output = getOutput(p)
			var String line
			while ((line = output.readLine()) != null) 
    			outputStr=outputStr+line
			return outputStr->p.exitValue
		}
		else{ // environment==processBuilder
			var ProcessBuilder builder = new ProcessBuilder(windowsCmd, "/c", command, ">"+tempfile)
	        var Process p = builder.start
	        p.waitFor
			var outputStr=readFile(tempfile)
            return outputStr->p.exitValue	 	
		}	
	}
	
	def private static BufferedReader getOutput(Process p) {
	    return new BufferedReader(new InputStreamReader(p.getInputStream))
	}
	
	def private static String readFile(String file) {
	    var BufferedReader reader = new BufferedReader(new FileReader (file));
	    var String         line = null;
	    var StringBuilder  stringBuilder = new StringBuilder();
	    var String         ls = System.getProperty("line.separator");
	
	    try {
	        while((line = reader.readLine()) != null) {
	            stringBuilder.append(line);
	            stringBuilder.append(ls);
	        }
	        return stringBuilder.toString();
	    } finally {
	        reader.close();
    }
}
		


}