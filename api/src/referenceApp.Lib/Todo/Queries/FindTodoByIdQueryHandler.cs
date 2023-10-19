using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using MediatR;
using Microsoft.EntityFrameworkCore;
using referenceApp.Lib.Todos.Models;
using referenceApp.Persistence;

namespace referenceApp.Lib.Todos.Queries
{
    public class FindTodoByIdQueryHandler : IRequestHandler<FindTodoByIdQuery, TodoModel>
    {
        private readonly ReferenceDbContext _context;

        public FindTodoByIdQueryHandler(ReferenceDbContext context)
        {
            _context = context;
        }

        public async Task<TodoModel> Handle(FindTodoByIdQuery request, CancellationToken cancellationToken)
        {
            var todos = _context.Todos;
            var result = new TodoModel();

            result = await todos.Where(x => x.Id == request.Id).Select(t => new TodoModel
            {
                Id = t.Id,
                Title = t.Title,
                Description = t.Description,
                WhenCreated = t.WhenCreated,
                IsComplete = t.IsComplete,
                IsUrgent = t.IsUrgent
            }).FirstOrDefaultAsync(cancellationToken);

            return result;
        }
    }
}
