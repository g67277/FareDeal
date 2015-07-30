using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

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
    }

    public class Address
    {
        public string StreetName {get; set;}
        public string City {get; set;}
        public string ZipCode {get; set;}
    }
}
