package org.generator.dslpaper2

import org.agriDSL.AExp
import org.agriDSL.ExperimentSpace
import java.util.List
import org.agriDSL.MeasurementRequirementElicitation
import java.util.ArrayList
import java.util.HashSet
import org.agriDSL.AExpExpr
import org.agriDSL.AExpEspace
import org.agriDSL.Op
import org.agriDSL.OpPlus
import org.agriDSL.OpMinus
import org.agriDSL.OpMultiply
import org.agriDSL.OpDivision
import org.agriDSL.AExpVal
import org.generator.CreateLangConstructs
import org.agriDSL.AExpDspace

class ResolveAExp {
	def static void main(String[] args) {
	}
	
	def static int resolveAExp (AExp aexp, List<String> dsm, List<String> dsi){
		switch(aexp){
			AExpVal:    return aexp.value
			AExpExpr:   return resolveAExp(aexp.a1.head, aexp.op.head, aexp.a2.head, dsm, dsi)
			AExpDspace: return lookUp(aexp.param.head, dsm, dsi)
		}
		throw new Throwable("resolveAExp: (aexp,dsm,dsi) not defined for espace")
	}
	
	def static int lookUp(String param, List<String> dsm, List<String> dsi){
		for(cnt:0..dsm.size-1)
			if(dsm.get(cnt).equals(param))
				return new Integer(dsi.get(cnt))
		throw new Throwable("lookup: dimension "+param+" not found in the design space")
	}
	
	def static int resolveAExp (AExp aexp, ExperimentSpace es, List<String> espace){
		switch(aexp){
			AExpExpr:   return resolveAExp(aexp.a1.head, aexp.op.head, aexp.a2.head, es, espace)
			AExpVal:    return aexp.value
			AExpEspace: return resolveAExp(aexp.param.head, es, espace)
		}
	}

	def static int resolveAExp (AExp a1, Op op, AExp a2, List<String> dsm, List<String> dsi){
		switch(op){
			OpPlus:     return resolveAExp(a1,dsm,dsi)+resolveAExp(a2,dsm,dsi)
			OpMinus:    return resolveAExp(a1,dsm,dsi)-resolveAExp(a2,dsm,dsi)
			OpMultiply: return resolveAExp(a1,dsm,dsi)*resolveAExp(a2,dsm,dsi)
			OpDivision: return resolveAExp(a1,dsm,dsi)/resolveAExp(a2,dsm,dsi)
		}
	}

	def static int resolveAExp (AExp a1, Op op, AExp a2, ExperimentSpace es, List<String> espace){
		switch(op){
			OpPlus:     return resolveAExp(a1,es,espace)+resolveAExp(a2,es,espace)
			OpMinus:    return resolveAExp(a1,es,espace)-resolveAExp(a2,es,espace)
			OpMultiply: return resolveAExp(a1,es,espace)*resolveAExp(a2,es,espace)
			OpDivision: return resolveAExp(a1,es,espace)/resolveAExp(a2,es,espace)
		}
	}
	
	def static int resolveAExp (String _dim, ExperimentSpace es, List<String> espace){
		for(cnt:0..es.expDimension.length-1){
			var expDim=es.expDimension.get(cnt)
			if(expDim.experimentDimensionName.head.equals(_dim))
				return new Integer(espace.get(cnt))
		}
		throw new Throwable("resolveAExp: dimension "+_dim+" not found in espace")
	}
	
	def static List<String> expDimensionsUsed (AExp aexp){
		var ret = new HashSet<String>
		switch (aexp){
			AExpExpr: { ret.addAll(expDimensionsUsed(aexp.a1.head)); ret.addAll(expDimensionsUsed(aexp.a2.head)) }
			AExpEspace: ret.add(aexp.param.head)
		}		
		return ret.toList
	}
	
	// retrieves all ExperimentDimensions used for a MeasurementRequirementElicitation
	def static List<String> expDimensionsUsed (MeasurementRequirementElicitation m){
		var ret = new HashSet<String>
		ret.addAll(expDimensionsUsed(m.iterations))
		ret.addAll(expDimensionsUsed(m.runs))
		ret.addAll(expDimensionsUsed(m.is))
		ret.addAll(expDimensionsUsed(m.cj))
		ret.addAll(expDimensionsUsed(m.cp))
		ret.addAll(expDimensionsUsed(m.co))
		ret.addAll(expDimensionsUsed(m.en))
		ret.addAll(expDimensionsUsed(m.ja))
		ret.addAll(expDimensionsUsed(m.enOwner))
		ret.addAll(expDimensionsUsed(m.jaOwner))
		return ret.toList
	}
	
	def static List<List<String>> retrieveExperimentSpaceElemens (ExperimentSpace espace){
		return CreateLangConstructs.returnExperimentInstances(espace)
	}
}