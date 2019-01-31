# GEM_QC

jhchoi@cern.ch

jskim@cern.ch


QC5 Response Uniformity Macro.

(1) Do all procedre until test run.(50,000events)

- SCRIBE configuration
- Zero Suppression
- Test run with 50,000 events.
- Then, set number of subevent = 250,000 events


**Make sure that all DAQ setup is stable.



(2)in "qc_uniformity.sh"
- Set "DETNAME" to the chamber name
- Set "CURRENT" to the I_mon (in uA) current in HV module.
- Set "Transfer" to the site where to transfer the raw outputs.
- Set "SAVEDIR" to directory where "cmssrs.raw" is created.
- in line#20, for-statement, set the initial&last value of 'i'. 

'i' is each run number.

**Basically, we set it 2 and 33 each. (=> 32 runs)



-Then,
> source qc_uniformity.sh











