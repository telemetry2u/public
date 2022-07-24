# Telemetry2U Public Repository
This repository contains the following sample code related to the [Telemetry2U](https://telemetry2u.com) platform for LoRaWAN sensor networks.

Path | Description
------------- | -------------
CSharp/ | Simple Telemetry2U API sample console application using C# and .NET 6
Excel/  | Microsoft Excel / VBA example of retrieving new data from the REST API
Octave/ | Simple Telemetry2U API sample script written using Octave / MATLAB
Python/ | Simple Telemetry2U API sample script written using Python 3

# API Description
The API provides read-only access to the LoRaWAN nodes that you have access to under your Telemetry2U account.
Your API key and authorization string may be generated under the Account / Api Keys section of your account and should 
be sent in the authorization header field of each RESTful API call. Please keep these keys confidential and the terms
of use prohibit placing calls to the API from public-facing web sites.

The following end-points are available:

https://telemetry2u.com/api/nodes

Returns the nodes that you have access to.

https://telemetry2u.com/api/data/{nodeId}

Returns the last received record for the specified node.

https://telemetry2u.com/api/data/{nodeId}/{startDate}/{endDate}

Returns all data received from a node between the start and end dates that are specified as UTC.
They should be in the ANSI format YYYY-DD-MM or YYYY-DD-MM HH:MM:SS.

## Example data from https://telemetry2u.com/api/nodes
```
[
   {
      "nodeId":"5504bc3f-a284-45f5-ada2-7851ae4719e0",
      "description":"In-Situ AquaTROLL 500 Demo",
      "latitude":null,
      "longitude":null,
      "notes":"Dragino RS485LN - T2U Demo"
   },
   {
      "nodeId":"66a65c69-0c7a-443b-ada3-ced59e8c46f2",
      "description":"LAQ4 Air Quality Sensor Demo",
      "latitude":null,
      "longitude":null,
      "notes":"Dragino LAQ4 - T2U Demo"
   },
   {
      "nodeId":"91dc80d7-5bca-450c-a2b4-0bfc76577d6b",
      "description":"LDDS01 Sensor Demo",
      "latitude":null,
      "longitude":null,
      "notes":"Dragino LDDS01 - T2U Demo"
   },
   {
      "nodeId":"cfcbe164-809b-433c-8171-40778b860ce3",
      "description":"LDDS75 Distance Meter Demo",
      "latitude":null,
      "longitude":null,
      "notes":"Dragino LDDS75 - T2U Demo"
   },
   {
      "nodeId":"4d8009a0-de51-40da-aa88-a770341576cd",
      "description":"LGT92 GPS/Motion Sensor Demo",
      "latitude":null,
      "longitude":null,
      "notes":"Dragino LGT92 - T2U Demo"
   },
   {
      "nodeId":"5c4c5524-4780-44b1-bde4-f3ae7f835eba",
      "description":"LHT65 Fridge/Freezer Demo",
      "latitude":null,
      "longitude":null,
      "notes":"Dragino LHT65 - T2U Demo"
   },
   {
      "nodeId":"9335c275-8ed1-46b5-8562-eeab07264ce9",
      "description":"LLMS01 Leaf Moisture Sensor - Demo",
      "latitude":null,
      "longitude":null,
      "notes":"Dragino LLMS01 - T2U Demo"
   },
   {
      "nodeId":"b07f4668-f48f-4304-a20a-b69c4d6af9f5",
      "description":"LSE01 Soil Sensor Demo",
      "latitude":null,
      "longitude":null,
      "notes":"Dragino LSE01 - T2U Demo"
   },
   {
      "nodeId":"e25c1a38-d2b7-497c-8c9f-f3d0300c785d",
      "description":"LSN50V2-S31 Temperature/Humidity/VPD Demo",
      "latitude":null,
      "longitude":null,
      "notes":"Dragino LSN50V2-S31 - T2U Demo"
   },
   {
      "nodeId":"a2aaad93-fcbd-489d-bd23-d91ccc979c57",
      "description":"LSPH01 Soil pH Sensor - Demo",
      "latitude":null,
      "longitude":null,
      "notes":"Dragino LSPH01 - T2U Demo"
   },
   {
      "nodeId":"8905405c-49c6-4fe9-9689-839d76b26a01",
      "description":"LT22222LT I/O Controller Demo",
      "latitude":null,
      "longitude":null,
      "notes":"Dragino LT22222LT - T2U Demo"
   },
   {
      "nodeId":"12f26ba9-3b32-45e5-b151-92b5b694670e",
      "description":"Milesight WS523 Power Switch/Meter Demo",
      "latitude":null,
      "longitude":null,
      "notes":"Milesight WS523 - T2U Demo"
   },
   {
      "nodeId":"9803f79c-d425-4b3e-b447-292d92ce6350",
      "description":"Netvox R718N37 3-Phase Current Meter Demo",
      "latitude":null,
      "longitude":null,
      "notes":"Netvox R718N37 - T2U Demo"
   },
   {
      "nodeId":"0819da0a-1b52-4286-bedf-32c64534284f",
      "description":"Netvox RB11E Motion Sensor Demo",
      "latitude":null,
      "longitude":null,
      "notes":"Netvox RB11E - T2U Demo"
   },
   {
      "nodeId":"8f2d629e-1a64-4e30-8369-733cf045d729",
      "description":"RS458LN with DO Sensor Demo",
      "latitude":null,
      "longitude":null,
      "notes":"Dragino RS485LN - T2U Demo"
   },
   {
      "nodeId":"b1185d06-8b2e-43f6-bfb1-07920566c827",
      "description":"RS485BL with SBE37SMP CTD Demo",
      "latitude":null,
      "longitude":null,
      "notes":"Dragino RS485BLDragino RS485LN - T2U Demo"
   }
]
```

## Example data from https://telemetry2u.com/api/data/5c4c5524-4780-44b1-bde4-f3ae7f835eba/2022-07-24/2022-07-25
```
[
   {
      "RxTimeUtc":"2022-07-24T00:07:46.73",
      "RxTimeLocal":"24/07/22 10:07:46",
      "AlertStatus":"C",
      "Int. Temperature":5.2,
      "Temperature":-19.5,
      "Int. Humidity":20.8,
      "Battery":3.01
   },
   {
      "RxTimeUtc":"2022-07-24T00:27:49.093",
      "RxTimeLocal":"24/07/22 10:27:49",
      "AlertStatus":"C",
      "Int. Temperature":5.2,
      "Temperature":-20.1,
      "Int. Humidity":20.0,
      "Battery":3.01
   },
   {
      "RxTimeUtc":"2022-07-24T00:47:52.073",
      "RxTimeLocal":"24/07/22 10:47:52",
      "AlertStatus":"C",
      "Int. Temperature":5.3,
      "Temperature":-19.3,
      "Int. Humidity":25.4,
      "Battery":3.01
   },
   {
      "RxTimeUtc":"2022-07-24T01:07:46.627",
      "RxTimeLocal":"24/07/22 11:07:46",
      "AlertStatus":"C",
      "Int. Temperature":5.5,
      "Temperature":-17.9,
      "Int. Humidity":46.6,
      "Battery":3.01
   },
   {
      "RxTimeUtc":"2022-07-24T01:27:49.06",
      "RxTimeLocal":"24/07/22 11:27:49",
      "AlertStatus":"C",
      "Int. Temperature":5.5,
      "Temperature":-18.2,
      "Int. Humidity":48.0,
      "Battery":3.01
   },
   {
      "RxTimeUtc":"2022-07-24T01:47:52.05",
      "RxTimeLocal":"24/07/22 11:47:52",
      "AlertStatus":"C",
      "Int. Temperature":5.5,
      "Temperature":-18.1,
      "Int. Humidity":41.3,
      "Battery":3.01
   },
   {
      "RxTimeUtc":"2022-07-24T02:07:55.037",
      "RxTimeLocal":"24/07/22 12:07:55",
      "AlertStatus":"C",
      "Int. Temperature":5.6,
      "Temperature":-15.9,
      "Int. Humidity":57.9,
      "Battery":3.01
   }
]
```