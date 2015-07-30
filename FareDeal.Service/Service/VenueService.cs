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

        public void SaveVenue(venue _venue, contact _contact, location _location)
        {
            
        }

        public venue GetByName(string name)
        {
            return db.venues.Where(v => v.name.ToLower() == name.ToLower()).FirstOrDefault();
        }
    }
}
