using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using MediatR;
using Microsoft.EntityFrameworkCore;
using referenceApp.Lib.Todos.Models;
using referenceApp.Persistence;

namespace referenceApp.Lib.Todos.Queries
{
    public class GetTodosListQueryHandler : IRequestHandler<GetTodosListQuery, TodoListModel>
    {
        private readonly ReferenceDbContext _context;

        public GetTodosListQueryHandler(ReferenceDbContext context)
        {
            _context = context;
        }

        public async Task<TodoListModel> Handle(GetTodosListQuery request, CancellationToken cancellationToken)
        {
            var todos = _context.Todos;
            var result = new TodoListModel();

            result.Todos = await todos.Select(t => new TodoModel
            {
                Id = t.Id,
                Title = t.Title,
                DueDate = t.DueDate,
                WhenCreated = t.WhenCreated,
                IsComplete = t.IsComplete
            }
            ).ToListAsync(cancellationToken);

            return result;
        }
    }
}
