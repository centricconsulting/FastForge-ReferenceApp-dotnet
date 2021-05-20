using MediatR;
using referenceApp.Lib.Todos.Models;

namespace referenceApp.Lib.Todos.Queries
{
    public class GetTodosListQuery : IRequest<TodoListModel>
    {
    }
}
