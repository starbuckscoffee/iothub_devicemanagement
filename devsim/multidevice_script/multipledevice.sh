#!/bin/bash
iothubname="<iot hub name>"
for i in 1 2 3 4 5 6 7 8 9 10
do
    # Create a new device Id
    echo Creating device Id simulateddevice$i
    az iot hub device-identity create --hub-name $iothubname --device-id simulateddevice$i

    # Set tag value for customer name (alternating between 2 customers names)
    echo Adding customer tag in device twin
    if [ $i -gt 5 ]
    then
        az iot hub device-twin update --device-id simulateddevice$i --hub-name $iothubname --set tags="{\"customer\":{\"name\":\"Smith\"}}"
    else
        az iot hub device-twin update --device-id simulateddevice$i --hub-name $iothubname --set tags="{\"customer\":{\"name\":\"Lewis\"}}"
    fi

    # Start the device simulator
    connectionString=$(az iot hub device-identity show-connection-string --hub-name $iothubname --device-id simulateddevice$i)
    connectionString=${connectionString#*: \"}
    connectionString=${connectionString%\"*}
    echo Starting device simulator $i with connection string $connectionString
    dotnet run "$connectionString" &
done
