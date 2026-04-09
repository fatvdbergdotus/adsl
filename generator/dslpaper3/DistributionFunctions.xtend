package org.generator.dslpaper3

import org.eclipse.xtext.generator.IFileSystemAccess2
import org.generator.ConfigurationManager
import org.agriDSL.Distribution
import org.agriDSL.ConstantDistribution
import java.util.List
import java.util.ArrayList
import org.generator.dslpaper2.ResolveAExp
import org.agriDSL.GeneralDistribution
import org.agriDSL.ExponentialDistribution

class DistributionFunctions {
	def static double maxValueDistributions (List<Distribution> ds, List<String> dsm, List<String> dsi){
		var double max=0.0
		for(d:ds)
			max=Math.max(max,maxValueDistribution(d,dsm,dsi))
		return max
	}
	
	def static double maxValueDistribution (Distribution d, List<String> dsm, List<String> dsi){
		var List<Pair<Double,Double>> dNumbers=DistributionToNumbers(d,dsm,dsi)
		var double maxX=0.0
		for(dNumber:dNumbers)
			maxX=Math.max(maxX,dNumber.key)
		return maxX
	}
	
	def static PrintDistributionNumbers (List<Pair<Double,Double>> ds)
	'''«FOR d:ds»«d.key» «d.value»
	«ENDFOR»e
	'''
	
	def static List<Pair<Double,Double>> DistributionToNumbers (Distribution d, List<String> dsm, List<String> dsi){
		switch(d){
			ConstantDistribution: 		return DistributionToNumbers(d,dsm,dsi)
			GeneralDistribution: 		return DistributionToNumbers(d,dsm,dsi)
			ExponentialDistribution:	return DistributionToNumbers(d,dsm,dsi)
		}
	}

	def static List<Pair<Double,Double>> DistributionToNumbers (ConstantDistribution d, List<String> dsm, List<String> dsi){
		var ret=new ArrayList<Pair<Double,Double>>
		ret.add(1.0*ResolveAExp.resolveAExp(d.aexp,dsm,dsi) -> 0.0)
		ret.add(1.0*ResolveAExp.resolveAExp(d.aexp,dsm,dsi) -> 1.0)
		return ret
	}
	
	def static List<Pair<Double,Double>> DistributionToNumbers (GeneralDistribution d, List<String> dsm, List<String> dsi){
		var ret=new ArrayList<Pair<Double,Double>>
		for(pv:d.probvals)
			ret.add(1.0*ResolveAExp.resolveAExp(pv.value,dsm,dsi) -> 1.0*ResolveAExp.resolveAExp(pv.prob,dsm,dsi))
		
		return ret
	}
	
	def static List<Pair<Double,Double>> DistributionToNumbers (ExponentialDistribution d, List<String> dsm, List<String> dsi){
		var ret=new ArrayList<Pair<Double,Double>>
		for(cnt:0..1000){ // 0 till 100 with step 0.1
			var double value= 0.1*cnt
			var double prob = 1.0-Math.pow(Math.E, -value*ResolveAExp.resolveAExp(d.aexp,dsm,dsi)) 
			ret.add(value -> prob)
		}
		return ret
	}
}