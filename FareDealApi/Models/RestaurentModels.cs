using System;
using System.Collections.Generic;

namespace LocalAccountsApp.Models
{
    // Models returned by AccountController actions.

    public class Restaurent
    {
        public int RestaurentId { get; set; }
        public string RestaurentName { get; set; }

        public string Address1 { get; set; }
        public string Address2 { get; set; }
        public string City { get; set; }

        public string State { get; set; }
        public string Zip { get; set; }
    } 
}
