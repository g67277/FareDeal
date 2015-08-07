using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

using FareDeal.Service;
using FareDeal.Service.Data;
using FareDealApi.Models;
using System.Threading.Tasks;

namespace FareDealApi.Controllers
{
    
    public class VenueController : BaseApiController
    {
       // VenueService service = new VenueService();
       // CategoryService catService = new CategoryService();
       //  GET: api/Venue
        public IEnumerable<venue> Get()
        {
            using (VenueService service = new VenueService())
            {
                IEnumerable<venue> venues = service.GetVenues();
                return venues;
            }
        }

        // GET: api/Venue/5
        public venue Get(Guid id)
        {
            using (VenueService service = new VenueService())
            {
                return service.GetById(id);
            }
        }

        // POST: api/Venue
        //[Authorize(Roles = "business")]
        public async Task<IHttpActionResult> Post(BusinessModel model)
        {
            category cat;
            using (CategoryService catService = new CategoryService())
            {
                 cat = catService.GetCategry(model.CategoryName, null);
            }
            using (VenueService service = new VenueService())
            {
                venue v = service.GetByName(model.RestaurantName);
                
                if (v == null)
                {

                    location l = new location();
                    l.id = Guid.NewGuid();
                    l.postalcode = model.ZipCode;
                    l.city = model.City;
                    l.address = model.StreetName;
                    l.state = model.State;
                    l.lang = model.Lng;
                    l.lat = model.Lat;
                    l.cc = "US";

                    v = new venue();
                    v.Id = Guid.NewGuid();
                    v.isOpen = true;
                    v.name = model.RestaurantName;
                    v.url = model.Website;
                    v.priceTier = model.PriceTier;
                    v.defaultPicUrl = "http://test.com/a.png";
                    //v.location_id = l.id;

                    v.contactName = model.ContactName;
                    v.phone = model.PhoneNumber;

                    v.location = l;


                    //find category

                    
                    //v.categoryId = cat.Id;
                    v.category = cat;

                    service.AddVenue(v);
                }
                else
                {

                }
            }
            return Ok();
        }

        [HttpGet]
        [Route("api/Venue/BalanceSummary")]
        [Authorize(Roles="business")]
        public VenueCreditSummary BalanceSummary(Guid id)
        {
            using (VenueService vc = new VenueService())
            {
                return vc.GetSummary(id);
            }
        }

        [HttpGet]
        [Route("api/Venue/Like")]
        public async Task<IHttpActionResult> Like(Guid id)
        {
            using(VenueService service = new VenueService())
            {
                service.SaveLike(id);
            }
            return Ok();
        }


        // PUT: api/Venue/5
        public void Put(int id, [FromBody]string value)
        {
        }

        // DELETE: api/Venue/5
        public void Delete(int id)
        {
        }
    }
}
