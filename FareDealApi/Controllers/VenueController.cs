using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

using FareDeal.Service;
using FareDeal.Service.Data;

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
        public void Post([FromBody]string value)
        {
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
