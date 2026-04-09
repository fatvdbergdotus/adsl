package org.generator.dslpaper2

import org.generator.ExecutionEngine
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.JavaIoFileSystemAccess
import java.io.PrintWriter
import java.io.BufferedWriter
import java.io.FileWriter
import org.generator.ConfigurationManager
import org.agriDSL.ConfigKeyValue
import java.util.ArrayList
import java.util.List
import java.io.File

class UMLsequenceEngine {
	def static void main(String[] args) {
		ConfigurationManager.loadConfg(new ArrayList<ConfigKeyValue>)
		var iterations=new ArrayList<List<String>>

		var path="c:\\temp\\"
		evaluateUML(path+"umlDiagramSpecificAll.dat", UMLsequenceRequirementEngineSpecific(exampleIterations,true)) // all iterations
		evaluateUML(path+"umlDiagramSpecificFirstLast.dat", UMLsequenceRequirementEngineSpecific(exampleIterations,false)) // first+last iteration
		evaluateUML(path+"umlDiagramGeneric.dat",  UMLsequenceRequirementEngineGeneric)
		evaluateUML(path+"umlDiagramPseudo.dat",  UMLsequenceRequirementEnginePseudo)
		
	}
	
	def static List<List<String>> exampleIterations (){
		var ret = new ArrayList<List<String>>
		var i1 = new ArrayList<String>
		i1.add("Entropy")
		i1.add("357")
		i1.add("requirement1")
		i1.add("requirement2")
		i1.add("requirement3")
		i1.add("requirement157")
		i1.add("requirement158")
		i1.add("requirement16")
		i1.add("requirement20")
		i1.add("business")
		i1.add("legal")
		i1.add("requirement1620")
		i1.add("legal")
		i1.add("firstDesign")
		i1.add("secondDesign")
		i1.add("lastDesign")
		i1.add("Coerce")
		i1.add("Jaccard")
		i1.add("6.5")
		i1.add("3450")
		i1.add("1")
		
		var i2 = new ArrayList<String>
		i2.add("Jaccard")
		i2.add("18.7")
		i2.add("requirement1a")
		i2.add("requirement2a")
		i2.add("requirement3a")
		i2.add("requirement157a")
		i2.add("requirement158a")
		i2.add("requirement16a")
		i2.add("requirement20a")
		i2.add("user")
		i2.add("technical")
		i2.add("requirement1620a")
		i2.add("legal")
		i2.add("firstDesignA")
		i2.add("secondDesignA")
		i2.add("lastDesignA")
		i2.add("Conjunction")
		i2.add("Jaccard2")
		i2.add("8.67")
		i2.add("6000")
		i2.add("2")
				
		var i3 = new ArrayList<String>
		i3.add("JaccardC")
		i3.add("18.7C")
		i3.add("requirement1c")
		i3.add("requirement2c")
		i3.add("requirement3c")
		i3.add("requirement157c")
		i3.add("requirement158c")
		i3.add("requirement16c")
		i3.add("requirement20c")
		i3.add("safety")
		i3.add("legal")
		i3.add("requirement1620c")
		i3.add("legal")
		i3.add("firstDesignC")
		i3.add("secondDesignC")
		i3.add("lastDesignC")
		i3.add("Disjunction")
		i3.add("Jaccard3")
		i3.add("9.67")
		i3.add("60001")
		i3.add("3")		
		
		ret.add(i1)
		ret.add(i2)
		ret.add(i3)
		return ret
	}
	
	def static stringToFile (String str, String filename){
	    var BufferedWriter writer = new BufferedWriter(new FileWriter(filename));
    	writer.write(str)
    	writer.close
	}
	
	def static private evaluateUML(String inputfilename, CharSequence cs){
		stringToFile(cs.toString,inputfilename)
		ExecutionEngine.UMLexecuteCommand(inputfilename)
	}
	
	// stores all four UML graphs to disc
	def static writeAllGraphs (String dirname,String inputfilename,List<List<String>> iterations){
		if(ConfigurationManager.lookupValue("generateUMLsequencediagram").equals("yes")){
			new File(dirname).mkdirs
			evaluateUMLSpecific(inputfilename+"specificAll", iterations, true)
			evaluateUMLSpecific(inputfilename+"specificSome", iterations, false)
			evaluateUMLGeneric(inputfilename+"generic")
			evaluateUMLPseudo(inputfilename+"pseudo")
		}
		else
			System.out.println("Warning: UML sequence diagrams are not printed")
	}

	def static evaluateUMLSpecific (String inputfilename, List<List<String>> iterations, boolean displayAllIterations){
		evaluateUML(inputfilename,UMLsequenceRequirementEngineSpecific(iterations,displayAllIterations))
	}

	// The generic algorithm for requirements elicitation with example instances
	def static private CharSequence UMLsequenceRequirementEngineSpecific(List<List<String>> iterations, boolean displayAllIterations){
	'''
	@startuml
	hide footbox
	
	actor Actor
	boundary Interface
	database Design
	database Requirement

	«var ifirst=iterations.head»
	Requirement -> Requirement: generate Requirement «ifirst.get(2)»,\n«ifirst.get(3)», ...,«ifirst.get(6)»
	Interface -> Design: Evaluate all \noperation spaces

	«FOR i:iterations»
		«IF !displayAllIterations && i.get(20)=="2"»...
		«ENDIF»
		«IF displayAllIterations || i.get(20)=="1" || i.get(20)==iterations.length.toString»
			«var entropyjaccard 	  = i.get(0)    /* the method used (Entropy or Jaccard) to determine the closest requirements */»
			«var entropyjaccardval    = i.get(1)    /* the value the method yields*/»
			«var req1    			  = i.get(2)  	/* the 1st requirement */»
			«var req2    			  = i.get(3)  	/* the 2st requirement */»
			«var req3				  = i.get(4)	/* the 3rd requirement */»
			«var reqnmin1			  = i.get(5)  	/* the one to last requirement */»
			«var reqn    			  = i.get(6)  	/* the last requirement */»
			«var req1sel 			  = i.get(7)  	/* the 1st selected requirement */»
			«var req2sel 			  = i.get(8)    /* the 2nd selected requirement */»
			«var req1selOwner         = i.get(9)    /* the owner of the 1st selected requirement */»
			«var req2selOwner         = i.get(10)   /* the owner of the 2nd selected requirement */»
			«var reqnew  		      = i.get(11)	/* the new requirement */»
			«var reqnewOwner          = i.get(12)   /* the owner of the new requirement */»
			«var design1 		      = i.get(13)  	/* the 1st design */»
			«var design2 		      = i.get(14)  	/* the 2st design */»
			«var designn 		      = i.get(15)   /* the last design */»
			«var coercIntersConjCompr = i.get(16)   /* the negotiation method used to turn two requirements into one */»
			«var newreqentropyjaccard = i.get(17)   /* the method used (Entropy or Jaccard) to determine the new owner of the requirement */»
			«var newreqentropyjaccardval = i.get(18) /* the value the method to determine the selected requirements*/»
			«var validateScore        = i.get(19)   /* the score of the validation process */»
			«var cnt                  = i.get(20)   /* the iteration counter */»
			
			group iteration «cnt» out of «iterations.length»
				Interface -> Requirement: Determine the two most similar or least affecting requirements
			
				group «entropyjaccard»
					Requirement -> Design: compute the «entropyjaccard» for requirement «req1» and «req2»
					group Requirement
						Design -> Design: evaluate «design1» for Requirement «req1» and «req2»
						...
						Design -> Design: evaluate «designn» for Requirement «req1» and «req2»
					end
					...
					Requirement -> Design: compute the «entropyjaccard» for requirement «reqnmin1» and «reqn»
					group Requirement
						Design -> Design: evaluate «design1» for requirement «reqnmin1» and «reqn»
						...
					end
					Requirement -> Requirement: Requirement «req1sel» and «req2sel»\nyield the «IF entropyjaccard=="Entropy"»lowest«ELSE»highest«ENDIF» «entropyjaccard», viz., «entropyjaccardval»
				end
				Requirement -> Interface: Requirement «req1sel» and «req2sel»
				
				group «coercIntersConjCompr»
					Interface -> Actor: «req1selOwner» and «req2selOwner» negotiate
				end
				Actor -> Interface: Requirement «reqnew»
				
				group «newreqentropyjaccard»
					Interface -> Requirement: The owner of requirement «reqnew» is «reqnewOwner»
				end
				
				Requirement -> Requirement: Add requirement «reqnew»
				Requirement -> Requirement: Remove requirement «req1sel» and «req2sel»s
			end
		«ENDIF»
	«ENDFOR»
	
	«var validateScore=iterations.last.get(19)»
	Requirement -> Requirement : Validate the requirements («validateScore»)
	
	@enduml	
	'''}
	
	def static evaluateUMLGeneric (String inputfilename){
		evaluateUML(inputfilename,UMLsequenceRequirementEngineGeneric)
	}
	
	// The generic algorithm for requirements elicitation 
	def static private CharSequence UMLsequenceRequirementEngineGeneric()
	'''
	@startuml
	hide footbox
	
	actor Actor
	boundary Interface
	database Design
	database Requirement
	
	loop for a number of ideas
		Requirement -> Requirement: Add the discovered idea/\npremature requirement
	end
	
	loop for a number of iterations
		Interface -> Requirement: Select the two most similar or least affecting requirements
	
		alt Entropy
			loop for each pair of requirements
				Requirement -> Design: Compute entropy for requirements pair
				loop for each design
					Design -> Design: Evaluate the design for both requirements
				end
				Design -> Requirement: The entropy of the requirements pair
			end
			Requirement -> Requirement: Two selected\nrequirements
		else Jaccard
			loop for each pair of requirements
				Requirement -> Design: Compute jaccard for requirements pair
				loop for each design
					Design -> Design: Evaluate the design for both requirements
				end
				Design -> Requirement: The jaccard of the requirements pair
			end
			Requirement -> Requirement: Two selected\nrequirements
		end
		Requirement -> Interface: Two selected requirements to be merged into one
		
		alt Coercion
			Interface -> Actor: Negotiate
		else Intersection
			Interface -> Actor: Negotiate
		else Conjunction
			Interface -> Actor: Negotiate
		else Compromise
			Interface -> Actor: Negotiate
		end
		Actor -> Interface: One new requirement
		
		alt Entropy
			Interface -> Requirement: Determine the owner of the new requirement
		else Jaccard
			Interface -> Requirement: Determine the owner of the new requirement
		end
		
		Requirement -> Requirement: Add the \nnew requirement
		Requirement -> Requirement: Remove the two\n former requirements
	end
	@enduml
	'''
	
	def static evaluateUMLPseudo (String inputfilename){
		evaluateUML(inputfilename,UMLsequenceRequirementEnginePseudo)
	}
	
	def static private CharSequence UMLsequenceRequirementEnginePseudo()
	'''
	@startuml
	hide footbox
	
	actor Actor
	boundary Interface
	database Requirement
	
	loop for a number of ideas
		Requirement -> Requirement: Add the discovered idea/premature requirement
	end
	
	loop for a number of iterations
		Interface -> Requirement: Select two requirements to be merged into one
	
		Requirement -> Interface: Two requirements to be merged into one
		Interface -> Actor: Negotiate
		Actor -> Interface: One new requirement
		
		Interface -> Requirement: Determine the owner of the new requirement
		Requirement -> Requirement: Add the new requirement
		Requirement -> Requirement: Remove the two former requirements
	end
	
		Requirement -> Requirement: Validate the requirements
	
	@enduml
	'''
}