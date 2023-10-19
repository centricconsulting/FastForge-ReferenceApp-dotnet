using System;

namespace referenceApp.Persistence.Models
{
    public class Todo
    {
        public Guid Id { get; set; } = Guid.NewGuid();
        public string Title { get; set; }
        public string Description { get; set; }
        public bool? IsComplete { get; set; } = false;
        public DateTime WhenCreated { get; set; }
        public bool IsUrgent { get; set; }
    }
}
