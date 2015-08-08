using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;
using Newtonsoft.Json;

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

        public string WeekendHours {get; set;}

        public double Lng { get; set; }

        public double Lat { get; set; }

        public string CategoryName { get; set; }

        public string ContactName { get; set; }

        public string Website { get; set; }
    }

    public class Address
    {
        public string StreetName {get; set;}
        public string City {get; set;}
        public string ZipCode {get; set;}
    }


    public class DealModel
    {
        public Guid VenueId { get; set; }
        [Required]
        public string DealTitle { get; set; }
        public string DealDescription { get; set; }
        [Required]
        public decimal DealValue { get; set; }
        [Required]
        public int TimeLimit { get; set; }
    }
}
