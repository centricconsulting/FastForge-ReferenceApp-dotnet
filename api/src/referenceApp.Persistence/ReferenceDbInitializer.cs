using System;
using System.Linq;
using referenceApp.Persistence.Models;

namespace referenceApp.Persistence
{
    public class ReferenceDbInitializer
    {
        public static void Initialize(ReferenceDbContext context)
        {
            var inittializer = new ReferenceDbInitializer();
            inittializer.SeedEveryThing(context);
        }

        private void SeedEveryThing(ReferenceDbContext context)
        {
            context.Database.EnsureCreated();

            if (context.Todos.Any())
            {
                return;
            }

            context.Todos.AddRange(new[] {
                new Todo{Id = Guid.NewGuid(), Title = $"Task One"},
                new Todo{Id = Guid.NewGuid(), Title = $"Task Two"},
                new Todo{Id = Guid.NewGuid(), Title = $"Task Three"}
            });

            context.SaveChanges();
        }
    }
}
