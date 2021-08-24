# Simple Octave / MATLAB  script demonstrating use of the Telemetry2U APi
# to retrieve data from LoRaWAN nodes.

# MIT License
# Copyright (c) 2021 Telemetry2U Pty Lrd
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

pkg load io;

# Call api/nodes endpoint to retrieve list of all nodes
url = "https://telemetry2u.com/api/nodes";

# Your API key and authorization string may be generated under the Account / Api Keys section of your Telemetry2U account.
# The following authorization details are for the demo account and may be used for experimentation.
authorization = "Basic ZGVtb0BleGFtcGxlLm9yZzpQOXg2ZGgrSXpZYVV1NS9mUHpjL1JZZkh3VzFuL0gyNStsMVNlYi9TY3oxUQ==";
options = weboptions('HeaderFields',{'Authorization', authorization});
nodes = fromJSON(webread(url, options=options));

# Print list of node descriptions.
nodes.description

# Find nodeId for "LHT65 Fridge/Freezer Demo"
nodeIndex = find(not(cellfun('isempty',strfind({nodes(:).description}, "LHT65 Fridge/Freezer Demo"))));
nodeId = nodes(nodeIndex).nodeId;

# Call api/data endpoint to retrieve data for node for past week.
secondsPerDay = 86400
startDate = strftime ("%Y-%m-%d", localtime (time () - 7 * secondsPerDay))
endDate = "9999-12-31"; # Use large end date to retrieve most recent data
url = sprintf("https://telemetry2u.com/api/data/%s/%s/%s", nodeId, startDate, endDate);
data = fromJSON(webread(url, options=options));

# Print last data item (most recent data received from node).
data(:,end)

# Convert data to cells for plotting.
celldata = struct2cell(data);

# Plot internal temperature.
idx = find(not(cellfun('isempty',strfind(fieldnames(data(:,1)), "Int. Temperature"))));
internalTemperature = d(idx,:);
y = cell2mat(internalTemperature);
plot(y);

# Plot internal humidity on same chart.
hold on;
idx = find(not(cellfun('isempty',strfind(fieldnames(data(:,1)), "Int. Humidity"))));
internalHumidity = d(idx,:);
y = cell2mat(internalHumidity);
plot(y);
hold off;
