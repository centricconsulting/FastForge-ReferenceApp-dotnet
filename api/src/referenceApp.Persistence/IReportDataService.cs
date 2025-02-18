using referenceApp.Common.Models.Entity;

namespace referenceApp.Persistence;

public interface IReportDataService
{

    ReportEntityModel GetReportInformationById(int id);

    ReportEntityModel GetReportInformation(string reportId, string reportSectionId);

    string GetMimeTypeByFileExtension(string resultFileExtension);
}
