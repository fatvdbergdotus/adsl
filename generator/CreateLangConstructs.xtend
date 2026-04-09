package org.generator

import org.agriDSL.impl.AgriDSLFactoryImpl
import org.agriDSL.OperationSpace
import org.agriDSL.PartID
import java.util.List
import org.agriDSL.DesignSpace
import java.util.ArrayList
import org.agriDSL.OperationDimensionValue
import org.agriDSL.OperationDimensionInterval
import org.agriDSL.OperationDimension
import java.util.Set
import java.util.HashSet
import java.util.Collections
import org.agriDSL.Range
import org.agriDSL.Requirement

import org.agriDSL.Requirement
import org.agriDSL.ExperimentSpace
import org.agriDSL.ExperimentDimension
import org.agriDSL.ExperimentDimension
import org.agriDSL.AExp
import org.agriDSL.AExpVal
import org.agriDSL.AExpEspace
import org.agriDSL.AExpExpr
import org.agriDSL.Op
import org.agriDSL.OpPlus
import org.agriDSL.OpMinus
import org.agriDSL.OpMultiply
import org.agriDSL.OpDivision
import org.agriDSL.Distribution
import org.agriDSL.ConstantDistribution
import org.agriDSL.GeneralDistribution
import org.agriDSL.ExponentialDistribution
import org.agriDSL.AExpDspace
import org.agriDSL.SystemAndPartExtensionToFailure
import org.agriDSL.SystemAndPartExtensionToRepair
import org.agriDSL.SystemAndPartExtensionPowerOn
import org.agriDSL.SystemAndPartExtensionPowerOff
import org.agriDSL.SystemAndPartExtensionShutdownTime
import org.agriDSL.SystemAndPartExtensionStartupTime
import org.agriDSL.SystemAndPartExtensionPolicyTimeShutDown
import org.agriDSL.SystemAndPartExtensionRate
import org.agriDSL.SystemAndPartExtensionCost
import org.agriDSL.SystemAndPartExtensionNumberOfUnits
import org.agriDSL.SystemAndPartExtension
import org.agriDSL.FeedbackLoop
import org.agriDSL.FeedbackLoopLatency
import org.agriDSL.ScenarioFeedbackLoop
import org.agriDSL.SystemAndPartExtensionUtilization

class CreateLangConstructs {
	  
	def static void main(String[] args) {
		//System.out.println(overlap(new Pair(208,230),new Pair(100,1112)))
		testGenerateManyReqs
	}
	
	def static ScenarioFeedbackLoop clone (ScenarioFeedbackLoop s){
		var ret = AgriDSLFactoryImpl::init.createScenarioFeedbackLoop
		ret.name=s.name
		ret.timeOffset=clone(s.timeOffset)
		ret.timeInterval=clone(s.timeInterval)
		ret.load=clone(s.load)
		return ret
	}
	
	def static SystemAndPartExtension clone (SystemAndPartExtension s){
		var ret = AgriDSLFactoryImpl::init.createSystemAndPartExtension
		ret.fail.addAll(s.fail.map[ i | clone(i) ])
	    ret.rep.addAll(s.rep.map[ i | clone(i) ]) 
	    ret.pon.addAll(s.pon.map[ i | clone(i) ]) 
	    ret.poff.addAll(s.poff.map[ i | clone(i) ]) 
	    ret.sdt.addAll(s.sdt.map[ i | clone(i) ]) 
	    ret.sut.addAll(s.sut.map[ i | clone(i) ])  
	    ret.pts.addAll(s.pts.map[ i | clone(i) ])  
	    ret.rate.addAll(s.rate.map[ i | clone(i) ])
	    ret.cost.addAll(s.cost.map[ i | clone(i) ])
	    ret.numu.addAll(s.numu.map[ i | clone(i) ])	
	    ret.util.addAll(s.util.map[ i | clone(i) ])
		return ret
	}
	
	def static FeedbackLoop clone (FeedbackLoop fl){
		var ret = AgriDSLFactoryImpl::init.createFeedbackLoop
		ret.name = fl.name
		ret.sensorID.add(fl.sensorID.head)
		ret.actuatorID.add(fl.actuatorID.head)
		
		if(fl.latency.head!==null)
			ret.latency.add(clone(fl.latency.head))
		if(fl.scen.head!==null)
			ret.scen.add(clone(fl.scen.head))
		return ret
	}
	
	def static FeedbackLoopLatency clone (FeedbackLoopLatency fll){
		var ret = AgriDSLFactoryImpl::init.createFeedbackLoopLatency
		ret.d.add(fll.d.head)		
		return ret
	}
	
	def static SystemAndPartExtensionToFailure clone (SystemAndPartExtensionToFailure s){
		var ret = AgriDSLFactoryImpl::init.createSystemAndPartExtensionToFailure
		ret.toFail.add(clone(s.toFail.head))
		return ret
	}

	def static SystemAndPartExtensionToRepair clone (SystemAndPartExtensionToRepair s){
		var ret = AgriDSLFactoryImpl::init.createSystemAndPartExtensionToRepair
		ret.toRepair.add(clone(s.toRepair.head))
		return ret
	}

	def static SystemAndPartExtensionPowerOn clone (SystemAndPartExtensionPowerOn s){
		var ret = AgriDSLFactoryImpl::init.createSystemAndPartExtensionPowerOn
		ret.powerOn.add(clone(s.powerOn.head))
		return ret
	}
	
	def static SystemAndPartExtensionPowerOff clone (SystemAndPartExtensionPowerOff s){
		var ret = AgriDSLFactoryImpl::init.createSystemAndPartExtensionPowerOff
		ret.powerOff.add(clone(s.powerOff.head))
		return ret
	}
	
	def static SystemAndPartExtensionShutdownTime clone (SystemAndPartExtensionShutdownTime s){
		var ret = AgriDSLFactoryImpl::init.createSystemAndPartExtensionShutdownTime
		ret.shutdownTime.add(clone(s.shutdownTime.head))
		return ret
	}
	
	def static SystemAndPartExtensionStartupTime clone (SystemAndPartExtensionStartupTime s){
		var ret = AgriDSLFactoryImpl::init.createSystemAndPartExtensionStartupTime
		ret.startupTime.add(clone(s.startupTime.head))
		return ret
	}
	
	def static SystemAndPartExtensionPolicyTimeShutDown clone (SystemAndPartExtensionPolicyTimeShutDown s){
		var ret = AgriDSLFactoryImpl::init.createSystemAndPartExtensionPolicyTimeShutDown
		ret.policyTimeShutdown.add(clone(s.policyTimeShutdown.head))
		return ret
	}
	
	def static SystemAndPartExtensionRate clone (SystemAndPartExtensionRate s){
		var ret = AgriDSLFactoryImpl::init.createSystemAndPartExtensionRate
		ret.rate.add(clone(s.rate.head))
		return ret
	}

	def static SystemAndPartExtensionCost clone (SystemAndPartExtensionCost s){
		var ret = AgriDSLFactoryImpl::init.createSystemAndPartExtensionCost
		ret.cost.add(clone(s.cost.head))
		return ret
	}

	def static SystemAndPartExtensionNumberOfUnits clone (SystemAndPartExtensionNumberOfUnits s){
		var ret = AgriDSLFactoryImpl::init.createSystemAndPartExtensionNumberOfUnits
		ret.numunits.add(clone(s.numunits.head))
		return ret
	}	

	def static SystemAndPartExtensionUtilization clone (SystemAndPartExtensionUtilization s){
		var ret = AgriDSLFactoryImpl::init.createSystemAndPartExtensionUtilization
		ret.red=s.red
		ret.orange=s.orange
		ret.green=s.green
		ret.blue=s.blue
		ret.black=s.black
		return ret
	}		
	
	def static Distribution clone (Distribution d){
		switch(d){
			ConstantDistribution: 		{ var ret = AgriDSLFactoryImpl::init.createConstantDistribution; ret.aexp=clone(d.aexp); return ret }
			GeneralDistribution:		clone(d)
			ExponentialDistribution:	{ var ret = AgriDSLFactoryImpl::init.createExponentialDistribution; ret.aexp=clone(d.aexp); return ret }
		}
		throw new Throwable("Distribution clone: unsupported type of Distribution")
	}
	
	def static GeneralDistribution clone (GeneralDistribution d){
		var ret = AgriDSLFactoryImpl::init.createGeneralDistribution
		for(pv:d.probvals){
			var pvcopy = AgriDSLFactoryImpl::init.createProbabilityValue
			pvcopy.prob=clone(pv.prob)
			pvcopy.value=clone(pv.value)
			ret.probvals.add(pvcopy)
		}
		return ret
	}
	
	def static AExp clone (AExp aexp){
		switch(aexp){
			AExpVal: 		{ var ret = AgriDSLFactoryImpl::init.createAExpVal; ret.value = aexp.value; return ret	}
			AExpEspace:		{ var ret = AgriDSLFactoryImpl::init.createAExpEspace; ret.param.add(aexp.param.head); return ret }	
			AExpExpr:		{ var ret = AgriDSLFactoryImpl::init.createAExpExpr; ret.a1.add(aexp.a1.head); ret.op.add(clone(aexp.op.head)); ret.a2.add(aexp.a2.head); return ret }
			AExpDspace:		{ var ret = AgriDSLFactoryImpl::init.createAExpDspace; ret.param.add(aexp.param.head); return ret }	
		}
		throw new Throwable("AExp clone: unsupported type of AExp")
	}
	
	def static Op clone (Op op){
		switch(op){
			OpPlus: 	return AgriDSLFactoryImpl::init.createOpPlus
			OpMinus:	return AgriDSLFactoryImpl::init.createOpMinus
			OpMultiply: return AgriDSLFactoryImpl::init.createOpMultiply
			OpDivision: return AgriDSLFactoryImpl::init.createOpDivision
		}	
	}
	
	def static testGenerateManyReqs(){
		var o2=LangConstructPopulations.operationModeMerge2
		var o3=LangConstructPopulations.operationModeMerge3
		var r =CreateLangConstructs.createRequirement("abc","def",o2,o3)
		System.out.println("Original requirement")
		System.out.println(LangConstructsToString.print(r))
		var rs=generateManyRequirements(r)
		for(cnt:0..rs.length-1){
			System.out.println("Requirement number "+cnt)
			System.out.println(LangConstructsToString.print(rs.get(cnt)))
		}
	}
	
	
	// converts a number of requirements into many requirements to be used in a testcase.
	def static List<Requirement> generateManyRequirements (List<Requirement> reqs){
		var ret = new ArrayList<Requirement>
		for(r:reqs)
			ret.addAll(generateManyRequirements(r))
		return ret
	}
	
	def static List<Requirement> generateManyRequirements (Requirement r){
		var int cnt = 100 // counter that ensures that all requirement names are unique
		var List<Requirement> ret = new ArrayList<Requirement>
		var omin =r.minReq.head.opModeSpace.head
		var omax =r.maxReq.head.opModeSpace.head
		var rname=r.name
		var rkind=r.rk.head
		
		// generates requirements that differ one dimension on the minimum operation space and the maximum operation space
		for(osMin:generateManyOperationSpaces(omin)){ // operation spaces that differ one from the minimum operation space
			for(osMax:generateManyOperationSpaces(omax)){ // operation spaces that differ one from the maximum operation space
				cnt=cnt+1
				var req = AgriDSLFactoryImpl::init.createRequirement
				req.name=rname + Integer.toString(cnt)
				req.rk.add(rkind)
				var reqMin = AgriDSLFactoryImpl::init.createRequirementMinimum
				reqMin.opModeSpace.add(osMin)
				var reqMax = AgriDSLFactoryImpl::init.createRequirementMaximum
				reqMax.opModeSpace.add(osMax)
				req.minReq.add(reqMin)
				req.maxReq.add(reqMax)
				ret.add(clone(req))
			}
		}
		return ret
	}
	
	def static List<OperationSpace> generateManyOperationSpaces (OperationSpace o){
		if(ConfigurationManager.lookupValue("generatemanyrequirements").equals("1"))
			return generateManyOperationSpaces1(o)
		else
			return generateManyOperationSpaces2(o)
	}
	
	// generates all the operation spaces that have two dimensions less than the input operation space
	def static List<OperationSpace> generateManyOperationSpaces2 (OperationSpace o){
		var List<OperationSpace> ret = new ArrayList<OperationSpace>
		for(omit1:0..o.opModeDimension.length-1){ // the first dimension to omit
			for(omit2:0..o.opModeDimension.length-1){ // the second dimension to omit
				if(omit1!=omit2){ // they have to be different
					var os = AgriDSLFactoryImpl::init.createOperationSpace
					for(cnt:0..o.opModeDimension.length-1)
						if(cnt!=omit1 && cnt!=omit2)
							os.opModeDimension.add(clone(o.opModeDimension.get(cnt)))
					ret.add(os)
				}
			}
		}
		return ret
	}

	// generates all the operation spaces that have one dimension less than the input operation space
	def static List<OperationSpace> generateManyOperationSpaces1 (OperationSpace o){
		var List<OperationSpace> ret = new ArrayList<OperationSpace>
		for(omit:0..o.opModeDimension.length-1){ // the dimension to omit
			var os = AgriDSLFactoryImpl::init.createOperationSpace
			for(cnt:0..o.opModeDimension.length-1)
				if(cnt!=omit)
					os.opModeDimension.add(clone(o.opModeDimension.get(cnt)))
			ret.add(os)
		}
		return ret
	}
	
	def static Requirement clone (Requirement r){
		var req = AgriDSLFactoryImpl::init.createRequirement
		req.rk.add(r.rk.head)
		req.name=r.name

		var min = AgriDSLFactoryImpl::init.createRequirementMinimum
		min.opModeSpace.add(clone(r.minReq.head.opModeSpace.head))
		//min.opModeSpace.add(LangConstructPopulations.emptyOS)
		req.minReq.add(min)

		var max = AgriDSLFactoryImpl::init.createRequirementMaximum
		max.opModeSpace.add(clone(r.maxReq.head.opModeSpace.head))
		//max.opModeSpace.add(LangConstructPopulations.emptyOS)
		req.maxReq.add(max)			
				
		return req
	}
	
	def static ExperimentSpace clone (ExperimentSpace es){
		var ret = AgriDSLFactoryImpl::init.createExperimentSpace
		for(dim:es.expDimension)
			ret.expDimension.add(clone(dim))
		return ret
	}
	
	def static ExperimentDimension clone(ExperimentDimension ed){
		var ret = AgriDSLFactoryImpl::init.createExperimentDimension
		ret.experimentDimensionName.add(ed.experimentDimensionName.head)
		ret.value.addAll(ed.value)
		return ret
	}
	
	def static OperationSpace clone (OperationSpace o){
		var OperationSpace os = AgriDSLFactoryImpl::init.createOperationSpace
		for(OperationDimension dim:o.opModeDimension)
			os.opModeDimension.add(clone(dim))
		return os
	}
	
	def static OperationDimension clone (OperationDimension d){
		switch(d){
			OperationDimensionValue:	return clone(d)
			OperationDimensionInterval: return clone(d)
		}		
	}
	
	def static OperationDimensionValue clone (OperationDimensionValue od){
		var ret = AgriDSLFactoryImpl::init.createOperationDimensionValue
		ret.opModeDimensionName.add(od.opModeDimensionName.head)
		ret.value.addAll(od.value)
		return ret
	}

	def static OperationDimensionInterval clone (OperationDimensionInterval oi){
		var ret = AgriDSLFactoryImpl::init.createOperationDimensionInterval
		var range = AgriDSLFactoryImpl::init.createRange
		range.begin=oi.range.head.begin
		range.end=oi.range.head.end
		ret.opModeDimensionName.add(oi.opModeDimensionName.head)
		ret.range.add(range)
		return ret
	}
		
	def static Requirement createRequirement (String requirementkind, String _name, OperationSpace minOS, OperationSpace maxOS){
		var req = AgriDSLFactoryImpl::init.createRequirement
		req.name=_name
		req.rk.add(requirementkind)
		if(minOS!==null){
			var _reqmin = AgriDSLFactoryImpl::init.createRequirementMinimum
			_reqmin.opModeSpace.add(minOS)
			req.minReq.add(_reqmin)
		}
		if(maxOS!==null){
			var _reqmax = AgriDSLFactoryImpl::init.createRequirementMaximum
			_reqmax.opModeSpace.add(maxOS)
			req.maxReq.add(_reqmax)			
		}
		return req
	}
	
	def static Requirement createRequirement(String rk, OperationSpace os1, OperationSpace os2){
		var req = AgriDSLFactoryImpl::init.createRequirement
		req.rk.add(rk)
		if(os1!==null){
			var min = AgriDSLFactoryImpl::init.createRequirementMinimum
			min.opModeSpace.add(os1)
			req.minReq.add(min)
		}
		if(os2!==null){
			var max = AgriDSLFactoryImpl::init.createRequirementMaximum
			max.opModeSpace.add(os2)
			req.maxReq.add(max)			
		}			
		return req
	}
	
	def static OperationSpace createOMS(List<List<String>> contents){
		var OMS = AgriDSLFactoryImpl::init.createOperationSpace
		for(dim:contents){
			if(dim.head=="0"){ // value
				var OMdimension = AgriDSLFactoryImpl::init.createOperationDimensionValue
				OMdimension.opModeDimensionName.add(dim.tail.head)
				OMdimension.value.addAll(dim.tail.tail)
				OMS.opModeDimension.add(OMdimension)
			}
			else if (dim.head=="1"){// intervals
				var OMdimension = AgriDSLFactoryImpl::init.createOperationDimensionInterval
				OMdimension.opModeDimensionName.add(dim.tail.head)
				var range = AgriDSLFactoryImpl::init.createRange
				range.begin = new Integer(dim.get(2))
				range.end = new Integer(dim.get(3))
				OMdimension.range.add(range)
				OMS.opModeDimension.add(OMdimension)
				if (dim.length>4) // outside the interval range
					throw new Throwable("createOMS: the defined interval contains more than two values")
			}
			else
				throw new Throwable("createOMS: first element of each dimension should be 0 or 1")
		}
		return OMS
	}
	
	def static OperationSpace mergeOMS (List<OperationSpace> oss){
		var List<OperationDimensionValue>    dimvals = new ArrayList
		var List<OperationDimensionInterval> dimints = new ArrayList
		for(os:oss)
			for(dim:os.opModeDimension) // gather all dimensions
				switch(dim){
					OperationDimensionValue:    dimvals.add(dim)
					OperationDimensionInterval: dimints.add(dim)
				}
		
		var ret = AgriDSLFactoryImpl::init.createOperationSpace
		var mergeDimVal = mergeDimensionsValue(dimvals)
		var mergeDimInt = mergeDimensionsInterval(dimints)
		ret.opModeDimension.addAll(mergeDimVal)
		ret.opModeDimension.addAll(mergeDimInt)
		return ret
	}
	
	def static Set<String> dimNames (Requirement req){
		var Set<String> ret = new HashSet
		for(min:req.minReq)
			ret.addAll(dimNames(min.opModeSpace.head))
		for(max:req.maxReq)
			ret.addAll(dimNames(max.opModeSpace.head))
		return ret
	}
	
	// returns the dimension names for two operation spaces
	// -1 means only o1 contains the dimension, +1 means only o2 contains the dimension, 0 means both contain the dimension
	def static Set<Pair<String,Integer>> commonDimNames (OperationSpace o1, OperationSpace o2){
		var o1and2names=new HashSet<String>
		var o1names=dimNames(o1)
		var o2names=dimNames(o2)
		o1and2names.addAll(o1names)
		o1and2names.addAll(o2names)
		
		var Set<Pair<String,Integer>> ret= new HashSet<Pair<String,Integer>>
		for(o12:o1and2names){
			if(o1names.contains(o12)&&o2names.contains(o12))
				ret.add(o12->0)
			else if(o1names.contains(o12))
				ret.add(o12->-1)
			else if(o2names.contains(o12))
				ret.add(o12->1)
		}
		return ret
	}

	def static Set<String> dimNames (OperationSpace os){
		var Set<String> ret = new HashSet
		for(dim:os.opModeDimension)
			ret.add(dimName(dim))
		return ret
	}
	
	def static OperationDimension returnDimensionWithName(OperationSpace os, String name){
		for(d:os.opModeDimension)
			if(dimName(d).equals(name))
				return clone(d)
		throw new Throwable("returnDimensionWithName: Dimension with "+name+" not found!")
	}	
	
	def static String dimName(OperationDimension od){
		switch(od){
			OperationDimensionValue:	return od.opModeDimensionName.head
			OperationDimensionInterval: return od.opModeDimensionName.head
		}
	}
	
	def static boolean emptyDimension (OperationDimension od){
		switch(od){
			OperationDimensionValue:	return od.value.length==0
			OperationDimensionInterval: return od.range.head.begin>od.range.head.end			
		}
	}
	
	def static boolean OMSmeetsRequirement (OperationSpace os, Requirement r){
		for(minReq:r.minReq)
			if(!subSetOMS(minReq.opModeSpace.head,os))
				return false
		for(maxReq:r.maxReq)
			if(!subSetOMS(os,maxReq.opModeSpace.head))
				return false
		return true
	}
	
	//DEFINES A PARTIAL ORDERING OVER operation spaces. This version only compares present dimensions
	def static boolean subSetOMS (OperationSpace small, OperationSpace large){
		for(dSmall:small.opModeDimension)
			for(dLarge:large.opModeDimension)
				if(sameNameOperationDimension(dSmall,dLarge))
					if(!subsetDimensionsValue(dSmall,dLarge)) // the small contains values that the large does not.
						return false
		return true
	}
		
	/* DEFINES A PARTIAL ORDERING OVER operation spaces. This version requires that if OS1 is a subset of OS2, that all dimensions of OS2 are present in OS1 too.
	def static boolean subSetOMS (OperationSpace small, OperationSpace large){
		if(large.opModeDimension==0) // every operation space is a subset of the empty operation space
			return true
		
		for(dSmall:small.opModeDimension) // check for empty dimensions
			if(emptyDimension(dSmall))
				return true
		
		for(dSmall:small.opModeDimension){
			for(dLarge:large.opModeDimension){
				if(!subsetDimensionsValue(dSmall,dLarge)) // the small contains values that the large does not.
					return false	
			}
		}	

		//check whether every dimension in large is represented in small
		var List<String> smallDims = new ArrayList
		var List<String> largeDims = new ArrayList
		
		for(dSmall:small.opModeDimension)
			smallDims.add(dimName(dSmall))
		for(dLarge:large.opModeDimension)
			largeDims.add(dimName(dLarge))

		return smallDims.containsAll(largeDims)
	}*/
	
	def static boolean sameNameOperationDimension(OperationDimension small, OperationDimension large){
		switch(small){
			OperationDimensionValue:
				switch(large){
					OperationDimensionValue:
						return small.opModeDimensionName.head==large.opModeDimensionName.head}}
		switch(small){
			OperationDimensionInterval:
				switch(large){
					OperationDimensionInterval:
						return small.opModeDimensionName.head==large.opModeDimensionName.head}}
		return false		
	}
	
	def static boolean subsetDimensionsValue(OperationDimension small, OperationDimension large){ // if the dimensions are similar, large should be a superset of small
		switch(small){
			OperationDimensionValue:
			switch(large){
				OperationDimensionValue: // both are of kind OperationDimensionValue
						return large.value.containsAll(small.value)
				default: throw new Throwable("subsetDimensionsValue: dimensions compared are of different types")
			}
		}
		switch(small){
			OperationDimensionInterval:
			switch(large){
				OperationDimensionInterval: // both are of kind OperationDimensionInterval
					return subRange(small.range.head,large.range.head)
				default: throw new Throwable("subsetDimensionsValue: dimensions compared are of different types")
			}
		}
		return true		
	}
	
	def static boolean subRange (Range small, Range large){
		return (large.begin<=small.begin) && (small.end<=large.end)
	}
	
	def static List<OperationDimensionInterval> mergeDimensionsInterval (List<OperationDimensionInterval> dimvals){
		var List<OperationDimensionInterval> ret = new ArrayList
		var Set<String> opdimNames               = new HashSet
		
		for(dv:dimvals) // gather the dimension names
			opdimNames.add(dv.opModeDimensionName.head)
		for(opdimName:opdimNames)
			ret.add(gatherValuesForDimensionInterval(opdimName,dimvals))				
		return ret	
	}
	
	def static OperationDimensionInterval gatherValuesForDimensionInterval (String dimName, List<OperationDimensionInterval> dimvals){
		var ret =   AgriDSLFactoryImpl::init.createOperationDimensionInterval
		var range = AgriDSLFactoryImpl::init.createRange
		var boolean first=true
		var Pair<Integer,Integer> minmax 
		for(dimval:dimvals)
			if(dimName==dimval.opModeDimensionName.head){
				var mx=new Pair(dimval.range.head.begin,dimval.range.head.end)
				if(first){
					minmax=mx
					first=false
				}
				else
					minmax=overlap(minmax,mx)
			}
		range.begin=minmax.key
		range.end=minmax.value
		ret.opModeDimensionName.add(dimName)
		ret.range.add(range)
		return ret
	}

	def static List<OperationDimensionValue> mergeDimensionsValue (List<OperationDimensionValue> dimvals){
		var List<OperationDimensionValue> ret = new ArrayList
		var Set<String> opdimNames            = new HashSet
		
		for(dv:dimvals) // gather the dimension names
			opdimNames.add(dv.opModeDimensionName.head)
		for(opdimName:opdimNames)
			ret.add(gatherValuesForDimensionValue(opdimName,dimvals))
		return ret
	}
	
	def static OperationDimensionValue gatherValuesForDimensionValue (String dimName, List<OperationDimensionValue> dimvals){
		var ret = AgriDSLFactoryImpl::init.createOperationDimensionValue
		var boolean first=true
		var List<String> values = new ArrayList
		for(dimval:dimvals)
			if(dimName==dimval.opModeDimensionName.head){
				if(first){
					values.addAll(dimval.value)
					first=false
				}
				else
					values=intersection(values,dimval.value)
			}
		ret.opModeDimensionName.add(dimName)
		ret.value.addAll(values)
		return ret
	}
	
	def static Pair<Integer,Integer> overlap (Pair<Integer,Integer> a, Pair<Integer,Integer> b){
		if(a.key==1&&a.value==-1) // no overlap
			return new Pair(1,-1)
		if(b.key==1&&b.value==-1) // no overlap
			return new Pair(1,-1)
		
		var intMin=Math.max(a.key,b.key)
		var intMax=Math.min(a.value,b.value)
		//System.out.println (intMin+" xxx "+intMax)
		if(intMax<intMin)
			return new Pair(1,-1) // no overlap
		else
			return new Pair(intMin,intMax)
	}
	
	def static List<String> intersection (List<String> l1, List<String> l2){
		var List<String> ret = new ArrayList
		for(e:l1)
			if(l2.contains(e))
				ret.add(e)
		return ret
	}
	
	def static PartID createPartID(String str){
		var partID = AgriDSLFactoryImpl::init.createPartID
		partID.partID = str
		return partID
	}
	
	def static DesignSpace createDS(List<List<String>> valuess){
		var ret_ds = AgriDSLFactoryImpl::init.createDesignSpace
		for(values:valuess){
			var dim = AgriDSLFactoryImpl::init.createDesignSpaceDimension
			dim.dsDimensionName.add(values.head)
			dim.value.addAll(values.tail)
			ret_ds.DSpaceDimension.add(dim)
		}
		return ret_ds
	}
	
	def static ExperimentSpace createES(List<List<String>> valuess){
		var ret_es = AgriDSLFactoryImpl::init.createExperimentSpace
		for(dimValues:valuess){
			var dim = AgriDSLFactoryImpl::init.createExperimentDimension
			dim.experimentDimensionName.add(dimValues.head)
			for(dimValue:dimValues.tail)
				dim.value.addAll(new Integer(dimValue))
			ret_es.expDimension.add(dim)
		}
		return ret_es
	}
	
	// return a subset of an experimentspace in which only dimensions "dimensionSubset" are present
	def static ExperimentSpace subsetofES(ExperimentSpace es, List<String> dimensionSubset){
		var esClone = clone(es)
		var ret_es  = AgriDSLFactoryImpl::init.createExperimentSpace
		for(dim:esClone.expDimension){
			if(dimensionSubset.contains(dim.experimentDimensionName.head)){
				ret_es.expDimension.add(clone(dim))
			}
		}
		return ret_es
	}
	
	def static List<List<String>> returnDesignInstances (DesignSpace ds){
		var ret_di=new ArrayList<List<String>>
		var desInstanceCounter=designInstanceCounter(ds)
		for(dic:desInstanceCounter){ // for each design instance (in integers) 
			var inst=new ArrayList<String>
			for(dim_nr:0..ds.DSpaceDimension.length-1){ // for each dimension
				inst.add(designSpaceGetValue(dim_nr,dic.get(dim_nr),ds))
			}
			ret_di.add(inst)
		}
		return ret_di
	}
	
	def static List<List<String>> returnExperimentInstances (ExperimentSpace es){
		var ret_ei=new ArrayList<List<String>>
		var expInstanceCounter=experimentInstanceCounter(es)
		for(dic:expInstanceCounter){ // for each design instance (in integers) 
			var inst=new ArrayList<String>
			for(dim_nr:0..es.expDimension.size-1){ // for each dimension
				inst.add(experimentSpaceGetValue(dim_nr,dic.get(dim_nr),es).toString)
			}
			ret_ei.add(inst)
		}
		return ret_ei
	}
	
	def static String designSpaceGetValue (int dimension, int value, DesignSpace ds){
		var dim=ds.DSpaceDimension.get(dimension)
		return dim.value.get(value)
	}

	def static int experimentSpaceGetValue (int dimension, int value, ExperimentSpace es){
		var ExperimentDimension dim=es.expDimension.get(dimension)
		return dim.value.get(value)
	}
	
	def static OperationDimension unionDimensions (OperationDimension d1, OperationDimension d2){
		switch(d1){
			OperationDimensionValue: 
				switch(d2){ OperationDimensionValue: unionDimensions (d1,d2) }
			OperationDimensionInterval:
				switch(d2){ OperationDimensionInterval: unionDimensions (d1,d2) }
		}
	}
	
	def static OperationDimension unionDimensions (OperationDimensionValue d1, OperationDimensionValue d2){
		var ret = AgriDSLFactoryImpl::init.createOperationDimensionValue
		ret.opModeDimensionName.add(d1.opModeDimensionName.head)
		var Set<String> d1d2values = new HashSet<String> // only add the same value once
		d1d2values.addAll(d1.value)
		d1d2values.addAll(d2.value)
		ret.value.addAll(d1d2values.toList)
		return ret
	}
	
	def static OperationDimension unionDimensions (OperationDimensionInterval d1, OperationDimensionInterval d2){
		var ret = AgriDSLFactoryImpl::init.createOperationDimensionInterval
		var range = AgriDSLFactoryImpl::init.createRange
		ret.opModeDimensionName.add(d1.opModeDimensionName.head)
		range.begin=Math.min(d1.range.head.begin,d2.range.head.begin)
		range.end=Math.max(d1.range.head.end,d2.range.head.end)
		ret.range.add(range)
		return ret
	}
	
	def static OperationDimension overlapDimensions (OperationDimension d1, OperationDimension d2){
		switch(d1){
			OperationDimensionValue:
				switch(d2){ OperationDimensionValue: overlapDimensions (d1,d2) }
			OperationDimensionInterval:
				switch(d2){ OperationDimensionInterval: overlapDimensions (d1,d2) }
		}		
	}

	def static OperationDimension overlapDimensions (OperationDimensionValue d1, OperationDimensionValue d2){
		var ret = AgriDSLFactoryImpl::init.createOperationDimensionValue
		ret.opModeDimensionName.add(d1.opModeDimensionName.head)
		for(d:d1.value)
			if(d2.value.contains(d))
				ret.value.add(d)
		return ret		
	}

	def static OperationDimension overlapDimensions (OperationDimensionInterval d1, OperationDimensionInterval d2){
		var ret = AgriDSLFactoryImpl::init.createOperationDimensionInterval
		var range = AgriDSLFactoryImpl::init.createRange
		ret.opModeDimensionName.add(d1.opModeDimensionName.head)
		var overlap=overlap(d1.range.head.begin -> d1.range.head.end,d2.range.head.begin -> d2.range.head.end)
		range.begin=overlap.key
		range.end=overlap.value
		ret.range.add(range)
		return ret		
	}

	def static List<List<Integer>> designInstanceCounter (DesignSpace ds){ // provides all design instances in number form
		var ret = new ArrayList<List<Integer>>
		var current = new ArrayList<Integer>
		
		for(cnt:0..ds.DSpaceDimension.length-1)
			current.add(0)
		
		for(cnt:0..totalDesignInstances(ds)-1){ // for each design instance
			for(dimnr:0..ds.DSpaceDimension.length-1){
				if(cnt%incrementDimension(ds).get(dimnr)==0) // increment
					current.set(dimnr,current.get(dimnr)+1)
				if(current.get(dimnr)>ds.DSpaceDimension.get(dimnr).value.length) // back to 1
					current.set(dimnr,1)
			}
			var cpy_current = new ArrayList<Integer>
			for(value:current)
				cpy_current.add(value-1) // start counting from 0 instead of 1
			ret.add(cpy_current)
		}
		return ret
	}
	
	def static List<List<Integer>> experimentInstanceCounter (ExperimentSpace es){ // provides all design instances in number form
		var ret = new ArrayList<List<Integer>>
		var current = new ArrayList<Integer>
		
		for(cnt:0..es.expDimension.length-1)
			current.add(0)
		
		for(cnt:0..totalExperimentInstances(es)-1){ // for each design instance
			for(dimnr:0..es.expDimension.length-1){
				if(cnt%incrementDimension(es).get(dimnr)==0) // increment
					current.set(dimnr,current.get(dimnr)+1)
				if(current.get(dimnr)>es.expDimension.get(dimnr).value.size) // back to 1
					current.set(dimnr,1)
			}
			var cpy_current = new ArrayList<Integer>
			for(value:current)
				cpy_current.add(value-1) // start counting from 0 instead of 1
			ret.add(cpy_current)
		}
		return ret
	}
	
	def static List<Integer> incrementDimension (DesignSpace ds){ // provides for each dimension, every how many instances it increments
		var ret = new ArrayList<Integer>
		var incr = 1
		for(dim:ds.DSpaceDimension){
			ret.add(incr)
			incr=incr*dim.value.length
		}
		return ret
	}
	
	def static List<Integer> incrementDimension (ExperimentSpace ds){ // provides for each dimension, every how many instances it increments
		var ret = new ArrayList<Integer>
		var incr = 1
		for(dim:ds.expDimension){
			ret.add(incr)
			incr=incr*dim.value.size
		}
		return ret
	}
	
	def static int totalDesignInstances (DesignSpace ds){ // computes the total number of design instances
		var cnt=1
		for(dim:ds.DSpaceDimension)
			cnt=cnt*dim.value.length
		return cnt
	}
	
	def static totalExperimentInstances (ExperimentSpace es){
		var int esSize=1
		for(dim:es.expDimension)
			esSize=esSize*dim.value.size
		return esSize
	}
}