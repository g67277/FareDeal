using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using FareDeal.Service.Data;

namespace FareDeal.Service
{
    public class BaseService : IDisposable
    {
        public FareDealDbContext db;
        public BaseService(FareDealDbContext dbContext)
        {
            db = dbContext;
            db.Configuration.LazyLoadingEnabled = false; 
        }
        public void Dispose()
        {
            db = null;
        }
    }
}
