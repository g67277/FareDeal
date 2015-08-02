using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Entity;
using FareDeal.Service.Data;

namespace FareDeal.Service
{
    public class LocationService
    {
        FareDealDbContext db = new FareDealDbContext();
        public List<location> GetLocations()
        {
            List<location> c = db.locations.ToList();
            return c;
        }

        public location GetLocation(Guid id)
        {
            return db.locations.Where(l => l.id == id).FirstOrDefault();
        }
    }
}
