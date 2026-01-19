import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/core/utils/app_roles.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';
import 'package:logsheet_app/core/widgets/custom_info_card.dart';
import 'package:logsheet_app/core/widgets/custom_section_card.dart';
import 'package:logsheet_app/core/widgets/custom_section_card_data.dart';
import 'package:logsheet_app/features/daily_production/data/model/daily_production/daily_production_fractionation_entity.dart';
import 'package:logsheet_app/features/daily_production/presentation/pages/daily_production/fractination/fra_daily_production_edit_page.dart';
import 'package:logsheet_app/features/master_data/data/model/master/data_form_no_entity.dart';
import 'package:logsheet_app/features/master_data/data/model/master/user_entity.dart';
import 'package:logsheet_app/features/daily_production/presentation/provider/daily_production/daily_production_fractionation_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/product_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DailyProductionFractionationDetailPage extends StatefulWidget {
  final List<DailyProductionFractionationEntity> listItem;
  final DataFormNoEntity formData;
  final bool isDisplayed;

  const DailyProductionFractionationDetailPage({
    super.key,
    required this.listItem,
    this.isDisplayed = true,
    required this.formData,
  });

  @override
  State<DailyProductionFractionationDetailPage> createState() =>
      _DailyProductionFractionationDetailPageState();
}

class _DailyProductionFractionationDetailPageState
    extends State<DailyProductionFractionationDetailPage> {
  final TextEditingController _remarkController = TextEditingController();
  late List<DailyProductionFractionationEntity> _listCurrentReport;

  String? oilTypeRmName;
  String? oilTypeFgsName;
  String? oilTypeFghName;

  final PageController detailPageControllers = PageController();

  @override
  void initState() {
    super.initState();
    final productProvider = context.read<ProductProvider>();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await productProvider.fetchProducts();
    });
    _listCurrentReport = widget.listItem;
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

  Widget CustomSectionCardData(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150, // Adjusted width for potentially longer labels
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF655F5B),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.black54)),
          ),
        ],
      ),
    );
  }

  Widget CustomSectionCard(String title, List<Widget> children) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF655F5B),
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
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

    String formatTime(TimeOfDay? time) =>
        time != null
            ? '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'
            : '-';

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
        'Fractionation Detail',
        style: TextStyle(color: Color(0xFF655F5B), fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.black),
      actions: [
        if (_listCurrentReport[0].preparedStatus == null &&
            _listCurrentReport[0].isCompleted == false)
          IconButton(
            onPressed: () async {
              // Navigate to your edit page
              final result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (context) => FraDailyProductionEditPage(
                        dataForm: widget.formData,
                        listReport: _listCurrentReport,
                      ),
                ),
              );
              if (result != null &&
                  result is List<DailyProductionFractionationEntity>) {
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

  String _displayTime(TimeOfDay? time) {
    if (time == null) return "-";
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }

  Widget _buildBody(
    BuildContext context,
    UserEntity? user,
    String formattedDate,
    String shift,
  ) {
    final productProvider = context.read<ProductProvider>();
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
                    'Work Center',
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
            ]),

            CustomSectionCard('Detail Data', [
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
                      SizedBox(height: 12.0),
                      CustomSectionCardData(
                        'Ticket ID',
                        _listCurrentReport[pageIndex].id,
                      ),
                      SizedBox(height: 12.0),
                      CustomSectionCard('Raw Material (RM)', [
                        CustomSectionCardData(
                          'Oil Type Id',
                          _displayValue(
                            _listCurrentReport[pageIndex].oilTypeRmId,
                          ),
                        ),

                        CustomSectionCardData(
                          'Oil Type Name',
                          _displayValue(
                            _listCurrentReport[pageIndex].oilTypeRmName,
                          ),
                        ),
                        // CustomSectionCardData('No', _displayValue(_currentReport.oilTypeRmNo)),
                        CustomSectionCardData(
                          'Cr',
                          _displayValue(
                            _listCurrentReport[pageIndex].oilTypeRmCr,
                          ),
                        ),
                        CustomSectionCardData(
                          'From Tank',
                          _displayValue(
                            _listCurrentReport[pageIndex].oilTypeRmFromTank,
                          ),
                        ),
                        CustomSectionCardData(
                          'Awal Jam',
                          _displayTime(
                            _listCurrentReport[pageIndex].oilTypeRmAwalJam,
                          ),
                        ),
                        CustomSectionCardData(
                          'Awal Flowmeter',
                          _displayValue(
                            _listCurrentReport[pageIndex]
                                .oilTypeRmAwalFlowmeter,
                          ),
                        ),
                        CustomSectionCardData(
                          'Akhir Jam',
                          _displayTime(
                            _listCurrentReport[pageIndex].oilTypeRmAkhirJam,
                          ),
                        ),
                        CustomSectionCardData(
                          'Akhir Flowmeter',
                          _displayValue(
                            _listCurrentReport[pageIndex]
                                .oilTypeRmAkhirFlowmeter,
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
                            _listCurrentReport[pageIndex].oilTypeFgsId,
                          ),
                        ),

                        CustomSectionCardData(
                          'Oil Type Name',
                          _displayValue(
                            _listCurrentReport[pageIndex].oilTypeFgsName,
                          ),
                        ),
                        // CustomSectionCardData('No', _displayValue(_currentReport.oilTypeFgsNo)),
                        CustomSectionCardData(
                          'Cr',
                          _displayValue(
                            _listCurrentReport[pageIndex].oilTypeFgsCr,
                          ),
                        ),
                        CustomSectionCardData(
                          'Awal Jam',
                          _displayTime(
                            _listCurrentReport[pageIndex].oilTypeFgsAwalJam,
                          ),
                        ),
                        CustomSectionCardData(
                          'Awal Flowmeter',
                          _displayValue(
                            _listCurrentReport[pageIndex]
                                .oilTypeFgsAwalFlowmeter,
                          ),
                        ),
                        CustomSectionCardData(
                          'Akhir Jam',
                          _displayTime(
                            _listCurrentReport[pageIndex].oilTypeFgsAkhirJam,
                          ),
                        ),
                        CustomSectionCardData(
                          'Akhir Flowmeter',
                          _displayValue(
                            _listCurrentReport[pageIndex]
                                .oilTypeFgsAkhirFlowmeter,
                          ),
                        ),
                        CustomSectionCardData(
                          'Total',
                          _displayValue(
                            _listCurrentReport[pageIndex].oilTypeFgsTotal,
                          ),
                        ),
                        CustomSectionCardData(
                          'To Tank',
                          _displayValue(
                            _listCurrentReport[pageIndex].oilTypeFgsToTank,
                          ),
                        ),
                      ]),

                      CustomSectionCard('By-Product (BP)', [
                        // CustomSectionCardData(
                        //   'Oil Type',
                        //   _displayValue(_currentReport.oilTypeFgh),
                        // ),
                        // CustomSectionCardData('No', _displayValue(_currentReport.oilTypeFghNo)),
                        CustomSectionCardData(
                          'Oil Type',
                          _displayValue(
                            _listCurrentReport[pageIndex].oilTypeFghId,
                          ),
                        ),

                        CustomSectionCardData(
                          'Oil Type Name',
                          _displayValue(
                            _listCurrentReport[pageIndex].oilTypeFghName,
                          ),
                        ),
                        CustomSectionCardData(
                          'Awal Jam',
                          _displayTime(
                            _listCurrentReport[pageIndex].oilTypeFghAwalJam,
                          ),
                        ),
                        CustomSectionCardData(
                          'Awal Flowmeter',
                          _displayValue(
                            _listCurrentReport[pageIndex]
                                .oilTypeFghAwalFlowmeter,
                          ),
                        ),
                        CustomSectionCardData(
                          'Akhir Jam',
                          _displayTime(
                            _listCurrentReport[pageIndex].oilTypeFghAkhirJam,
                          ),
                        ),
                        CustomSectionCardData(
                          'Akhir Flowmeter',
                          _displayValue(
                            _listCurrentReport[pageIndex]
                                .oilTypeFghAkhirFlowmeter,
                          ),
                        ),
                        CustomSectionCardData(
                          'Total',
                          _displayValue(
                            _listCurrentReport[pageIndex].oilTypeFghTotal,
                          ),
                        ),
                        CustomSectionCardData(
                          'To Tank',
                          _displayValue(
                            _listCurrentReport[pageIndex].oilTypeFghToTank,
                          ),
                        ),
                      ]),
                    ],
                  );
                },
              ),
            ]),

            CustomSectionCard('Utility Usage (UU)', [
              CustomSectionCardData(
                'Item',
                _displayValue(_listCurrentReport[0].uuItem),
              ),
              CustomSectionCardData(
                'Budget Ref Qty',
                _displayValue(_listCurrentReport[0].uuBudgetRefQty),
              ),
              CustomSectionCardData(
                'Flowmeter Before',
                _displayValue(_listCurrentReport[0].uuFlowmeterBefore),
              ),
              CustomSectionCardData(
                'Flowmeter After',
                _displayValue(_listCurrentReport[0].uuFlowmeterAfter),
              ),
              CustomSectionCardData(
                'Flowmeter Total',
                _displayValue(_listCurrentReport[0].uuFlowmeterTotal),
              ),
              CustomSectionCardData(
                'Yield (%)',
                _displayValue(_listCurrentReport[0].uuYieldPercent),
              ),
              CustomSectionCardData(
                'Listrik',
                _displayValue(_listCurrentReport[0].uuListrik),
              ),
              CustomSectionCardData(
                'Air',
                _displayValue(_listCurrentReport[0].uuAir),
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
              CustomSectionCardData(
                'Verified Remarks',
                _displayValue(_listCurrentReport[0].verifiedStatusRemarks),
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
            // user?.role
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
                             _showApprovedRejectedBottomSheet(
                                context,
                                false,
                                shift,
                                user!,
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
                              _showApprovedRejectedBottomSheet(
                                context,
                                true,
                                shift,
                                user!,
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
        return Consumer2<DailyProductionFractionationProvider, UserProvider>(
          builder:
              (context, provider, userProvider, child) => AlertDialog(
                title: const Text('Hapus Ticket'),
                content: Text("Apakah anda yakin ingin menghapus Ticket "),
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
                        _listCurrentReport[0].shift ?? "",
                        _listCurrentReport[0].plant ?? "",
                        formatDatetoString(
                              _listCurrentReport[0].transactionDate,
                              'yyyy-MM-dd HH:mm:ss',
                            ) ??
                            "",
                      );

                      if (result) {
                        if (!context.mounted) return;
                        Navigator.pop(context); // Close dialog
                        Navigator.pop(context); // Go back from detail page
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Report berhasil di-delete")),
                        );
                      }
                      // if (!context.mounted) return;
                      // Navigator.pop(context); // Close dialog
                      // Navigator.pop(context); // Go back from detail page
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
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
                ElevatedButton(
                  onPressed: () async {
                    final result = await context
                        .read<DailyProductionFractionationProvider>()
                        .sendApproveRejectReport(
                          user.username,
                          isApproved ? "Approved" : "Rejected",
                          user.role,
                          _listCurrentReport[0].shift ?? "",
                          isApproved ? null : _remarkController.text,
                          _listCurrentReport[0].plant ?? "",
                          formatDatetoString(
                                _listCurrentReport[0].transactionDate,
                                'yyyy-MM-dd HH:mm:ss',
                              ) ??
                              "",
                          _listCurrentReport[0].workCenter ?? "",
                        );

                    if (result) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isApproved
                                ? "Report berhasil diapprove"
                                : "Report berhasil direject",
                          ),
                        ),
                      );
                      Navigator.of(context).pop(); // Close bottom sheet
                      Navigator.of(context).pop(); // Go back from detail page
                    } else {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isApproved
                                ? "Report gagal diapprove"
                                : "Report gagal direject",
                          ),
                        ),
                      );
                    }
                  },
                  child: Text(
                    isApproved ? 'Submit Approval' : 'Submit Rejection',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
