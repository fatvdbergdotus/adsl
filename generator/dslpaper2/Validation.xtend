package org.generator.dslpaper2

import java.util.List

class Validation {
	def static void main(String[] args) {

	}
	
	// computes for a design, the ratio of requirements it meets
	def static Double computeRatioRequirementsMetDesign (List<Boolean> reqoutcomesDesign){
		var Double ret = 0.0
		for(r:reqoutcomesDesign)
			if(r)
				ret=ret+1.0
		return ret/reqoutcomesDesign.size
	}
	
	def static Double computeRatioRequirements (List<List<Boolean>> reqoutcomes){
		var Double ret = 0.0
		for(r:reqoutcomes){
			ret = ret + Math.pow(computeRatioRequirementsMetDesign(r),2)
		}
		return Math.sqrt(ret)
	}
}