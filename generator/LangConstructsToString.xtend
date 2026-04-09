package org.generator

import org.agriDSL.OperationSpace
import org.agriDSL.OperationDimensionValue
import org.agriDSL.OperationDimensionInterval
import org.agriDSL.DesignSpace
import java.util.List
import org.agriDSL.OperationDimension
import org.agriDSL.Requirement
import org.agriDSL.RequirementTrace
import org.agriDSL.ExperimentSpace
import java.util.ArrayList
import org.agriDSL.MeasurementRequirementElicitation
import org.agriDSL.AExp
import org.agriDSL.AExpVal
import org.agriDSL.AExpEspace
import org.agriDSL.AExpExpr
import org.agriDSL.OpPlus
import org.agriDSL.OpMinus
import org.agriDSL.OpMultiply
import org.agriDSL.OpDivision
import org.agriDSL.Op
import org.generator.dslpaper2.ResolveAExp
import org.agriDSL.AExpDspace

class LangConstructsToString {
	var static nl="\n" // newline
	var static marker="================================"
	var static reqMarker="====Requirements================"
	var static traceMarker="====Trace======================="

	def static void main(String[] args) {
		var r=CreateLangConstructs.createRequirement ("abc", "def", LangConstructPopulations.smallOS, LangConstructPopulations.mediumOS)
		var rString=print(r)
		System.out.println(rString)
	}


	def static String printStr(String str, boolean toPrint){
		if(toPrint)
			return str
		else
			return ""
	}
	
	def static String measurementRequirementElicitationEvaluatedToString(MeasurementRequirementElicitation m, ExperimentSpace es, List<String> expelem){
		return evaluatedToString(m.iterations,es,expelem)+" iterations "+ 
		evaluatedToString(m.runs,es,expelem)+" runs "+
	    " actors have distribution "+evaluatedToString(m.is,es,expelem)+" intersection "+ 
		evaluatedToString(m.cj,es,expelem)+ " conjunction "+ 
		evaluatedToString(m.cp,es,expelem)+ " compromise "+
		evaluatedToString(m.co,es,expelem)+ " coerce "+
		"requirements are selected using "+ 
		evaluatedToString(m.en,es,expelem)+ " entropy "+ 
		evaluatedToString(m.ja,es,expelem)+ " jaccard "+
		"requirement owner is selected using "+ 
		evaluatedToString(m.enOwner,es,expelem)+ " entropy "+ 
		evaluatedToString(m.jaOwner,es,expelem)+ " jaccard "		
	}
	
	def static String measurementRequirementElicitationUnevaluatedToString(MeasurementRequirementElicitation m){
		return aexpUnevaluatedToString(m.iterations)+" iterations "+ 
		aexpUnevaluatedToString(m.runs)+" runs "+
	    " actors have distribution "+aexpUnevaluatedToString(m.is)+" intersection "+ 
		aexpUnevaluatedToString(m.cj)+ " conjunction "+ 
		aexpUnevaluatedToString(m.cp)+ " compromise "+
		aexpUnevaluatedToString(m.co)+ " coerce "+
		"requirements are selected using "+ 
		aexpUnevaluatedToString(m.en)+ " entropy "+ 
		aexpUnevaluatedToString(m.ja)+ " jaccard "+
		"requirement owner is selected using "+ 
		aexpUnevaluatedToString(m.enOwner)+ " entropy "+ 
		aexpUnevaluatedToString(m.jaOwner)+ " jaccard "
	}

	def static String evaluatedToString(AExp aexp, ExperimentSpace es, List<String> expelem){
		return ResolveAExp.resolveAExp(aexp,es,expelem).toString
	}
	
	def static String aexpUnevaluatedToString(AExp aexp){
		switch(aexp){
			AExpVal:    return aexp.value.toString
			AExpDspace:	return "dspace ("+aexp.param.head+")"
			AExpEspace:	return "espace ("+aexp.param.head+")"
			AExpExpr:	return "("+aexpUnevaluatedToString(aexp.a1.head)+opToString(aexp.op.head)+aexpUnevaluatedToString(aexp.a2.head)+")"
		}
	}
	
	def static int aexpEvaluatedToString(AExp aexp, List<String> dsm, List<String> dsi){
		switch(aexp){
			AExpVal:    return aexp.value
			AExpDspace:	new Integer(loopupValueForDimension(aexp.param.head,dsm,dsi))
			AExpEspace:	new Integer(loopupValueForDimension(aexp.param.head,dsm,dsi))
			AExpExpr:	return applyOp(aexp.op.head,aexpEvaluatedToString(aexp.a1.head,dsm,dsi),aexpEvaluatedToString(aexp.a2.head,dsm,dsi))
		}
	}
	
	def static loopupValueForDimension (String dim, List<String> dsm, List<String> dsi){
		for(cnt:0..dsm.size-1){
			if(dsm.get(cnt)==dim)
				return dsi.get(cnt)
		}
	}
	
	def static int applyOp(Op op, int a1, int a2){
		switch(op){
			OpPlus:      return a1+a2
			OpMinus:     return a1-a2
			OpMultiply:  return a1*a2
			OpDivision:  return a1/a2
		}
	}
	
	def static String opToString(Op op){
		switch(op){
			OpPlus:      return "+"
			OpMinus:     return "-"
			OpMultiply:  return "*"
			OpDivision:  return "/"
		}
	}
	
	def static String operationSpaceToString (OperationSpace os){ // by default an operation space is printed on multiple lines
		return operationSpaceToString(os,false)
	}
	
	def static String operationSpaceToString (OperationSpace os, boolean oneLine){
		var str="" 
		str = str+ printStr("==== operation space ====\n",!oneLine)
		str = str+ printStr("[ ",oneLine)

		for(dim:os.opModeDimension)
			switch(dim){
				OperationDimensionValue: str = str + operationDimensionValueToString(dim) + " " + printStr("\n",!oneLine)
				OperationDimensionInterval: str = str + operationDimensionIntervalToString(dim) + " " + printStr("\n",!oneLine)
			}
		str = str + printStr("=========================",!oneLine)
		str = str+ printStr(" ]",oneLine)
		return str
	}
	
	def static String operationDimensionValueToString (OperationDimensionValue odv){
		var str=odv.opModeDimensionName.head + " {"
		for(v:odv.value)
			str=str+" "+v+" "
		str=str+" }"
		return str
	}
	
	def static String operationDimensionIntervalToString (OperationDimensionInterval odi){
		var str=odi.opModeDimensionName.head +  " {"
		for(v:odi.range)
			str=str+" "+v.begin+":"+v.end+" "
		str=str+" }"		
		return str
	}	
	
	def static String esToString(ExperimentSpace es){
		var str="==== experiment space ====\n"
		for(dim:es.expDimension){
			str=str+dim.experimentDimensionName.head+" {" + designSpaceValuesToString(listIntegerToString(dim.value))+ " } \n" // note: reuse of designSpaceValuesToString
		}
		str=str+"=========================="
		return str
	}
	
	def static listIntegerToString (List<Integer> iList){
		var ret=new ArrayList<String>
		for(iItem:iList)
			ret.add(iItem.toString)		
		return ret
	}
	
	def static String designSpaceToString(DesignSpace ds){
		designSpaceToString(ds,false)
	}
	
	def static String designSpaceToString(DesignSpace ds, boolean oneLine){
		var str=""
		str = str+ printStr("==== design space ====\n",!oneLine)
		str = str+ printStr("[ ",oneLine)
		for(dim:ds.DSpaceDimension){
			str=str+dim.dsDimensionName.head+" { "+designSpaceValuesToString(dim.value)+" } "+printStr("\n",!oneLine)
		}
		str = str + printStr("=========================",!oneLine)
		str = str+ printStr(" ]",oneLine)
		return str
	}
	
	def static String designSpaceValuesToString(List<String> values){
		var str=""
		for(value:values)
			str=str+value+" "
		return str
	}
	
	def static String print (Requirement r){
		var ret = marker+nl 
		ret=ret + "kind: "+r.rk.head+nl
		ret=ret + "name: "+r.name+nl
		ret=ret + "minOS"+nl
		ret=ret + print(r.minReq.head.opModeSpace.head)
		ret=ret + "maxOS"+nl
		ret=ret + print(r.maxReq.head.opModeSpace.head)
		ret=ret + marker
		return ret
	}
	
	// prints many requirementtaces, each on a single line
	def static String printOneLineRequirementTrace (List<RequirementTrace> traces){
		var ret = traceMarker+nl
		for(tr:traces)
			ret = ret + printOneLine(tr)
		ret = ret + marker+nl
		return ret
	}
	
	def static String printOneLine (RequirementTrace rt){
		if(!rt.req1.empty)
			return "RT: "+rt.req1.head.name+" -> "+rt.req2.head.name+" "+rt.timestamp+"\n"
		else
			return "RT: NULL "+rt.req2.head.name+" -> "+rt.timestamp+"\n"
	}
	
	
	// prints many requirements, each one on a single line
	def static String printOneLine (List<Requirement> reqs){
		var ret = reqMarker+nl
		for(r:reqs)
			ret = ret + printOneLine(r)
		ret = ret + marker+nl
		return ret
	}
	
	// prints a requirement on one single line
	def static String printOneLine (Requirement r){
		var ret = "name: "+r.name
		ret = ret + " kind: "+r.rk.head
		ret= ret + " min: "+printOneLine(r.minReq.head.opModeSpace.head)
		ret = ret + " max: "+ printOneLine(r.maxReq.head.opModeSpace.head) + nl
		return ret
	}

	def static String print (OperationSpace os){
		var ret = ""
		for(dim:os.opModeDimension)
			ret = ret + print(dim)+nl
		return ret
	}	

	def static String printOneLine (OperationSpace os){
		var ret = ""
		for(dim:os.opModeDimension)
			ret = ret + print(dim) + " "
		return ret
	}
	
	def static String print (OperationDimension od){
		switch(od){
			OperationDimensionValue:    return print(od)
			OperationDimensionInterval: return print(od)
		}
	}	
	
	def static String print (OperationDimensionValue ov){
		var ret=ov.opModeDimensionName.head
		ret=ret+"{"
		for(value:ov.value)
			ret=ret+" "+value
		ret=ret+" }"
		return ret
	}	

	def static String print (OperationDimensionInterval oi){
		var ret=oi.opModeDimensionName.head
		ret=ret+"["
		ret=ret+oi.range.head.begin+":"+oi.range.head.end
		ret=ret+"]"
		return ret
	}	
}