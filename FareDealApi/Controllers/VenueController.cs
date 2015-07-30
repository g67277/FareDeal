using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

using FareDeal.Service;
using FareDeal.Service.Data;
using FareDealApi.Models;

namespace FareDealApi.Controllers
{
    public class VenueController : ApiController
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
        public void Post(BusinessModel model)
        {
            venue v = service.GetByName(model.RestaurantName);
            if (v == null)
            {
                v = new venue();
                v.Id = Guid.NewGuid();
                v.isOpen = true;
                v.name = model.RestaurantName;

                location l = new location();
                l.id = Guid.NewGuid();
                l.postalcode = model.ZipCode;
                l.city = model.City;
                l.address = model.StreetName;
                l.state = model.State;                

                contact c = new contact();
                c.venue_contact_id = v.Id;
                c.first_name = model.FirstName;
                c.last_name = model.LastName;
                c.phone = model.PhoneNumber;
                
            }
            
            
            
            
            
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
