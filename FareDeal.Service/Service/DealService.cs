using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using FareDeal.Service.Data;

namespace FareDeal.Service
{
    public class DealService : BaseService
    {
        //FareDealDbContext db = FareDealDbContextSngleton.Instance;

        public DealService() : base(new FareDealDbContext())
        {
        }
        public IEnumerable<deal> GetDeals()
        {
            return db.deals.ToList();
        }

        public void AddDeal(deal deal)
        {
            try
            {
                db.deals.Add(deal);               
                db.SaveChanges();
            }
            catch(Exception e)
            {
                throw e;
            }
        }
    }
}
