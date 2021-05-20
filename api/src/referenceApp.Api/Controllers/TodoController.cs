using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.FeatureManagement;
using Microsoft.FeatureManagement.Mvc;
using referenceApp.Api.Infrastructure;
using referenceApp.Api.Models;
using referenceApp.Lib.Todos.CreateNewTodo;
using referenceApp.Lib.Todos.Models;
using referenceApp.Lib.Todos.Queries;
using referenceApp.Lib.Todos.ToggleTodoComplete;

namespace referenceApp.Api.Controllers
{
    public class TodoController : ApiControllerBase
    {
        public TodoController(IFeatureManager featureManager) : base(featureManager)
        {
        }

        [HttpGet]
        [Produces("application/json")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<TodoListModel> List()
        {
            return await Mediator.Send(new GetTodosListQuery());
        }

        [HttpPost]
        [Produces("application/json")]
        [Consumes("application/json")]
        [ProducesResponseType(StatusCodes.Status201Created)]
        public async Task<TodoModel> CreateNewTask([FromBody] NewTodoModel model)
        {
            var command = new CreateNewTodoCommand
            {
                Title = model.Title,
                DueDate = model.DueDate
            };

            return await Mediator.Send(command);
        }

        [HttpPut("{id}")]
        [Produces("application/json")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        public async Task<IActionResult> ToggleIsComplete(string id)
        {
            await Mediator.Send(new TodoToggleIsCompleteCommand(id));

            return new NoContentResult();
        }

        [HttpDelete("{id}")]
        [Produces("application/json")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [FeatureGate(FeatureFlags.DeleteTodo)]
        public IActionResult Delete(string id)
        {
            return Ok();
        }
    }
}
