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

        public deal GetDealById(Guid id)
        {
            return db.deals.Where(d => d.id == id).FirstOrDefault();
        }

        public void SaveDeal(deal deal)
        {
            try
            {
                db.Entry(deal).State = System.Data.Entity.EntityState.Modified;
                db.SaveChanges();
            }
            catch (Exception e)
            {
                throw e;
            }
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

        public void PurchaseDeal(deal_transcation transaction)
        {
            try
            {
                deal _deal = db.deals.Where(d => d.id == transaction.deal_id).FirstOrDefault();
                db.Entry(_deal).Reference<venue>(d=>d.venue).Load();
                db.Entry(_deal.venue).Collection<venue_credit>(v => v.venue_credit).Load();
                
                //add transactions
                db.deal_transcation.Add(transaction);
                
                //debit venue credit
                venue_credit vc = _deal.venue.venue_credit.First();
                vc.credit_available = vc.credit_available - 1;
                //update count
                _deal.totalPurchased += 1;

                db.SaveChanges();
            }
            catch(Exception e)
            {
                throw e;
            }
        }

        public void SwapDeal(deal_transcation transaction)
        {
            try
            {
                deal _deal = db.deals.Where(d => d.id == transaction.deal_id).FirstOrDefault();
                db.Entry(_deal).Reference<venue>(d => d.venue).Load();
                db.Entry(_deal.venue).Collection<venue_credit>(v => v.venue_credit).Load();
                

                //add transactions
                db.deal_transcation.Add(transaction);

                //debit venue credit
                venue_credit vc = _deal.venue.venue_credit.First();
                vc.credit_available = vc.credit_available + 1;

                //update counts
                _deal.totalSwapped += 1;
                db.SaveChanges();
            }
            catch (Exception e)
            {
                throw e;
            }
        }
    }
}
