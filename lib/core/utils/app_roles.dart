/// A centralized class for managing user roles and permissions.
class AppRoles {
  // This is a private constructor, which means you cannot create an
  // instance of this class. We only want to access its static members.
  AppRoles._();

  /// Roles with access to the general Quality Control (QC) section.
  static const List<String> qualityControlAccess = [
    "ADM",
    "LEAD",
    "LEAD_QC",
    "OPR",
    "OPR_QC",
    "MGR",
    "MGR_QC",
  ];

  static const List<String> admin = ['ADM'];

  static const List<String> leadQC = ["LEAD", "LEAD_QC"];
  static const List<String> leadProd = ["LEAD", "LEAD_PROD"];
  static const List<String> managerProd = ["MGR", "MGR_PROD"];

  /// Roles that can approve within the Quality Control (QC) section.
  static const List<String> qualityControlManagerApproval = [
    "MGR",
    "MGR_QC",
    "ADM",
  ];

  /// Roles with access to the Production quality reports section.
  static const List<String> productionQualityAccess = [
    "ADM",
    "OPR",
    "OPR_PROD",
    "LEAD",
    "LEAD_PROD",
    "MGR",
    "MGR_PROD",
  ];

  /// Roles that can approve within the Production quality reports section.
  static const List<String> productionQualityManagerApproval = [
    "MGR",
    "MGR_PROD",
    "ADM",
  ];

  /// Roles with general access to Production Logsheets (like Pretreatment and Deodorizing).
  static const List<String> logsheetAccess = [
    "ADM",
    "OPR",
    "OPR_PROD",
    "LEAD",
    "LEAD_PROD",
    "MGR",
    "MGR_PROD",
  ];

  /// Roles that can approve Production Logsheets.
  static const List<String> logsheetManagerApproval = [
    "MGR",
    "MGR_PROD",
    "ADM",
  ];

  /// Roles that can approve within the Production quality reports section.
  static const List<String> productionManagerApproval = [
    "MGR",
    "MGR_PROD",
    "ADM",
  ];

  /// Roles with access to the Form Transfer feature.
  static const List<String> formTransferAccess = [
    "ADM",
    "PRO",
    "CPC",
    "OPS",
    "LEAD_PROD",
    "STAFF_PROD",
    "OPR_PROD",
    "OPR",
    "QC",
    "LEAD_QC",
    "MGR_QC",
    "STAFF_QC",
    "OPR_QC",
    "MGR_OPS",
    "LEAD_OPS",
    "MGR",
    "PPIC",
    "MGR_PPIC",
    "LEAD_PPIC",
    "STAFF_PPIC",
  ];

  /// Roles that can approve Prepared level in Form Transfer.
  static const List<String> formTransferPreparedApproval = [
    "PRO",
    "CPC",
    "OPS",
    "LEAD_PROD",
    "STAFF_PROD",
    "OPR_PROD",
    "OPR",
    "ADM",
  ];

  /// Roles that can approve Checked level in Form Transfer.
  static const List<String> formTransferCheckedApproval = [
    "QC",
    "LEAD_QC",
    "MGR_QC",
    "STAFF_QC",
    "OPR_QC",
    "ADM",
  ];

  /// Roles that can approve Approved level in Form Transfer.
  static const List<String> formTransferApprovedApproval = [
    "OPS",
    "MGR_OPS",
    "LEAD_OPS",
    "ADM",
    "MGR",
  ];

  /// Roles that can approve Acknowledged level in Form Transfer.
  static const List<String> formTransferAcknowledgedApproval = [
    "PPIC",
    "MGR_PPIC",
    "LEAD_PPIC",
    "STAFF_PPIC",
    "ADM",
  ];
}
