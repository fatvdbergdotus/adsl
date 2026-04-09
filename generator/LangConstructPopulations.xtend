package org.generator

import org.agriDSL.OperationSpace
import org.agriDSL.DesignSpace
import org.agriDSL.impl.AgriDSLFactoryImpl
import org.agriDSL.ExperimentSpace

class LangConstructPopulations {
	def static void main(String[] args) {
		//operationModePopulation1()
		//operationModePopulation2()
		
		//var oss=LangConstructComputations.mergeOperationSpaces(#[tractor])
		//System.out.println(LangConstructsToString.operationSpaceToString(oss))
		
		//designSpacePopulation()
		
		//var om1and2     = CreateLangConstructs.mergeOMS(#[operationModeMerge1,operationModeMerge2,operationModeMerge3])
		//var str_om1and2 = LangConstructsToString.operationSpaceToString(om1and2)
		//System.out.println(str_om1and2)

		//test_subsetOMS
		
		constructSubsetAndPrintes()
		
		//test_encompasses_requirement
	}
	
	def static void test_encompasses_requirement(){
		// TEST: AgriDSLPaper2Requirements.encompasses (Requirement smallerReq, Requirement largerReq){
		var l1 = #['0','dim1','a','b','c']
		var l2 = #['0','dim2','a','b']
		var l3 = #['1','range1','1','5']
		var os1min = CreateLangConstructs.createOMS(#[l1,l2,l3])

		//var r1=CreateLangConstructs.createRequirement("name",os1min,os1max)
		//var r2=CreateLangConstructs.createRequirement("name",os2min,os2max)
	}
	
	def static test_subsetOMS(){
		System.out.println(CreateLangConstructs.subSetOMS(mediumOS,smallOS))
		System.out.println(CreateLangConstructs.subSetOMS(largeOS,mediumOS))
		System.out.println(CreateLangConstructs.subSetOMS(largeOS,smallOS))
		
		System.out.println(CreateLangConstructs.subSetOMS(smallOS,mediumOS))
		System.out.println(CreateLangConstructs.subSetOMS(mediumOS,largeOS))
		System.out.println(CreateLangConstructs.subSetOMS(smallOS,largeOS))

		System.out.println(CreateLangConstructs.subSetOMS(emptyOS,smallOS))
		System.out.println(CreateLangConstructs.subSetOMS(emptyOS,mediumOS))
		System.out.println(CreateLangConstructs.subSetOMS(emptyOS,largeOS))
		
		System.out.println(CreateLangConstructs.subSetOMS(smallOS,zeroOS))
		System.out.println(CreateLangConstructs.subSetOMS(mediumOS,zeroOS))
		System.out.println(CreateLangConstructs.subSetOMS(largeOS,zeroOS))		
		
		System.out.println(CreateLangConstructs.subSetOMS(zeroOS,smallOS))
		System.out.println(CreateLangConstructs.subSetOMS(zeroOS,mediumOS))
		System.out.println(CreateLangConstructs.subSetOMS(zeroOS,largeOS))

		System.out.println(CreateLangConstructs.subSetOMS(smallOS,emptyOS))
		System.out.println(CreateLangConstructs.subSetOMS(mediumOS,emptyOS))
		System.out.println(CreateLangConstructs.subSetOMS(largeOS,emptyOS))
		
		System.out.println(CreateLangConstructs.subSetOMS(smallOS,smallOS))
		System.out.println(CreateLangConstructs.subSetOMS(mediumOS,mediumOS))
		System.out.println(CreateLangConstructs.subSetOMS(largeOS,largeOS))			
	}
	
	def static emptyOS(){ // each other Operation Space is a subset of this one
		return CreateLangConstructs.createOMS(#[])
	}
	
	def static zeroOS(){ // each other Operation Space is a superset of this one because of one empty dimension
		return CreateLangConstructs.createOMS(#[#['0','zero']])
	}
	
	def static smallOS(){
		var l1 = #['0','dim1','a','b','c']
		var l2 = #['0','dim2','a','b']
		var l3 = #['1','range1','1','5']
		return CreateLangConstructs.createOMS(#[l1,l2,l3])
	}

	def static mediumOS(){
		var l1 = #['0','dim1','a','b','c']
		var l2 = #['0','dim2','a','b']
		var l3 = #['1','range1','0','15']
		return CreateLangConstructs.createOMS(#[l1,l2,l3])
		//return CreateLangConstructs.createOMS(#[l1,l2,l3])		
	}
	
	def static largeOS(){
		var l1 = #['0','dim1','a','b','c']
		var l2 = #['0','dim2','a','b']
		var l3 = #['1','range1','0','500']
		return CreateLangConstructs.createOMS(#[l1,l2,l3])		
	}	

	def static operationModeMerge1(){
		var l1 = #['0','dim5','a','b','c']
		var l2 = #['0','dim2','d','e','f']
		var l3 = #['0','dim3','g','h','i']
		val l4 = #['1','range1','40','50']
		return CreateLangConstructs.createOMS(#[l1,l2,l3,l4])
	}
	
	def static operationModeMerge2(){
		var l2 = #['0','dim2','d','e','f']
		var l1 = #['0','dim1','a','z','c']
		var l3 = #['0','dim3','g','y','i','p','f']
		var l4 = #['0','dim4','a','b']
		var l5 = #['1','range1','5','15']
		var l6 = #['1','range2','8','15']
		return CreateLangConstructs.createOMS(#[l1,l2,l3,l4,l5,l6])
	}
	
	def static operationModeMerge3(){
		var l2 = #['0','dim222','d','e','f']
		var l1 = #['0','dim1','a','z','q']
		var l3 = #['0','dim3','g','y','i','p','f','r','r']
		var l4 = #['0','dim4','a','b']
		var l5 = #['1','range2','7','14']
		return CreateLangConstructs.createOMS(#[l1,l2,l3,l4,l5])
	}	
	
	def static designSpacePopulation(){
		var d1 = #['dim1','val1','val2','val3','val4']
		var d2 = #['dim2','vala','valb','valc','vald','vale']
		var d3 = #['dim3','valq','valr','vals']
		val d4 = #['dim4','0','1']
		var ds=CreateLangConstructs.createDS(#[d1,d2,d3,d4])
		var str=LangConstructsToString.designSpaceToString(ds)
		System.out.println(str)
		
		System.out.println(CreateLangConstructs.designSpaceGetValue(1,2,ds))
		
		//CreateLangConstructs.designInstanceCounter(ds)
		CreateLangConstructs.returnDesignInstances(ds)
		
		//for(cnt:0..CreateLangConstructs.designInstanceCounter(ds).length-1)
		//	System.out.println(CreateLangConstructs.designInstanceCounter(ds).get(cnt))
		
		//for(cnt:0..CreateLangConstructs.returnDesignInstances(ds).length-1)
		//	System.out.println(CreateLangConstructs.returnDesignInstances(ds).get(cnt))
	}
	
	def static OperationSpace tractor (){
		var d1 = #['1','speed','0','70']
		var d2 = #['0','surface','snow','wet','dry']
		var d3 = #['0','surface','snow','wet','dry']
		return CreateLangConstructs.createOMS(#[d1,d2,d3])
	}
	
	def static OperationSpace trailor (){
		var d1 = #['1','speed','0','30']
		return CreateLangConstructs.createOMS(#[d1])
	}

	def static OperationSpace reglularTire (){
		var d1 = #['1','speed','0','100']
		var d2 = #['0','surface','dry']
		return CreateLangConstructs.createOMS(#[d1])
	}
	
	def static OperationSpace allSeasonTire (){
		var d1 = #['1','speed','0','50']
		var d2 = #['0','surface','dry','wet']
		return CreateLangConstructs.createOMS(#[d1])
	}

	def static OperationSpace winterTire (){
		var d1 = #['1','speed','0','20']
		var d2 = #['0','surface','snow']
		return CreateLangConstructs.createOMS(#[d1])
	}

	def static operationModePopulation1 (){
		var list1 = #['0','dim1','A1','B1','C1','D1','E1','F1','G1']
		var list2 = #['0','dim2','A2','B2','C2','D2','E2','F2','G2']
		var list3 = #['0','dim3','A3','B3','C3','D3','E3','F3','G3']
		var list4 = #['0','dim4','A4','B4','C4','D4','E4','F4','G4']
		var list5 = #['0','dim5','A5','B5','C5','D5','E5','F5','G5']
		var listOfLists = #[list1, list2, list3, list4, list5]
	
		var OMS = CreateLangConstructs.createOMS(listOfLists)
		var str = LangConstructsToString.operationSpaceToString (OMS)
		System.out.println(str)
	}

	def static operationModePopulation2 (){
		var list1 = #['0','dim6','A1','B1','C1','D1','E1','F1','G1']
		var list2 = #['1','dim7','6','9']
		var list3 = #['0','dim8','A3','B3','C3','D3','E3','F3','G3']
		var list4 = #['0','dim9','A4','B4','C4','D4','E4','F4','G4']
		var list5 = #['0','dim10','A5','B5','C5','D5','E5','F5','G5']
		var listOfLists = #[list1, list2, list3, list4, list5]
	
		var OMS = CreateLangConstructs.createOMS(listOfLists)
		var str = LangConstructsToString.operationSpaceToString (OMS)
		System.out.println(str)
	}
	
	def static ExperimentSpace constructSubsetAndPrintes(){
		var list1 = #['dim1','val1,1','val1,2','val1,3','val1,4','val1,5']
		var list2 = #['dim2','val2,1','val2,2','val2,3','val2,4','val2,5']
		var list3 = #['dim3','val3,1','val3,2','val3,3','val3,4','val3,5']
		var list4 = #['dim4','val4,1','val4,2','val4,3','val4,4','val4,5']
		var list5 = #['dim5','val5,1','val5,2','val5,3','val5,4','val5,5']
		
		var es = CreateLangConstructs.createES(#[list1,list2,list3,list4,list5])
		var esStr = LangConstructsToString.esToString(es)
		System.out.println(esStr)

		var esSubset = CreateLangConstructs.subsetofES(es,#['dim1','dim3','dim4'])
		var esSubsetStr = LangConstructsToString.esToString(esSubset)
		System.out.println(esSubsetStr)
		
		return es	
	}
	
	//def static OperationSpace emptyOS (){
	//	return CreateLangConstructs.createOMS(#[#['0','osinit','true']]) // To distinguish between empty and uninitialized OperationSpaces 
	//}
	

	

}