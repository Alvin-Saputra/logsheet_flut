import 'package:flutter/material.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';
import 'package:logsheet_app/core/widgets/custom_section_card.dart';
import 'package:logsheet_app/core/widgets/custom_section_card_data.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_outgoing_shipment_product_by_vessel/analytical_result_outgoing_shipment_product_by_vessel_header_entity.dart';

class AnalyticalResultOutgoingShipmentProductByVesselMetadata extends StatelessWidget {
  final AnalyticalResultOutgoingShipmentProductByVesselHeaderEntity report;

  const AnalyticalResultOutgoingShipmentProductByVesselMetadata({
    Key? key,
    required this.report,
  }) : super(key: key);

  @override
 Widget build(BuildContext context) {
  return Column(
    children: [
      // --- 1. Metadata & Remarks ---
      CustomSectionCard(
        'Metadata & Remarks',
        [
          CustomSectionCardData(
            'Transaction Date',
            formatDatetoString(report.entryDate, 'dd-MM-yyyy')??'-',
          ),
          
          // CustomSectionCardData('Remarks', report.remarks),
          // CustomSectionCardData('Flag', report.flag),
        ],
      ),
      const SizedBox(height: 16),

      // --- 2. Status & History ---
      CustomSectionCard('Status & History', [
        CustomSectionCardData('Entried By', report.entryBy??'-'),
        CustomSectionCardData(
          'Entry Date',
          formatDatetoString(report.entryDate, 'dd-MM-yyyy')??'-',
        ),
        const Divider(),
        CustomSectionCardData(
          'Prepared By',
          report.preparedBy ?? '-',
        ),
        CustomSectionCardData(
          'Prepared Date',
          formatDatetoString(
                report.preparedDate,
                'dd-MM-yyyy',
              ) ??
              '-',
        ),
        CustomSectionCardData(
          'Prepared Status',
          report.preparedStatus ?? '-',
        ),
        CustomSectionCardData(
          'Prepared Remarks',
          report.preparedStatusRemarks ?? '-',
        ),
        if (report.approvedBy != null ||
            report.approvedStatus != null) ...[
          const Divider(),
          CustomSectionCardData(
            'Checked By',
            report.approvedBy ?? '-',
          ),
          CustomSectionCardData(
            'Checked Date',
            formatDatetoString(
                  report.approvedDate,
                  'dd-MM-yyyy',
                ) ??
                '-',
          ),
          CustomSectionCardData(
            'Checked Status',
            report.approvedStatus ?? '-',
          ),
          CustomSectionCardData(
            'Checked Remarks',
            report.approvedStatusRemarks ?? '-',
          ),
        ],
      ]),
      const SizedBox(height: 16),

      // --- 3. Form Info ---
      CustomSectionCard('Form Info', [
        CustomSectionCardData('Form No', report.formNo??'-'),
        CustomSectionCardData(
          'Date Issued',
          formatDatetoString(report.dateIssued, 'dd-MM-yyyy') ??
              '-',
        ),
        CustomSectionCardData(
          'Revision No',
          report.revisionNo ?? '-',
        ),
        CustomSectionCardData(
          'Revision Date',
          formatDatetoString(
                report.revisionDate,
                'dd-MM-yyyy',
              ) ??
              '-',
        ),
      ]),

      const SizedBox(height: 30),
    ],
  );
}

}
