using FareDealApi.Models;
using Microsoft.AspNet.Identity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;

namespace FareDealApi.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            ViewBag.Title = "Home Page";

            return View();
        }

        [HttpGet]
        [Route(Name = "setPassword")]
        public ActionResult SetPassword(string id="", string code="")
        {
            ViewBag.Token = Url.Encode(code);
            ViewBag.Id = id;
            return View();
        }
    }
}
