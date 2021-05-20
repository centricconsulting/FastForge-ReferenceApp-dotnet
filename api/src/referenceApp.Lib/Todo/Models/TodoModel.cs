using System;
using referenceApp.Persistence.Models;

namespace referenceApp.Lib.Todos.Models
{
    public class TodoModel
    {
        public TodoModel() { }
        public TodoModel(Todo todo)
        {
            Id = todo.Id;
            Title = todo.Title;
            DueDate = todo.DueDate;
            WhenCreated = todo.WhenCreated;
            IsComplete = todo.IsComplete;
        }

        public Guid Id { get; set; }
        public string Title { get; set; }
        public DateTime? DueDate { get; set; }
        public DateTime WhenCreated { get; set; }
        public bool? IsComplete { get; set; }
    }
}
