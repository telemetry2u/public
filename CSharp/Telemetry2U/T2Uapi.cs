using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;

namespace Telemetry2U
{
    public class T2Uapi
    {
        private const string host = "https://telemetry2u.com";
        private readonly HttpClient client;

        public T2Uapi(string email, string apiKey)
        {
            string authorization = System.Convert.ToBase64String(Encoding.GetEncoding("ISO-8859-1").GetBytes(email + ":" + apiKey));
            client = new HttpClient();
            client.DefaultRequestHeaders.Add("Authorization", "Bearer " + authorization);
        }

        private async Task<string> GetJson(string request)
        {
            var response = await client.GetAsync($"{host}/api/{request}");
            response.EnsureSuccessStatusCode();
            return await response.Content.ReadAsStringAsync();
        }

        public async Task<List<Node>> GetNodes()
        {
            var json = await GetJson("nodes");
            if (json.Length > 0 && json[0] != '[')
            {
                throw new Exception(json);
            }
            var result = JsonSerializer.Deserialize<List<Node>>(json);
            return result ?? new List<Node>();
        }

        public async Task<List<Dictionary<string,string>>> GetData(string nodeId, DateTime startDate, DateTime endDate)
        {
            var json = await GetJson($"data/{nodeId}/{startDate:yyyy-MM-dd}/{endDate:yyyy-MM-dd}");
            var options = new JsonSerializerOptions();
            options.Converters.Add(new StringConverter());
            var data = JsonSerializer.Deserialize<List<Dictionary<string, string>>>(json, options);
            return data ?? new List<Dictionary<string, string>>();
        }

        private class StringConverter : System.Text.Json.Serialization.JsonConverter<string>
        {
            public override string Read(ref Utf8JsonReader reader, Type typeToConvert, JsonSerializerOptions options)
            {
                if (reader.TokenType == JsonTokenType.Number)
                {
                    return reader.GetDecimal().ToString();
                }
                return reader.GetString() ?? "";
            }

            public override void Write(Utf8JsonWriter writer, string value, JsonSerializerOptions options)
            {
                writer.WriteStringValue(value);
            }
        }
    }
}
