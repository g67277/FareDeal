using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Web.Hosting;
using System.Web.Http;

namespace FareDealApi.Controllers
{
    public class ImageController : ApiController
    {

        public HttpResponseMessage Get(int id)
        {
            var result = new HttpResponseMessage(HttpStatusCode.OK);
            String filePath = HostingEnvironment.MapPath("~/Images/readme1.jpg");
            FileStream fileStream = new FileStream(filePath, FileMode.Open);
            Image image = Image.FromStream(fileStream);
            MemoryStream memoryStream = new MemoryStream();
            image.Save(memoryStream, ImageFormat.Jpeg);
            result.Content = new ByteArrayContent(memoryStream.ToArray());
            result.Content.Headers.ContentType = new MediaTypeHeaderValue("image/jpeg");

            return result;
        }

        public void Delete(int id)
        {
            String filePath = HostingEnvironment.MapPath("~/Images/HT.jpg");
            File.Delete(filePath);
        }

        public HttpResponseMessage Post()
        {
            var result = new HttpResponseMessage(HttpStatusCode.OK);
            if (Request.Content.IsMimeMultipartContent())
            {
                Request.Content.ReadAsMultipartAsync<MultipartMemoryStreamProvider>(new MultipartMemoryStreamProvider()).ContinueWith((task) =>
                {
                    MultipartMemoryStreamProvider provider = task.Result;
                    foreach (HttpContent content in provider.Contents)
                    {
                        Stream stream = content.ReadAsStreamAsync().Result;
                        Image image = Image.FromStream(stream);
                        var testName = content.Headers.ContentDisposition.Name;
                        String filePath = HostingEnvironment.MapPath("~/Images/");
                        String[] headerValues = (String[])Request.Headers.GetValues("ImageId");
                        String fileName = headerValues[0] + ".jpg";
                        String fullPath = Path.Combine(filePath, fileName);
                        image.Save(fullPath);
                    }
                });
                return result;
            }
            else
            {
                throw new HttpResponseException(Request.CreateResponse(HttpStatusCode.NotAcceptable, "This request is not properly formatted"));
            }


        }

    }
}
