package org.generator

import org.agriDSL.Configuration
import java.util.Map
import java.util.HashMap
import org.agriDSL.ConfigKeyValue
import java.util.List

import java.util.List
import java.util.ArrayList

class ConfigurationManager {
	var static Map<String,String> configuration = new HashMap<String,String> // for storing all config entries to be retrieved
	var static boolean firstRun=true
	
	def static loadConfg(){ 											 // no DSL input provided
		loadConfg(new ArrayList<ConfigKeyValue>)
	}
	
	def static loadConfg(List<ConfigKeyValue> ckvs){					 // used by generator to put the DSL-dependent config here
		if(firstRun){
			loadFixedConfig()
			firstRun=false
		}
		for (ckv:ckvs)		// The DSL config overrides the fixed config, if applicable.
			configuration.put(ckv.key,ckv.value)
	}
	
	// Example usage:  if(ConfigurationManager.lookupValue("runFirstDSIonly3").equals("yes")){ .................. }
	
	def static loadFixedConfig(){											 		// used by the generator to put the fixed config here
		configuration.put("runFirstDSIonly3","yes")									// only the first design instance is evaluated for doGenerate3
		//configuration.put("runFirstDSIonly3","no")								// all design instances are evaluated for doGenerate3
		configuration.put("gnuplotpath","F:\\inpath\\gnuplot\\bin\\gnuplot.exe")	// temporary file to store gnuplot sources in
		configuration.put("tempgnuplotfile","C:\\temp\\gnuplot.xxx")				// temporary file to store gnuplot sources in
		configuration.put("displayRandomGenerations","yes")							// display numbers that are generated with the random number (RandomOrg) generator
		configuration.put("tempFile","C:\\temp\\agridsl.xxx")						// temporarily file used to store results
		configuration.put("tempFile2","C:\\temp\\agridsl2.xxx")						// second temporarily file used to store results
		configuration.put("windowsCommandC","C:\\Windows\\System32\\cmd.exe /c ")	// the windows command call
		configuration.put("windowsCommand","C:\\Windows\\System32\\cmd.exe ") 		// the windows command call
		configuration.put("environment","f:\\inpath\\")								// environment in which windowsCommand calls are run
		//configuration.put("javaExecEngine","process")								// execution engine used to perform command external to Java
		configuration.put("javaExecEngine","processBuilder")						// execution engine used to perform command external to Java (generally used by iDSL)
		configuration.put("graphvizPath","f:\\inpath\\dot.exe ")					// path to graphviz engine
		configuration.put("javapathUMLplant","C:\\ProgramData\\Oracle\\Java\\javapath\\java.exe") // path to Java that is used for PlantUML
		configuration.put("plantJar","F:\\inpath\\plantuml\\plant.jar")				// the full path of the UMLplant library
		//configuration.put("prepath","F:\\Aeclipse\\workspace\\aDSL\\runtime-EclipseXtext\\AgriDSL\\src-gen\\")  // prepath to DSL files
		configuration.put("prepath","F:\\Aeclipse\\workspace\\aDSL\\runtime-EclipseXtext\\aDSL\\src-gen\\")
		configuration.put("prepathversion2","F:\\Aeclipse\\aDSL\\runtime-EclipseXtext\\aDSL\\src-gen\\")
		configuration.put("postpath","")
		//configuration.put("numitemslevel3feedback","10")							// number of items to show at level 3 feedback
		configuration.put("generateblackandwhitegraphs","no")						// are black-and-white graphs generated during evaluation? if not, much time is saved.
		configuration.put("generateUMLsequencediagram","yes")						// are UML sequence diagrams generated?
		configuration.put("generateRequirementEngineIndividualTraces","yes")		// are traces for each individual requirement generated of the requirement engine?
		configuration.put("generateRequirementEngineAllTraces","yes")				// are traces for all requirements at once generated of the requirement engine?
		configuration.put("generateRequirementEngineOverallLog","yes")				// generate a single log file containing all iterations?
		configuration.put("generateRequirementEngineIterationLog","yes")			// generate a log file per iteration?
		configuration.put("randomGeneratorFile","F:/Aeclipse/adsl_random_input.txt")  // file with 1.5 million random integers between 0 and 100 from RANDOM.org
		//configuration.put("generatemanyrequirements","1")							// use minus 1 for generating many requirments from few requirements
		configuration.put("generatemanyrequirements","2")							// use minus 2 for generating many requirments from few requirements
	}
	
	// ConfigurationManager.lookupValue(key)	
	def static lookupValue (String key){
		var configValue = configuration.get(key)
		if(configValue!=null)
			return configValue
		else
			throw new Throwable("key "+key+" not found in Configuration")
	}
}