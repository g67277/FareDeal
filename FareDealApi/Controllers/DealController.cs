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
        public async Task<IHttpActionResult> Post(DealModel model)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            using (DealService service = new DealService())
            {
                service.AddDeal(new FareDeal.Service.Data.deal()
                {
                    id = Guid.NewGuid(),
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
