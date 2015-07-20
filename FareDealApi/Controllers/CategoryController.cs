using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

using FareDeal.Service.Data;
using FareDeal.Service;

namespace FareDealApi.Controllers
{
    //[Authorize]
    public class CategoryController : ApiController
    {
        CategoryService categoryService = new CategoryService();
        // GET: api/Category
        public IEnumerable<category> Get()
        {
            //return new string[] { "value1", "value2" };
            return categoryService.GetCategories();
            
        }

        // GET: api/Category/5
        public category Get(Guid id)
        {
            return categoryService.GetCategry(null, id);
        }

        // POST: api/Category
        public void Post([FromBody]string value)
        {
        }

        // PUT: api/Category/5
        public void Put(int id, [FromBody]string value)
        {
        }

        // DELETE: api/Category/5
        public void Delete(int id)
        {
        }
    }
}
