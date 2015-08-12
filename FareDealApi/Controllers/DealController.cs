using FareDeal.Service;
using FareDealApi.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;

using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.Owin.Security;

using FareDeal.Service.Data;

namespace FareDealApi.Controllers
{
    public class DealController : ApiController
    {
        // GET: api/Deal
        public IEnumerable<string> Get()
        {
            return new string[] { "value1", "value2" };
        }

        // GET: api/Deal/5
        public string Get(int id)
        {
            return "value";
        }

        // POST: api/Deal
        [Authorize(Roles = "business")]
        public async Task<IHttpActionResult> Post(DealModel model)
        {
            venue v;
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            using (DealService service = new DealService())
            {
                var deal = service.GetDealById(model.DealId);
                if (deal == null)
                {
                    service.AddDeal(new FareDeal.Service.Data.deal()
                    {
                        id = model.DealId,
                        venue_id = model.VenueId,
                        description = model.DealDescription,
                        title = model.DealTitle,
                        deal_value = model.DealValue,
                        timeLimit = model.TimeLimit,
                        original_value = 0,
                        active = true,
                        credit_required = 20,
                    });
                }
                else
                {

                    deal.active = model.Active;
                    deal.description = model.DealDescription;
                    deal.deal_value = model.DealValue;
                    deal.title = model.DealTitle;
                    deal.credit_required = model.CreditRequired;
                    service.SaveDeal(deal);


                }
            }
            return Ok();
        }

        // PUT: api/Deal/5
        public void Put(int id, [FromBody]string value)
        {
        }

        // DELETE: api/Deal/5
        public void Delete(int id)
        {
        }

        [HttpGet]
        [Route("api/Deal/Purchase")]
        [Authorize]
        public async Task<IHttpActionResult> PurchaseDeal(Guid dealId)
        {
            
            using (DealService service = new DealService())
            {
               
                service.PurchaseDeal(new FareDeal.Service.Data.deal_transcation()
                    {
                        tran_id = Guid.NewGuid(),
                        deal_id = dealId,
                        quantity_redeemed = 1,
                        active = true,
                        tran_time = DateTime.Now,
                        user_id =  Guid.Parse(User.Identity.GetUserId())
                    });
            }
            return Ok();
        }

        [HttpGet]
        [Route("api/Deal/Swap")]
        [Authorize]
        public async Task<IHttpActionResult> SwapDeal(Guid newDealId, Guid originalDealId)
        {

            using (DealService service = new DealService())
            {

                service.PurchaseDeal(new FareDeal.Service.Data.deal_transcation()
                {
                    tran_id = Guid.NewGuid(),
                    deal_id = newDealId,
                    quantity_redeemed = 1,
                    active = true,
                    tran_time = DateTime.Now,
                    user_id = Guid.Parse(User.Identity.GetUserId())
                });

                service.SwapDeal(new FareDeal.Service.Data.deal_transcation()
                {
                    tran_id = Guid.NewGuid(),
                    deal_id = originalDealId,
                    quantity_redeemed = -1,
                    active = true,
                    tran_time = DateTime.Now,
                    user_id = Guid.Parse(User.Identity.GetUserId())
                });
            }
            return Ok();
        }
    }
}
