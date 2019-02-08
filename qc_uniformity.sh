##Author:
#Junho Choi : jhchoi@cern.ch,
#Jaesung Kim : jskim@cern.ch

#Reference 
#/var/www/html/srs_v3.php
#/var/www/cgi-bin/start_Date.sh

##Before start
##screen -S connectionfortrans
##ssh TRANSsite

##set env variables###
DAQ_ROOT_DOMAIN_NAME=DATE
SMI_STATE=DATEdaq_test_daq::daq_test_control

##Set names
#DETNAME="GE11-X-S-CERN-0013"
#CURRENT="577"
DETNAME="GE11-X-S-CERN-0013"
CURRENT="577"
TRANSFER="jskim@147.47.242.71:~/Documents/GEM/QC5/"
SAVEDIR=/run/media/userSRS/3C10-04F0/GE11-X-S-CERN-0013/
I_START=2
I_FINAL=33
##Run each 250k events
##i=run number##
for i in `seq ${I_START} ${I_FINAL}`; 
do
    echo $i" run"

   ##"Start Process" button on "Ready to Start" in DAQ_TEST program
    while [ TRUE ]
    do
	state=`/ecs/ECS/Linux/smiGetState $SMI_STATE`
	index=`echo \`expr index "$state" /\``
	let index-=1
	state=`echo ${state:0:$index}`
	if [[ "$state" == "READY" ]] ##When the button is activated
	then
	##Click the button
	    /opt/smi/linux/smiSendCommand $SMI_STATE START_PROCESSES/CONFIG=DEFAULT
	    break
	fi
    done
     ##"Start" button in "Data taking" in DAQ_TEST
    
    while [ TRUE ]
    do
	state=`/ecs/ECS/Linux/smiGetState $SMI_STATE`
	index=`echo \`expr index "$state" /\``
	let index-=1
	state=`echo ${state:0:$index}`
	if [[ "$state" == "STARTED" ]]
	##When the button is activated
	then
	##Click the button
	    /opt/smi/linux/smiSendCommand $SMI_STATE START_DATA_TAKING
	    break
	fi
    done
    
    ##"Start run" in DAQ tap of SCRIBE
    date +%s > /srsconfig/unixstart
    /var/www/cgi-bin/slow_control /var/www/cgi-bin/startTest.txt

    ##Now run a 250k event job.


    ##Check the run is finished##
    while [ TRUE ]
    do
	##Check status == READY ( When "Start Process" butteon on "Ready to Start" is activated ), 
	##which means the run is finished
	##Every 30 secs
	
        state=`/ecs/ECS/Linux/smiGetState $SMI_STATE`
        index=`echo \`expr index "$state" /\``
        let index-=1
	state=`echo ${state:0:$index}`
        if [[ "$state" == "READY" ]]
        then
	    
	    break
	    ##If the run is finished, break the loop
        fi
	sleep 30
    done
    
    ##"stop run" in DAQ tap of SCRIBE 
    /var/www/cgi-bin/slow_control /var/www/cgi-bin/stopTest.txt

    ##change filename
    pushd $SAVEDIR ##Go to the location where "cmssrs.raw" is
    filename=${DETNAME}"_Run"`printf %04d $i`"_Physics_"${CURRENT}"uA_XRay_40kV_100uA_250kEvt.raw"
    mv cmssrs.raw $filename
    scp $filename ${TRANSFER}"/"
    popd
##Go back to the next run.
done    


echo "@@FINISH : QC5 UNIFORMITY@@"
