
#pragma rtGlobals=1		// Use modern global access method.
function init() // 

	string KEresponse
	print "\r";print "\r";print "\r";print "\r";
	VDTWrite2 "*IDN?\n"; VDTREAD2/T="\n" KEresponse; print "IDN: ", KEresponse
	VDTWrite2 "*IDN?\n"; VDTREAD2/T="\n" KEresponse; print "IDN: ", KEresponse
	VDTWrite2 "*IDN?\n"; VDTREAD2/T="\n" KEresponse; print "IDN: ", KEresponse
	VDTWrite2 "*IDN?\n"; VDTREAD2/T="\n" KEresponse; print "IDN: ", KEresponse

	VDTWrite2 ":CONF\n";VDTWrite2 ":READ?\n";VDTREAD2/T="\n" KEresponse;print "MEAS = ", KEresponse;
	VDTWrite2 ":CONF\n";VDTWrite2 ":READ?\n";VDTREAD2/T="\n" KEresponse;print "MEAS = ", KEresponse
	VDTWrite2 ":CONF\n";VDTWrite2 ":READ?\n";VDTREAD2/T="\n" KEresponse;print "MEAS = ", KEresponse
	VDTWrite2 ":CONF\n";VDTWrite2 ":READ?\n";VDTREAD2/T="\n" KEresponse;print "MEAS = ", KEresponse
	VDTWrite2 ":CONF\n";VDTWrite2 ":READ?\n";VDTREAD2/T="\n" KEresponse;print "MEAS = ", KEresponse
	VDTWrite2 "*CLS\n"

end

function initKE6485(numPoints, deltaT) // Zahl der Messungen, Zeit zwischen 2 Messungen in ticks (=1/60 s)
	variable numPoints
	variable deltaT
	variable/G j=0
	variable/G deltaTGlobal = deltaT
	string KEresponse
	string/G WaveNameStr  = UniqueName("KE_", 1, 0 )
	make/O/N=(numpoints) $WaveNameStr
	wave w = $WaveNameStr
	w=NaN
	display w
	ModifyGraph grid=1,mirror=1,minor=1,gridStyle=3,gridRGB=(65280,43520,32768)
	VDTWrite2 ":MEAS?\n";VDTREAD2/T="\n" KEresponse;print "MEAS = ", KEresponse
	VDTWrite2 ":SYST:ERR?\n";VDTREAD2/T="\n" KEresponse;print "ERR = ", KEresponse
end

function KE6485(s)
	STRUCT WMBackgroundStruct &s
	string response, junk, resultStr
	variable resultVar
	variable/G j
	string/G  WaveNameStr
	wave w = $WaveNameStr
	if (j >= numpnts(w))
		StopKeithleyRead()
		return 0
	endif
	VDTWrite2 ":MEAS?\n"
	VDTREAD2/T="\n" response;//print response
	resultStr=StringFromList(0, response, ",")
	resultStr = removeEnding(resultStr)
	//print resultStr
	resultVar = str2Num(resultStr)
	resultvar *= -1
	w[j]=resultvar
	j += 1
	//print time(), resultVar
	return 0
end


Function StartKeithleyRead()
	variable/G deltaTGlobal
	string/G WaveNameStr
	beep
	print "Now read data into Wave", WaveNameStr
	CtrlNamedBackground KERead, period=deltaTGlobal, proc=KE6485
	CtrlNamedBackground KERead, start
End

Function StopKeithleyRead()
	CtrlNamedBackground KERead, stop
	print "Finished"
	beep;
End