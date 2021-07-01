using FluentValidation.TestHelper;
using referenceApp.Lib.Todos.CreateNewTodo;
using Xunit;

namespace referenceApp.Lib.Tests
{
    public class CreateNewTodoCommandValidatorTests
    {
        private CreateNewTodoCommandValidator _validator;

        public CreateNewTodoCommandValidatorTests()
        {
            _validator = new CreateNewTodoCommandValidator();
        }

        [Fact]
        public void ShouldRequireId()
        {
            var model = new CreateNewTodoCommand();
            var result = _validator.TestValidate(model);
            result.ShouldHaveValidationErrorFor(cmd => cmd.Id);
        }

        [Fact]
        public void ShouldRequireTitiel()
        {
            var model = new CreateNewTodoCommand();
            var result = _validator.TestValidate(model);
            result.ShouldHaveValidationErrorFor(cmd => cmd.Title);
        }
    }
}
