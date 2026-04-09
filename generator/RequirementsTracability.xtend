package org.generator

import org.agriDSL.OperationSpace
import org.eclipse.xtext.generator.IFileSystemAccess2
import java.util.List
import java.util.ArrayList
import org.agriDSL.Requirement
import org.agriDSL.DesignSpace

class RequirementsTracability {
	def static void main(String[] args) {
		
	}
	
	// the function that returns the traces for all requirements
	def static processDesignMainsystremRequirements (List<Requirement> reqs, List<Pair<String,Pair<String,String>>> DSISyspartReq, 
													 List<Pair<String,Pair<String,OperationSpace>>> DSISyspartOS,
													 String mainSystemName, DesignSpace dspace){
		var ret=""
		//var mainSystemDSIReq = filterMainSystemDSIReq(DSISyspartReq,mainSystemName) // DSI-requirements tuples
		var mainSystemDSIOS  = filterMainSystemDSIOS(DSISyspartOS,mainSystemName)  // DSI-operation space tuples
		ret=ret+displayDesignsTemplateUK(dspace,mainSystemDSIOS)
		for(dsiOS:mainSystemDSIOS)
			for(req:reqs){
				var OS=filterOS(dsiOS.key,mainSystemDSIOS)
			
				var OperationSpace reqMin
				var OperationSpace reqMax
				if(!req.minReq.empty)
					reqMin=req.minReq.head.opModeSpace.head
				else
					reqMin=LangConstructPopulations.zeroOS
				if(!req.maxReq.empty)
					reqMax=req.maxReq.head.opModeSpace.head
				else
					reqMax=LangConstructPopulations.emptyOS

				var boolean tooLow=!CreateLangConstructs.subSetOMS(reqMin,OS)
				var boolean tooHigh=!CreateLangConstructs.subSetOMS(OS,reqMax)			
				var reqMessageUK=reqMeetsDesigntemplateUK(req.name,dsiOS.key,tooLow,tooHigh,OS,reqMin,reqMax)
				ret=ret+reqMessageUK
			}
		return ret
	}

	def static filterOS(String dsi, List<Pair<String,OperationSpace>> mainSystemDSIOS){
		for(c:mainSystemDSIOS)
			if(dsi==c.key)
				return c.value
		throw new Throwable("filterOS: requested DSI not found")
	}

	// select the mainSystem components for DSI-requirements tuples
	def static List<Pair<String,String>> filterMainSystemDSIReq (List<Pair<String,Pair<String,String>>> DSISyspartReq, String mainSystemName){
		var List<Pair<String,String>> ret = new ArrayList
		for(c:DSISyspartReq)
			if(c.value.key==mainSystemName)
				ret.add(c.key->c.value.value)
		return ret
	}
	
	// select the mainSystem components for DSI-operation space tuples
	def static List<Pair<String,OperationSpace>> filterMainSystemDSIOS (List<Pair<String,Pair<String,OperationSpace>>> DSISyspartReq, String mainSystemName){
		var List<Pair<String,OperationSpace>> ret = new ArrayList
		for(c:DSISyspartReq)
			if(c.value.key==mainSystemName)
				ret.add(c.key->c.value.value)
		return ret
	}	
	
	def static displayDesignsTemplateUK(DesignSpace dspace, List<Pair<String, OperationSpace>> mainSystemDSIOS){
	    '''The cyber-physical model contains design space «LangConstructsToString.designSpaceToString(dspace,true)». 
This design space yields design instances «FOR dsi:mainSystemDSIOS»«dsi.key» «ENDFOR». These design instances are evaluated for meeting the requirements, as follows.
	    '''	
	}

	def static reqMeetsDesigntemplateUK(String requirement, String design, boolean tooLow, boolean tooHigh, 
								 OperationSpace operationspaceDSI, OperationSpace operationspaceMin, OperationSpace operationspaceMax){
'''

Requirement «requirement» is «IF tooLow||tooHigh»not «ENDIF»satisfied for design «design», because the operation space «LangConstructsToString.operationSpaceToString(operationspaceDSI,true)» of design «design» is «IF tooLow»below the minimum operation space«
»«LangConstructsToString.operationSpaceToString(operationspaceMin,true)»«
»«ELSEIF tooHigh»above the maximum operation space«
»«LangConstructsToString.operationSpaceToString(operationspaceMax,true)»«
»«ELSE»between the minimum operation space«
»«LangConstructsToString.operationSpaceToString(operationspaceMin,true)»«
»and maximum operation space«
»«LangConstructsToString.operationSpaceToString(operationspaceMax,true)»«ENDIF»of requirement «requirement».'''}

	def reqMeetsDesigntemplateNL(String requirement, String design, boolean not, OperationSpace operationspaceDSI, boolean below, OperationSpace operationspaceReq)
		'''Er is «IF not»niet «ENDIF»voldaan aan requirement «requirement» voor design «design», omdat de operatieruimte
		«LangConstructsToString.operationSpaceToString(operationspaceDSI)»
		van design «design» «IF below»lager«ELSE»hoger«ENDIF» is dan de «IF below»minimum«ELSE»maximum«ENDIF» operatieruimte
		«LangConstructsToString.operationSpaceToString(operationspaceReq)»
		van requirement «requirement».
		
		'''
}