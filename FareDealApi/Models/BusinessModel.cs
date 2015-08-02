using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using FareDeal.Service.Data;

namespace FareDealApi.Models
{
    public class BusinessModel
    {
        public string RestaurantName {get; set;}

        public string FirstName { get; set; }
        public string LastName { get; set; }

        public string StreetName { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string ZipCode { get; set; }

        public string PhoneNumber {get; set;}
        public short PriceTier {get; set;}

        public string WeekdaysHours {get; set;}

        public string WeekEndHours {get; set;}

        public string Lang { get; set; }

        public string Lat { get; set; }

        public string CategoryName { get; set; }
    }

    public class Address
    {
        public string StreetName {get; set;}
        public string City {get; set;}
        public string ZipCode {get; set;}
    }

   [Serializable]
    public class RestaurentModel
    {
        venue Venue { get; set; }
        location Location { get; set; }
        category Categories { get; set; }

    }
}
