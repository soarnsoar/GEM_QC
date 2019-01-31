##Before start
##screen -S connectionfortrans
##ssh TRANSsite
##exit


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

for i in `seq 2 33`;
do
    echo $i" run"
    ##Start Process button on Ready to Start in DAQ_TEST program
    while [ TRUE ]
    do
	state=`/ecs/ECS/Linux/smiGetState $SMI_STATE`
	index=`echo \`expr index "$state" /\``
	let index-=1
	state=`echo ${state:0:$index}`
	if [[ "$state" == "READY" ]]
	then
	    /opt/smi/linux/smiSendCommand $SMI_STATE START_PROCESSES/CONFIG=DEFAULT
	    break
	fi
    done
     ##Start button in Data taking in DAQ_TEST
    
    while [ TRUE ]
    do
	state=`/ecs/ECS/Linux/smiGetState $SMI_STATE`
	index=`echo \`expr index "$state" /\``
	let index-=1
	state=`echo ${state:0:$index}`
	if [[ "$state" == "STARTED" ]]
	then
	    /opt/smi/linux/smiSendCommand $SMI_STATE START_DATA_TAKING
	    break
	fi
    done
    
    ##Start run in DAQ tap of SCRIBE
    date +%s > /srsconfig/unixstart
    /var/www/cgi-bin/slow_control /var/www/cgi-bin/startTest.txt

    while [ TRUE ]
    do
	##Check status == READY
        state=`/ecs/ECS/Linux/smiGetState $SMI_STATE`
        index=`echo \`expr index "$state" /\``
        let index-=1
	state=`echo ${state:0:$index}`
        if [[ "$state" == "READY" ]]
        then
	    
	    break
        fi
	sleep 30
    done
    
    ##stop run
    /var/www/cgi-bin/slow_control /var/www/cgi-bin/stopTest.txt

    ##change filename
    pushd $SAVEDIR
    filename=${DETNAME}"_Run"`printf %04d $i`"_Physics_"${CURRENT}"uA_XRay_40kV_100uA_250kEvt.raw"
    mv cmssrs.raw $filename
    scp $filename ${TRANSFER}"/"${DETNAME}
    popd

done    
