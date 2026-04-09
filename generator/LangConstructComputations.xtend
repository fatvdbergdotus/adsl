package org.generator

import org.agriDSL.OperationSpace
import java.util.List
import java.util.Collection
import java.util.Set
import java.util.HashSet
import org.agriDSL.OperationDimension
import org.agriDSL.OperationDimensionValue
import org.agriDSL.OperationDimensionInterval
import com.google.common.collect.ArrayListMultimap
import java.util.ArrayList
import org.agriDSL.impl.AgriDSLFactoryImpl
import java.util.Collections

class LangConstructComputations {
	def static void main(String[] args) {
		var list1 = #['0','dim1','A1','B1','C1','D1','E1','F1','G1']
		var list2 = #['0','dim1','A2','B2','C2','D2','E2','F2','G1']
		var list3 = #['0','dim3','A3','B2','C3','D3','E3','F3','G1','dim1']
		var list4 = #['0','dim4','A4','B4','C4','D4','E4','F4','G1','dim1']
		var list5 = #['0','dim5','A5','B5','C5','D5','E5','F5','G1','dim1']
		System.out.println(findOverlapValuesForAllDimensions(#[list1, list2, list3, list4, list5],""))
	}
	
	def static OperationSpace mergeOperationSpaces(List<OperationSpace> oss){
		var ret_os = AgriDSLFactoryImpl::init.createOperationSpace
		for(dimname:gatherDimensionNames(oss)){
			var ods = gatherValuesForDimension(dimname,oss)
			if(!areOfSameType(ods))
				throw new Throwable("mergeOperationDimensions: operationSpaces have different kinds (value/interval) for the same dimension")
			
			if(value_dimension(ods.head)){
				var vals = extractOperationDimensionsValues(ods) // value-values
				var vals_dim = findOverlapValuesForAllDimensions(vals,dimname)
				ret_os.opModeDimension.add(vals_dim)
			}
			else{
				var ints = extractOperationDimensionsIntegers(ods) // interval-values			
				var ints_dim = findOverlapIntervalForAllDimensions(ints.key, ints.value,dimname)
				ret_os.opModeDimension.add(ints_dim)
			}
		}
		return ret_os
	}
	
	def static List<OperationDimension> gatherValuesForDimension(String dimname, List<OperationSpace> oss){
		// adds for each os in oss, the dimension that matches dimname
		var ret = new ArrayList<OperationDimension>
		for(os:oss)
			for(odim:os.opModeDimension)
				if(dimname==operationDimensionName(odim))
					ret.add(odim)
		return ret
	}
	
	def static OperationDimensionValue findOverlapValuesForAllDimensions (List<List<String>> values, String dimname){
		var odv = AgriDSLFactoryImpl::init.createOperationDimensionValue
		odv.opModeDimensionName.add(dimname)
		var ret_values = new ArrayList<String>
		for(value:values.head){
			var all_contain=true
			for(other_dim:values.tail){
				if (!other_dim.contains(value))
					all_contain=false // value is not contained in each dimension
			}
			if(all_contain)
				ret_values.add(value)
		}
		odv.value.addAll(ret_values)
		odv.opModeDimensionName.add("no_name_values")
		return odv
	}
	
	def static OperationDimensionInterval findOverlapIntervalForAllDimensions (List<Integer> begins, List<Integer> ends, String dimname){
		// compute the range that is supported by all dimensions
		var odi = AgriDSLFactoryImpl::init.createOperationDimensionInterval
		odi.opModeDimensionName.add(dimname)
		var range = AgriDSLFactoryImpl::init.createRange
		range.begin = Collections.max(begins)
		range.end = Collections.min(ends)
		odi.range.add(range)
		odi.opModeDimensionName.add("no_name_range")
		return odi
	}
	
	def static List<List<String>> extractOperationDimensionsValues (List<OperationDimension> ods){
		// extracts the values for a set of the same dimensions to prepare a computation
		var List<List<String>> values = new ArrayList<List<String>>
		for(od:ods)
			switch(od){
				OperationDimensionValue: {
					values.add(od.value)
				}
			}
		return values
	}
	
	def static Pair<List<Integer>,List<Integer>> extractOperationDimensionsIntegers (List<OperationDimension> ods){
		// extracts the ranges for a set of the same dimensions to prepare a computation		
		var ranges_begin = new ArrayList<Integer>
		var ranges_end = new ArrayList<Integer>
		for(od:ods)
			switch(od){
				OperationDimensionInterval:{
					ranges_begin.add(od.range.head.begin)
					ranges_end.add(od.range.head.end)}
					
			}
		return new Pair(ranges_begin,ranges_end)
	}
	
	def static Set<String> gatherDimensionNames(List<OperationSpace> oss){
		var Set<String> dimNames = new HashSet<String>
		for(os:oss) // gather all the dimension names
			for(dim:os.opModeDimension)
				dimNames.add(operationDimensionName(dim))	
		return dimNames	
	}
	
	def static String operationDimensionName (OperationDimension od){
		switch(od){
			OperationDimensionValue: return od.opModeDimensionName.head
			OperationDimensionInterval: return od.opModeDimensionName.head
		}		
	}
	
	def static boolean areOfSameType (List<OperationDimension> ods){
		var value=0
		var interval=0
		for(od:ods)
			switch(od){
				OperationDimensionValue: value=value+1
				OperationDimensionInterval: interval=interval+1
			}
		return (value==0)||(interval==0)	
	}
	
	def static boolean value_dimension (OperationDimension od){
		switch(od){
				OperationDimensionValue: return true
				OperationDimensionInterval: return false
		}
	}
}