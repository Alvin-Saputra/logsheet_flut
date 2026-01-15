import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';
import 'package:logsheet_app/core/widgets/custom_snack_bar.dart';
import 'package:logsheet_app/features/master_data/data/model/master/data_form_no_entity.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/plant_provider.dart';
import 'package:logsheet_app/core/widgets/custom_date_field.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/data_form_no_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/user_provider.dart';
import 'package:logsheet_app/features/production/presentation/pages/dry_fractionation/dry_fractionation_detail_page.dart';
import 'package:logsheet_app/features/production/presentation/pages/dry_fractionation/dry_fractionation_input.dart';
import 'package:logsheet_app/features/production/presentation/provider/dry_fractionation/dry_fractionation_provider.dart';
import 'package:logsheet_app/features/quality_control/presentation/pages/analytical_result_incoming_plant_chemical_ingredient/analytical_result/analytical_result_incoming_plant_chemical_ingredient_detail_page.dart';
import 'package:logsheet_app/features/quality_control/presentation/pages/analytical_result_incoming_plant_chemical_ingredient/analytical_result/analytical_result_incoming_plant_chemical_ingredient_input_page.dart';
import 'package:logsheet_app/features/quality_control/presentation/provider/analytical_result_incoming_plant_chemical_ingredient/analytical_result/analytical_result_incoming_plant_chemical_ingredient_provider.dart';
import 'package:provider/provider.dart';

class DryFractionationListPage extends StatefulWidget {
  const DryFractionationListPage({super.key});

  @override
  State<DryFractionationListPage> createState() =>
      _DryFractionationListPageState();
}

class _DryFractionationListPageState extends State<DryFractionationListPage> {
  DataFormNoEntity? formData;

  final TextEditingController dateEntryController = TextEditingController();
  @override
  initState() {
    super.initState();
    context
        .read<DryFractionationProvider>()
        .clearReports();
  }

  @override
  Widget build(BuildContext context) {
    final userRole = context.read<UserProvider>().currentUser?.role;
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(userRole ?? ''),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      DryFractionationInputPage(form: formData,),
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
            await context.read<DryFractionationProvider>().fetchReport(
              plantId,
              formattedDate,
            );
          });
        },
        label: const Text("Tambah Report"),
        icon: Icon(Icons.add),
        backgroundColor: Color(0xFFB91C1C),
        foregroundColor: Colors.white,
      ),
    );
  }

  AppBar _buildAppBar() {
    formData =
        context
            .read<DataFormNoProvider>()
            .dataFormNoList
            .where((form) => form.isMenu == "Logsheet_Dry_Fractionation")
            .first;
    return AppBar(title: Text("List (${formData!.code})"), actions: [
        
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
                return Consumer<DryFractionationProvider>(
                  builder: (
                    BuildContext context,
                    DryFractionationProvider provider,
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
                              material: item.crystallizer,
                              role: role,
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
                await context.read<DryFractionationProvider>().fetchReport(
                  plantId,
                  formattedDate,
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
    required String? material,
    required String? entryBy,
    required String? role,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => DryFractionationDetailPage(
                  data: context
                      .read<DryFractionationProvider>()
                      .reportList
                      .firstWhere((element) => element.id == id),
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
          await context.read<DryFractionationProvider>().fetchReport(
            plantId,
            formattedDate,
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
                    "${_formatDateString(date)}",
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  SizedBox(width: 8),

                  SizedBox(width: 8),
                  const Icon(Icons.storage, size: 18, color: Colors.grey),
                  SizedBox(width: 8),
                  Text(
                    "$material",
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
              // Row(
              //   children: [
              //     const Icon(
              //       Icons.car_repair_outlined,
              //       size: 18,
              //       color: Colors.grey,
              //     ),
              //     SizedBox(width: 8),
              //     Text(
              //       'Vessel/Vechicle: $vesselVehicle',
              //       style: const TextStyle(fontSize: 14, color: Colors.black87),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateString(String? s) {
    if (s == null || s.isEmpty) return '-';
    final dt = DateTime.tryParse(s);
    if (dt != null) {
      return DateFormat('dd-MM-yyyy').format(dt);
    }
    // If parsing fails, return the original string as a fallback
    return s;
  }
}
