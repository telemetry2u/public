using System;
using System.Threading.Tasks;
using System.Linq;

// Simple C# console project demonstrating use of the Telemetry2U APi
// to retrieve data from LoRaWAN nodes.

// MIT License
// Copyright (c) 2021 Telemetry2U Pty Lrd
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

namespace Telemetry2U
{
    class ConsoleDemo
    {
        static async Task Main()
        {
            // Your API key and authorization string may be generated under the Account / Api Keys section of your Telemetry2U account.
            // The following authorization details are for the demo account and may be used for experimentation.
            var api = new T2Uapi(email: "demo@example.org",
                apiKey: "P9x6dh+IzYaUu5/fPzc/RYfHwW1n/H25+l1Seb/Scz1Q");

            // Print list of nodes Ids and descriptions
            var nodes = await api.GetNodes();
            Console.WriteLine("Node Id\t\t\t\t\tDescription");
            foreach (var node in nodes)
            {
                Console.WriteLine($"{node.nodeId}\t{node.description}");
            }
            Console.WriteLine();

            // Retrieve last 7 days of data for "LHT65 Fridge/Freezer Demo"
            var nodeId = nodes.Where(n => n.description == "LHT65 Fridge/Freezer Demo")
                .Select(n => n.nodeId)
                .Single();
            var data = await api.GetData(nodeId, DateTime.UtcNow.Date.AddDays(-7), endDate: DateTime.MaxValue);

            // If data was retrieved print the list of keys in the dictionary
            if (data.Count > 0)
            {
                var keyList = string.Join(",", data[0].Keys);
                Console.WriteLine($"Keys: {keyList}");
                Console.WriteLine();
            }

            // Display time, temperature and humidity values for first 10 records
            Console.WriteLine("Rx Time (UTC)\t\tTemp\tHumidity");
            foreach (var row in data.Take(10))
            {
                var rxTimeLocal = DateTime.Parse(row["RxTimeUtc"]);
                var intTemp = decimal.Parse(row["Int. Temperature"]);
                var intHumidity = decimal.Parse(row["Int. Humidity"]);
                Console.WriteLine($"{rxTimeLocal}\t{intTemp}\t{intHumidity}");
            }
        }
    }
}
