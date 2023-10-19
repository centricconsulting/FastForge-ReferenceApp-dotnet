using System;
using referenceApp.Persistence.Models;

namespace referenceApp.Lib.Todos.Models
{
    public class TodoModel
    {
        public TodoModel() { }
        public TodoModel(referenceApp.Persistence.Models.Todo todo)
        {
            Id = todo.Id;
            Title = todo.Title;
            Description = todo.Description;
            WhenCreated = todo.WhenCreated;
            IsComplete = todo.IsComplete;
            IsUrgent = todo.IsUrgent;
        }

        public Guid Id { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public DateTime WhenCreated { get; set; }
        public bool? IsComplete { get; set; }
        public bool IsUrgent { get; set; }
    }
}
