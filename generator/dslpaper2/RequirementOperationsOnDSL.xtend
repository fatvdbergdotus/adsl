package org.generator.dslpaper2

import org.agriDSL.Model
import org.agriDSL.impl.AgriDSLFactoryImpl
import org.generator.CreateLangConstructs
import org.agriDSL.TimestampRequirement
import java.util.ArrayList
import java.util.List
import org.agriDSL.Requirement
import org.generator.AgriDSLGenerator
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.generator.LangConstructsToString
import org.generator.LangConstructComputations

class RequirementOperationsOnDSL {
	def static void main(String[] args) {}
	
	def static void sysOut (String s){
		System.out.println(s)
	}
	
	// One huge script to test all the functions in this class
	def static void testRequirementOperationsOnDSL(Resource r, IFileSystemAccess2 f, String fsapath){
		var m = r.allContents.toIterable.filter(typeof(Model)).toList.head
		
		copyRequirementsInitally(m)
		sysOut(LangConstructsToString.printOneLine(returnRequirementsWithHighestTimestamp(m)))
		
		for(cnt:1..5){
			copyRequirementsNextTimeStep(m)
			sysOut(LangConstructsToString.printOneLine(returnRequirementsWithHighestTimestamp(m)))
		}

		copyAndMultiplyRequirementsNextTimeStep(m)
		sysOut(LangConstructsToString.printOneLine(returnRequirementsWithHighestTimestamp(m)))

		var r1=   returnRequirementNWithHighestTimestamp (m,5)
		var r2=   returnRequirementNWithHighestTimestamp (m,8)
		var r1r2= RequirementMerge.coerce(r1,r2)
		copyRequirementsNextTimeStepAndRemoveTwoAndAddOne(m,5,8,r1r2)
		sysOut(LangConstructsToString.printOneLine(returnRequirementsWithHighestTimestamp(m)))
		
		var r3=	  returnRequirementNWithHighestTimestamp (m,2)
		var r4=	  returnRequirementNWithHighestTimestamp (m,4)
		var r3r4= RequirementMerge.intersection(r3,r4)
		copyRequirementsNextTimeStepAndRemoveTwoAndAddOne(m,2,4,r3r4)
		sysOut(LangConstructsToString.printOneLine(returnRequirementsWithHighestTimestamp(m)))

		var r5=   returnRequirementNWithHighestTimestamp (m,1)
		var r6=   returnRequirementNWithHighestTimestamp (m,8)
		var r5r6= RequirementMerge.conjunction(r5,r6)
		copyRequirementsNextTimeStepAndRemoveTwoAndAddOne(m,1,8,r5r6)
		sysOut(LangConstructsToString.printOneLine(returnRequirementsWithHighestTimestamp(m)))
		
		var r7=	  returnRequirementNWithHighestTimestamp (m,2)
		var r8=	  returnRequirementNWithHighestTimestamp (m,4)
		var r7r8= RequirementMerge.compromiseCoinFlipPerDimension(r7,r8)
		copyRequirementsNextTimeStepAndRemoveTwoAndAddOne(m,2,4,r7r8)
		sysOut(LangConstructsToString.printOneLine(returnRequirementsWithHighestTimestamp(m)))
		
		var r9=	  returnRequirementNWithHighestTimestamp (m,2)
		var r10=  returnRequirementNWithHighestTimestamp (m,4)
		var r9r10=RequirementMerge.compromiseCoinFlipPerDimension(r9,r10)
		copyRequirementsNextTimeStepAndRemoveTwoAndAddOne(m,2,4,r9r10)
		sysOut(LangConstructsToString.printOneLine(returnRequirementsWithHighestTimestamp(m)))		

		RequirementOperationsOnDSL.removeAllOfRequirements(m)
		sysOut(LangConstructsToString.printOneLine(returnRequirementsWithHighestTimestamp(m)))
	}
	
	// resets the requirements for each experiment run
	def static resetRequirements(Model model){
		removeTimestampedRequirements(model)
		removeRequirementTraces(model)
		copyRequirementsInitally(model)
		copyAndMultiplyRequirementsNextTimeStep(model)
	}
	
	def static removeRequirementTraces(Model model){
		model.requirementTraces.clear
	}
	
	// clone the initial requirements
	def static void copyRequirementsInitally (Model m){
		for(req:m.requirements){
			var tsReq = AgriDSLFactoryImpl::init.createTimestampRequirement
			tsReq.timestamp=1
			tsReq.req.add(CreateLangConstructs.clone(req))
			m.tsrequirements.add(tsReq)	
		}
	}
	
	// remove all requirements but the initial requirements
	def static void removeTimestampedRequirements (Model m){
		m.tsrequirements.clear
	}
	
	// clone the requirements with the highest timestamp and add 1 to the timestamp
	def static void copyRequirementsNextTimeStep (Model m){
		var tsrnew = new ArrayList<TimestampRequirement> 
		var highestTime=detectHighestTime(m.tsrequirements)
		for(tsr:m.tsrequirements){
			if(tsr.timestamp==highestTime){
				var tsReq = AgriDSLFactoryImpl::init.createTimestampRequirement
				tsReq.timestamp=highestTime+1
				tsReq.req.add(CreateLangConstructs.clone(tsr.req.head))
				tsrnew.add(tsReq)
			}
		}
		m.tsrequirements.addAll(tsrnew)
	}
	
	// return the requirements with the highest timestamp
	def static List<Requirement> returnRequirementsWithHighestTimestamp (Model m){
		var highestTime=detectHighestTime(m.tsrequirements)
		return returnRequirements(m,highestTime)
	}
	
	// return the requirements with a given timestamp
	def static List<Requirement> returnRequirements (Model m, int timestamp){
		var ret=new ArrayList<Requirement>
		for(tsr:m.tsrequirements){
			if(tsr.timestamp==timestamp){
				var req=CreateLangConstructs.clone(tsr.req.head)
				ret.add(req)
			}
		}
		return ret
	}
	
	// return the n^th requirement with a given timestamp
	def static Requirement returnRequirementN (Model m, int timestamp, int n){
		var r=returnRequirements (m,timestamp).get(n)
		return CreateLangConstructs.clone(r)
	}
	
	def static Requirement returnRequirementNWithHighestTimestamp (Model m, int n){
		var reqs=returnRequirementsWithHighestTimestamp(m)
		return CreateLangConstructs.clone(reqs.get(n))
	}
	
	// remove all the requirements
	def static removeAllOfRequirements (Model m){
		m.tsrequirements.clear
	}
	
	// find the highest timestamp among all requirements
	def static detectHighestTime (List<TimestampRequirement> tsrs){
		var ret=-1
		for(tsr:tsrs)
			if(tsr.timestamp>ret)
				ret=tsr.timestamp
		if(ret==-1)
			throw new Throwable("detectHighestTime: no requirements detected")
		return ret
	}
	
	def static void copyRequirementsNextTimeStepAndRemoveTwoAndAddOne 
										(Model m, int r1remove, int r2remove, Requirement rnew){
		var tsrnew = new ArrayList<TimestampRequirement>
		var highestTime=detectHighestTime(m.tsrequirements)
		
		// add everything but skip requirement r1remove and requirement r2remove
		var req=returnRequirementsWithHighestTimestamp(m)
		for(cnt:0..req.length-1)
			if(cnt!=r1remove && cnt!=r2remove){
				var tsReq = AgriDSLFactoryImpl::init.createTimestampRequirement
				tsReq.timestamp=highestTime+1
				tsReq.req.add(CreateLangConstructs.clone(req.get(cnt)))
				tsrnew.add(tsReq)
			}
		
		// add requirement rnew
		var tsReq2 = AgriDSLFactoryImpl::init.createTimestampRequirement
		tsReq2.timestamp=highestTime+1
		tsReq2.req.add(CreateLangConstructs.clone(rnew))
		tsrnew.add(tsReq2)
		
		m.tsrequirements.addAll(tsrnew)
	}

	// generates many smaller Requirements from less bigger Requirements
	def static copyAndMultiplyRequirementsNextTimeStep(Model m){
		var tsrnew = new ArrayList<TimestampRequirement>
		var highestTime=detectHighestTime(m.tsrequirements)
		for(tsr:m.tsrequirements){
			if(tsr.timestamp==highestTime){
				var reqs=CreateLangConstructs.generateManyRequirements(tsr.req.head)
				for(r:reqs){
					var tsReq = AgriDSLFactoryImpl::init.createTimestampRequirement
					tsReq.timestamp=highestTime+1
					tsReq.req.add(r)
					tsrnew.add(tsReq)
					
					// add corresponding trace
					RequirementSEngine.addtrace(m,r,1)			
				}
			}
		}
		m.tsrequirements.addAll(tsrnew)	
	}
}