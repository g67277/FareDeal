using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using System.Data.Entity;

using FareDeal.Service.Data;

namespace FareDeal.Service
{
    public class VenueService : BaseService
    {
        //FareDealDbContext db = FareDealDbContextSngleton.Instance;
        
        public VenueService() : base(new FareDealDbContext())
        {

        }

        public IEnumerable<venue> GetVenuesByCategoryNLocation(string category, double lat1, double lng1)
        {
            IEnumerable<venue> venues = db.venues;
            //find local
            if (!(lat1 == 0 || lng1 == 0))
            {
                List<venue> lstVenue = new List<venue>();
                foreach (var v in venues)
                {
                    db.Entry(v).Reference(vc => vc.location).Load();
                    db.Entry(v).Collection(vc => vc.venue_credit).Load();
                    db.Entry(v).Reference(vc => vc.category).Load();
                    var credit = v.venue_credit.FirstOrDefault();
                    if (credit != null && credit.credit_available > 0)
                    {
                        db.Entry(v).Collection(t => t.deals).Query().Where(o => o.active == true).Load();   
                    }
                    var distance = GetDistanceFromLatLonInKm(v.location.lat, v.location.lng, lat1, lng1);
                    if (distance < 10)
                    {
                        v.dist_to_location = distance * 1000;
                        lstVenue.Add(v);
                    }
                }
                venues = lstVenue;
            }
            if (!string.IsNullOrEmpty(category))
            {
                return venues.Where(v => v.category.name.ToLower() == category.ToLower());
            }
            return venues;
        }

        public IEnumerable<venue> GetVenuesByPriceNLocation(int priceTier, double lat1, double lng1)
        {
            IEnumerable<venue> venues = null;
            //find local
            if (priceTier > 0)
            {
                 venues = db.venues.Where(v => v.priceTier == priceTier);
            }
            else
            {
                 venues = db.venues;
            }

            if (!(lat1 == 0 || lng1 == 0))
            {
                List<venue> lstVenue = new List<venue>();
                foreach (var v in venues)
                {
                    db.Entry(v).Reference(vc => vc.location).Load();
                    db.Entry(v).Collection(vc => vc.venue_credit).Load();
                    db.Entry(v).Reference(vc => vc.category).Load();
                    var credit = v.venue_credit.FirstOrDefault();
                    if (credit != null && credit.credit_available > 0)
                    {
                        db.Entry(v).Collection(t => t.deals).Query().Where(o => o.active == true).Load();  
                    }
                    var distance = GetDistanceFromLatLonInKm(v.location.lat, v.location.lng, lat1, lng1);
                    if (distance < 10)
                    {
                        v.dist_to_location = distance * 1000;
                        lstVenue.Add(v);
                    }
                }
                venues = lstVenue;
            }
            return venues;
        }

        private double GetDistanceFromLatLonInKm(double lat1, double long1, double lat2, double long2)
        {
            double _eQuatorialEarthRadius = 6378.1370D;
            double _d2r = (Math.PI / 180D);

            double dlong = (long2 - long1) * _d2r;
            double dlat = (lat2 - lat1) * _d2r;
            double a = Math.Pow(Math.Sin(dlat / 2D), 2D) + Math.Cos(lat1 * _d2r) * Math.Cos(lat2 * _d2r) * Math.Pow(Math.Sin(dlong / 2D), 2D);
            double c = 2D * Math.Atan2(Math.Sqrt(a), Math.Sqrt(1D - a));
            double d = _eQuatorialEarthRadius * c;

            return d;
        }
        
        public IEnumerable<venue> GetVenues()
        {
            var venues = db.venues.ToList();
            foreach (var v in venues)
            {
                db.Entry(v).Reference(vc => vc.location).Load();
                db.Entry(v).Collection(vc => vc.venue_credit).Load();
                db.Entry(v).Reference(vc => vc.category).Load();

                var credit = v.venue_credit.FirstOrDefault();

                if (credit != null && credit.credit_available > 0)
                {
                    db.Entry(v).Collection(t => t.deals).Query().Where(o => o.active == true).Load(); 
                }
            }
            return venues;
        }

        public IEnumerable<venue> GetVenuesByCategory(string catName)
        {
            var venues = db.venues.ToList();
            foreach (var v in venues)
            {
                db.Entry(v).Reference(vc => vc.location).Load();
                db.Entry(v).Collection(vc => vc.venue_credit).Load();
                db.Entry(v).Reference(vc => vc.category).Load();
                var credit = v.venue_credit.FirstOrDefault();

                if (credit != null && credit.credit_available > 0)
                {
                    db.Entry(v).Collection(d => d.deals).Query().Where(d1 => d1.active == true); 
                }
            }
            return venues.Where(v=>v.category.name.ToLower() == catName.ToLower());
        }

        public IEnumerable<venue> GetVenueByPriceTier(int tier)
        {
            var venues = db.venues.Where(v=>v.priceTier <= tier).ToList();
            foreach (var v in venues)
            {
                db.Entry(v).Reference(vc => vc.location).Load();
                db.Entry(v).Collection(vc => vc.venue_credit).Load();
                db.Entry(v).Reference(vc => vc.category).Load();
                var credit = v.venue_credit.FirstOrDefault();

                if (credit != null && credit.credit_available > 0)
                {
                    db.Entry(v).Collection(t => t.deals).Query().Where(o => o.active == true).Load();                
                }

            }
            return venues;
        }

        public void AddCredit(Guid venueId, int credit)
        {
            venue_credit vc = db.venue_credit.Where(v => v.venue_id == venueId).FirstOrDefault();
            if (vc != null)
            {
                vc.credit_available = vc.credit_available + credit;
            }
            db.Entry(vc).State = System.Data.Entity.EntityState.Modified;
            db.SaveChanges();
        }
        public void SaveVenue(venue _venue)
        {
            try
            {
                //db.Entry(_venue.category).State = System.Data.Entity.EntityState.Unchanged;
                //db.venues.Add(_venue);
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
            db.Entry(_venue).Reference(vc => vc.category).Load();
            db.Entry(_venue).Collection(t=>t.deals).Query().Where(o=>o.active == true).Load(); 
            db.Entry(_venue).Reference(vc => vc.location).Load();
            return _venue;
        }

        public venue GetByUserId(Guid id)
        {
            venue _venue = db.venues.Where(v => v.uId == id).FirstOrDefault();
            db.Entry(_venue).Collection(vc => vc.venue_credit).Load();
            db.Entry(_venue).Reference(vc => vc.category).Load();
            db.Entry(_venue).Collection(t => t.deals).Query().Where(o => o.active == true).Load(); 
            db.Entry(_venue).Reference(vc => vc.location).Load();

            return _venue;
        }

        public List<VenueCreditSummary> GetSummary(Guid venueId)
        {
            venue _venue = db.venues.Where(v => v.Id == venueId).FirstOrDefault();
            db.Entry(_venue).Collection(vc => vc.venue_credit).Load();

            var total = from T1 in db.venues
                        where T1.Id == venueId
                        join T2 in db.deals on T1.Id equals T2.venue_id
                        join T3 in db.deal_transcation on T2.id equals T3.deal_id
                        where (T1.Id == venueId && T3.tran_time.Year == DateTime.Now.Year)
                        group T3 by new { T1.Id, T2.id, T3.tran_time.Month, T3.tran_time.Year } into g                        
                        select new
                        {
                            DealId = g.Key.id,
                            VenueId = g.Key.Id,
                            Month = g.Key.Month,
                            Year = g.Key.Year,
                            Purchased = g.Sum(t3 => t3.quantity_redeemed.CompareTo(-1)),
                            Swapped = g.Sum(t3 => t3.quantity_redeemed.CompareTo(1))
                        };

            List<VenueCreditSummary> vcs = new List<VenueCreditSummary>();
            foreach(var t in total)
            {
                vcs.Add(
                    new VenueCreditSummary()
                    {
                        VenueId = t.VenueId,
                        Year = t.Year,
                        Month = t.Month,
                        VenueName = _venue.name,
                        TotalDealsPurchased = Math.Abs(t.Purchased),
                        TotalDealsSwapped = Math.Abs(t.Swapped),
                        CreditAvailable = _venue.venue_credit.FirstOrDefault().credit_available
                    }
                );
            }


            //Get all deals 
            //venue _venue = db.venues.Where(v => v.Id == venueId).FirstOrDefault();
            //db.Entry(_venue).Collection(s => s.deals).Load();
            //db.Entry(_venue).Collection(vc => vc.venue_credit).Load();

            //int pd = _venue.deals.Sum(s => s.totalPurchased).Value;
            //int sd = _venue.deals.Sum(s => s.totalSwapped).Value;

            //var ob = new VenueCreditSummary()
            //{
            //    CreditAvailable = _venue.venue_credit.FirstOrDefault().credit_available,
            //    TotalDealsPurchased = pd,
            //    TotalDealsSwapped = sd,
            //    VenueId = _venue.Id,
            //    VenueName = _venue.name
            //};

            return vcs;
        }

        public void SaveLike(Guid id, bool like)
        {
            venue _venue = db.venues.Where(v => v.Id == id).FirstOrDefault();
            if (_venue.likes == null)
                _venue.likes = 0;
            if (like)
            {
                _venue.likes += 1;
            }
            else
            {
                _venue.likes = _venue.likes - 1;
            }
            db.SaveChanges();
        }

        public void SaveFavourites(Guid id, bool favourite)
        {
            venue _venue = db.venues.Where(v => v.Id == id).FirstOrDefault();
            if (_venue.favourites == null)
                _venue.favourites = 0;
            if (favourite)
            {
                _venue.favourites += 1;
            }
            else
            {
                _venue.favourites = _venue.favourites - 1;
            }
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

        public int Month { get; set; }
        public int Year { get; set; }
    }
}
