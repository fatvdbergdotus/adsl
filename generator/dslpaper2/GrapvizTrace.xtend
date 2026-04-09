package org.generator.dslpaper2

import org.generator.ExecutionEngine
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.JavaIoFileSystemAccess
import java.io.PrintWriter
import java.io.BufferedWriter
import java.io.FileWriter
import org.generator.ConfigurationManager
import org.agriDSL.ConfigKeyValue
import java.util.ArrayList
import java.util.List
import org.agriDSL.Requirement
import org.agriDSL.RequirementTrace
import org.agriDSL.impl.AgriDSLFactoryImpl
import org.generator.CreateLangConstructs
import java.util.Set
import java.util.HashSet

class GraphvizTrace {
	def static void main(String[] args) {
	}
	
	def static writeTraceGraphsToDisc (IFileSystemAccess2 fsa, String filenameTXT, String filenamePDF, List<Requirement> reqs, List<RequirementTrace> reqTraces){
		if(ConfigurationManager.lookupValue("generateRequirementEngineAllTraces").equals("yes"))
			writeAllEncompassingTraceGraphToDisc(fsa,filenameTXT,filenamePDF,reqs,reqTraces)
			
		if(ConfigurationManager.lookupValue("generateRequirementEngineIndividualTraces").equals("yes"))
			for(r:uniqueRequirements(reqTraces))
				writeIndividualTraceGraphToDisc(fsa,filenameTXT,filenamePDF,reqs,reqTraces,r)
	}
	
	// writes the requirements trace that encompasses all requirements to disc
	def static writeAllEncompassingTraceGraphToDisc (IFileSystemAccess2 fsa, String filenameTXT, String filenamePDF, List<Requirement> reqs, List<RequirementTrace> reqTraces){
		var CharSequence tgraph = traceGraph(reqs,reqTraces,traceAllToString(reqTraces),null)
		fsa.generateFile(filenameTXT+".dat",tgraph)
		ExecutionEngine.GVexecuteCommand(tgraph,filenamePDF+".pdf")
	}
	
	// writes the requirements trace beloging to requirement r to disc
	def static writeIndividualTraceGraphToDisc (IFileSystemAccess2 fsa, String filenameTXT, String filenamePDF, List<Requirement> reqs, List<RequirementTrace> reqTraces, Requirement r){
		var CharSequence tgraph = traceGraph(reqs,reqTraces,traceSubsetToString(reqTraces,r),r)
		fsa.generateFile(filenameTXT+"_"+r.name+".dat",tgraph)
		ExecutionEngine.GVexecuteCommand(tgraph,filenamePDF+"_"+r.name+".pdf")		
	}
	
	// returns the requirement names in string format that are in some way related to requirement r
	def static List<String> traceSubsetToString (List<RequirementTrace> rts, Requirement r){
		var ret = new ArrayList<String>
		for(rt:traceSubset (rts,r)){
			if(rt.req1!=null && !rt.req1.empty) // making sure req1 exists
				ret.add(rt.req1.head.name)
			ret.add(rt.req2.head.name)
		}
		return ret
	}
	
	// returns all the requirement names in string format
	def static List<String> traceAllToString (List<RequirementTrace> rts){
		var ret = new HashSet<String>
		for(rt:rts){
			if(rt.req1!=null && !rt.req1.empty) // making sure req1 exists
				ret.add(rt.req1.head.name)
			ret.add(rt.req2.head.name)
		}
		return ret.toList
	}
	
	// determines the subset of requirement traces that are in some way related to requirement r
	def static List<RequirementTrace> traceSubset (List<RequirementTrace> rts, Requirement r){
		var ret = new HashSet<RequirementTrace>
		for(rt:rts){
			if(traceLeadsTo(rts,rt.req2.head,r)) // the tree structure above Requirement r
				ret.add(rt)
			ret.addAll(pathToEnd(rts,r)) // the straight path from Requirement r to its final requirement
		}
		return ret.toList
	}
	
	def static List<RequirementTrace> pathToEnd (List<RequirementTrace> rts, Requirement r){
		var ret = new ArrayList<RequirementTrace>
		for(rt:rts)
			if(rt.req1!==null && !rt.req1.empty && rt.req1.head.name==r.name){
				ret.add(rt)
				ret.addAll(pathToEnd(rts,rt.req2.head))
			}
		return ret
	}
	
	// are requirement r1 and r2 connected via a trace in rts?
	def static boolean traceLeadsTo (List<RequirementTrace> rts, Requirement r1, Requirement r2){
		for(rt:rts) // direct connection / base case
			if(rt.req1!==null && !rt.req1.empty && rt.req1.head.name==r1.name && rt.req2.head.name==r2.name)
				return true
		// recursion: does r1 lead to r2 in 2 or more steps?
		for(rt:rts)
			if(rt.req1!==null && !rt.req1.empty && rt.req1.head.name==r1.name && traceLeadsTo(rts,rt.req2.head,r2))
				return true
		// no pro-example found
		return false
	}
	
	def static List<Requirement> uniqueRequirements (List<RequirementTrace> reqTraces){
		var Set<Requirement> ret = new HashSet<Requirement>
		for(rt:reqTraces){
			if(rt.req1!==null && !rt.req1.empty)
				ret.add(rt.req1.head)
			ret.add(rt.req2.head)
		}
		return ret.toList
	}
	
	// merges the reqs into the reqtraces
	def static CharSequence traceGraph (List<Requirement> reqs, List<RequirementTrace> reqTraces, List<String> subsetRequirements, Requirement _r){
		var mergedTraces = new ArrayList<RequirementTrace>
		for(r:reqs){
			var trace = AgriDSLFactoryImpl::init.createRequirementTrace
			//trace.req1 // purposely, since the requirement does not have a predessesor
			trace.req2.add(CreateLangConstructs.clone(r))
			trace.timestamp=0 
			mergedTraces.add(trace)
		}
		mergedTraces.addAll(reqTraces)
		return traceGraph(mergedTraces,subsetRequirements,_r)
	}
	
	def static CharSequence traceGraph (List<RequirementTrace> reqTraces, List<String> subsetRequirements, Requirement r){
		var Requirement _r
		if(r!=null)
			_r=r
		else
			_r=CreateLangConstructs.createRequirement ("","dummyNameThatWillNeverBeUsed", null,null)
	'''
	digraph G {
	«FOR time:1..maxTimeStamp(reqTraces)»
		«IF returnTimeStamp(reqTraces,time).length>0»
			subgraph cluster_time_«time» {
				«FOR rt:returnTimeStamp(reqTraces,time)»
				«IF subsetRequirements.contains(rt.req2.head.name)»«rt.req2.head.name»«IF rt.req2.head.name==_r.name»[style=filled,color=green,fontcolor=white]«ENDIF»;«ENDIF»
				«ENDFOR»
				label = "time=«time»";
				color=blue
			}
			
			«FOR rt:returnTimeStamp(reqTraces,time)»«IF !rt.req1.empty»«IF rt.req1.head.name!=rt.req2.head.name»
				«IF subsetRequirements.contains(rt.req1.head.name) || subsetRequirements.contains(rt.req2.head.name)»
				«rt.req1.head.name» -> «rt.req2.head.name»;«ENDIF»
			«ENDIF»«ENDIF»«ENDFOR»
		«ENDIF»
	«ENDFOR»
	
		subgraph cluster_time_1 {
		«FOR rt:reqTraces»«IF rt.req1.empty»
			«IF subsetRequirements.contains(rt.req2.head.name)»«rt.req2.head.name»«IF rt.req2.head.name==_r.name»[style=filled,color=green,fontcolor=white]«ELSE»[style=filled,color=red,fontcolor=white]«ENDIF»;«ENDIF»
		«ENDIF»«ENDFOR»
			label = "time=1";
			color=blue
		}
		
		subgraph cluster_time_«maxTimeStamp(reqTraces)+1» {
			«FOR rt:reqTraces»«IF finalReq(rt.req2.head,reqTraces)»
			«IF subsetRequirements.contains(rt.req2.head.name)»«rt.req2.head.name»«IF rt.req2.head.name==_r.name»[style=filled,color=green,fontcolor=white]«ELSE»[style=filled,color=blue,fontcolor=white]«ENDIF»;«ENDIF»
			«ENDIF»«ENDFOR»
			label = "time=«maxTimeStamp(reqTraces)+1»";
			color=blue
		}
	}
	'''}
	
	// returns true when requirement r is a final requirement w.r.t. reqTraces
	def static boolean finalReq(Requirement r, List<RequirementTrace> reqTraces){
		for(rt:reqTraces)
			if(rt.req1!==null && !rt.req1.empty && rt.req1.head.name==r.name)
				return false
		return true
	}
	
	// determines the maximum timestamp value
	def static int maxTimeStamp(List<RequirementTrace> reqTraces){
		var int ret=0
		for(rt:reqTraces)
			if(rt.timestamp>ret)
				ret=rt.timestamp
		return ret
	}
	
	// determins whether there is activity for a certain timestampvalue
	def static List<RequirementTrace> returnTimeStamp(List<RequirementTrace> reqTraces, int timestampvalue){
		var ret=new ArrayList<RequirementTrace>
		for(rt:reqTraces)
			if(rt.timestamp==timestampvalue)
				ret.add(rt)
		return ret
	}
}