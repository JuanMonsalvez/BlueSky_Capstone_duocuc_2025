using System;
using System.Configuration;
using System.IO;
using System.Text;
using iText.Kernel.Pdf;
using iText.Kernel.Pdf.Canvas.Parser;
using iText.Kernel.Pdf.Canvas.Parser.Listener;

namespace bluesky.Services.IA
{
    public static class TextExtractors
    {
        public static string GetUploadsPhysicalPath()
        {
            string relative = ConfigurationManager.AppSettings["UPLOAD_PATH"] ?? "~/Uploads/";
            return System.Web.HttpContext.Current.Server.MapPath(relative);
        }

        /// <summary>
        /// Extrae texto desde un archivo PDF usando iText7.
        /// </summary>
        public static string ExtraerTextoPdf(string fullPath)
        {
            if (string.IsNullOrWhiteSpace(fullPath))
                throw new ArgumentException("Ruta del PDF vacía.", nameof(fullPath));

            if (!File.Exists(fullPath))
                throw new FileNotFoundException("No se encontró el archivo PDF.", fullPath);

            var sb = new StringBuilder();

            using (var pdf = new PdfDocument(new PdfReader(fullPath)))
            {
                int numPages = pdf.GetNumberOfPages();
                for (int i = 1; i <= numPages; i++)
                {
                    var strategy = new SimpleTextExtractionStrategy();
                    var page = pdf.GetPage(i);
                    string text = PdfTextExtractor.GetTextFromPage(page, strategy);

                    if (!string.IsNullOrWhiteSpace(text))
                    {
                        sb.AppendLine(text);
                    }
                }
            }

            return sb.ToString();
        }

        /// <summary>
        /// Ejemplo anterior para .txt (por si lo llegas a usar).
        /// </summary>
        public static string ExtraerTextoBasico(string fileName)
        {
            string uploadsPath = GetUploadsPhysicalPath();
            string fullPath = Path.Combine(uploadsPath, fileName);

            if (!File.Exists(fullPath))
                throw new FileNotFoundException("No se encontró el archivo.", fullPath);

            var ext = Path.GetExtension(fullPath)?.ToLowerInvariant();

            if (ext == ".txt")
            {
                return File.ReadAllText(fullPath, Encoding.UTF8);
            }

            throw new NotSupportedException($"Extensión no soportada aún: {ext}");
        }
    }
}
