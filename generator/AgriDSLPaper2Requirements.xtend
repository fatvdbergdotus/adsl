package org.generator

import org.agriDSL.Configuration
import java.util.Map
import java.util.HashMap
import org.agriDSL.ConfigKeyValue
import java.util.List

import java.util.List
import org.agriDSL.Requirement
import org.agriDSL.OperationSpace
import java.util.ArrayList
import java.util.HashSet
import java.util.Set
import java.util.Collections
import org.agriDSL.DesignSpace
import org.agriDSL.Model
import org.agriDSL.impl.AgriDSLFactoryImpl
import org.agriDSL.TimestampRequirement

class AgriDSLPaper2Requirements {
	def static dummy (){}
	


	// to observe requirements on the basis of operation spaces.
	def static boolean meetsRequirement (OperationSpace os, List<Requirement> reqs){
		for(r:reqs)
			if(!CreateLangConstructs.OMSmeetsRequirement(os,r)) return false
		return true				
	}
	
	def static booleanList (int number, int numbooleans){
		var _number=number+1
		var List<Boolean> blist = new ArrayList<Boolean>
		for(cnt:numbooleans-1..0)
			if(_number>power(2,cnt)){
				_number=_number-power(2,cnt)
				blist.add(true)
			}
			else
				blist.add(false)
		return blist
	}
	
	// computes the powerset of a set with n objects, containing 2^n objects.
	def static List<List<Requirement>> powerSet (List<Requirement> req){
		var ret = new ArrayList<List<Requirement>>
		for(cnt:0..power(2,req.length)-1){
			var selectReq = new ArrayList<Requirement>
			var bl=booleanList(cnt,req.length)
			for(rcnt:0..req.length-1)
				if(bl.get(rcnt))
					selectReq.add(req.get(rcnt))
			ret.add(selectReq)		
		}
		return ret
	}
	
	def static int power (int base, int exp){
		if(exp==0)
			return 1
		else
			return base*power(base,exp-1)
	}	
	
	// TODO: test this function
	// If the larger requirement encompasses the smaller requirement, then the larger requirement is useless. 
	def static boolean encompasses (Requirement smallerReq, Requirement largerReq){
		// largerReq does not contain dimensions that are not in smallerReq
		for(elem:CreateLangConstructs.dimNames(largerReq))
			if(!CreateLangConstructs.dimNames(smallerReq).contains(elem))
				return false
		
		// largerReq encompasses smallerReq: largerReq.minimum < smallerReq.minimum < smallerReq.maximum < largerReq.maximum 
		
		// largerReq.minimum < smallerReq.minimum
		if(!largerReq.minReq.empty && !smallerReq.minReq.empty) // req could be empty
			if(!CreateLangConstructs.subSetOMS(largerReq.minReq.head.opModeSpace.head,smallerReq.minReq.head.opModeSpace.head))
				return false
		
		// smallerReq.minimum < smallerReq.maximum	
		if(!smallerReq.minReq.empty && !smallerReq.maxReq.empty) // req could be empty
			if(!CreateLangConstructs.subSetOMS(smallerReq.minReq.head.opModeSpace.head,smallerReq.maxReq.head.opModeSpace.head))
				return false
		
		// smallerReq.maximum < largerReq.maximum
		if(!smallerReq.maxReq.empty && !largerReq.maxReq.empty) // req could be empty
			if(!CreateLangConstructs.subSetOMS(smallerReq.maxReq.head.opModeSpace.head,largerReq.maxReq.head.opModeSpace.head))
				return false
		
		return true
	} 
	
	// Determines the entropy of a frequency table (expected amount of information)
	def static double entropy (List<Pair<String,Integer>> entryFreq, boolean dummy){
		var int numentries=0
		var double entropy=0.0
		for(ef:entryFreq)
			numentries=numentries+ef.value // count the total entries
		for(ef:entryFreq){
			var information=-(1.0*ef.value/numentries)*Math.log(1.0*ef.value/numentries)/Math.log(2)
			entropy=entropy+information
		}
		return entropy
	}

	// Determines the entropy of a list of strings (expected amount of information)	
	def static double entropy (List<String> entries){
		var Set<String> entriesSet = new HashSet
		entriesSet.addAll(entries)
		
		var List<Pair<String,Integer>> entryFreq = new ArrayList
		for(e:entriesSet)
			entryFreq.add(e->Collections.frequency(entries,e))
		return entropy(entryFreq, true)
	}
	
	def static void main(String[] args) {
		System.out.println(entropy(#["1"->1,"2"->6],true))
		System.out.println(entropy(#["1","2","2","2","2","2","2"]))
		System.out.println(entropy(#["6","7","5","6","43","6","65","6","64","76","64","6","64","64","64","6"])) // excel: 2.305036533
		System.out.println(entropy(#["6","15","20","18","16","18","16","34","64","76","64","6","64","64","64","6"])) // excel: 2.727217001
		
		System.out.println(entropy(#["1"]))
		
		System.out.println(booleanList(0,8))
		System.out.println(booleanList(17,8))
		System.out.println(booleanList(37,8))
		
		//System.out.println(powerSet(#["a","b","c"]))
	}
	
	
	// def static boolean subSetOMS (OperationSpace small, OperationSpace large)
}