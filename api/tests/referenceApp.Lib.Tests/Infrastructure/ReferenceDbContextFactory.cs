using System;
using Microsoft.EntityFrameworkCore;
using referenceApp.Persistence;
using referenceApp.Persistence.Models;

namespace referenceApp.Lib.Tests.Infrastructure
{
    public class ReferenceDbContextFactory
    {
        public static ReferenceDbContext Create()
        {
            var options = new DbContextOptionsBuilder<ReferenceDbContext>()
                    .UseInMemoryDatabase(Guid.NewGuid().ToString())
                    .Options;

            var context = new ReferenceDbContext(options);

            context.Database.EnsureCreated();

            context.Todos.AddRange(new[] {
                new Todo{Id = Guid.NewGuid(), Title = $"Title - {Guid.NewGuid().ToString()}"},
                new Todo{Id = Guid.NewGuid(), Title = $"Title - {Guid.NewGuid().ToString()}"},
                new Todo{Id = Guid.NewGuid(), Title = $"Title - {Guid.NewGuid().ToString()}"}
            });

            context.SaveChanges();

            return context;
        }

        public static void Destroy(ReferenceDbContext context)
        {
            if (!context.Database.IsInMemory())
                return;

            context.Database.EnsureDeleted();

            context.Dispose();
        }
    }
}
