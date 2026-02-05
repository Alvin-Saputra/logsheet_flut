import 'package:flutter/material.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';
import 'package:logsheet_app/core/widgets/custom_section_card_data.dart';
import 'package:logsheet_app/features/production/data/model/dry_fractionation/local/dry_fractionation_detail_entity.dart';

void dryFractionationDetailBottomSheet(
    BuildContext context,
    DryFractionationDetailEntity detail,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Detail Cycle #${detail.filtrationCycleNumber}",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Divider(),
                CustomSectionCardData(
                  "Filtration Temp",
                  "${detail.filtrationTemp ?? '-'}",
                ),

                CustomSectionCardData(
                  "Filtration Start Time",
                  formatTimeOfDay(detail.timeStartFiltration) ?? '-',
                ),

                CustomSectionCardData(
                  "Filtration End Time",
                  formatTimeOfDay(detail.timeEndFiltration) ?? '-',
                ),

                CustomSectionCardData("Load (%)", "${detail.load ?? '-'}"),
                const SizedBox(height: 8),
                const Text(
                  "Olein",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                CustomSectionCardData("IV", "${detail.oleinIv ?? '-'}"),
                CustomSectionCardData("CP (°C)", "${detail.oleinCp ?? '-'}"),
                CustomSectionCardData("FFA", "${detail.oleinFfa ?? '-'}"),
                CustomSectionCardData(
                  "Color (Red)",
                  "${detail.oleinColorRed ?? '-'}",
                ),
                const SizedBox(height: 8),
                const Text(
                  "Stearin",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                CustomSectionCardData("IV", "${detail.stearinIv ?? '-'}"),
                CustomSectionCardData("FFA", "${detail.stearinFfa ?? '-'}"),
                CustomSectionCardData(
                  "Color (Red)",
                  "${detail.stearinColorRed ?? '-'}",
                ),
                CustomSectionCardData("PV", "${detail.stearinPv ?? '-'}"),
              ],
            ),
          ),
        );
      },
    );
  }