using System;
using MediatR;
using referenceApp.Lib.Todos.Models;

namespace referenceApp.Lib.Todos.ToggleTodoComplete
{
    public class TodoToggleIsCompleteCommand : IRequest<Unit>
    {
        public Guid Id { get; set; }

        public TodoToggleIsCompleteCommand() { }
        public TodoToggleIsCompleteCommand(string id)
        {
            Id = new Guid(id);
        }
    }
}
