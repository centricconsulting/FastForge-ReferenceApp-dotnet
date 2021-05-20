using System;
using referenceApp.Persistence;
using Xunit;

namespace referenceApp.Lib.Tests.Infrastructure
{
    public class QueryTestFixture : IDisposable
    {
        public ReferenceDbContext Context { get; set; }

        public QueryTestFixture()
        {
            Context = ReferenceDbContextFactory.Create();
        }

        public void Dispose()
        {
            ReferenceDbContextFactory.Destroy(Context);
        }
    }

    [CollectionDefinition("QueryCollection")]
    public class QueryCollection : ICollectionFixture<QueryTestFixture> { }
}
