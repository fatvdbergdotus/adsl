package org.generator.dslpaper2

import org.generator.ConfigurationManager
import org.agriDSL.ConfigKeyValue
import java.util.ArrayList
import java.util.List
import org.generator.FileOperations

class RandomOrg {
	def static void main(String[] args) {
		init
		System.out.println("")
	}
	
	var static int indexCounter
	var static List<Integer> randomNumbers
	
	new(){ init }
	
	def static updateCounterAndDisplayGeneration(int drawnValue, int maxValue){
		indexCounter=indexCounter+1
		if(ConfigurationManager.lookupValue("displayRandomGenerations").equals("yes"))
			if(indexCounter%10000==0)
				System.out.println("Random number "+indexCounter+" fetched.")
				
		if(ConfigurationManager.lookupValue("displayRandomGenerations").equals("yes"))
			System.out.println("Drawn number "+drawnValue+" out of "+maxValue)
	}
	
	def static init(){
		indexCounter=0
		randomNumbers=new ArrayList<Integer>
		ConfigurationManager.loadConfg(new ArrayList<ConfigKeyValue>)
		var fileInts=ConfigurationManager.lookupValue("randomGeneratorFile")
		randomNumbers.addAll(FileOperations.readFromFile(fileInts))
		System.out.println("")
	}
	
	// returns an integer value on range [0,maxValue)
	def nextInt (int maxValue){
		if(maxValue>100)
			throw new Throwable("RandomOrg nextInt: maxValue>100")
		
		var draw=randomNumbers.get(indexCounter)%maxValue
		updateCounterAndDisplayGeneration(draw,maxValue)
		return draw
	}
	
	def nextBoolean(){
		var draw=(randomNumbers.get(indexCounter)%2)
		updateCounterAndDisplayGeneration(draw,2)
		return draw==1
	}
	
	// returns an integer value on range [0,maxValue)
	def static nextIntStatic (int maxValue){
		if(maxValue>100)
			throw new Throwable("RandomOrg nextInt: maxValue>100")
		
		var draw=randomNumbers.get(indexCounter)%maxValue
		updateCounterAndDisplayGeneration(draw,maxValue)
		return draw
	}
	
	def static nextBooleanStatic (){
		var draw=(randomNumbers.get(indexCounter)%2)
		updateCounterAndDisplayGeneration(draw,2)
		return draw==1
	}
}