using System;
using System.Collections.Generic;
using System.Reflection.Metadata.Ecma335;
using System.Security.AccessControl;
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
        public async Task<ActionResult<List<TodoModel>>> List([FromQuery] int? _limit = null, [FromQuery] int? _page = null)
        {
            var result = await Mediator.Send(new GetTodosListQuery(_limit, _page));
            return new OkObjectResult(result.Todos);
        }

        [HttpGet("{id}")]
        [Produces("application/json")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<TodoModel>> GetTodo(Guid id)
        {
            return await Mediator.Send(new FindTodoByIdQuery(id));
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
                Description = model.Description,
                IsUrgent = model.IsUrgent
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
