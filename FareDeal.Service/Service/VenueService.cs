using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using FareDeal.Service.Data;

namespace FareDeal.Service
{
    public class VenueService : BaseService
    {
        //FareDealDbContext db = FareDealDbContextSngleton.Instance;
        
        public VenueService() : base(new FareDealDbContext())
        {

        }
        
        public IEnumerable<venue> GetVenues()
        {
            return db.venues.ToList();
        }

        public void AddVenue(venue _venue, location _location, category c)
        {
            try
            {
                db.Entry(_venue.category).State = System.Data.Entity.EntityState.Unchanged;
                db.venues.Add(_venue);
                db.SaveChanges();
            }
            catch(Exception e)
            {
                throw e;
            }
        }

        public venue GetByName(string name)
        {
            return db.venues.Where(v => v.name.ToLower() == name.ToLower()).FirstOrDefault();
        }
    }
}
