# Telemetry2U Public Repository
This repository contains the following sample code related to the [Telemetry2U](https://telemetry2u.com) platform for LoRaWAN sensor networks.

Path | Description
------------- | -------------
CSharp/ | Simple Telemetry2U API sample console application using C# and .NET5
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