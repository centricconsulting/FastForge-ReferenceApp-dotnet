using Microsoft.EntityFrameworkCore;
using referenceApp.Persistence.Models;

namespace referenceApp.Persistence
{
    public class ReferenceDbContext : DbContext
    {
        public ReferenceDbContext(DbContextOptions<ReferenceDbContext> options) : base(options) { }

        public DbSet<Todo> Todos { get; set; }
    }
}
