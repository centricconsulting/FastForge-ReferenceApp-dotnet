using FluentValidation;

namespace referenceApp.Lib.Todos.CreateNewTodo
{
    public class CreateNewTodoCommandValidator : AbstractValidator<CreateNewTodoCommand>
    {
        public CreateNewTodoCommandValidator()
        {
            RuleFor(x => x.Id).NotEmpty();
            RuleFor(x => x.Title).NotEmpty();
        }
    }
}
