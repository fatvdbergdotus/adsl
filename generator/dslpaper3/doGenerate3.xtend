package org.generator.dslpaper3

import org.eclipse.xtext.generator.IFileSystemAccess2
import org.agriDSL.Model
import org.eclipse.emf.ecore.resource.Resource
import org.agriDSL.MeasurementSimulateToObtainVariousMeasures
import org.generator.CreateLangConstructs
import org.agriDSL.Part
import org.agriDSL.DesignSpace
import org.agriDSL.aSystem
import org.generator.AgriDSLGenerator
import org.generator.ConfigurationManager
import org.agriDSL.FeedbackLoop
import java.util.ArrayList
import java.util.List

class doGenerate3 {
	def static doGenerate(IFileSystemAccess2 fsa, Resource resource, MeasurementSimulateToObtainVariousMeasures measure){
		System.out.println("START doGenerate3")
	
		var postpath = "\\dslpaper3\\"
		var prepath  = ConfigurationManager.lookupValue("prepathversion2")
		var fsapath  = resource.getURI().lastSegment + postpath + "\\" // the FSA automatically includes the prepath
		var path     = prepath + fsapath	
		
		var model      = resource.allContents.toIterable.filter(typeof(Model)).toList.head
		var fls 	   = model.eAllContents.toIterable.filter(typeof(FeedbackLoop)).toList
		var mainSystem = resource.allContents.toIterable.filter(typeof(aSystem)).toList.head
		var ss   	   = model.eAllContents.toIterable.filter(typeof(aSystem)).toList
		var ps         = model.eAllContents.toIterable.filter(typeof(Part)).toList
		var dspace     = resource.allContents.toIterable.filter(typeof(DesignSpace)).head
		var dsm 	   = AgriDSLGenerator.designSpaceDimensionNames(dspace)
		var simRuns    = measure.runs
		var simLength  = measure.length
		
		var GraphSettings gs=new GraphSettings(true,true,true,true,true,true)
		
		ResolveSyntacticSugar.resolve(model)
		ResolveSyntacticSugar.copyScenarioToFeedbackloops(model)
		
		var firstdsi=CreateLangConstructs.returnDesignInstances(dspace).head
		
		if(ConfigurationManager.lookupValue("runFirstDSIonly3").equals("yes"))
			createGraphViz.storeAndExecuteGraphVizs(fsa,fsapath,path,AgriDSLGenerator.DSItoText(firstdsi)+"/model",mainSystem,dsm,firstdsi,ss,ps,gs,fls)
		else
			for(dsi:CreateLangConstructs.returnDesignInstances(dspace))
				createGraphViz.storeAndExecuteGraphVizs(fsa,fsapath,path,AgriDSLGenerator.DSItoText(dsi)+"/model",mainSystem,dsm,dsi,ss,ps,gs,fls)	
		
	
		System.out.println("STOP doGenerate3")
	}
}