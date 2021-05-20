using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using MediatR;
using Microsoft.EntityFrameworkCore;
using referenceApp.Persistence;

namespace referenceApp.Lib.Todos.ToggleTodoComplete
{
    public class TodoToggleIsCompleteCommandHandler : IRequestHandler<TodoToggleIsCompleteCommand, Unit>
    {
        private readonly ReferenceDbContext _context;

        public TodoToggleIsCompleteCommandHandler(ReferenceDbContext context)
        {
            _context = context;
        }

        public async Task<Unit> Handle(TodoToggleIsCompleteCommand request, CancellationToken cancellationToken)
        {
            var todo = await _context.Todos.Where(t => t.Id == request.Id).FirstOrDefaultAsync();

            if (todo == null)
                return Unit.Value;

            if (todo.IsComplete.HasValue)
                todo.IsComplete = !todo.IsComplete;
            else
                todo.IsComplete = true;

            await _context.SaveChangesAsync(cancellationToken);

            return Unit.Value;
        }
    }
}
