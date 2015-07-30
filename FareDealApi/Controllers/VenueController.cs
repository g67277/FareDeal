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
        VenueService service = new VenueService();
        // GET: api/Venue
        public IEnumerable<venue> Get()
        {
            IEnumerable<venue> venues = service.GetVenues();
            return venues;

        }


        // GET: api/Venue/5
        public string Get(int id)
        {
            return "value";
        }

        // POST: api/Venue
        [Authorize(Roles = "business")]
        public async Task<IHttpActionResult> Post(BusinessModel model)
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
                l.lang = "-5.00";
                l.lat = "-5.00";
                l.cc = "US";

                v = new venue();
                v.Id = Guid.NewGuid();
                v.isOpen = true;
                v.name = model.RestaurantName;
                v.url = "http://test.com";
                v.priceTier = model.PriceTier;
                v.defaultPicUrl = "http://test.com/a.png";
                v.location_id = l.id;


                contact c = new contact();
                c.venue_contact_id = v.Id;
                c.first_name = model.FirstName;
                c.last_name = model.LastName;
                c.phone = model.PhoneNumber;
                service.AddVenue(v, c, l);
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
