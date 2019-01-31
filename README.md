# GEM_QC

jhchoi@cern.ch

jskim@cern.ch


 Macro for QC5 Response Uniformity

(1) Do all procedre until test run.(50,000events)

- SCRIBE configuration
- Zero Suppression
- Test run with 50,000 events.
- Then, set number of subevent = 250,000 events in "Date"(DAQ_TEST program)


**Make sure that all DAQ setup is stable.




(2)Set variables in "qc_uniformity.sh"
- Set "DETNAME" to the chamber name
>(e.g) DETNAME="GE11-X-S-CERN-0013"

- Set "CURRENT" to the I_mon (in uA) current in HV module.
> (e.g) CURRENT="577"

- Set "Transfer" to the site where to transfer the raw outputs.
>(e.g) Transfer="jhchoi@lxplus.cern.ch:~/GEM/QC5/"

- Set "SAVEDIR" to directory where "cmssrs.raw" is created.
>(e.g) SAVEDIR=/run/media/userSRS/3C10-04F0/GE11-X-S-CERN-0013/

- in line#21, for-statement, set the initial&last value of 'i'. 
'i' is each run number.

**Basically, we set it 2 and 33 each. (=> 32 runs)


(3) Make a new connection to the transfer site.

->To trasfer raw outputs without asking passwords.

> screen -S connection_to_transfer
> ssh USERNAME@<Transfer site>

ctrl+a+d

Now, transfer site doesn't require password when you transfer files via "scp"

**Please test whether it requires passwd OR NOT when you do "scp" to the transfer site.


(4) Then, run the script.
> source qc_uniformity.sh











