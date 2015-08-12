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

using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.Owin.Security;


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

        public IEnumerable<venue> GetLocal(float lng, float lat)
        {
            List<venue> vList = new List<venue>();

            using (VenueService service = new VenueService())
            {
                foreach(venue v in service.GetVenues())
                {
                    var distance = GetDistanceFromLatLonInKm(v.location.lat, v.location.lng, lat, lng);
                    if (distance < 10)
                    {
                        vList.Add(v);
                    }
                }
            }
            return vList;
        }
        [Route("api/Venue/GetVenuesByPriceNLocation")]
        [HttpGet]
        public IEnumerable<venue> GetVenuesByPriceNLocation(int priceTier, double lat, double lng)
        {
            using (VenueService service = new VenueService())
            {
                return service.GetVenuesByPriceNLocation(priceTier, lat, lng);
            }
        }
        [Route("api/Venue/GetVenuesByCategoryNLocation")]
        [HttpGet]
        public IEnumerable<venue> GetVenuesByCategoryNLocation(string category, double lat, double lng)
        {
            using (VenueService service = new VenueService())
            {
                return service.GetVenuesByCategoryNLocation(category, lat, lng);
            }
        }

        [Route("api/Venue/GetVenueByCategory")]
        [HttpGet]
        public IEnumerable<venue> GetVenueByCategory(string catName)
        {
            using (VenueService service = new VenueService())
            {
                return service.GetVenuesByCategory(catName);
            }
        }

        [Route("api/Venue/GetVenueByPriceTier")]
        [HttpGet]
        public IEnumerable<venue> GetVenueByPriceTier(int tier)
        {
            using (VenueService service = new VenueService())
            {
                return service.GetVenueByPriceTier(tier);
            }
        }

        [Route("api/Venue/GetVenueByPriceTier")]
        [HttpGet]
        public IEnumerable<venue> GetVenues(int priceTier, string category, float lat, float lng)
        {
            
            using (VenueService service = new VenueService())
            {
                return service.GetVenueByPriceTier(priceTier);
            }
        }

        private double GetDistanceFromLatLonInKm(double lat1,double long1,double lat2,double long2) 
        {
             double _eQuatorialEarthRadius = 6378.1370D;
	         double _d2r = (Math.PI / 180D);

            double dlong = (long2 - long1) * _d2r;
            double dlat = (lat2 - lat1) * _d2r;
            double a = Math.Pow(Math.Sin(dlat / 2D), 2D) + Math.Cos(lat1 * _d2r) * Math.Cos(lat2 * _d2r) * Math.Pow(Math.Sin(dlong / 2D), 2D);
            double c = 2D * Math.Atan2(Math.Sqrt(a), Math.Sqrt(1D - a));
            double d = _eQuatorialEarthRadius * c;

            return d;
        }

        [Authorize(Roles="business")]
        [HttpGet]
        [Route("api/Venue/MyVenue")]
        public venue MyVenue()
        {
            using (VenueService service = new VenueService())
            {
               return service.GetByUserId(Guid.Parse(User.Identity.GetUserId()));
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
        [Authorize(Roles = "business")]
        public async Task<IHttpActionResult> Post(BusinessModel model)
        {
            category cat;
            venue v;
            using (CategoryService catService = new CategoryService())
            {
                 cat = catService.GetCategry(model.CategoryName, null);
            }
            using (VenueService service = new VenueService())
            {
                v = service.GetByName(model.RestaurantName);
                
                if (v == null)
                {

                    location l = new location();
                    l.id = Guid.NewGuid();
                    l.postalcode = model.ZipCode;
                    l.city = model.City;
                    l.address = model.StreetName;
                    l.state = model.State;
                    l.lng = model.Lng;
                    l.lat = model.Lat;
                    l.cc = "US";

                    v = new venue();
                    v.Id = Guid.NewGuid();
                    v.isOpen = true;
                    v.name = model.RestaurantName;
                    v.description = model.Description;
                    v.url = model.Website;
                    v.priceTier = model.PriceTier;
                    v.defaultPicUrl = model.ImageName;
                    //v.location_id = l.id;
                    v.weekdayHours = model.WeekdaysHours;
                    v.weekendHours = model.WeekendHours;

                    v.contactName = model.ContactName;
                    v.phone = model.PhoneNumber;

                    v.location = l;
                    v.uId = Guid.Parse(User.Identity.GetUserId());

                    //find category

                    
                    //v.categoryId = cat.Id;
                    v.category = cat;

                    venue_credit vc = new venue_credit();
                    vc.Id = Guid.NewGuid();
                    vc.venue_id = v.Id;
                    vc.credit_auto_increase = 5;
                    vc.credit_available = 50;
                    vc.credit_threhold = 10;

                    v.venue_credit.Add(vc);

                    service.AddVenue(v);

                    //save image on disk
                    SaveImage(v.defaultPicUrl);
                }
                else
                {

                }
            }
            return Ok("{VenueId: " + v.Id + "}");
        }

        private void SaveImage(string p)
        {
            System.IO.File.Create(p);
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

        [HttpGet]
        [Route("api/Venue/AddCredit")]
        public async Task<IHttpActionResult> AddCredit(Guid venueId, int credit)
        {
            using (VenueService service = new VenueService())
            {
                service.AddCredit(venueId, credit);
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
