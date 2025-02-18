
namespace referenceApp.PowerBi.Enums
{
    public class ReportEnumMapper
    {
        public static ReportEnum IntToReportEnum(int? value)
        {
            if (value == null || value <= 0)
                return 0;
            return (ReportEnum)value;
        }

    }
}
