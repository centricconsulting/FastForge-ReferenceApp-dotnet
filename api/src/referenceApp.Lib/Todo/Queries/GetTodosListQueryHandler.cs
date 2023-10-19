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

            var query = todos.Select(t => new TodoModel
            {
                Id = t.Id,
                Title = t.Title,
                Description = t.Description,
                WhenCreated = t.WhenCreated,
                IsComplete = t.IsComplete,
                IsUrgent = t.IsUrgent
            });

            if (request.Limit.HasValue && request.Page.HasValue)
            {
                query = query.Skip((request.Page.Value - 1) * request.Limit.Value).Take(request.Limit.Value);
            }

            result.Todos = await query.ToListAsync(cancellationToken);

            return result;
        }
    }
}
