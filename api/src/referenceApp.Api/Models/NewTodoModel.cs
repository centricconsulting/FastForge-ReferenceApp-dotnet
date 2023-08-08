using System;

namespace referenceApp.Api.Models
{
    public class NewTodoModel
    {
        public string Title { get; set; }
        public string Description { get; set; }
        public bool IsUrgent { get; set; }
    }
}
