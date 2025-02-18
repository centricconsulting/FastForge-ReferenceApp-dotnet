
using System;
using referenceApp.Common.Models.Entity;

namespace referenceApp.Persistence
{
    // ToDo Power BI: DATA - Delete if not needed. Implement data access code to retrieve report Guids and other details needed for integrating with Power BI.
    public class ReportDataService : IReportDataService
    {
        private readonly ReferenceDbContext _dbContext;
        public ReportDataService(ReferenceDbContext dbContext)
        {
            _dbContext = dbContext ?? throw new ArgumentNullException(nameof(dbContext));
        }


        public ReportEntityModel GetReportInformationById(int id)
        {
            throw new NotImplementedException();
        }

        public ReportEntityModel GetReportInformation(string reportId, string reportSectionId)
        {
            throw new NotImplementedException();
        }

        public string GetMimeTypeByFileExtension(string resultFileExtension)
        {
            if (string.IsNullOrWhiteSpace(resultFileExtension))
                throw new ArgumentNullException(nameof(resultFileExtension));

            // ToDo Power BI: DATA - Create FileType table in db and write code to retrieve the mimi type here. Columns: Id, FileExtension, Name, Description, ImageType, MimeType, Application
            //return _dbContext.FileTypes.FirstOrDefault(f => f.FileExtension.ToLower() == resultFileExtension.ToLower())?.MimeType;
            switch (resultFileExtension.ToLower())
            {
                case "xlsx":
                case "xls":
                    return "application/vnd.ms-excel";

                case "docx":
                    return "application/msword";

                case "pdf":
                    return "application/pdf";

                default:
                    return string.Empty;
            }
        }

    }
}
