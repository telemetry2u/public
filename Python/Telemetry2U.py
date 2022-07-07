#!/usr/bin/env python
# Simple Python  script demonstrating use of the Telemetry2U APi
# to retrieve data from LoRaWAN nodes.

# MIT License
# Copyright (c) 2021 Telemetry2U Pty Lrd
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

from http.client import HTTPSConnection
import json
import pandas as pd
import matplotlib.pyplot as plt
from datetime import datetime, timedelta

def do_request(request):
    connection = HTTPSConnection("telemetry2u.com")
    # Your API key and authorization string may be generated under the Account / Api Keys section of your Telemetry2U account.
    # The following authorization details are for the demo account and may be used for experimentation.
    authorization = "Bearer ZGVtb0BleGFtcGxlLm9yZzpQOXg2ZGgrSXpZYVV1NS9mUHpjL1JZZkh3VzFuL0gyNStsMVNlYi9TY3oxUQ=="
    headers = { "Authorization" : authorization}
    connection.request("GET", request, headers=headers)
    response = connection.getresponse()
    data = json.loads(response.read())
    return pd.json_normalize(data)

def main():
    # Retrieve and print list of node ids / descriptions
    nodes = do_request("/api/nodes")
    print(nodes[['nodeId', 'description']])

    # Find nodeId for "LHT65 Fridge/Freezer Demo"
    nodeId = nodes.query("description=='LHT65 Fridge/Freezer Demo'")["nodeId"].values[0]

    # Call api/data endpoint to retrieve data for node for past week.
    startDate = (datetime.now() - timedelta(days=7)).strftime('%Y-%m-%d')
    endDate = "9999-12-31"; # Use large end date to retrieve most recent data
    data = do_request(f"/api/data/{nodeId}/{startDate}/{endDate}")

    data['Int. Temperature'].plot()
    data['Int. Humidity'].plot()
    plt.show()
    
if __name__ == '__main__':
    main()
