package org.generator.dslpaper3

import java.util.List
import org.agriDSL.Distribution
import org.generator.ExecutionEngine
import org.generator.ConfigurationManager

class createGNUplot {
	def static CharSequence PiechartGNUplotCharSequence (double valRed, double valOrange, double valGreen, double valBlue, double valBlack, String filename){
		var double sum    = valRed + valOrange + valGreen + valBlue + valBlack
		var double split1 = (360 * valRed) / sum
		var double split2 = (360 * (valRed+valOrange) ) / sum
		var double split3 = (360 * (valRed+valOrange+valGreen) ) / sum
		var double split4 = (360 * (valRed+valOrange+valGreen+valBlue) ) / sum
	'''
		set term png size 200,240
		set output "«replaceBackSlashesBySlashes(filename)».png"
		
		#set label "Utilization chart" at screen 0,0
		
		set size square
		set style fill solid 1.0 border -1
		
		set object 1 circle at screen 0.5,0.5 size \
		  screen 0.45 arc [0 : «split1»] fillcolor rgb "red" front
		set object 2 circle at screen 0.5,0.5 size \
		  screen 0.45 arc [«split1» : «split2»] fillcolor rgb "orange" front
		set object 3 circle at screen 0.5,0.5 size \
		  screen 0.45 arc [«split2» : «split3»] fillcolor rgb "green" front
		set object 4 circle at screen 0.5,0.5 size \
		  screen 0.45 arc [«split3» : «split4»] fillcolor rgb "blue" front
		set object 5 circle at screen 0.5,0.5 size \
		  screen 0.45 arc [«split4» : 360] fillcolor rgb "black" front
		
		#plot a white line, i.e., plot nothing
		unset border
		unset tics
		unset key
		plot x with lines lc rgb "#ffffff"	
	'''}
	
	// default output format for GNUplot is PDF, size x squared.
	def static CharSequence DistributionsToGNUplotCharSequence (List<Distribution> ds, List<String> dnames, String filename, List<String> dsm, List<String> dsi){
		return DistributionsToGNUplotCharSequence (ds,dnames,filename,dsm,dsi,"png","300","150")
	}
	
	def static CharSequence DistributionsToGNUplotCharSequence (List<Distribution> ds, List<String> dnames, String filename, List<String> dsm, 
																List<String> dsi, String outputtype){
		return DistributionsToGNUplotCharSequence(ds,dnames,filename,dsm,dsi,outputtype,"300","300")														
	}
	
	def static CharSequence DistributionsToGNUplotCharSequence (List<Distribution> ds, List<String> dnames, String filename, List<String> dsm, 
																List<String> dsi, String outputtype, String x, String y){
		var maxValue=DistributionFunctions.maxValueDistributions(ds,dsm,dsi)
		'''
		set term «outputtype» size «x»,«y»
		set output "«replaceBackSlashesBySlashes(filename)».«outputtype»"
		set yrange[0:1] # CDF
		set xrange[0:«maxValue*1.1»]
		set key left top
		plot «FOR dname:dnames»"-" with lines title '«dname»', «ENDFOR»
		«FOR d:ds»«DistributionFunctions.PrintDistributionNumbers(DistributionFunctions.DistributionToNumbers(d,dsm,dsi))»
		«ENDFOR»
		'''	
	}
	
	def static String replaceBackSlashesBySlashes (String filename){
		filename.replace('\\','/')
	}
	
	def static DistributionsToGNUplot (List<Distribution> ds, List<String> dnames, String filename, List<String> dsm, List<String> dsi){
		var CharSequence cs = DistributionsToGNUplotCharSequence(ds,dnames,filename,dsm,dsi)
		ExecutionEngine.GNUplotExecuteCommand(cs,filename)
	}
	
	def static PiechartGNUplot (double valRed, double valOrange, double valGreen, double valBlue, double valBlack, String filename){
		var CharSequence cs = PiechartGNUplotCharSequence (valRed, valOrange, valGreen, valBlue, valBlack, filename)
		ExecutionEngine.GNUplotExecuteCommand(cs,filename)
	}
}