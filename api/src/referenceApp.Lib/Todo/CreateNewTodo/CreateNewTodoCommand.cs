using System;
using MediatR;
using referenceApp.Lib.Todos.Models;

namespace referenceApp.Lib.Todos.CreateNewTodo
{
    public class CreateNewTodoCommand : IRequest<TodoModel>
    {
        public Guid Id { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public DateTime WhenCreated { get; set; } = DateTime.UtcNow;
        public bool IsUrgent { get; set; }
    }
}
