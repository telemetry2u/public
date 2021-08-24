namespace Telemetry2U
{
    public class Node
    {
#pragma warning disable IDE1006 // Naming Styles
        public string nodeId { get; set; } = "";
        public string description { get; set; } = "";
        public decimal? latitude { get; set; }
        public decimal? longitude { get; set; }
        public string? notes { get; set; }
    }
}
