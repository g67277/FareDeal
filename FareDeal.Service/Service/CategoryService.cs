using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Entity;
using FareDeal.Service.Data;

namespace FareDeal.Service
{
    public class CategoryService
    {
        FareDealDbContext db = new FareDealDbContext();
        public List<category> GetCategories()
        {
            List<category> c = db.categories.ToList();
            return c;
        }

        public void AddNewCategory(category category)
        {
            db.categories.Add(category);
            db.SaveChanges();
        }

        public category GetCategry(string name, Guid? categoryId)
        {

            category cat = null;
            if (categoryId != null)
            {
               cat  = db.categories.Where(ca => ca.Id == categoryId).FirstOrDefault();
               return cat;
            }
            cat = db.categories.Where(ca => ca.name.ToLower() == name.ToLower()).FirstOrDefault();
            return cat;
        }

        public category GetCategoryForVenue(Guid venueId)
        {
            venue_category vencat = db.venue_category.Where(vc => vc.venue_id == venueId).FirstOrDefault();
            return db.categories.Where(c => c.Id == vencat.category_id).FirstOrDefault();
        }
    }
}
