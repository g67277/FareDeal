using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

using FareDeal.Service;

namespace FareDealApi.Controllers
{
    [Authorize]
    public class ValuesController : ApiController
    {
        // GET api/values
        public string Get()
        {
            var userName = this.RequestContext.Principal.Identity.Name;
            //return String.Format("Hello, {0}.", userName);

            FareDealDbContext dbContext = new FareDealDbContext();
            List<Restaurent> rs = dbContext.Restaurents.ToList();
            return String.Format("Total  {0} records found", rs.Count());
        }
    }
}
