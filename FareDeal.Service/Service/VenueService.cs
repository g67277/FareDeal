using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using FareDeal.Service.Data;

namespace FareDeal.Service
{
    public class VenueService
    {
        FareDealDbContext db = new FareDealDbContext();
        public IEnumerable<venue> GetVenues()
        {
            return db.venues.ToList();
        }
    }
}
