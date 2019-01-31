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




(2)Set variables in "qc_uniformity.sh"
- Set "DETNAME" to the chamber name
- Set "CURRENT" to the I_mon (in uA) current in HV module.
- Set "Transfer" to the site where to transfer the raw outputs.
>(e.g) jhchoi@lxplus.cern.ch:~/GEM/QC5/
- Set "SAVEDIR" to directory where "cmssrs.raw" is created.
- in line#20, for-statement, set the initial&last value of 'i'. 

'i' is each run number.

**Basically, we set it 2 and 33 each. (=> 32 runs)


(3) Make a new connection to the transfer site.

->To trasfer rawoutputs without asking passwords.

> screen -S connection_to_transfer
ssh USERNAME@<Transfer site>
ctrl+a+d

Now, transfer site doesn't require password when you transfer files via "scp"

**Please test whether it requires passwd OR NOT when you do "scp" to the transfer site.


(4) Then, run the script.
> source qc_uniformity.sh











