import 'package:flutter/material.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';
import 'package:logsheet_app/core/widgets/custom_section_card.dart';
import 'package:logsheet_app/core/widgets/custom_section_card_data.dart';
import 'package:logsheet_app/features/production/data/model/dry_fractionation/local/dry_fractionation_header_entity.dart';

void dryFractionationMetaDataBottomSheet(
  BuildContext context,
  DryFractionationHeaderEntity report,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Agar bisa full height/flexible
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.7, // Tinggi awal 70% layar
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              // Handle bar (garis kecil di atas untuk visual drag)
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Title Bottom Sheet
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Document Information",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(),

              // Content List
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // --- 1. Metadata & Remarks ---
                      CustomSectionCard(
                        'Metadata & Remarks', // Sesuaikan properti title
                        [
                          // Asumsi CustomSectionCard menerima children/items
                          CustomSectionCardData(
                            'Transaction Date',
                            formatDatetoString(report.date, 'dd-MM-yyyy'),
                          ),
                          CustomSectionCardData(
                            'Posting Date',
                            formatDatetoString(
                              report.postingDate,
                              'dd-MM-yyyy',
                            ),
                          ),
                          CustomSectionCardData('Remarks', report.remarks),
                          CustomSectionCardData('Flag', report.flag),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // --- 2. Status & History ---
                      CustomSectionCard('Status & History', [
                        CustomSectionCardData('Entried By', report.entryBy),
                        CustomSectionCardData(
                          'Entry Date',
                          formatDatetoString(report.entryDate, 'dd-MM-yyyy'),
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

                        // Tampilkan Approved section hanya jika ada datanya
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
                        CustomSectionCardData('Form No', report.formNo),
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

                      const SizedBox(height: 30), // Extra space bottom
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
