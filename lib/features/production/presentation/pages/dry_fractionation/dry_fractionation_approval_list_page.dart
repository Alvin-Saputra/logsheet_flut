import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';
import 'package:logsheet_app/core/widgets/custom_date_field.dart';
import 'package:logsheet_app/core/widgets/custom_snack_bar.dart';
import 'package:logsheet_app/features/master_data/data/model/master/data_form_no_entity.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/plant_provider.dart';
import 'package:logsheet_app/features/production/presentation/pages/dry_fractionation/dry_fractionation_approval_detail_page.dart';
import 'package:logsheet_app/features/production/presentation/provider/dry_fractionation/dry_fractionation_provider.dart';
import 'package:logsheet_app/features/quality_control/presentation/pages/analytical_result_incoming_material_by_truck/analytical_result_incoming_material_by_truck_approval_detail_page.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/data_form_no_provider.dart';
import 'package:provider/provider.dart';

// Dummy model class to simulate your report entity

class DryFractionationApprovalListPage extends StatefulWidget {
  const DryFractionationApprovalListPage({super.key});

  @override
  State<DryFractionationApprovalListPage> createState() =>
      _DryFractionationApprovalListPageState();
}

class _DryFractionationApprovalListPageState
    extends State<DryFractionationApprovalListPage> {
  DataFormNoEntity? formData;
  final TextEditingController dateEntryController = TextEditingController();
  @override
  initState() {
    super.initState();
    context.read<DryFractionationProvider>().clearReports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildFilterSection(context),
          Expanded(
            child: Consumer<DryFractionationProvider>(
              builder: (
                BuildContext context,
                DryFractionationProvider provider,
                Widget? child,
              ) {
                return (provider.isLoading)
                    ? const Center(child: CircularProgressIndicator())
                    : (provider.reportList.isEmpty)
                    ? const Center(child: Text("No Data Available"))
                    : Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: ListView.builder(
                        itemCount: provider.reportList.length,
                        itemBuilder: (context, index) {
                          final item = provider.reportList[index];
                          log("item.transactionDate: ${item.date}");
                          final formattedDate = formatDatetoString(
                            item.date,
                            'dd-MM-yyyy',
                          );
                          return _approvalCardItem(
                            id: item.id ?? '',
                            date: formattedDate ?? '-',
                            preparedStatus: item.preparedStatus ?? '',
                            checkedStatus: item.approvedStatus ?? '',
                          );
                        },
                      ),
                    );
              },
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    formData =
        context
            .read<DataFormNoProvider>()
            .dataFormNoList
            .where(
              (form) =>
                  form.isMenu ==
                  "Analytical_Result_Of_Incoming_Material_By_Vessel",
            )
            .first;
    return AppBar(
      title: Text("Approval (${formData!.code})"),
      actions: [
        Consumer<DryFractionationProvider>(
          builder: (
            BuildContext context,
            DryFractionationProvider provider,
            Widget? child,
          ) {
            return (provider.isLoading)
                ? CircularProgressIndicator()
                : IconButton(
                  onPressed: () async {
                    final plant =
                        await context.read<PlantProvider>().currentPlant;
                    await provider.fetchReport(plant?.code ?? '', '');
                  },
                  icon: Icon(Icons.replay),
                );
          },
        ),
      ],
    );
  }

  Widget _buildFilterSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        children: [
          Expanded(
            child: CustomDateField(
              controller: dateEntryController,
              label: 'Tanggal',
              icon: Icons.event,
            ),
          ),
          SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: () async {
              if (dateEntryController.text != "") {
                final formattedDate = changeStringDateFormat(
                  dateEntryController.text,
                  'dd-MM-yyyy',
                  'yyyy-MM-dd',
                );
                log('Searching for date: $formattedDate');

                final plant = context.read<PlantProvider>().currentPlant;
                final plantId = plant?.code ?? '';
                await context.read<DryFractionationProvider>().fetchReport(
                  plantId,
                  formattedDate,
                );
              } else if (dateEntryController.text == "") {
                showSnackBar("Silahkan Pilih Tanggal", this.context);
              }
            },
            icon: const Icon(Icons.search),
            label: const Text('Cari'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFAB2F2B),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _approvalCardItem({
    required String id,
    required String date,
    required String? preparedStatus,
    required String? checkedStatus,

    IconData? icon,
    Color? iconColor,
    Color? cardColor,
    String? showedStatus,
  }) {
    // Tentukan warna dan ikon berdasarkan status
    if (preparedStatus == "Approved" && checkedStatus == "Approved") {
      icon = Icons.check_circle;
      iconColor = Colors.green;
      cardColor = Colors.green[50];
      showedStatus = "Approved";
    } else if (preparedStatus == "Rejected" || checkedStatus == "Rejected") {
      icon = Icons.cancel;
      iconColor = Colors.red;
      cardColor = Colors.red[50];
      showedStatus = "Rejected";
    } else if (preparedStatus != '') {
      icon = Icons.hourglass_empty;
      iconColor = Colors.orange;
      cardColor = Colors.orange[50];
      showedStatus = "Prepared";
    } else if (preparedStatus == '' && checkedStatus == '') {
      icon = Icons.hourglass_empty;
      iconColor = Colors.blue;
      cardColor = Colors.blue[50];
      showedStatus = "Submitted";
    }

    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => DryFractionationApprovalDetailPage(
                    data: context
                        .read<DryFractionationProvider>()
                        .reportList
                        .firstWhere((element) => element.id == id),
                  ),
            ),
          ).then((_) async {
            if (!mounted) return;
            final plant = await context.read<PlantProvider>().currentPlant;
            final formattedDate = changeStringDateFormat(
              dateEntryController.text,
              'dd-MM-yyyy',
              'yyyy-MM-dd',
            );
            await context.read<DryFractionationProvider>().fetchReport(
              plant?.code ?? '',
              formattedDate,
            );
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: iconColor, size: 36),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      id,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('Date: $date', style: const TextStyle(fontSize: 14)),

                    const SizedBox(height: 4),

                    const SizedBox(height: 4),
                    Text(
                      'Status: $showedStatus',
                      style: TextStyle(
                        fontSize: 14,
                        color: iconColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
