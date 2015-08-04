using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace FareDeal.Service.Data
{

    public sealed class FareDealDbContextSngleton
    {
        private static readonly FareDealDbContext instance = new FareDealDbContext();

        static FareDealDbContextSngleton() { }

        private FareDealDbContextSngleton() { }

        public static FareDealDbContext Instance
        {
            get
            {
                return instance;
            }
        }
    }  
}
