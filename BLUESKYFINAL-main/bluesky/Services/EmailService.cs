using System;
using System.Configuration;
using System.Net;
using System.Net.Mail;

namespace bluesky.Services
{
    public class EmailService
    {
        private readonly string _fromEmail;
        private readonly string _fromName;
        private readonly string _host;
        private readonly int _port;
        private readonly string _user;
        private readonly string _password;

        public EmailService()
        {
            _fromEmail = ConfigurationManager.AppSettings["SmtpFromEmail"];
            _fromName = ConfigurationManager.AppSettings["SmtpFromName"];
            _host = ConfigurationManager.AppSettings["SmtpHost"];
            _port = int.Parse(ConfigurationManager.AppSettings["SmtpPort"]);
            _user = ConfigurationManager.AppSettings["SmtpUser"];
            _password = ConfigurationManager.AppSettings["SmtpPassword"];
        }

        public void SendEmail(string toEmail, string subject, string htmlBody)
        {
            if (string.IsNullOrWhiteSpace(toEmail))
                throw new ArgumentException("Destinatario vacío", nameof(toEmail));

            using (var message = new MailMessage())
            {
                message.From = new MailAddress(_fromEmail, _fromName);
                message.To.Add(toEmail);
                message.Subject = subject;
                message.Body = htmlBody;
                message.IsBodyHtml = true;

                using (var client = new SmtpClient(_host, _port))
                {
                    client.EnableSsl = true;
                    client.Credentials = new NetworkCredential(_user, _password);
                    client.Send(message);
                }
            }
        }
    }
}
