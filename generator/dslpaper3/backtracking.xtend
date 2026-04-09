package org.generator.dslpaper3

import org.agriDSL.aSystem
import java.util.List
import java.util.ArrayList
import org.agriDSL.SystemOrPart
import org.agriDSL.Part
import org.agriDSL.SystemID
import org.agriDSL.PartID
import org.agriDSL.DesAlternative
import org.agriDSL.FeedbackLoop
import java.util.Collections

class backtracking {
	def static void main(String[] args) {
		var lst=#["a","b","c"]
		var revLst=reverseLS(lst)
		System.out.println(revLst)
	}
	
	// reverse a list of Strings
	def static List<String> reverseLS(List<String> _ls){
		var ls = cloneLS(_ls)
		Collections.reverse(ls)
		return ls
	}

	// clone a list of Strings
	def static List<String> cloneLS (List<String> ls){
		var ret=new ArrayList<String>
		ret.addAll(ls)
		return ret
	}
	
	// returns a path between sensor and actuator in "fl"
	def static List<String> generateFeedbackloop (FeedbackLoop fl, aSystem asystem, List<aSystem> ss, List<Part> ps, List<String> dsm, List<String> dsi){
		var List<String> pathSensor   = pathCPStoComponent(asystem, ss, ps, fl.sensorID.head, dsm, dsi)
		var List<String> pathActuator = pathCPStoComponent(asystem, ss, ps, fl.actuatorID.head, dsm, dsi)
		
		if(pathSensor==null || pathActuator==null) // no loop found
			return null
		
		var psensor = cloneLS(pathSensor)
		var pactuator = cloneLS(pathActuator)
		var lastCommon=""
		while(psensor.head==pactuator.head){
			lastCommon=psensor.head
			psensor=psensor.tail.toList
			pactuator=pactuator.tail.toList
		}
		// put together the feedback loop consisting of three parts
		var append = reverseLS(psensor.toList)
		append.add(lastCommon)
		append.add(lastCommon) // is added twice to be able to distinguish a change of direction 
		append.addAll(pactuator)
		return append
	}
	
	// return a path only containing processing units (System and Part) between sensor and actuator in "fl"
	def static List<String> generateCleanFeedbackloop (FeedbackLoop fl, aSystem asystem, List<aSystem> ss, List<Part> ps, List<String> dsm, List<String> dsi){
		var ret = new ArrayList<String>
		var genFeedbackloop = generateFeedbackloop(fl,asystem,ss,ps,dsm,dsi)
		var ssNames = ss.map[ s | s.name ]
		var psNames = ps.map[ s | s.name ]
				
		for(g:genFeedbackloop)
			if(ssNames.contains(g) || psNames.contains(g))
				ret.add(g)
		return ret
	}
	
	// pathCPStoComponent: overloaded function to find the path from any SystemOrPath to a "target"
	def static List<String> pathCPStoComponent (aSystem asystem, List<aSystem> ss, List<Part> ps, String target, List<String> dsm, List<String> dsi){
		var List<Pair<String,String>> conns=generateConnections(asystem,ss,ps,dsm,dsi)
		var path = pathCPStoComponent(conns,target,asystem.name)
		if(path.last!=asystem.name) // check if the CPS system has been reached, otherwise throw an error
			return null//throw new Throwable("CPS system "+asystem.name+" not reached.")
		return reverseLS(path)
	}
	
	def static List<String> pathCPStoComponent (List<Pair<String,String>> conns, String _target, String CPS){ 
		//dsm and dsi are not needed here, because they are resolved in the generateConnections function 
		var ret=new ArrayList<String>
		var target=_target
		var boolean foundNew=true
		ret.add(target)
		while(foundNew){
			foundNew=false
			for(c:conns)
				if(c.value==target){
					ret.add(c.key)
					target=c.key
					foundNew=true
				}
		}
		return ret
	}
	
	// generateConnections: derives all the connections of a asystem in String->String format
	def static List<Pair<String,String>> generateConnections (aSystem asystem, List<aSystem> ss, List<Part> ps, List<String> dsm, List<String> dsi){
		var connections=new ArrayList<Pair<String,String>>
		for(sop:asystem.systemOrParts){
			connections.add(asystem.name -> nameOfSop(sop))
			for(gc:generateConnections(sop,ss,ps,dsm,dsi))
				connections.add(gc)
		}
		return connections
	}
	
	def static List<Pair<String,String>> generateConnections (Part part, List<aSystem> ss, List<Part> ps, List<String> dsm, List<String> dsi){
		return new ArrayList<Pair<String,String>>
	}
	
	def static List<Pair<String,String>> generateConnections (SystemID systemid, List<aSystem> ss, List<Part> ps, List<String> dsm, List<String> dsi){
		var connections=new ArrayList<Pair<String,String>>
		
		var system=lookupSystem(systemid,ss)
		connections.add(systemid.name -> system.name)
		connections.addAll(generateConnections(system,ss,ps,dsm,dsi))		

		return connections
	}
	
	def static aSystem lookupSystem(SystemID sid, List<aSystem> ss){
		for(s:ss)
			if(s.name==sid.systemID)
				return s
		return null
	}
	
	def static List<Pair<String,String>> generateConnections (PartID partid, List<aSystem> ss, List<Part> ps, List<String> dsm, List<String> dsi){
		var connections=new ArrayList<Pair<String,String>>

		var part=lookupPart(partid,ps)
		connections.add(partid.name -> part.name)
		
		return connections	
	}
	
	def static Part lookupPart (PartID pid, List<Part> ps){
		for(p:ps)
			if(p.name==pid.partID)
				return p
		return null
	}
	
	def static String lookupValueForDimension (String dimname, List<String> dsm, List<String> dsi){
		for(cnt:0..dsm.size-1){
			if(dsm.get(cnt)==dimname)
				return dsi.get(cnt)
		}
		throw new Throwable("lookupValueForDimension: "+dimname+" not found!")	
	}
	
	def static List<Pair<String,String>> generateConnections (DesAlternative desalt, List<aSystem> ss, List<Part> ps, List<String> dsm, List<String> dsi){
		var connections=new ArrayList<Pair<String,String>>
		var dsivalue = lookupValueForDimension(desalt.dsDimensionName.head,dsm,dsi)

		for(ds:desalt.ds){
			if(ds.dsValue.head==dsivalue){
				connections.add(desalt.dsDimensionName.head -> nameOfSop(ds.systemOrParts.head))
				connections.addAll(generateConnections(ds.systemOrParts.head,ss,ps,dsm,dsi))
			}				
		}
		return connections	
	}
 	
	def static List<Pair<String,String>> generateConnections (SystemOrPart sop, List<aSystem> ss, List<Part> ps, List<String> dsm, List<String> dsi){
		switch(sop){
			aSystem:  		generateConnections(sop,ss,ps,dsm,dsi)
			Part:     		generateConnections(sop,ss,ps,dsm,dsi)
			SystemID: 		generateConnections(sop,ss,ps,dsm,dsi)
			PartID:   		generateConnections(sop,ss,ps,dsm,dsi)
			DesAlternative: generateConnections(sop,ss,ps,dsm,dsi)
		}
	}
	
	def static String nameOfSop (SystemOrPart sop){
		switch(sop){
			aSystem:  		sop.name
			Part:     		sop.name
			SystemID: 		sop.name
			PartID:   		sop.name
			DesAlternative: sop.dsDimensionName.head
		}
	}
}
