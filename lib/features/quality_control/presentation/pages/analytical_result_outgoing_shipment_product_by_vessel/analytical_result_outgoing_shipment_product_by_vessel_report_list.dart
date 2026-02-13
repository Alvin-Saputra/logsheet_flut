import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';
import 'package:logsheet_app/core/widgets/custom_snack_bar.dart';
import 'package:logsheet_app/features/master_data/data/model/master/data_form_no_entity.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/plant_provider.dart';
import 'package:logsheet_app/core/widgets/custom_date_field.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/data_form_no_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/user_provider.dart';
import 'package:logsheet_app/features/quality_control/presentation/pages/analytical_result_outgoing_shipment_product_by_vessel/analytical_result_outgoing_shipment_product_by_vessel_input_page.dart';
import 'package:logsheet_app/features/quality_control/presentation/pages/analytical_result_outgoing_shipment_product_by_vessel/analytical_result_outgoing_shipment_product_by_vessel_list_detail_page.dart';
import 'package:logsheet_app/features/quality_control/presentation/provider/analytical_result_outgoing_shipment_product_by_vessel/analytical_result_outgoing_shipment_product_by_vessel_provider.dart';
import 'package:provider/provider.dart';

class AnalyticalResultOutgoingShipmentProductByVesselReportList
    extends StatefulWidget {
  const AnalyticalResultOutgoingShipmentProductByVesselReportList({super.key});

  @override
  State<AnalyticalResultOutgoingShipmentProductByVesselReportList>
  createState() =>
      _AnalyticalResultOutgoingShipmentProductByVesselReportListState();
}

class _AnalyticalResultOutgoingShipmentProductByVesselReportListState
    extends State<AnalyticalResultOutgoingShipmentProductByVesselReportList> {
  DataFormNoEntity? formData;

  final TextEditingController dateEntryController = TextEditingController();
  @override
  initState() {
    super.initState();
    context
        .read<AnalyticalResultOutgoingShipmentProductByVesselProvider>()
        .clearReports();
  }

  @override
  Widget build(BuildContext context) {
    final userRole = context.read<UserProvider>().currentUser?.role;
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(userRole ?? ''),
     
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
                  "Analytical_Result_of_Outgoing_Shipment_By_Vessel",
            )
            .first;
    return AppBar(title: Text("Analytical Result of OutGoing Shipment By Vessel Report List (${formData!.code})"), actions: [
        
      ],
    );
  }

  Widget _buildBody(String role) {
    return Column(
      children: [
        _buildFilterSection(context, role),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Builder(
              builder: (context) {
                return Consumer<
                  AnalyticalResultOutgoingShipmentProductByVesselProvider
                >(
                  builder: (
                    BuildContext context,
                    AnalyticalResultOutgoingShipmentProductByVesselProvider
                    provider,
                    Widget? child,
                  ) {
                    return (provider.isLoading)
                        ? Center(child: CircularProgressIndicator())
                        : (provider.reportList.isEmpty)
                        ? Center(child: Text('No data'))
                        : ListView.builder(
                          itemCount: provider.reportList.length,
                          itemBuilder: (context, index) {
                            final item = provider.reportList[index];
                            return _cardItem(
                              id: item.id ?? '',
                              date: item.entryDate?.toString() ?? '',
                              entryBy: item.entryBy ?? '',
                              productName: item.productName,
                              role: role,
                              approvedStatus: item.approvedStatus ?? '',
                              preparedStatus: item.preparedStatus ?? '',
                            );
                          },
                        );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterSection(BuildContext context, String role) {
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
                await context
                    .read<
                      AnalyticalResultOutgoingShipmentProductByVesselProvider
                    >()
                    .fetchReport(
                      formattedDate,
                      isFilterBasedOnRole: false,
                      role: role,
                    );
              } else if (dateEntryController.text == "") {
                showSnackBar("Silahkan Pilih Tanggal", this.context);
              }

              // }
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

  Widget _cardItem({
    required String id,
    required String date,
    required String? productName,
    required String? entryBy,
    required String? role,
    required String approvedStatus,
    required String preparedStatus,
    Color? badgeColor,
    String? showedStatus,
  }) {
    if (preparedStatus == "Approved" && approvedStatus == "Approved") {
      badgeColor = Colors.green;
      showedStatus = "Approved";
    } else if (preparedStatus == "Rejected" || approvedStatus == "Rejected") {
      badgeColor = Colors.red;
      showedStatus = "Rejected";
    } else if (preparedStatus != '') {
      badgeColor = Colors.orange;
      showedStatus = "Prepared";
    } else if (preparedStatus == '') {
      badgeColor = Colors.blue;
      showedStatus = "Submitted";
    }
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (
                  context,
                ) => AnalyticalResultOutgoingShipmentProductByVesselListDetailPage(
                  data: context
                      .read<
                        AnalyticalResultOutgoingShipmentProductByVesselProvider
                      >()
                      .reportList
                      .firstWhere((element) => element.id == id), isShowApprovalAction: false,
                ),
          ),
        ).then((_) async {
          if (!mounted) return;

          final plant = context.read<PlantProvider>().currentPlant;
          final plantId = plant?.code ?? '';
          final formattedDate = changeStringDateFormat(
            dateEntryController.text,
            'dd-MM-yyyy',
            'yyyy-MM-dd',
          );
          await context
              .read<AnalyticalResultOutgoingShipmentProductByVesselProvider>()
              .fetchReport(
                formattedDate,
                isFilterBasedOnRole: false,
                role: role,
              );
        });
      },
      child: Card(
        child: Padding(
          padding: EdgeInsetsGeometry.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      "$id",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$showedStatus',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(height: 16),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    changeStringDateFormat(date, "yyyy-MM-dd", "dd-MM-yyyy"),
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  SizedBox(width: 8),

                  SizedBox(width: 8),
                  const Icon(Icons.storage, size: 18, color: Colors.grey),
                  SizedBox(width: 8),
                  Text(
                    "$productName",
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  SizedBox(width: 16),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.person, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    'Entried by: $entryBy',
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
