using System.Threading.Tasks;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.AspNet.Identity.Owin;
using Microsoft.Owin;
using FareDealApi.Models;
using System.Net.Mail;
using System.Configuration;
using System;

namespace FareDealApi
{
    // Configure the application user manager used in this application. UserManager is defined in ASP.NET Identity and is used by the application.

    public class ApplicationUserManager : UserManager<ApplicationUser>
    {
        public ApplicationUserManager(IUserStore<ApplicationUser> store)
            : base(store)
        {
        }

        public static ApplicationUserManager Create(IdentityFactoryOptions<ApplicationUserManager> options, IOwinContext context)
        {
            var manager = new ApplicationUserManager(new UserStore<ApplicationUser>(context.Get<ApplicationDbContext>()));

            manager.EmailService = new EmailService();

            // Configure validation logic for usernames
            manager.UserValidator = new UserValidator<ApplicationUser>(manager)
            {
                AllowOnlyAlphanumericUserNames = false,
                RequireUniqueEmail = true
            };
            // Configure validation logic for passwords
            manager.PasswordValidator = new PasswordValidator
            {
                RequiredLength = 6,
                RequireNonLetterOrDigit = false,
                RequireDigit = false,
                RequireLowercase = false,
                RequireUppercase = false,
            };
            var dataProtectionProvider = options.DataProtectionProvider;
            if (dataProtectionProvider != null)
            {
                manager.UserTokenProvider = new DataProtectorTokenProvider<ApplicationUser>(dataProtectionProvider.Create("ASP.NET Identity"))
                {
                    //Code for email confirmation and reset password life time
                    TokenLifespan = TimeSpan.FromHours(6)
                };
            }
            return manager;

        }
    }

    public class ApplicationRoleManager : RoleManager<IdentityRole>
    {
        public ApplicationRoleManager(IRoleStore<IdentityRole, string> roleStore)
            : base(roleStore)
        {
        }

        public static ApplicationRoleManager Create(IdentityFactoryOptions<ApplicationRoleManager> options, IOwinContext context)
        {
            var appRoleManager = new ApplicationRoleManager(new RoleStore<IdentityRole>(context.Get<ApplicationDbContext>()));

            return appRoleManager;
        }
    }

    //public class EmailService : IIdentityMessageService
    //{
    //    public async Task SendAsync(IdentityMessage message)
    //    {
    //        await configSendGridasync(message);
    //    }

    //    // Use NuGet to install SendGrid (Basic C# client lib) 
    //    private async Task configSendGridasync(IdentityMessage message)
    //    {

    //        MailMessage mail = new MailMessage();
    //        mail.Subject = message.Subject;
    //        mail.Body = message.Body;
    //        mail.IsBodyHtml = true;
    //        mail.From = new MailAddress(ConfigurationManager.AppSettings["emailFrom"]);
    //        mail.To.Add((ConfigurationManager.AppSettings["emailTo"]));
    //        mail.Priority = MailPriority.High;

    //        SmtpClient client = new SmtpClient();
    //        client.EnableSsl = true;
    //        client.Credentials = new System.Net.NetworkCredential((ConfigurationManager.AppSettings["userName"]), (ConfigurationManager.AppSettings["password"]));
    //        client.Host = (ConfigurationManager.AppSettings["smtpServer"]);
    //        client.Send(mail);

    //    }
    //}
}
