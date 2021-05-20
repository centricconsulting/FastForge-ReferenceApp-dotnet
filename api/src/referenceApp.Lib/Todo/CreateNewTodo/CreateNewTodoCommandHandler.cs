using System;
using System.Threading;
using System.Threading.Tasks;
using MediatR;
using Microsoft.EntityFrameworkCore;
using referenceApp.Lib.Todos.Models;
using referenceApp.Persistence;
using referenceApp.Persistence.Models;

namespace referenceApp.Lib.Todos.CreateNewTodo
{
    public class CreateNewTodoCommandHandler : IRequestHandler<CreateNewTodoCommand, TodoModel>
    {
        private readonly ReferenceDbContext _context;

        public CreateNewTodoCommandHandler(ReferenceDbContext context)
        {
            _context = context;
        }

        public async Task<TodoModel> Handle(CreateNewTodoCommand request, CancellationToken cancellationToken)
        {
            var newTodo = new Todo();

            newTodo.Id = request.Id;
            newTodo.Title = request.Title;
            newTodo.DueDate = request.DueDate;
            newTodo.WhenCreated = request.WhenCreated;

            await _context.Todos.AddAsync(newTodo, cancellationToken);

            await _context.SaveChangesAsync(cancellationToken);

            return new TodoModel(newTodo);
        }
    }
}
