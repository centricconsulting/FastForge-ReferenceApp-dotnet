using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using MediatR;
using referenceApp.Lib.Todos.Models;

namespace referenceApp.Lib.Todos.Queries
{
    public class FindTodoByIdQuery : IRequest<TodoModel>
    {
        public Guid Id { get; set; }

        public FindTodoByIdQuery(Guid id)
        {
            Id = id;
        }
    }
}
