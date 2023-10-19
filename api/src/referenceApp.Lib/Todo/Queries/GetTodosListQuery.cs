using MediatR;
using referenceApp.Lib.Todos.Models;

namespace referenceApp.Lib.Todos.Queries
{
    public class GetTodosListQuery : IRequest<TodoListModel>
    {
        public int? Limit { get; set; }
        public int? Page { get; set; }

        public GetTodosListQuery(int? limit = null, int? page = null)
        {
            Limit = limit;
            Page = page;
        }
    }
}
