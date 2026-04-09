package org.generator.dslpaper3

import org.agriDSL.Model
import org.agriDSL.aSystem
import org.agriDSL.DefaultSystemExtension
import org.agriDSL.DefaultPartExtension
import org.agriDSL.SystemAndPartExtension
import org.agriDSL.Distribution
import org.agriDSL.ConstantDistribution
import org.agriDSL.GeneralDistribution
import org.agriDSL.ExponentialDistribution
import org.agriDSL.impl.AgriDSLFactoryImpl
import org.agriDSL.AExp
import org.agriDSL.AExpVal
import org.agriDSL.AExpEspace
import org.agriDSL.AExpExpr
import org.agriDSL.AExpDspace
import org.agriDSL.Op
import org.agriDSL.SystemOrPart
import org.agriDSL.OpPlus
import org.agriDSL.OpMinus
import org.agriDSL.OpMultiply
import org.agriDSL.OpDivision
import org.generator.CreateLangConstructs
import org.agriDSL.SystemID
import org.agriDSL.Part
import org.agriDSL.PartID
import org.agriDSL.DesAlternative
import java.util.List
import java.util.ArrayList
import org.agriDSL.ScenarioFeedbackLoop
import org.agriDSL.FeedbackLoop

class ResolveSyntacticSugar {
	def static copyScenarioToFeedbackloops(Model model){
		var List<ScenarioFeedbackLoop> scenarioFBLs = model.scen.head.sfbl
		var List<FeedbackLoop>         fbloops      = model.loops
		for(scenarioFBL:scenarioFBLs)
			for(fbloop:fbloops){
				if(scenarioFBL.name==fbloop.name) // add ScenarioFeedbackLoop to FeedbackLoop
					fbloop.scen.add(CreateLangConstructs.clone(scenarioFBL))
			}
	}
	
	
	// recursive fuction that applies syntactic sugar: (1) composite system, (2) default SystemAndPartExtensions
	def static resolve(Model model){
		var mainSystem = model.eAllContents.toIterable.filter(typeof(aSystem)).toList.head
		var systemDefaultExtension = model.eAllContents.toIterable.filter(typeof(DefaultSystemExtension)).toList.head.defsysext
		var partDefaultExtension = model.eAllContents.toIterable.filter(typeof(DefaultPartExtension)).toList.head.defparext
		var systems = model.eAllContents.toIterable.filter(typeof(aSystem)).toList
		var parts = model.eAllContents.toIterable.filter(typeof(Part)).toList 
		resolve (mainSystem,systemDefaultExtension,partDefaultExtension,systems,parts)
	}
	
	def static resolve(aSystem asystem, SystemAndPartExtension defsysext, SystemAndPartExtension defparext, List<aSystem> ss, List<Part> ps){
		asystem.ext=replaceEmptyEntriesByDefault(asystem.ext,defsysext)
		for(sop:asystem.systemOrParts)
			resolve(sop,defsysext,defparext,ss,ps)
	}
	
	def static resolve(SystemOrPart sop, SystemAndPartExtension defsysext, SystemAndPartExtension defparext, List<aSystem> ss, List<Part> ps){
		switch(sop){
			aSystem: 	resolve(sop,defsysext,defparext,ss,ps)
			SystemID: 	resolve(sop,defsysext,defparext,ss,ps)
			Part: 		resolve(sop,defsysext,defparext,ss,ps)
			PartID: 	resolve(sop,defsysext,defparext,ss,ps)
			DesAlternative: resolve(sop,defsysext,defparext,ss,ps)
		}
		return void
	}
	
	def static resolve(DesAlternative desalt, SystemAndPartExtension defsysext, SystemAndPartExtension defparext, List<aSystem> ss, List<Part> ps){
		for(alt:desalt.ds)
			resolve(alt.systemOrParts.head,defsysext,defparext,ss,ps)		
	}
	
	def static resolve(SystemID sid, SystemAndPartExtension defsysext, SystemAndPartExtension defparext, List<aSystem> ss, List<Part> ps){
		var system = backtracking.lookupSystem(sid,ss)
		resolve(system,defsysext,defparext,ss,ps)
		return void
	}
	
	def static resolve(Part part, SystemAndPartExtension defsysext, SystemAndPartExtension defparext, List<aSystem> ss, List<Part> ps){
		part.ext=replaceEmptyEntriesByDefault(part.ext,defsysext)
	}	
	
	def static resolve(PartID pid, SystemAndPartExtension defsysext, SystemAndPartExtension defparext, List<aSystem> ss, List<Part> ps){
		var part = backtracking.lookupPart(pid,ps)
		resolve(part,defsysext,defparext,ss,ps)
	}
	
	def static boolean systemAndPartExtensionIsComplete (SystemAndPartExtension sa){
		return sa != null && sa.fail!=null && !sa.fail.empty && sa.rep!=null && !sa.rep.empty
		&& sa.pon!=null && !sa.pon.empty && sa.poff!=null && !sa.poff.empty && sa.sdt!=null && !sa.sdt.empty
		&& sa.sut!=null && !sa.sut.empty && sa.pts!=null && !sa.pts.empty
		&& sa.rate!=null && !sa.rate.empty && sa.cost!=null && !sa.cost.empty
	}
	
	def static SystemAndPartExtension replaceEmptyEntriesByDefault (SystemAndPartExtension toBeChecked, SystemAndPartExtension defaultEntry){
		if(!systemAndPartExtensionIsComplete(defaultEntry))
			throw new Throwable("systemAndPartExtensionIsComplete: The defaultentry is not complete")
		
		if(toBeChecked==null) // ret becomes the clone of defaultEntry
			return CreateLangConstructs.clone(defaultEntry)
		
		var ret=AgriDSLFactoryImpl::init.createSystemAndPartExtension

		if (toBeChecked.fail==null || toBeChecked.fail.empty) 
			ret.fail.add(CreateLangConstructs.clone(defaultEntry.fail.head)) 
		else 
			ret.fail.add(CreateLangConstructs.clone(toBeChecked.fail.head))
			
		if (toBeChecked.rep==null || toBeChecked.rep.empty)  
			ret.rep.add(CreateLangConstructs.clone(defaultEntry.rep.head))   
		else 
			ret.rep.add(CreateLangConstructs.clone(toBeChecked.rep.head))
			
		if (toBeChecked.pon==null || toBeChecked.pon.empty)  
			ret.pon.add(CreateLangConstructs.clone(defaultEntry.pon.head))   
		else 
			ret.pon.add(CreateLangConstructs.clone(toBeChecked.pon.head))
			
		if (toBeChecked.poff==null || toBeChecked.poff.empty) 
			ret.poff.add(CreateLangConstructs.clone(defaultEntry.poff.head)) 
		else 
			ret.poff.add(CreateLangConstructs.clone(toBeChecked.poff.head))
			
		if (toBeChecked.sdt==null || toBeChecked.sdt.empty)  
			ret.sdt.add(CreateLangConstructs.clone(defaultEntry.sdt.head))   
		else 
			ret.sdt.add(CreateLangConstructs.clone(toBeChecked.sdt.head))
			
		if (toBeChecked.sut==null || toBeChecked.sut.empty)  
			ret.sut.add(CreateLangConstructs.clone(defaultEntry.sut.head))   
		else 
			ret.sut.add(CreateLangConstructs.clone(toBeChecked.sut.head))
			
		if (toBeChecked.pts==null || toBeChecked.pts.empty)  
			ret.pts.add(CreateLangConstructs.clone(defaultEntry.pts.head))   
		else 
			ret.pts.add(CreateLangConstructs.clone(toBeChecked.pts.head))
			
		if (toBeChecked.rate==null || toBeChecked.rate.empty) 
			ret.rate.add(CreateLangConstructs.clone(defaultEntry.rate.head)) 
		else 
			ret.rate.add(CreateLangConstructs.clone(toBeChecked.rate.head))
			
		if (toBeChecked.cost==null || toBeChecked.cost.empty) 
			ret.cost.add(CreateLangConstructs.clone(defaultEntry.cost.head)) 
		else 
			ret.cost.add(CreateLangConstructs.clone(toBeChecked.cost.head))
			
		if (toBeChecked.numu==null || toBeChecked.numu.empty) 
			ret.numu.add(CreateLangConstructs.clone(defaultEntry.numu.head)) 
		else 
			ret.numu.add(CreateLangConstructs.clone(toBeChecked.numu.head))
		
		//TODO
		if (toBeChecked.util==null || toBeChecked.util.empty)
			ret.util.add(defaultSystemAndPartExtensionUtilization)
		else
			ret.util.add(CreateLangConstructs.clone(toBeChecked.util.head))
			
		return ret		
	}
	
	def static defaultSystemAndPartExtensionUtilization (){
		var ret = AgriDSLFactoryImpl::init.createSystemAndPartExtensionUtilization
		ret.red = -1
		ret.orange = -1
		ret.green = -1
		return ret
	}

	def static Distribution clone (Distribution d)  { return CreateLangConstructs.clone(d) }
	def static AExp clone (AExp aexp)				{ return CreateLangConstructs.clone(aexp) }	
}