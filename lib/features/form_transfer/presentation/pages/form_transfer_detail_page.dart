import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/core/utils/app_roles.dart';
import 'package:logsheet_app/features/auth/data/datasources/local/storage_service/storage_service.dart';
import 'package:logsheet_app/features/form_transfer/data/model/remote/form_transfer_header_model.dart';
import 'package:logsheet_app/features/form_transfer/presentation/pages/form_transfer_input_page.dart';
import 'package:logsheet_app/features/form_transfer/presentation/provider/form_transfer_provider.dart';
import 'package:logsheet_app/features/master_data/data/model/master/user_entity.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/user_provider.dart';
import 'package:provider/provider.dart';

class FormTransferDetailPage extends StatefulWidget {
  final FormTransferHeaderModel item;
  final bool isDisplayed;

  const FormTransferDetailPage({
    super.key,
    required this.item,
    this.isDisplayed = true,
  });

  @override
  State<FormTransferDetailPage> createState() => _FormTransferDetailPageState();
}

class _FormTransferDetailPageState extends State<FormTransferDetailPage> {
  final TextEditingController _remarkController = TextEditingController();
  late FormTransferHeaderModel _currentTransfer;

  @override
  void initState() {
    super.initState();
    _currentTransfer = widget.item;
  }

  @override
  void dispose() {
    _remarkController.dispose();
    super.dispose();
  }

  Widget _buildInfoCard(String title, String value) {
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
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
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

  Widget _buildSection(String title, List<Widget> children) {
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

  String _getApprovalLevel() {
    // Determine which approval level is pending
    if (_currentTransfer.jsonPreparedStatus == null) {
      return 'prepared';
    } else if (_currentTransfer.jsonCheckedStatus == null) {
      return 'checked';
    } else if (_currentTransfer.jsonApprovedStatus == null) {
      return 'approved';
    } else if (_currentTransfer.jsonAcknowledgedStatus == null) {
      return 'acknowledged';
    }
    return '';
  }

  bool _canShowApprovalButtons(UserEntity? user) {
    final level = _getApprovalLevel();
    if (level.isEmpty) return false;

    switch (level) {
      case 'prepared':
        return AppRoles.formTransferPreparedApproval.contains(user?.role);
      case 'checked':
        return AppRoles.formTransferCheckedApproval.contains(user?.role);
      case 'approved':
        return AppRoles.formTransferApprovedApproval.contains(user?.role);
      case 'acknowledged':
        return AppRoles.formTransferAcknowledgedApproval.contains(user?.role);
      default:
        return false;
    }
  }

  String _getApprovalLevelLabel() {
    final level = _getApprovalLevel();
    switch (level) {
      case 'prepared':
        return 'Prepared';
      case 'checked':
        return 'Checked';
      case 'approved':
        return 'Approved';
      case 'acknowledged':
        return 'Acknowledged';
      default:
        return '';
    }
  }

  void _showApproveRejectBottomSheet(
    BuildContext context,
    bool isApproved,
    UserEntity user,
  ) {
    final level = _getApprovalLevel();

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
                  isApproved ? 'Approve Form Transfer' : 'Reject Form Transfer',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Level: ${_getApprovalLevelLabel()}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                if (!isApproved)
                  TextFormField(
                    controller: _remarkController,
                    decoration: const InputDecoration(
                      labelText: 'Remarks',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 5,
                  ),
                const SizedBox(height: 16),
                Consumer<FormTransferProvider>(
                  builder: (context, provider, child) {
                    return ElevatedButton(
                      onPressed:
                          provider.isLoading
                              ? null
                              : () async {
                                final storageService =
                                    context.read<StorageService>();
                                final token =
                                    await storageService.readSessionToken() ??
                                    '';

                                if (isApproved) {
                                  await context
                                      .read<FormTransferProvider>()
                                      .approveTransfer(
                                        _currentTransfer.jsonId,
                                        'Bearer $token',
                                        level: level,
                                      );
                                } else {
                                  await context
                                      .read<FormTransferProvider>()
                                      .rejectTransfer(
                                        _currentTransfer.jsonId,
                                        'Bearer $token',
                                        level: level,
                                        remarks:
                                            _remarkController.text.isNotEmpty
                                                ? _remarkController.text
                                                : null,
                                      );
                                }

                                if (!context.mounted) return;

                                // Show success message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      isApproved
                                          ? 'Form Transfer ${_currentTransfer.jsonId} berhasil diapprove'
                                          : 'Form Transfer ${_currentTransfer.jsonId} berhasil direject',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    backgroundColor: Colors.black,
                                  ),
                                );

                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                      child:
                          provider.isLoading
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : Text(
                                isApproved
                                    ? 'Submit Approval'
                                    : 'Submit Rejection',
                              ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return Consumer2<FormTransferProvider, UserProvider>(
          builder: (context, provider, userProvider, child) {
            return AlertDialog(
              title: const Text('Hapus Form Transfer'),
              content: Text(
                'Apakah anda yakin ingin menghapus Form Transfer ${_currentTransfer.jsonId}?',
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Tidak'),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                  ),
                  child:
                      provider.isLoading
                          ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                          : const Text('Ya'),
                  onPressed: () async {
                    final storageService = context.read<StorageService>();
                    final token = await storageService.readSessionToken() ?? '';

                    await provider.deleteTransfer(
                      _currentTransfer.jsonId,
                      'Bearer $token',
                    );

                    if (!context.mounted) return;
                    Navigator.pop(context, true);
                  },
                ),
              ],
            );
          },
        );
      },
    );

    if (shouldDelete == true) {
      if (!context.mounted) return;
      Navigator.of(context).pop();
    }
  }

  String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '-';
    try {
      final dateTime = DateTime.parse(dateStr);
      return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>().currentUser;

    String transactionDate = '-';
    if (_currentTransfer.jsonTransactionDate != null) {
      try {
        final dateTime = DateTime.parse(_currentTransfer.jsonTransactionDate!);
        transactionDate = DateFormat('dd MMMM yyyy').format(dateTime);
      } catch (e) {
        transactionDate = _currentTransfer.jsonTransactionDate!;
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F9),
      appBar: _buildAppBar(context, user),
      body: _buildBody(transactionDate, user),
    );
  }

  AppBar _buildAppBar(BuildContext context, UserEntity? user) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      title: const Text(
        'Form Transfer',
        style: TextStyle(color: Color(0xFF655F5B), fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.black),
      actions: [
        // Show edit/delete if prepared status is null or user has lead role
        if (_currentTransfer.jsonPreparedStatus == null ||
            AppRoles.leadProd.contains(user?.role) ||
            AppRoles.admin.contains(user?.role)) ...[
          IconButton(
            onPressed: () async {
              // Navigate to edit page
              final result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const FormTransferInputPage(),
                ),
              );

              if (result != null && result is FormTransferHeaderModel) {
                setState(() {
                  _currentTransfer = result;
                });
              }
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () async => await _showDeleteConfirmationDialog(context),
            icon: const Icon(Icons.delete_rounded, color: Colors.red),
          ),
        ],
      ],
    );
  }

  Widget _buildBody(String transactionDate, UserEntity? user) {
    final details = _currentTransfer.jsonDetail ?? [];

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(
          top: 16,
          bottom: 36,
          right: 16,
          left: 16,
        ),
        child: Column(
          children: [
            // Header Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFAB2F2B),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoCard('Transaction Date', transactionDate),
                  const SizedBox(width: 8),
                  _buildInfoCard('Rows', '${details.length}'),
                ],
              ),
            ),

            // ID Section
            _buildSection('ID', [
              _buildDataRow('Transfer ID', _currentTransfer.jsonId),
            ]),

            // Company & Plant Section
            _buildSection('Company & Plant', [
              _buildDataRow('Company', _currentTransfer.jsonCompany ?? '-'),
              _buildDataRow('Plant', _currentTransfer.jsonPlant ?? '-'),
            ]),

            // Department Section
            _buildSection('Department Information', [
              _buildDataRow('From Dept', _currentTransfer.jsonFromDept ?? '-'),
              _buildDataRow('To Dept', _currentTransfer.jsonToDept ?? '-'),
            ]),

            // Form Information Section
            _buildSection('Form Information', [
              _buildDataRow('Form No', _currentTransfer.jsonFormNo ?? '-'),
              _buildDataRow(
                'Date Issued',
                formatDate(_currentTransfer.jsonDateIssued),
              ),
              _buildDataRow(
                'Revision No',
                _currentTransfer.jsonRevisionNo?.toString() ?? '-',
              ),
              _buildDataRow(
                'Revision Date',
                formatDate(_currentTransfer.jsonRevisionDate),
              ),
            ]),

            // Details Section
            if (details.isNotEmpty)
              _buildSection(
                'Transfer Rows',
                details.asMap().entries.map((entry) {
                  final index = entry.key;
                  final detail = entry.value;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (details.length > 1)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            'Row ${index + 1}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF655F5B),
                            ),
                          ),
                        ),
                      _buildDataRow('Oil Type', detail.jsonOilType ?? '-'),
                      _buildDataRow('Quantity', detail.jsonQuantity ?? '-'),
                      _buildDataRow(
                        'From Storage Tank',
                        detail.jsonFromStorageTankNo ?? '-',
                      ),
                      _buildDataRow(
                        'From Refinery/Fractionation',
                        detail.jsonFromRefineryFractionation ?? '-',
                      ),
                      if (detail.jsonFromOther != null &&
                          detail.jsonFromOther!.isNotEmpty)
                        _buildDataRow('From Other', detail.jsonFromOther!),
                      _buildDataRow(
                        'To Storage Tank',
                        detail.jsonToStorageTankNo ?? '-',
                      ),
                      _buildDataRow(
                        'To Refinery/Fractionation',
                        detail.jsonToRefineryFractionation ?? '-',
                      ),
                      if (detail.jsonToOther != null &&
                          detail.jsonToOther!.isNotEmpty)
                        _buildDataRow('To Other', detail.jsonToOther!),
                      const SizedBox(height: 8),
                      const Text(
                        'Quality Parameters:',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      _buildDataRow(
                        'M&I (%)',
                        detail.jsonQualityMAndI?.toString() ?? '-',
                      ),
                      _buildDataRow(
                        'FFA (%)',
                        detail.jsonQualityFfa?.toString() ?? '-',
                      ),
                      _buildDataRow(
                        'Color R',
                        detail.jsonQualityLovColorR?.toString() ?? '-',
                      ),
                      _buildDataRow(
                        'Color Y',
                        detail.jsonQualityLovColorY?.toString() ?? '-',
                      ),
                      _buildDataRow(
                        'CP Temp (°C)',
                        detail.jsonQualityCpTemp?.toString() ?? '-',
                      ),
                      _buildDataRow(
                        'SMP (°C)',
                        detail.jsonQualitySmp?.toString() ?? '-',
                      ),
                      _buildDataRow(
                        'PV',
                        detail.jsonQualityPv?.toString() ?? '-',
                      ),
                      _buildDataRow(
                        'IV',
                        detail.jsonQualityIv?.toString() ?? '-',
                      ),
                      if (detail.jsonRemark != null &&
                          detail.jsonRemark!.isNotEmpty)
                        _buildDataRow('Row Remark', detail.jsonRemark!),
                      if (details.length > 1)
                        const Divider(height: 24, thickness: 1),
                    ],
                  );
                }).toList(),
              ),

            // Status & History Section
            _buildSection('Status & History', [
              _buildDataRow('Entried By', _currentTransfer.jsonEntryBy ?? '-'),
              _buildDataRow(
                'Entry Date',
                formatDate(_currentTransfer.jsonEntryDate),
              ),
              const Divider(),
              _buildDataRow(
                'Prepared By',
                _currentTransfer.jsonPreparedBy ?? '-',
              ),
              _buildDataRow(
                'Prepared Date',
                formatDate(_currentTransfer.jsonPreparedDate),
              ),
              _buildDataRow(
                'Prepared Status',
                _currentTransfer.jsonPreparedStatus ?? '-',
              ),
              _buildDataRow(
                'Prepared Remarks',
                _currentTransfer.jsonPreparedStatusRemarks ?? '-',
              ),
              const Divider(),
              _buildDataRow(
                'Checked By',
                _currentTransfer.jsonCheckedBy ?? '-',
              ),
              _buildDataRow(
                'Checked Date',
                formatDate(_currentTransfer.jsonCheckedDate),
              ),
              _buildDataRow(
                'Checked Status',
                _currentTransfer.jsonCheckedStatus ?? '-',
              ),
              _buildDataRow(
                'Checked Remarks',
                _currentTransfer.jsonCheckedStatusRemarks ?? '-',
              ),
              const Divider(),
              _buildDataRow(
                'Approved By',
                _currentTransfer.jsonApprovedBy ?? '-',
              ),
              _buildDataRow(
                'Approved Date',
                formatDate(_currentTransfer.jsonApprovedDate),
              ),
              _buildDataRow(
                'Approved Status',
                _currentTransfer.jsonApprovedStatus ?? '-',
              ),
              _buildDataRow(
                'Approved Remarks',
                _currentTransfer.jsonApprovedStatusRemarks ?? '-',
              ),
              const Divider(),
              _buildDataRow(
                'Acknowledged By',
                _currentTransfer.jsonAcknowledgedBy ?? '-',
              ),
              _buildDataRow(
                'Acknowledged Date',
                formatDate(_currentTransfer.jsonAcknowledgedDate),
              ),
              _buildDataRow(
                'Acknowledged Status',
                _currentTransfer.jsonAcknowledgedStatus ?? '-',
              ),
              _buildDataRow(
                'Acknowledged Remarks',
                _currentTransfer.jsonAcknowledgedStatusRemarks ?? '-',
              ),
              const Divider(),
              _buildDataRow(
                'Updated By',
                _currentTransfer.jsonUpdatedBy ?? '-',
              ),
              _buildDataRow(
                'Updated Date',
                formatDate(_currentTransfer.jsonUpdatedDate),
              ),
            ]),

            // Approval Buttons
            if (widget.isDisplayed && _canShowApprovalButtons(user))
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 62,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: ElevatedButton(
                          onPressed: () {
                            _showApproveRejectBottomSheet(
                              context,
                              false,
                              user!,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[700],
                            foregroundColor: Colors.white,
                          ),
                          child: Text('Reject ${_getApprovalLevelLabel()}'),
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
                            _showApproveRejectBottomSheet(context, true, user!);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[700],
                            foregroundColor: Colors.white,
                          ),
                          child: Text('Approve ${_getApprovalLevelLabel()}'),
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
}
