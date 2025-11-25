class AnalyticalResultIncomingMaterialByVesselReportEntity {
  // =========================
  // HEADER FIELDS
  // =========================
  final String idHdr;
  final String company;
  final String plant;
  final String? transactionDate;

  final String? material;
  final String? arrival;
  final String? quantity;
  final String? supplier;
  final String? shipName;
  final String? contractDoNomor;
  final String? ffa;
  final String? mni;
  final String? dobi;
  final String? others;
  final String? hasilAnalisaFfa;
  final String? hasilAnalisaIv;
  final String? hasilAnalisaMoisture;
  final String? hasilAnalisaDobi;
  final String? hasilAnalisaPv;
  final String? hasilAnalisaAnv;

  final String? remarks;
  final String? flag;
  final String? entryBy;
  final String? entryDate;
  final String? preparedBy;
  final String? preparedDate;
  final String? preparedStatus;
  final String? preparedStatusRemarks;
  final String? approvedBy;
  final String? approvedDate;
  final String? approvedStatus;
  final String? approvedStatusRemarks;
  final String? updatedBy;
  final String? updatedDate;
  final String? formNo;
  final String? dateIssued;
  final String? revisionNo;
  final String? revisionDate;

  // =========================
  // DETAIL FIELDS
  // =========================
  final String idDetail;

  final String? palkaSNo;
  final String? palkaSFfa;
  final String? palkaSIv;
  final String? palkaSDobi;
  final String? palkaSMni;

  final String? palkaCNo;
  final String? palkaCFfa;
  final String? palkaCIv;
  final String? palkaCDobi;
  final String? palkaCMni;

  final String? palkaPNo;
  final String? palkaPFfa;
  final String? palkaPIv;
  final String? palkaPDobi;
  final String? palkaPMni;

  AnalyticalResultIncomingMaterialByVesselReportEntity({
    // HEADER
    required this.idHdr,
    required this.company,
    required this.plant,
    required this.transactionDate,
    required this.material,
    required this.arrival,
    required this.quantity,
    required this.supplier,
    required this.shipName,
    required this.contractDoNomor,
    required this.ffa,
    required this.mni,
    required this.dobi,
    required this.others,
    required this.hasilAnalisaFfa,
    required this.hasilAnalisaIv,
    required this.hasilAnalisaMoisture,
    required this.hasilAnalisaDobi,
    required this.hasilAnalisaPv,
    required this.hasilAnalisaAnv,
    required this.remarks,
    required this.flag,
    required this.entryBy,
    required this.entryDate,
    required this.preparedBy,
    required this.preparedDate,
    required this.preparedStatus,
    required this.preparedStatusRemarks,
    required this.approvedBy,
    required this.approvedDate,
    required this.approvedStatus,
    required this.approvedStatusRemarks,
    required this.updatedBy,
    required this.updatedDate,
    required this.formNo,
    required this.dateIssued,
    required this.revisionNo,
    required this.revisionDate,

    // DETAIL
    required this.idDetail,
    required this.palkaSNo,
    required this.palkaSFfa,
    required this.palkaSIv,
    required this.palkaSDobi,
    required this.palkaSMni,
    required this.palkaCNo,
    required this.palkaCFfa,
    required this.palkaCIv,
    required this.palkaCDobi,
    required this.palkaCMni,
    required this.palkaPNo,
    required this.palkaPFfa,
    required this.palkaPIv,
    required this.palkaPDobi,
    required this.palkaPMni,
  });

  factory AnalyticalResultIncomingMaterialByVesselReportEntity.fromMap(
    Map<String, dynamic> map,
  ) {
    return AnalyticalResultIncomingMaterialByVesselReportEntity(
      // HEADER
      idHdr: map['id_hdr']?.toString() ?? '', // header ID
      company: map['company']?.toString() ?? '',
      plant: map['plant']?.toString() ?? '',
      transactionDate: map['transaction_date']?.toString(),

      material: map['material']?.toString(),
      arrival: map['arrival']?.toString(),
      quantity: map['quantity']?.toString(),
      supplier: map['supplier']?.toString(),
      shipName: map['ship_name']?.toString(),
      contractDoNomor: map['contract_do_nomor']?.toString(),
      ffa: map['ffa']?.toString(),
      mni: map['mni']?.toString(),
      dobi: map['dobi']?.toString(),
      others: map['others']?.toString(),

      hasilAnalisaFfa: map['hasil_analisa_ffa']?.toString(),
      hasilAnalisaIv: map['hasil_analisa_iv']?.toString(),
      hasilAnalisaMoisture: map['hasil_analisa_moisture']?.toString(),
      hasilAnalisaDobi: map['hasil_analisa_dobi']?.toString(),
      hasilAnalisaPv: map['hasil_analisa_pv']?.toString(),
      hasilAnalisaAnv: map['hasil_analisa_anv']?.toString(),

      remarks: map['remarks']?.toString(),
      flag: map['flag']?.toString(),
      entryBy: map['entry_by']?.toString(),
      entryDate: map['entry_date']?.toString(),
      preparedBy: map['prepared_by']?.toString(),
      preparedDate: map['prepared_date']?.toString(),
      preparedStatus: map['prepared_status']?.toString(),
      preparedStatusRemarks: map['prepared_status_remarks']?.toString(),
      approvedBy: map['approved_by']?.toString(),
      approvedDate: map['approved_date']?.toString(),
      approvedStatus: map['approved_status']?.toString(),
      approvedStatusRemarks: map['approved_status_remarks']?.toString(),
      updatedBy: map['updated_by']?.toString(),
      updatedDate: map['updated_date']?.toString(),
      formNo: map['form_no']?.toString(),
      dateIssued: map['date_issued']?.toString(),
      revisionNo: map['revision_no']?.toString(),
      revisionDate: map['revision_date']?.toString(),

      // DETAIL
      idDetail: map['id_hdr']?.toString() ?? '', // detail id
      palkaSNo: map['palka_s_no']?.toString(),
      palkaSFfa: map['palka_s_ffa']?.toString(),
      palkaSIv: map['palka_s_iv']?.toString(),
      palkaSDobi: map['palka_s_dobi']?.toString(),
      palkaSMni: map['palka_s_mni']?.toString(),

      palkaCNo: map['palka_c_no']?.toString(),
      palkaCFfa: map['palka_c_ffa']?.toString(),
      palkaCIv: map['palka_c_iv']?.toString(),
      palkaCDobi: map['palka_c_dobi']?.toString(),
      palkaCMni: map['palka_c_mni']?.toString(),

      palkaPNo: map['palka_p_no']?.toString(),
      palkaPFfa: map['palka_p_ffa']?.toString(),
      palkaPIv: map['palka_p_iv']?.toString(),
      palkaPDobi: map['palka_p_dobi']?.toString(),
      palkaPMni: map['palka_p_mni']?.toString(),
    );
  }
}
