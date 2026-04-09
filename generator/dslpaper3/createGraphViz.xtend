package org.generator.dslpaper3

import java.util.List
import org.agriDSL.Part
import org.agriDSL.aSystem
import org.agriDSL.DesAlternative
import org.agriDSL.SystemID
import org.agriDSL.PartID
import org.agriDSL.SystemOrPart
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.generator.ExecutionEngine
import java.util.Set
import java.util.HashSet
import org.agriDSL.DefaultSystemExtension
import org.agriDSL.SystemAndPartExtension
import org.agriDSL.impl.AgriDSLFactoryImpl
import org.generator.LangConstructsToString
import org.agriDSL.FeedbackLoop
import java.util.ArrayList
import org.generator.CreateLangConstructs
import org.agriDSL.Distribution
import org.agriDSL.AExp

class createGraphViz {
	def static CPSGraphElements CPSGE_details_loops (List<FeedbackLoop> fls, aSystem mainSystem, List<aSystem> ss, List<Part> ps, List<String> dsm, List<String> dsi) 
		{ return new CPSGraphElements(true,true,fls,mainSystem,ss,ps,dsm,dsi) }
	def static CPSGraphElements CPSGE_details_noloops (List<FeedbackLoop> fls, aSystem mainSystem, List<aSystem> ss, List<Part> ps, List<String> dsm, List<String> dsi) 
		{ return new CPSGraphElements(true,false,fls,mainSystem,ss,ps,dsm,dsi) }
	def static CPSGraphElements CPSGE_nodetails_loops (List<FeedbackLoop> fls, aSystem mainSystem, List<aSystem> ss, List<Part> ps, List<String> dsm, List<String> dsi) 
		{ return new CPSGraphElements(false,true,fls,mainSystem,ss,ps,dsm,dsi) }			
	def static CPSGraphElements CPSGE_nodetails_noloops (List<FeedbackLoop> fls, aSystem mainSystem, List<aSystem> ss, List<Part> ps, List<String> dsm, List<String> dsi) 
		{ return new CPSGraphElements(false,false,fls,mainSystem,ss,ps,dsm,dsi) }
	
	
	
	def static void storeAndExecuteGraphVizs (IFileSystemAccess2 fsa2, String fsapath, String path, String pathextension, 
											  aSystem mainSystem, List<String> dsm, List<String> dsi, 
											  List<aSystem> ss, List<Part> ps, GraphSettings gs, List<FeedbackLoop> fls){
		// graph without feedback loops
		var List<FeedbackLoop> flempty=new ArrayList<FeedbackLoop>		
		storeAndExecuteGraphViz  (CPSGE_details_loops(flempty,mainSystem,ss,ps,dsm,dsi),"gviz-nofbloops-details-fbloopsonly-showregconnns", fsa2, fsapath, path, pathextension, gs, true)
		storeAndExecuteGraphViz  (CPSGE_details_noloops(flempty,mainSystem,ss,ps,dsm,dsi),"gviz-nofbloops-details-allnodes-showregconnns", fsa2, fsapath, path, pathextension, gs, true)
		storeAndExecuteGraphViz  (CPSGE_nodetails_loops(flempty,mainSystem,ss,ps,dsm,dsi),"gviz-nofbloops-nodetails-fbloopsonly-showregconnns", fsa2, fsapath, path, pathextension, gs, true)
		storeAndExecuteGraphViz  (CPSGE_nodetails_noloops(flempty,mainSystem,ss,ps,dsm,dsi),"gviz-nofbloops-nodetails-allnodes-showregconnns", fsa2, fsapath, path, pathextension, gs, true)
		storeAndExecuteGraphViz  (CPSGE_details_loops(flempty,mainSystem,ss,ps,dsm,dsi),"gviz-nofbloops-details-fbloopsonly-hideregconnns", fsa2, fsapath, path, pathextension, gs, false)
		storeAndExecuteGraphViz  (CPSGE_details_noloops(flempty,mainSystem,ss,ps,dsm,dsi),"gviz-nofbloops-details-allnodes-hideregconnns", fsa2, fsapath, path, pathextension, gs, false)
		storeAndExecuteGraphViz  (CPSGE_nodetails_loops(flempty,mainSystem,ss,ps,dsm,dsi),"gviz-nofbloops-nodetails-fbloopsonly-hideregconnns", fsa2, fsapath, path, pathextension, gs, false)
		storeAndExecuteGraphViz  (CPSGE_nodetails_noloops(flempty,mainSystem,ss,ps,dsm,dsi),"gviz-nofbloops-nodetails-allnodes-hideregconnns", fsa2, fsapath, path, pathextension, gs, false)
		
		// graphs with one feedback loop each
		for(fl:fls){
			var flist = new ArrayList<FeedbackLoop>
			flist.add(fl)
			storeAndExecuteGraphViz (CPSGE_details_loops(flist,mainSystem,ss,ps,dsm,dsi),"gviz-"+fl.name+"-details-fbloopsonly-showregconnns", fsa2, fsapath, path, pathextension, gs, true)
			storeAndExecuteGraphViz (CPSGE_details_noloops(flist,mainSystem,ss,ps,dsm,dsi),"gviz-"+fl.name+"-details-allnodes-showregconnns", fsa2, fsapath, path, pathextension, gs, true)
			storeAndExecuteGraphViz (CPSGE_nodetails_loops(flist,mainSystem,ss,ps,dsm,dsi),"gviz-"+fl.name+"-nodetails-fbloopsonly-showregconnns", fsa2, fsapath, path, pathextension, gs, true)
			storeAndExecuteGraphViz (CPSGE_nodetails_noloops(flist,mainSystem,ss,ps,dsm,dsi),"gviz-"+fl.name+"-nodetails-allnodes-showregconnns", fsa2, fsapath, path, pathextension, gs, true)
			storeAndExecuteGraphViz (CPSGE_details_loops(flist,mainSystem,ss,ps,dsm,dsi),"gviz-"+fl.name+"-details-fbloopsonly-hideregconnns", fsa2, fsapath, path, pathextension, gs, false)
			storeAndExecuteGraphViz (CPSGE_details_noloops(flist,mainSystem,ss,ps,dsm,dsi),"gviz-"+fl.name+"-details-allnodes-hideregconnns", fsa2, fsapath, path, pathextension, gs, false)
			storeAndExecuteGraphViz (CPSGE_nodetails_loops(flist,mainSystem,ss,ps,dsm,dsi),"gviz-"+fl.name+"-nodetails-fbloopsonly-hideregconnns", fsa2, fsapath, path, pathextension, gs, false)
			storeAndExecuteGraphViz (CPSGE_nodetails_noloops(flist,mainSystem,ss,ps,dsm,dsi),"gviz-"+fl.name+"-nodetails-allnodes-hideregconnns", fsa2, fsapath, path, pathextension, gs, false)
		}
		
		// graph with all feedback loops
		var flistAll = new ArrayList<FeedbackLoop>
		for(fl:fls)
			flistAll.add(CreateLangConstructs.clone(fl))
		storeAndExecuteGraphViz  (CPSGE_details_loops(flistAll,mainSystem,ss,ps,dsm,dsi),"gviz-allfbloops-details-fbloopsonly-showregconnns", fsa2, fsapath, path, pathextension, gs, true)						  	
		storeAndExecuteGraphViz  (CPSGE_details_noloops(flistAll,mainSystem,ss,ps,dsm,dsi),"gviz-allfbloops-details-allnodes-showregconnns", fsa2, fsapath, path, pathextension, gs, true)
		storeAndExecuteGraphViz  (CPSGE_nodetails_loops(flistAll,mainSystem,ss,ps,dsm,dsi),"gviz-allfbloops-npdetails-fbloopsonly-showregconnns", fsa2, fsapath, path, pathextension, gs, true)						  	
		storeAndExecuteGraphViz  (CPSGE_nodetails_noloops(flistAll,mainSystem,ss,ps,dsm,dsi),"gviz-allfbloops-nodetails-allnodes-showregconnns", fsa2, fsapath, path, pathextension, gs, true)
		storeAndExecuteGraphViz  (CPSGE_details_loops(flistAll,mainSystem,ss,ps,dsm,dsi),"gviz-allfbloops-details-fbloopsonly-hideregconnns", fsa2, fsapath, path, pathextension, gs, false)						  	
		storeAndExecuteGraphViz  (CPSGE_details_noloops(flistAll,mainSystem,ss,ps,dsm,dsi),"gviz-allfbloops-details-allnodes-hideregconnns", fsa2, fsapath, path, pathextension, gs, false)
		storeAndExecuteGraphViz  (CPSGE_nodetails_loops(flistAll,mainSystem,ss,ps,dsm,dsi),"gviz-allfbloops-npdetails-fbloopsonly-hideregconnns", fsa2, fsapath, path, pathextension, gs, false)						  	
		storeAndExecuteGraphViz  (CPSGE_nodetails_noloops(flistAll,mainSystem,ss,ps,dsm,dsi),"gviz-allfbloops-nodetails-allnodes-hideregconnns", fsa2, fsapath, path, pathextension, gs, false)
	}

	// 	//new (boolean showdetails, boolean showonlyfeedbackloops, List<FeedbackLoop> fls, aSystem mainSystem, List<aSystem> ss, 
    //		 List<Part> ps, List<String> dsm, List<String> dsi) // CPSGraphElements
	
	def static void storeAndExecuteGraphViz  (CPSGraphElements CPSGE, String filename, IFileSystemAccess2 fsa2, String fsapath, String path, String pathextension, 
											  GraphSettings gs, boolean showregularconns){
		var showdetails       = CPSGE.retShowdetails
		var showfbloopsonly   = CPSGE.retShowonlyfeedbackloops
		var mainSystem		  = CPSGE.retMainSystem		
		var fls				  = CPSGE.retFls
		var dsm				  = CPSGE.retDsm
		var dsi				  = CPSGE.retDsi
		var ss				  = CPSGE.retSs
		var ps				  = CPSGE.retPs
							  	
		var GZmodel           = createGraphVizMain(mainSystem,dsm,dsi,ss,ps,gs,fls,fsa2,fsapath,path,pathextension,showdetails,showfbloopsonly,showregularconns)
		var inputfilePath     = path + pathextension + "//"+filename+".dat"
		var outputfilePath 	  = path + pathextension + "//"+filename+".pdf"
		var inputfileFsaPath  = fsapath + pathextension + "//"+filename+".dat"
		var outputfileFsaPath = fsapath + pathextension + "//"+filename+".pdf"
		
		fsa2.generateFile(inputfileFsaPath,GZmodel)
		ExecutionEngine.GVexecuteCommand(inputfilePath,outputfilePath)
	}	
	
	def static List2String (List<String> ls) '''«FOR l:ls»«l»_«ENDFOR»'''
	
	def static List<String> connsToNodes(List<Pair<String,String>> conns){
		var Set<String> nodes = new HashSet<String>
		for(c:conns){
			nodes.add(c.key)
			nodes.add(c.value)
		}
		return nodes.toList
	}
	
	def static int numberOutputNodes (String node, List<Pair<String,String>> conns){
		var int count=0
		for(c:conns)
			if(c.key.equals(node))
				count=count+1
		return count
	}
	
	def static int outportNumber (Pair<String,String> conn, List<Pair<String,String>> conns){
		var int count=0
		for(c:conns){
			if(c.key==conn.key && c.value==conn.value) // found it
				return count
			if(c.key==conn.key) // next output port
				count=count+1
		}
	}
	
	//backtracking.generateFeedbackloop (FeedbackLoop fl, aSystem asystem, List<aSystem> ss, List<Part> ps, List<String> dsm, List<String> dsi){
	
	def static List<List<String>> generateFeedbackloops (List<FeedbackLoop> fls, aSystem mainSystem, List<aSystem> ss, List<Part> ps,
														 List<String> dsm, List<String> dsi){
		var ret=new ArrayList<List<String>>
		for(fl:fls){
			var genFL = backtracking.generateFeedbackloop (fl,mainSystem,ss,ps,dsm,dsi)
			if(genFL!=null)
				ret.add(genFL)
		}
		return ret
	}
	
	def static List<String> returnUntilDuplicate (List<String> list){
		// find the positions of the duplicates
		var int dubPosition=-1
		for(cnt:0..list.size-2)
			if(list.get(cnt)==list.get(cnt+1))
				dubPosition=cnt
		
		// add the elements up to the duplicates to the returned list
		var ret = new ArrayList<String>
		for(cnt:0..dubPosition)
			ret.add(list.get(cnt))
		return ret
	}
	
	def static List<String> floopsUp (List<List<String>> floops){
		var List<String> ret = new ArrayList<String>
		for(floop:floops)
			ret.addAll(returnUntilDuplicate(floop))
		return ret
	}
	
	def static List<String> floopsDown (List<List<String>> floops){
		var List<String> ret = new ArrayList<String>
		for(_floop:floops){
			var floop=new ArrayList<String>
			floop.addAll(_floop)
			ret.addAll(returnUntilDuplicate(floop.reverse))
		}
		return ret
	}
	
	// which of the conns has a fb loop going through?
	def static fbloopConns(List<Pair<String,String>> conns, List<String> fUpAndDown){
		var ret=new ArrayList<Pair<String,String>>
		for(conn:conns){
			if(fUpAndDown.contains(conn.key) && fUpAndDown.contains(conn.value)) // evidence of the connection in a fbloop
				ret.add(conn)
		}
		return ret		
	}
	
	// which of the nodes has a fb loop going through?
	def static fbloopNodes(List<String> nodes, List<String> fUpAndDown){
		var ret=new ArrayList<String>
	    for(node:nodes)
	    	if(fUpAndDown.contains(node)) // evidence of the node in a fbloop
	    		ret.add(node)
		return ret
	}
	
	def static CharSequence createGraphVizMain (aSystem mainSystem, List<String> dsm, List<String> dsi, 
											    List<aSystem> ss, List<Part> ps, GraphSettings gs, List<FeedbackLoop> fls,
											    IFileSystemAccess2 fsa2, String fsapath, String path, String pathextension, 
											    boolean showdetails, boolean showonlyfeedbackloops, boolean showregularconns){
		var List<List<String>> floops   = generateFeedbackloops(fls,mainSystem,ss,ps,dsm,dsi)
		var List<String> fUp   			= floopsUp(floops)
		var List<String> fDown 			= floopsDown(floops)
		var fUpAndDown = new ArrayList<String>
		fUpAndDown.addAll(fUp)
		fUpAndDown.addAll(fDown)
		var conns      = backtracking.generateConnections (mainSystem,ss,ps,dsm,dsi)
		var nodes      = connsToNodes(conns)
		
		if(showonlyfeedbackloops){ // take the subset of the conns and nodes that has a fbloop
			conns=fbloopConns(conns,fUpAndDown)
			nodes=fbloopNodes(nodes,fUpAndDown)
		}
	'''
		digraph {
			// regular connections
			«FOR c:conns»«IF c.key!=c.value»«c.key»:«c.key»_out_«outportNumber(c,conns)»->«c.value»:«c.value»_in_0 «IF !showregularconns»[color=grey88]«ENDIF»;«ENDIF»
			«ENDFOR»
			
			// feedback loop connections (in the system)
			«IF floops.size>0»«FOR floopcnt:0..floops.size-1»«var floop=floops.get(floopcnt)»«var boolean up=true»«FOR cnt:0..floop.size-2»
			«IF floop.get(cnt)!=floop.get(cnt+1)»«floop.get(cnt)»:feedbackport_«inOrOut(true,up)»->«floop.get(cnt+1)»:feedbackport_«inOrOut(false,up)» [label="«fls.get(floopcnt).name»"];«ELSE»/*«up=false»*/«ENDIF»
			«ENDFOR»«ENDFOR»«ENDIF»
			
			// feedback loop connections (outside the system, dotted line), latency node and scenario node 
			«IF floops.size>0»«FOR floopcnt:0..floops.size-1»«externalFeedbackLoop(floops,floops.get(floopcnt),fls.get(floopcnt),path,pathextension,dsm,dsi,showdetails)»
			«ENDFOR»«ENDIF»
			
			// nodes of the system
			«FOR n:nodes»«var boolean isPart=lookupPart(n,ps)!=null»
			«IF n==mainSystem.name»«graphvizNode (n,path,pathextension,isPart,0,numberOutputNodes(n,conns),false,fUp.contains(n),#[#[]],lookupSAPE(n,ss,ps),dsm,dsi,showdetails)»
			«ELSE»«graphvizNode (n,path,pathextension,isPart,1,numberOutputNodes(n,conns),fUpAndDown.contains(n),fUpAndDown.contains(n),#[#[]],lookupSAPE(n,ss,ps),dsm,dsi,showdetails)»
			«ENDIF»
			«ENDFOR»
		}
	'''}
	
	def static externalFeedbackLoop (List<List<String>> floops, List<String> floop, FeedbackLoop fls, String path, String pathextension,
									 List<String> dsm, List<String> dsi, boolean showdetails){ // 4 cases, with/without latency, with/without scenario
		var boolean latency  = !(fls.latency==null || fls.latency.empty)							 	
		var boolean scenario = !(fls.scen==null || fls.scen.empty)					 	
									 	
		'''
		«IF latency»«latencyNode(fls.name,fls.latency.head.d.head,path,pathextension,dsm,dsi,showdetails)»«ENDIF»
		
		«IF scenario»«scenarioNode(fls.name, fls.scen.head.timeOffset, fls.scen.head.timeInterval, fls.scen.head.load, dsm, dsi, showdetails)»«ENDIF»
		
		«IF latency && scenario»
			«floop.last»:«floop.last»_partout->latency_«fls.name» [label="«fls.name»", style=dashed];
			latency_«fls.name»->scenario_«fls.name» [label="«fls.name»", style=dashed];
			scenario_«fls.name»->«floop.head»:«floop.head»_partout [label="«fls.name»", style=dashed];	
		«ELSEIF latency && !scenario»
			«floop.last»:«floop.last»_partout->latency_«fls.name» [label="«fls.name»", style=dashed];
			latency_«fls.name»->«floop.head»:«floop.head»_partout [label="«fls.name»", style=dashed];
		«ELSEIF !latency && scenario»
			«floop.last»:«floop.last»_partout->scenario_«fls.name» [label="«fls.name»", style=dashed];
			scenario_«fls.name»->«floop.head»:«floop.head»_partout [label="«fls.name»", style=dashed];		
		«ELSEIF !latency && !scenario»
			«floop.last»:«floop.last»_partout->«floop.head»:«floop.head»_partout [label="«fls.name»", style=dashed];
		«ENDIF»
		'''					 	
	}
									 	
	def static latencyNode (String title, Distribution d, String path, String pathextension, List<String> dsm, List<String> dsi, boolean showdetails){
		var ds = new ArrayList<Distribution>
		ds.add(d)
		var dnames = new ArrayList<String>
		dnames.add("latency")
		var outputfilename=path+pathextension+"\\latency_"+title+".gnuplot"
		var gnuplot=createGNUplot.DistributionsToGNUplotCharSequence(ds, dnames, outputfilename, dsm, dsi, "png")
		ExecutionEngine.GNUplotExecuteCommand(gnuplot,outputfilename)
	
	'''latency_«title» [ fontsize=10 shape=plaintext label=< <table border='1' cellborder='0' bgcolor='#0000FF'> 
	   <tr><td><font color="white"><b>Latency of «title»</b></font></td></tr>
	   «IF showdetails»<tr><td>
			<table>
				<tr><td><img src="«outputfilename».png" /></td></tr>
			</table>
	   </td></tr>«ENDIF»
	   </table>>];
	'''}
		
	def static scenarioNode (String title, AExp aTimeOffset, AExp aTimeInterval, AExp load, List<String> dsm, List<String> dsi, boolean showdetails){
		var timeOffet = LangConstructsToString.aexpEvaluatedToString(aTimeOffset,dsm,dsi)
		var timeInterval = LangConstructsToString.aexpEvaluatedToString(aTimeOffset,dsm,dsi)
	'''scenario_«title» [ fontsize=10 shape=plaintext label=< <table border='1' cellborder='0' bgcolor='#0000FF'> 
		   <tr><td><font color="white"><b>Scenario of «title»</b></font></td></tr>
		   «IF showdetails»<tr><td>
				<table border='0' cellborder='0' bgcolor='#EEEEEE'>
					<tr><td>timeOffset: «timeOffet»</td></tr>
					<tr><td>TimeInterval: «timeInterval»</td></tr>
					<tr><td>Load: «LangConstructsToString.aexpEvaluatedToString(load,dsm,dsi)»</td></tr>
				</table>
		   </td></tr>«ENDIF»
		   </table>>];
	'''
	}

	
	def static inOrOut (boolean in, boolean up) '''«IF (up&&in) || (!up&&!in)»in«ELSE»out«ENDIF»'''

	def static aSystem lookupSystem(String id, List<aSystem> ss){
		for(s:ss)
			if(s.name==id)
				return s
		return null
	}

	def static Part lookupPart(String id, List<Part> ps){
		for(p:ps)
			if(p.name==id)
				return p
		return null
	}
	
	def static SystemAndPartExtension lookupSAPE (String id, List<aSystem> ss, List<Part> ps){
		var system=lookupSystem(id,ss)
		if(system!==null)
			return system.ext
		var part=lookupPart(id,ps)
		if(part!==null)
			return part.ext
	}

	def static CharSequence createGraphViz(SystemOrPart sop, List<String> dsm, List<String> dsi, List<aSystem> ss, List<Part> ps, GraphSettings gs){
		switch(sop){
			aSystem: 		return createGraphViz(sop,dsm,dsi,ss,ps,gs)
			Part: 	 		return createGraphViz(sop,dsm,dsi,ss,ps,gs)
			SystemID:		return createGraphViz(sop,dsm,dsi,ss,ps,gs)
			PartID:			return createGraphViz(sop,dsm,dsi,ss,ps,gs)
			DesAlternative: return createGraphViz(sop,dsm,dsi,ss,ps,gs)
		}
	}

	def static CharSequence createGraphViz (aSystem system, List<String> dsm, List<String> dsi, List<aSystem> ss, List<Part> ps, GraphSettings gs)'''
		// systemNode «system.name»
		«FOR sop:system.systemOrParts»
			«createGraphViz(sop,dsm,dsi,ss,ps,gs)»
		«ENDFOR»
	'''

	def static CharSequence createGraphViz (Part part, List<String> dsm, List<String> dsi, List<aSystem> ss, List<Part> ps, GraphSettings gs)'''
		// partNode «part.name»
	'''

	def static CharSequence createGraphViz (SystemID systemid, List<String> dsm, List<String> dsi, List<aSystem> ss, List<Part> ps, GraphSettings gs){
		var systemID = backtracking.lookupSystem(systemid,ss)
	'''
		// systemIDNode «systemid.name» to «systemid.systemID»
		«createGraphViz(systemID,dsm,dsi,ss,ps,gs)»
	'''}
	

	def static CharSequence createGraphViz (PartID partid, List<String> dsm, List<String> dsi, List<aSystem> ss, List<Part> ps, GraphSettings gs){
		var partID = backtracking.lookupPart(partid,ps)
	'''		
		// partIDNode «partid.name» to «partid.partID»
		«createGraphViz(partID,dsm,dsi,ss,ps,gs)»
	'''}
	
	def static CharSequence createGraphViz (DesAlternative desalt, List<String> dsm, List<String> dsi, List<aSystem> ss, List<Part> ps, GraphSettings gs){
		var dsivalue = backtracking.lookupValueForDimension(desalt.dsDimensionName.head,dsm,dsi)
		var CharSequence selectedAlt = ""

		for(ds:desalt.ds)
			if(ds.dsValue.head==dsivalue){
				selectedAlt=createGraphViz(ds.systemOrParts.head,dsm,dsi,ss,ps,gs)
			}
		'''
			// desaltNode «desalt.dsDimensionName.head» to «dsivalue» 
			«selectedAlt»
		'''
	}
	
	
	def static CharSequence distributionNode (String title, String filename){
	'''
		subgraph cluster_«title» {
			fbax [width=0.2, height=0.2, shape="box", image="«filename»"];
			label = "«title»";
		}
	'''} 

	def static CharSequence graphvizNode (String nodeName, String path, String pathextension, boolean isPart, int _inputPorts, int _outputPorts, 
							 boolean feedbackLoopIn, boolean feedbackLoopOut, List<List<String>> contents,
							 SystemAndPartExtension sape, List<String> dsm, List<String> dsi, boolean showdetails){
		var inputPorts=_inputPorts+booleanToNumber(feedbackLoopIn)
		var outputPorts=_outputPorts+booleanToNumber(feedbackLoopOut)
		if(_outputPorts==0)
			outputPorts=outputPorts+1
		if(_inputPorts==0)
			inputPorts=inputPorts+1		
		
		// create GNUplots containing toFailure and toRepair
		if(sape!=null){		
			var ds=new ArrayList<Distribution>
			ds.add(sape.fail.head.toFail.head)
			ds.add(sape.rep.head.toRepair.head)
			var dnames= new ArrayList<String>
			dnames.add("toFailure")
			dnames.add("toRepair")
			createGNUplot.DistributionsToGNUplot (ds, dnames, path+pathextension+"//toFailureAndRepart_"+nodeName+".gnuplot", dsm, dsi)
		}
		
		// create pi-chart GNUplots containing utilizations
		if(sape!=null && sape.util.head.red!=-1 /* default value */)		
			createGNUplot.PiechartGNUplot(sape.util.head.red,sape.util.head.orange,sape.util.head.green,sape.util.head.blue,sape.util.head.black,
										  path+pathextension+"//utilization_"+nodeName+".gnuplot"
			)
		
		
	'''
	 	«nodeName» [ fontsize=10 shape=plaintext label=< <table border='1' cellborder='0' bgcolor='#FF0000'> 

			   «IF _inputPorts>0 || feedbackLoopIn»
		  	   // top ports
			   <tr height='10'>
			   «FOR cnt:0..inputPorts-1»
				   <td port='«portNameIn(nodeName,feedbackLoopIn,cnt,inputPorts-1)»' colspan="«outputPorts»" width='«100/inputPorts»%' bgcolor="«portColor(feedbackLoopIn,cnt,inputPorts-1)»" border="1"></td>
			   «ENDFOR»
			   </tr>
			   «ENDIF»

			   // title
			   <tr><td port="«nodeName»_999" colspan="«inputPorts*outputPorts»"><font color="white"><b>«nodeName»</b></font></td></tr>

			   «IF sape!==null && showdetails»
			   // SystemAndPartExtension (AExp)
			   <tr><td colspan="«inputPorts*outputPorts»">
					<table border='0' cellborder='0' bgcolor='#EEEEEE'>
						<tr><td>PowerOn: «LangConstructsToString.aexpEvaluatedToString(sape.pon.head.powerOn.head,dsm,dsi)»</td></tr>
						<tr><td>PowerOff: «LangConstructsToString.aexpEvaluatedToString(sape.poff.head.powerOff.head,dsm,dsi)»</td></tr>
						<tr><td>ShutdownTime: «LangConstructsToString.aexpEvaluatedToString(sape.sdt.head.shutdownTime.head,dsm,dsi)»</td></tr>
						<tr><td>StartupTime: «LangConstructsToString.aexpEvaluatedToString(sape.sut.head.startupTime.head,dsm,dsi)»</td></tr>
						<tr><td>ShutdownPolicy: «LangConstructsToString.aexpEvaluatedToString(sape.pts.head.policyTimeShutdown.head,dsm,dsi)»</td></tr>
						<tr><td>NumberOfUnits: «LangConstructsToString.aexpEvaluatedToString(sape.numu.head.numunits.head,dsm,dsi)»</td></tr>
						<tr><td>CostPerUnit: «LangConstructsToString.aexpEvaluatedToString(sape.cost.head.cost.head,dsm,dsi)»</td></tr>
					</table>			   
			   </td></tr>
			   
			   // SystemAndPartExtension (Distributions)
			   <tr><td colspan="«inputPorts*outputPorts»">
					<table border='0' cellborder='0'>
						<tr><td><img src="«path»«pathextension»\toFailureAndRepart_«nodeName».gnuplot.png" /></td></tr>
					</table>
			   </td></tr>
				«ENDIF»
				
				«IF sape!=null && sape.util.head.red!=-1 && showdetails»
				// Results (Pie-chart)
			   <tr><td colspan="«inputPorts*outputPorts»">
					<table border='0' cellborder='0'>
						<tr><td><img src="«path»«pathextension»\utilization_«nodeName».gnuplot.png" /></td></tr>
					</table>
			   </td></tr>				
				«ENDIF»
				
			   «FOR content:contents»«IF !content.empty && showdetails»
			   // contents
			   <tr><td colspan="«inputPorts*outputPorts»">
					<table border='0' cellborder='0' bgcolor='#EEEEEE'>
						«FOR c:content»
						<tr><td>«c»</td></tr>
						«ENDFOR»
					</table>
			   </td></tr>

			   «ENDIF»«ENDFOR»
			   
			   «IF (_outputPorts>0 || feedbackLoopOut) && !isPart»
			   // bottom ports
			   <tr height='10'>
			   «FOR cnt:0..outputPorts-1»
					<td port='«portNameOut(nodeName,feedbackLoopOut,cnt,outputPorts-1)»' colspan="«inputPorts»" width='«100/outputPorts»%' bgcolor="«portColor(feedbackLoopOut,cnt,outputPorts-1)»" border="1"></td>
				«ENDFOR»
			   </tr>
			   «ENDIF»
			   
			   «IF isPart»
			   <tr height='1'><td port='«nodeName»_partout' colspan='«inputPorts*outputPorts»' width='100%'><font color="red"><b>a</b></font></td></tr>
			   «ENDIF»
		   </table>>];		
	
	'''}
	
	def static portColor (boolean feedbackLoop, int counter, int max) 
		'''«IF feedbackLoop && counter==max»#0000FF«ELSE»#00FF00«ENDIF»'''
		
	def static portNameIn (String nodeName, boolean feedbackLoop, int counter, int max)
		'''«IF feedbackLoop && counter==max»feedbackport_in«ELSE»«nodeName»_in_«counter»«ENDIF»'''

	def static portNameOut (String nodeName, boolean feedbackLoop, int counter, int max)
		'''«IF feedbackLoop && counter==max»feedbackport_out«ELSE»«nodeName»_out_«counter»«ENDIF»'''
	
	def static booleanToNumber (boolean b) { if(b) return 1 else return 0 }
	
	def static graphvizNodeContent (int ports, List<String> content)
	'''<tr><table>«FOR c:content»<tr><td>«c»</td></tr>
	«ENDFOR»'''

	def static CharSequence testCreateGraphVizMain (aSystem mainSystem, List<String> dsm, List<String> dsi, 
													List<aSystem> ss, List<Part> ps, GraphSettings gs)
	'''
		graph {
			a -- b;
			«testGraphvizNode1»
			
			«testGraphvizNode2»
			
			«testGraphvizNode3»
			
			«testGraphvizNode4»
		}
	'''
	
	def static testGraphvizNode1(){
		var content1 = #["ac1a","ac1b","c1c","c1d","c1e"]
		var content2 = #["c2a","c2b","c2c","c2d","c2e"]
		var contents = #[content1,content2]
		return graphvizNode("nodeName1","path1","pathextension1",false,4,3,true,true,contents,testSAPE,null,null,true)
	}

	def static testGraphvizNode2(){
		var content1 = #["c1a","c1b","c1c","c1d","c1e"]
		var content2 = #["c2a","c2b","c2c","c2d","c2e"]
		var contents = #[content1,content2,content1]
		return graphvizNode("nodeName2","path2","pathextension2",false,7,3,true,false,contents,testSAPE,null,null,true)
	}

	def static testGraphvizNode3(){
		var content1 = #["ac1a","ac1b","c1c","c1d","c1e"]
		var content2 = #["c2a","c2b","c2c","c2d","c2e"]
		var contents = #[content1,content2]
		return graphvizNode("nodeName3","path3","pathextension3",false,4,3,false,true,contents,testSAPE,null,null,true)
	}

	def static testGraphvizNode4(){
		var content1 = #["c1a","c1b","c1c","c1d","c1e"]
		var content2 = #["c2a","c2b","c2c","c2d","c2e"]
		var contents = #[content1,content2,content1]
		return graphvizNode("nodeName4","path4","pathextension4",false,7,3,false,false,contents,testSAPE,null,null,true)
	}
	
	def static SystemAndPartExtension testSAPE(){
		var ret=AgriDSLFactoryImpl::init.createSystemAndPartExtension
		return ret
	}
	
	def static workingExampleGraph()'''
	graph {
	 	nodeName [ shape=plaintext label=< <table border='1' cellborder='0' bgcolor='#FF0000'> 
		  // top ports
			   <tr height='10'>
					<td port='nodeName_in_0' colspan="4" width='25%' bgcolor="#00FF00" border="1"></td>
					<td port='nodeName_in_1' colspan="4" width='25%' bgcolor="#00FF00" border="1"></td>
					<td port='nodeName_in_2' colspan="4" width='25%' bgcolor="#00FF00" border="1"></td>
					<td port='nodeName_in_3' colspan="4" width='25%' bgcolor="#00FF00" border="1"></td>
					<td port='nodeName_in_4' colspan="4" width='25%' bgcolor="#00FF00" border="1"></td>
			   </tr>

			   // title
			   <tr><td port="nodeName999" colspan="20"><font color="white"><b>nodeName</b></font></td></tr>

			   // contents 1
			   <tr><td colspan="20">
					<table border='1' cellborder='0' bgcolor='#EEEEEE'>
						<tr><td>a1</td></tr>
						<tr><td>b2</td></tr>
						<tr><td>c3</td></tr>
					</table>
			   </td></tr>

			   // contents 2
			   <tr><td colspan="20">
					<table border='1' cellborder='0' bgcolor='#EEEEEE'>
						<tr><td>a1</td></tr>
						<tr><td>b2</td></tr>
						<tr><td>c3</td></tr>
					</table>
			   </td></tr>
			   
			   // bottom ports
			   <tr height='10'>
					<td port='nodeName_out_0' colspan="5" width='25%' bgcolor="#00FF00" border="1"></td>
					<td port='nodeName_out_1' colspan="5" width='25%' bgcolor="#00FF00" border="1"></td>
					<td port='nodeName_out_2' colspan="5" width='25%' bgcolor="#00FF00" border="1"></td>
					<td port='nodeName_out_3' colspan="5" width='25%' bgcolor="#00FF00" border="1"></td>
			   </tr>
		   </table>>];
	}	
	'''
	
}