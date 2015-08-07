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

        public void AddVenue(venue _venue)
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

        public venue GetById(Guid id)
        {
            venue _venue = db.venues.Where(v => v.Id == id).FirstOrDefault();
            db.Entry(_venue).Collection(vc => vc.venue_credit).Load();
            if (_venue.venue_credit.First().credit_available > 5)
            {
                db.Entry(_venue).Collection(s => s.deals).Load();
            }

            return _venue;
        }

        public VenueCreditSummary GetSummary(Guid venueId)
        {
            //Get all deals 
            venue _venue = db.venues.Where(v => v.Id == venueId).FirstOrDefault();
            db.Entry(_venue).Collection(s => s.deals).Load();
            db.Entry(_venue).Collection(vc => vc.venue_credit).Load();

            int pd = _venue.deals.Sum(s => s.totalPurchased).Value;
            int sd = _venue.deals.Sum(s => s.totalSwapped).Value;

            var ob = new VenueCreditSummary()
            {
                CreditAvailable = _venue.venue_credit.FirstOrDefault().credit_available,
                TotalDealsPurchased = pd,
                TotalDealsSwapped = sd,
                VenueId = _venue.Id,
                VenueName = _venue.name
            };

            return ob;
        }

        public void SaveLike(Guid id)
        {
            venue _venue = db.venues.Where(v => v.Id == id).FirstOrDefault();
            if (_venue.likes == null)
                _venue.likes = 0;
            _venue.likes += 1;
            db.SaveChanges();
        }
    }

    public class VenueCreditSummary
    {
        public Guid VenueId { get; set; }
        public string VenueName { get; set; }
        public int TotalDealsPurchased { get; set; }
        public int TotalDealsSwapped { get; set; }
        public int CreditAvailable { get; set; }
    }
}
