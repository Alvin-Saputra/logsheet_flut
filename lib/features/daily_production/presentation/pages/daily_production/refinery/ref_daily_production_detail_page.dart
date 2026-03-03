import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/core/utils/app_roles.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';
import 'package:logsheet_app/core/widgets/custom_section_card.dart';
import 'package:logsheet_app/core/widgets/custom_section_card_data.dart';
import 'package:logsheet_app/features/daily_production/data/model/daily_production/daily_production_refinery_entity.dart';
import 'package:logsheet_app/features/master_data/data/model/master/data_form_no_entity.dart';
import 'package:logsheet_app/features/master_data/data/model/master/user_entity.dart';
import 'package:logsheet_app/features/daily_production/presentation/pages/daily_production/refinery/ref_daily_production_edit_page.dart';
import 'package:logsheet_app/features/daily_production/presentation/provider/daily_production/daily_production_refinery_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DailyProductionRefineryDetailPage extends StatefulWidget {
  final List<DailyProductionRefineryEntity> listItem;
  final DataFormNoEntity dataForm;
  final bool isDisplayed;

  const DailyProductionRefineryDetailPage({
    super.key,
    this.isDisplayed = true,
    required this.dataForm,
    required this.listItem,
  });

  @override
  State<DailyProductionRefineryDetailPage> createState() =>
      _DailyProductionRefineryDetailPageState();
}

class _DailyProductionRefineryDetailPageState
    extends State<DailyProductionRefineryDetailPage> {
  final TextEditingController _remarkController = TextEditingController();
  late List<DailyProductionRefineryEntity> _listCurrentReport;
  final PageController detailPageControllers = PageController();
  @override
  void initState() {
    super.initState();
    _listCurrentReport = widget.listItem;
    _listCurrentReport.sort((a, b) => a.no!.compareTo(b.no!));
  }

  // Helper to display values, defaulting to '-' for nulls
  String _displayValue(dynamic value) {
    return value?.toString() ?? '-';
  }

  // Helper to format date-times
  String _formatDateTime(DateTime? date) {
    return date != null ? DateFormat('yyyy-MM-dd HH:mm').format(date) : '-';
  }

  Widget CustomInfoCard(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFAB2F2B),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: title == "Shift" ? 24 : 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _displayTime(TimeOfDay? time) {
    if (time == null) return "-";
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().currentUser;
    final String formattedDate =
        _listCurrentReport[0].transactionDate != null
            ? DateFormat(
              'dd MMMM yyyy',
            ).format(_listCurrentReport[0].transactionDate!)
            : '-';
    final String shift = _displayValue(_listCurrentReport[0].shift);

    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F9),
      appBar: _buildAppBar(context),
      body: _buildBody(context, user, formattedDate, shift),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      title: const Text(
        'Refinery Detail',
        style: TextStyle(color: Color(0xFF655F5B), fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.black),
      actions: [
        if (_listCurrentReport[0].preparedStatus == null &&
            _listCurrentReport[0].isCompleted == false)
          IconButton(
            onPressed: () async {
              final result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (context) => RefDailyProductionEditPage(
                        listReport: _listCurrentReport,
                        dataForm: widget.dataForm,
                      ),
                ),
              );
              if (result != null &&
                  result is List<DailyProductionRefineryEntity>) {
                setState(() {
                  _listCurrentReport = result;
                });
              }
            },
            icon: const Icon(Icons.edit),
          ),
        if (_listCurrentReport[0].preparedStatus == null)
          IconButton(
            onPressed: () async => _showDeleteConfirmationDialog(context),
            icon: const Icon(Icons.delete_rounded, color: Colors.red),
          ),
      ],
    );
  }

  String _formatTimeOfDay(TimeOfDay? time) {
    if (time == null) return '-';
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Widget _buildBody(
    BuildContext context,
    UserEntity? user,
    String formattedDate,
    String shift,
  ) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Top Info Cards
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFAB2F2B),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomInfoCard('Tanggal', formattedDate),
                  const SizedBox(width: 8),
                  CustomInfoCard(
                    'Machine',
                    _displayValue(_listCurrentReport[0].workCenter),
                  ),
                  const SizedBox(width: 8),
                  CustomInfoCard('Shift', shift),
                ],
              ),
            ),

             CustomSectionCard('ID & General Info', [
              CustomSectionCardData(
                'Company',
                _displayValue(_listCurrentReport[0].company),
              ),
              CustomSectionCardData(
                'Plant',
                _displayValue(_listCurrentReport[0].plant),
              ),
              CustomSectionCardData('Ticket ID', _listCurrentReport[0].id),
            ]),

            CustomSectionCard('Production Details', [
              Center(
                child: SmoothPageIndicator(
                  controller:
                      detailPageControllers, // Gunakan satu controller untuk semua
                  count: _listCurrentReport.length,
                  effect: const WormEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    activeDotColor: Colors.blue, // Sesuaikan warna tema Anda
                    dotColor: Colors.grey,
                  ),
                  onDotClicked: (index) {
                    detailPageControllers.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ),
              ExpandablePageView.builder(
                controller: detailPageControllers,
                itemCount: _listCurrentReport.length,
                itemBuilder: (context, pageIndex) {
                  return Column(
                    children: [
                      // CustomSectionCard('ID & General Info', [
                      //   CustomSectionCardData(
                      //     'Ticket ID',
                      //     _listCurrentReport[pageIndex].id,
                      //   ),
                      //   CustomSectionCardData(
                      //     'Company',
                      //     _displayValue(_listCurrentReport[pageIndex].company),
                      //   ),
                      //   CustomSectionCardData(
                      //     'Plant',
                      //     _displayValue(_listCurrentReport[pageIndex].plant),
                      //   ),
                      //   CustomSectionCardData(
                      //     'CPO Tank',
                      //     _displayValue(_listCurrentReport[pageIndex].cpoTank),
                      //   ),
                      // ]),

                      CustomSectionCard('Raw Material (RM)', [
                        CustomSectionCardData(
                          'CPO Tank',
                          _displayValue(_listCurrentReport[pageIndex].cpoTank),
                        ),
                        CustomSectionCardData(
                          'Oil Type',

                          (_listCurrentReport[pageIndex].oilTypeRm != null)
                              ? _listCurrentReport[pageIndex].oilTypeRm
                              : '-',
                        ),
                        CustomSectionCardData(
                          'Awal Jam',
                          _formatTimeOfDay(
                            _listCurrentReport[pageIndex].oilTypeRmAwalJam,
                          ),
                        ),
                        CustomSectionCardData(
                          'Awal Flowmeter (T/H)',
                          _displayValue(
                            _listCurrentReport[pageIndex]
                                .oilTypeRmAwalFlowmeter,
                          ),
                        ),
                        CustomSectionCardData(
                          'Akhir Jam',
                          _formatTimeOfDay(
                            _listCurrentReport[pageIndex].oilTypeRmAkhirJam,
                          ),
                        ),
                        CustomSectionCardData(
                          'Akhir Flowmeter (T/H)',
                          _displayValue(
                            _listCurrentReport[pageIndex]
                                .oilTypeRmAkhirFlowmeter,
                          ),
                        ),
                        CustomSectionCardData(
                          'OIP',
                          _displayValue(
                            _listCurrentReport[pageIndex].oilTypeRmOip,
                          ),
                        ),
                        CustomSectionCardData(
                          'Total',
                          _displayValue(
                            _listCurrentReport[pageIndex].oilTypeRmTotal,
                          ),
                        ),
                      ]),

                      CustomSectionCard('Finished Goods (FG)', [
                        CustomSectionCardData(
                          'Oil Type',
                          _displayValue(
                            _listCurrentReport[pageIndex].oilTypeFg,
                          ),
                        ),
                        CustomSectionCardData(
                          'Awal Jam',
                          _formatTimeOfDay(
                            _listCurrentReport[pageIndex].oilTypeFgAwalJam,
                          ),
                        ),
                        CustomSectionCardData(
                          'Awal Flowmeter (T/H)',
                          _displayValue(
                            _listCurrentReport[pageIndex]
                                .oilTypeFgAwalFlowmeter,
                          ),
                        ),
                        CustomSectionCardData(
                          'Akhir Jam',
                          _formatTimeOfDay(
                            _listCurrentReport[pageIndex].oilTypeFgAkhirJam,
                          ),
                        ),
                        // --- AKHIR PERUBAHAN 3 ---
                        CustomSectionCardData(
                          'Akhir Flowmeter (T/H)',
                          _displayValue(
                            _listCurrentReport[pageIndex]
                                .oilTypeFgAkhirFlowmeter,
                          ),
                        ),
                        CustomSectionCardData(
                          'Total',
                          _displayValue(
                            _listCurrentReport[pageIndex].oilTypeFgTotal,
                          ),
                        ),
                        CustomSectionCardData(
                          'To Tank',
                          _displayValue(
                            _listCurrentReport[pageIndex].oilTypeFgToTank,
                          ),
                        ),
                      ]),

                      CustomSectionCard('By-Product (BP)', [
                        CustomSectionCardData(
                          'Oil Type',
                          _displayValue(
                            _listCurrentReport[pageIndex].oilTypeBp,
                          ),
                        ),
                        CustomSectionCardData(
                          'Awal Jam',
                          _formatTimeOfDay(
                            _listCurrentReport[pageIndex].bpAwalJam,
                          ),
                        ),
                        CustomSectionCardData(
                          'Awal Flowmeter (T/H)',
                          _displayValue(
                            _listCurrentReport[pageIndex].bpAwalFlowmeter,
                          ),
                        ),
                        CustomSectionCardData(
                          'Akhir Jam',
                          _formatTimeOfDay(
                            _listCurrentReport[pageIndex].bpAkhirJam,
                          ),
                        ),
                        CustomSectionCardData(
                          'Akhir Flowmeter (T/H)',
                          _displayValue(
                            _listCurrentReport[pageIndex].bpAkhirFlowmeter,
                          ),
                        ),
                        CustomSectionCardData(
                          'Total',
                          _displayValue(_listCurrentReport[pageIndex].bpTotal),
                        ),
                        CustomSectionCardData(
                          'To Tank',
                          _displayValue(_listCurrentReport[pageIndex].bpToTank),
                        ),
                      ]),

                      CustomSectionCard('Bleaching Earth (BE)', [
                        CustomSectionCardData(
                          'Ref. Tank',
                          _displayValue(
                            _listCurrentReport[pageIndex].beRefTank,
                          ),
                        ),
                        CustomSectionCardData(
                          'Ref. Qty',
                          _displayValue(_listCurrentReport[pageIndex].beRefQty),
                        ),
                        CustomSectionCardData(
                          'Total Bag',
                          _displayValue(
                            _listCurrentReport[pageIndex].beTotalBag,
                          ),
                        ),
                        CustomSectionCardData(
                          'Total Jenis',
                          _displayValue(
                            _listCurrentReport[pageIndex].beTotalJenis,
                          ),
                        ),
                        CustomSectionCardData(
                          'Lot Batch Number',
                          _displayValue(
                            _listCurrentReport[pageIndex].beLotBatchNumber,
                          ),
                        ),
                        CustomSectionCardData(
                          'Yield (%)',
                          _displayValue(
                            _listCurrentReport[pageIndex].beYieldPercent,
                          ),
                        ),
                      ]),

                      CustomSectionCard('Phosphoric Acid (PA)', [
                        CustomSectionCardData(
                          'Ref. Tank',
                          _displayValue(
                            _listCurrentReport[pageIndex].paRefTank,
                          ),
                        ),
                        CustomSectionCardData(
                          'Ref. Qty',
                          _displayValue(_listCurrentReport[pageIndex].paRefQty),
                        ),
                        CustomSectionCardData(
                          'Total',
                          _displayValue(_listCurrentReport[pageIndex].paTotal),
                        ),
                        CustomSectionCardData(
                          'Lot Batch Number',
                          _displayValue(
                            _listCurrentReport[pageIndex].paLotBatchNumber,
                          ),
                        ),
                        CustomSectionCardData(
                          'Yield (%)',
                          _displayValue(
                            _listCurrentReport[pageIndex].paYieldPercent,
                          ),
                        ),
                      ]),

                      CustomSectionCard('Utility Usage (UU)', [
                        CustomSectionCardData(
                          'Item',
                          _displayValue(_listCurrentReport[pageIndex].uuItem),
                        ),
                        CustomSectionCardData(
                          'Budget Ref Tank',
                          _displayValue(
                            _listCurrentReport[pageIndex].uuBudgetRefTank,
                          ),
                        ),
                        CustomSectionCardData(
                          'Budget Qty',
                          _displayValue(
                            _listCurrentReport[pageIndex].uuBudgetQty,
                          ),
                        ),
                        CustomSectionCardData(
                          'Total CPO',
                          _displayValue(
                            _listCurrentReport[pageIndex].uuTotalCpo,
                          ),
                        ),
                        CustomSectionCardData(
                          'Total Steam',
                          _displayValue(
                            _listCurrentReport[pageIndex].uuTotalSteam,
                          ),
                        ),
                        CustomSectionCardData(
                          'Steam / CPO',
                          _displayValue(
                            _listCurrentReport[pageIndex].uuSteamCpo,
                          ),
                        ),
                        CustomSectionCardData(
                          'Yield (%)',
                          _displayValue(
                            _listCurrentReport[pageIndex].uuYieldPercent,
                          ),
                        ),
                      ]),
                    ],
                  );
                },
              ),
            ]),

            CustomSectionCard('Metadata & Remarks', [
              CustomSectionCardData(
                'Transaction Date',
                _formatDateTime(_listCurrentReport[0].transactionDate),
              ),
              CustomSectionCardData(
                'Posting Date',
                _formatDateTime(_listCurrentReport[0].postingDate),
              ),
              CustomSectionCardData(
                'Remarks',
                _displayValue(_listCurrentReport[0].remarks),
              ),
              CustomSectionCardData(
                'Flag',
                _displayValue(_listCurrentReport[0].flag),
              ),
            ]),

            // --- AKHIR PERUBAHAN 5 ---
            CustomSectionCard('Status & History', [
              CustomSectionCardData(
                'Entried By',
                _displayValue(_listCurrentReport[0].entryBy),
              ),
              CustomSectionCardData(
                'Entry Date',
                _formatDateTime(_listCurrentReport[0].entryDate),
              ),
              const Divider(),
              CustomSectionCardData(
                'Prepared By',
                _displayValue(_listCurrentReport[0].preparedBy),
              ),
              CustomSectionCardData(
                'Prepared Date',
                _formatDateTime(_listCurrentReport[0].preparedDate),
              ),
              CustomSectionCardData(
                'Prepared Status',
                _displayValue(_listCurrentReport[0].preparedStatus),
              ),
              CustomSectionCardData(
                'Prepared Remarks',
                _displayValue(_listCurrentReport[0].preparedStatusRemarks),
              ),
              const Divider(),
              CustomSectionCardData(
                'Verified By',
                _displayValue(_listCurrentReport[0].verifiedBy),
              ),
              CustomSectionCardData(
                'Verified Date',
                _formatDateTime(_listCurrentReport[0].verifiedDate),
              ),
              CustomSectionCardData(
                'Verified Status',
                _displayValue(_listCurrentReport[0].verifiedStatus),
              ),

              const Divider(),
              CustomSectionCardData(
                'Checked By',
                _displayValue(_listCurrentReport[0].checkedBy),
              ),
              CustomSectionCardData(
                'Checked Date',
                _formatDateTime(_listCurrentReport[0].checkedDate),
              ),
              CustomSectionCardData(
                'Checked Status',
                _displayValue(_listCurrentReport[0].checkedStatus),
              ),
              CustomSectionCardData(
                'Checked Remarks',
                _displayValue(_listCurrentReport[0].checkedStatusRemarks),
              ),
              CustomSectionCardData(
                'Status (Open/Closed)',
                _displayValue(
                  _listCurrentReport[0].isCompleted == true ? "Closed" : "Open",
                ),
              ),
            ]),

            CustomSectionCard('Form Info', [
              CustomSectionCardData(
                'Form No',
                _displayValue(_listCurrentReport[0].formNo),
              ),
              CustomSectionCardData(
                'Date Issued',
                _formatDateTime(_listCurrentReport[0].dateIssued),
              ),
              CustomSectionCardData(
                'Revision No',
                _displayValue(_listCurrentReport[0].revisionNo),
              ),
              CustomSectionCardData(
                'Revision Date',
                _formatDateTime(_listCurrentReport[0].revisionDate),
              ),
            ]),

            // Action Buttons
            if (AppRoles.leadProd.contains(user?.role))
              if (widget.isDisplayed)
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 62,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: ElevatedButton(
                            onPressed: () {
                              // if (_listCurrentReport[0].isCompleted == false) {
                              //   ScaffoldMessenger.of(context).showSnackBar(
                              //     const SnackBar(
                              //       content: Text(
                              //         "Report Must be Completed Before Being Rejected",
                              //       ),
                              //     ),
                              //   );
                              //   return;
                              // }
                              _showApprovedRejectedBottomSheet(
                                context,
                                false,
                                shift,
                                user!,

                                _listCurrentReport[0].isCompleted ?? false,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[700],
                              foregroundColor: Colors.white,
                            ),
                            child: Text("Reject Shift $shift"),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 62,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: ElevatedButton(
                            onPressed: () {
                              //   if(_listCurrentReport[0].isCompleted == false){
                              //   ScaffoldMessenger.of(context).showSnackBar(
                              //     const SnackBar(
                              //       content: Text(
                              //         "Report Must be Completed Before Being Approved",
                              //       ),
                              //     ),
                              //   );
                              //   return;
                              // }
                              _showApprovedRejectedBottomSheet(
                                context,
                                true,
                                shift,
                                user!,

                                _listCurrentReport[0].isCompleted ?? false,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[700],
                              foregroundColor: Colors.white,
                            ),
                            child: Text("Approve Shift $shift"),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        // TODO: 4. Use a Consumer for your production provider
        // return Consumer<DailyProductionRefineryProvider>(
        //   builder: (context, provider, child) {
        //     bool isLoadingDelete = provider.isLoadingDelete;
        return Consumer2<DailyProductionRefineryProvider, UserProvider>(
          builder:
              (context, provider, userProvider, child) => AlertDialog(
                title: const Text('Hapus Ticket'),
                content: Text(
                  "Apakah anda yakin ingin menghapus Ticket ${_listCurrentReport[0].id}?",
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text("Tidak"),
                    onPressed: () => Navigator.pop(context),
                  ),
                  ElevatedButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child:
                        provider.isLoadingDelete
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                            : const Text(
                              'Ya',
                              style: TextStyle(color: Colors.white),
                            ),
                    onPressed: () async {
                      final result = await provider.deleteTicketById(
                        userProvider.currentUser?.username ?? "",
                        _listCurrentReport[0].id,
                        _listCurrentReport[0].shift ?? "",
                        _listCurrentReport[0].plant ?? "",
                      );

                      if (result) {
                        if (!context.mounted) return;
                        Navigator.pop(context); // Close dialog
                        Navigator.pop(context); // Go back from detail page
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Report berhasil di-delete")),
                        );
                      }
                    },
                  ),
                ],
              ),
        );
        //   },
        // );
      },
    );
  }

  void _showApprovedRejectedBottomSheet(
    BuildContext context,
    bool isApproved,
    String shift,
    UserEntity user,
    bool isTicketCompleted,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  isApproved ? "Approve Report" : "Reject Report",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  isTicketCompleted
                      ? "Are you sure you want to ${isApproved ? "approve" : "reject"} this report?"
                      : "Are you sure you want to ${isApproved ? "approve" : "reject"} this report? Report must be completed before it can be ${isApproved ? "approved" : "rejected"}.",
                  style: const TextStyle(
                    fontSize: 14,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (!isApproved)
                  TextFormField(
                    controller: _remarkController,
                    decoration: const InputDecoration(
                      labelText: "Remarks",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 5,
                  ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Cancel"),
                        ),
                      ),
                    ),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final result = await context
                              .read<DailyProductionRefineryProvider>()
                              .sendApproveRejectReport(
                                user.username,
                                isApproved ? "Approved" : "Rejected",
                                user.role,
                                shift,
                                isApproved ? null : _remarkController.text,
                                _listCurrentReport[0].id!,
                                _listCurrentReport[0].plant!,
                                changeUncompletedTicket:
                                    isTicketCompleted ? false : true,
                                approveAllShift: false
                              );

                          if (result) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isApproved
                                      ? "ID Transaksi ${_listCurrentReport[0].id} berhasil diapprove"
                                      : "ID Transaksi ${_listCurrentReport[0].id} berhasil direject",
                                ),
                              ),
                            );
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          } else {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isApproved
                                      ? "ID Transaksi ${_listCurrentReport[0].id} gagal diapprove"
                                      : "ID Transaksi ${_listCurrentReport[0].id} gagal direject",
                                ),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
                          foregroundColor: Colors.white,
                        ),
                        child: Text(
                          isApproved ? 'Submit Approval' : 'Submit Rejection',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
