using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace NTNMath.Data.Models;

[Table("Report")]
[Index("ReportSectionId", Name = "IX_Report_ReportSectionId", IsUnique = true)]
public partial class Report
{
    [Key]
    public int Id { get; set; }

    [Required]
    [StringLength(100)]
    [Unicode(false)]
    public string Name { get; set; }

    [StringLength(100)]
    [Unicode(false)]
    public string DownloadFileName { get; set; }

    [StringLength(50)]
    [Unicode(false)]
    public string ReportId { get; set; }

    [Required]
    [StringLength(50)]
    [Unicode(false)]
    public string ReportSectionId { get; set; }

    public bool IsPaginatedReport { get; set; }

    [StringLength(50)]
    [Unicode(false)]
    public string PaginatedReportId { get; set; }

    [StringLength(100)]
    [Unicode(false)]
    public string DataModelTableName { get; set; }

    public bool HasPaginatedVisual { get; set; }
}
