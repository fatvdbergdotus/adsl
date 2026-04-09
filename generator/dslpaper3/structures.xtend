package org.generator.dslpaper3

import java.util.List
import java.util.ArrayList
import org.agriDSL.FeedbackLoop
import org.agriDSL.Part
import org.agriDSL.aSystem

// a struct with different settings for showing a graph
class GraphSettings {
	var boolean showPartID
	var boolean showSystemID
	var boolean showOperationSpaces
	var boolean showSystemExtensions
	var boolean showPartExtensions
	var boolean showFeedbackLoops
	
	new(boolean _showPartID, boolean _showSystemID, boolean _showOperationSpaces, boolean _showSystemExtensions, 
		boolean _showPartExtensions, boolean _showFeedbackLoops){
		showPartID=_showPartID
		showSystemID=_showSystemID 
		showOperationSpaces=_showOperationSpaces
		showSystemExtensions=_showSystemExtensions
		showPartExtensions=_showPartExtensions
		showFeedbackLoops=_showFeedbackLoops
	}
	
	def boolean retShowPartID() { return showPartID }
	def boolean retshowSystemID() { return showSystemID }
	def boolean retshowOperationSpaces() { return showOperationSpaces }
	def boolean retshowSystemExtensions() { return showSystemExtensions }
	def boolean retshowPartExtensions() { return showPartExtensions }
	def boolean retshowFeedbackLoops() { return showFeedbackLoops }
}

// a struct for deriving the components of a CPS graph, such as nodes, connections and feedback loops
class CPSGraphElements {
	var boolean showdetails
	var boolean showonlyfeedbackloops
	var List<FeedbackLoop> fls = new ArrayList<FeedbackLoop>
	var aSystem mainSystem
	var List<aSystem> ss = new ArrayList<aSystem>
	var	List<Part> ps = new ArrayList<Part>
	var List<String> dsm = new ArrayList<String>
	var List<String> dsi = new ArrayList<String>
	
	var List<List<String>> floops = new ArrayList<List<String>>
	var List<String> fUp = new ArrayList<String>
	var List<String> fDown = new ArrayList<String>
	var List<String> fUpAndDown = new ArrayList<String>
	var List<Pair<String,String>> conns = new ArrayList<Pair<String,String>>
	var List<String> nodes = new ArrayList<String>
	
	new (boolean _showdetails, boolean _showonlyfeedbackloops, List<FeedbackLoop> _fls, aSystem _mainSystem, List<aSystem> _ss, 
		 		List<Part> _ps, List<String> _dsm, List<String> _dsi){
		showdetails=_showdetails
		showonlyfeedbackloops=_showonlyfeedbackloops
		fls.addAll(_fls)
		mainSystem=_mainSystem
		ss.addAll(_ss)
		ps.addAll(_ps)
		dsm.addAll(_dsm)
		dsi.addAll(_dsi)		
		
		var List<List<String>> floops   = createGraphViz.generateFeedbackloops (fls,mainSystem,ss,ps,dsm,dsi)
		var List<String> fUp   			= createGraphViz.floopsUp(floops)
		var List<String> fDown 			= createGraphViz.floopsDown(floops)
		fUpAndDown = new ArrayList<String>
		fUpAndDown.addAll(fUp)
		fUpAndDown.addAll(fDown)
		var conns      = backtracking.generateConnections (mainSystem,ss,ps,dsm,dsi)
		var nodes      = createGraphViz.connsToNodes(conns)
		
		if(showonlyfeedbackloops){ // take the subset of the conns and nodes that has a fbloop
			conns=createGraphViz.fbloopConns(conns,fUpAndDown)
			nodes=createGraphViz.fbloopNodes(nodes,fUpAndDown)
		}
	}

	// make the parameters accesible
	def boolean retShowdetails() { return showdetails }
	def boolean retShowonlyfeedbackloops() { return showonlyfeedbackloops }
	def List<FeedbackLoop> retFls() { return fls }
	def aSystem retMainSystem() { return mainSystem }
	def List<aSystem> retSs() { return ss }
	def List<Part> retPs() { return ps }
	def List<String> retDsm() { return dsm }
	def List<String> retDsi() { return dsi }
		
	// make derived information accesible
	def List<List<String>> retFloops() { return floops }
	def List<String> retFUp() { return fUp }
	def List<String> retFDown() { return fDown }
	def List<String> retFUpAndDown() { return fUpAndDown }
	def List<Pair<String,String>> retConns() { return conns }
	def List<String> retNodes() { return nodes }
}