import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/core/utils/app_roles.dart';
import 'package:logsheet_app/core/widgets/custom_remark_field.dart';
import 'package:logsheet_app/core/widgets/custom_snack_bar.dart';
import 'package:logsheet_app/features/auth/data/datasources/local/storage_service/storage_service.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/plant_provider.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/form_transfer/form_transfer_detail_model.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/form_transfer/form_transfer_header_model.dart';
import 'package:logsheet_app/features/quality_control/presentation/provider/form_transfer/form_transfer_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/user_provider.dart';
import 'package:provider/provider.dart';

class FormTransferApprovalDetailPage extends StatefulWidget {
  final String id;
  final String approvalLevel;

  const FormTransferApprovalDetailPage({
    super.key,
    required this.id,
    required this.approvalLevel,
  });

  @override
  State<FormTransferApprovalDetailPage> createState() =>
      _FormTransferApprovalDetailPageState();
}

class _FormTransferApprovalDetailPageState
    extends State<FormTransferApprovalDetailPage> {
  FormTransferHeaderModel? transferItem;
  final TextEditingController remarkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadTransferData();
    });
  }

  void _loadTransferData() {
    final provider = context.read<FormTransferProvider>();
    try {
      final item = provider.transfers.firstWhere(
        (element) => element.jsonId == widget.id,
      );
      setState(() {
        transferItem = item;
      });
    } catch (e) {
      // Item not found in list
      setState(() {
        transferItem = null;
      });
    }
  }

  @override
  void dispose() {
    remarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Consumer<FormTransferProvider>(
        builder: (
          BuildContext context,
          FormTransferProvider provider,
          Widget? child,
        ) {
          return provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildBody(context);
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Consumer2<FormTransferProvider, UserProvider>(
      builder: (
        BuildContext context,
        FormTransferProvider transferProvider,
        UserProvider userProvider,
        Widget? child,
      ) {
        if (transferItem == null) {
          return const Center(child: Text('Transfer data not found'));
        }

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
                      _buildInfoCard(
                        'Form No',
                        transferItem?.jsonFormNo ?? '-',
                      ),
                      _buildInfoCard(
                        'Date',
                        _formatDateString(transferItem?.jsonTransactionDate),
                      ),
                    ],
                  ),
                ),

                // General Information Section
                _buildSection('General Information', [
                  _buildDataRow('ID', transferItem?.jsonId ?? ''),
                  _buildDataRow('Company', transferItem?.jsonCompany ?? ''),
                  _buildDataRow('Plant', transferItem?.jsonPlant ?? ''),
                  _buildDataRow(
                    'From Department',
                    transferItem?.jsonFromDept ?? '',
                  ),
                  _buildDataRow(
                    'To Department',
                    transferItem?.jsonToDept ?? '',
                  ),
                  _buildDataRow(
                    'Date Issued',
                    _formatDateString(transferItem?.jsonDateIssued),
                  ),
                  _buildDataRow(
                    'Revision No',
                    '${transferItem?.jsonRevisionNo ?? '-'}',
                  ),
                  _buildDataRow(
                    'Revision Date',
                    _formatDateString(transferItem?.jsonRevisionDate),
                  ),
                ]),

                // Transfer Details Section
                if (transferItem?.jsonDetail != null &&
                    transferItem!.jsonDetail!.isNotEmpty)
                  _buildSection(
                    'Transfer Details (${transferItem!.jsonDetail!.length} items)',
                    _buildDetailRows(transferItem!.jsonDetail!),
                  ),

                // Approval Status Section (2-step: Lead → Manager)
                _buildSection('Approval Status', [
                  _buildApprovalStatusRow(
                    'Lead Approval',
                    transferItem?.jsonPreparedBy,
                    transferItem?.jsonPreparedDate,
                    transferItem?.jsonPreparedStatus,
                    transferItem?.jsonPreparedStatusRemarks,
                  ),
                  _buildApprovalStatusRow(
                    'Manager Approval',
                    transferItem?.jsonApprovedBy,
                    transferItem?.jsonApprovedDate,
                    transferItem?.jsonApprovedStatus,
                    transferItem?.jsonApprovedStatusRemarks,
                  ),
                ]),

                // Entry Information
                _buildSection('Entry Information', [
                  _buildDataRow('Entry By', transferItem?.jsonEntryBy ?? '-'),
                  _buildDataRow(
                    'Entry Date',
                    _formatDateString(transferItem?.jsonEntryDate),
                  ),
                  _buildDataRow(
                    'Updated By',
                    transferItem?.jsonUpdatedBy ?? '-',
                  ),
                  _buildDataRow(
                    'Updated Date',
                    _formatDateString(transferItem?.jsonUpdatedDate),
                  ),
                ]),

                // Approval Actions Section
                _buildApprovalActionsSection(context, userProvider),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildDetailRows(List<FormTransferDetailModel> details) {
    final List<Widget> widgets = [];

    for (int i = 0; i < details.length; i++) {
      final detail = details[i];
      widgets.add(
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Item ${i + 1}: ${detail.jsonOilType ?? '-'}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xFF655F5B),
                ),
              ),
              const Divider(height: 16),
              _buildDataRow('Quantity', detail.jsonQuantity ?? '-'),
              _buildDataRow(
                'From Storage Tank',
                detail.jsonFromStorageTankNo ?? '-',
              ),
              _buildDataRow(
                'From Refinery/Fractionation',
                detail.jsonFromRefineryFractionation ?? '-',
              ),
              _buildDataRow('From Other', detail.jsonFromOther ?? '-'),
              _buildDataRow(
                'To Storage Tank',
                detail.jsonToStorageTankNo ?? '-',
              ),
              _buildDataRow(
                'To Refinery/Fractionation',
                detail.jsonToRefineryFractionation ?? '-',
              ),
              _buildDataRow(
                'To Auto Filling Tank',
                detail.jsonToAutoFillingTank?.toString() ?? '-',
              ),
              _buildDataRow('To Other', detail.jsonToOther ?? '-'),
              const Divider(height: 16),
              const Text(
                'Quality Parameters:',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Color(0xFFAB2F2B),
                ),
              ),
              const SizedBox(height: 8),
              _buildDataRow(
                'M & I',
                detail.jsonQualityMAndI?.toString() ?? '-',
              ),
              _buildDataRow('FFA', detail.jsonQualityFfa?.toString() ?? '-'),
              _buildDataRow(
                'Lovibond Color R',
                detail.jsonQualityLovColorR?.toString() ?? '-',
              ),
              _buildDataRow(
                'Lovibond Color Y',
                detail.jsonQualityLovColorY?.toString() ?? '-',
              ),
              _buildDataRow(
                'Cloud Point Temp',
                detail.jsonQualityCpTemp?.toString() ?? '-',
              ),
              _buildDataRow('SMP', detail.jsonQualitySmp?.toString() ?? '-'),
              _buildDataRow('PV', detail.jsonQualityPv?.toString() ?? '-'),
              _buildDataRow('IV', detail.jsonQualityIv?.toString() ?? '-'),
              if (detail.jsonRemark != null && detail.jsonRemark!.isNotEmpty)
                _buildDataRow('Remark', detail.jsonRemark!),
            ],
          ),
        ),
      );
    }

    return widgets;
  }

  Widget _buildApprovalActionsSection(
    BuildContext context,
    UserProvider userProvider,
  ) {
    final userRole = userProvider.currentUser?.role;

    // 2-step approval flow: Lead (prepared) -> Manager (approved)
    final String? preparedStatus = transferItem?.jsonPreparedStatus;
    final String? approvedStatus = transferItem?.jsonApprovedStatus;

    // If both steps are approved
    if (preparedStatus == 'Approved' && approvedStatus == 'Approved') {
      return _buildSection('Approval Actions', [
        const Center(
          child: Text(
            'Transfer Fully Approved',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green,
              fontSize: 16,
            ),
          ),
        ),
      ]);
    }

    // If either step is rejected
    if (preparedStatus == 'Rejected' || approvedStatus == 'Rejected') {
      return _buildSection('Approval Actions', [
        const Center(
          child: Text(
            'Transfer Rejected',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
              fontSize: 16,
            ),
          ),
        ),
      ]);
    }

    // Manager approval flow (MGR, MGR_QC, ADM)
    if (AppRoles.qualityControlManagerApproval.contains(userRole)) {
      // Manager can only approve if Lead has already approved
      if (preparedStatus == 'Approved' && approvedStatus == null) {
        return _buildSection('Approval Actions', [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
                    onPressed: () => _showRejectBottomSheet(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[700],
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.close, color: Colors.white),
                        SizedBox(width: 8),
                        Text('Reject', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
                    onPressed: () => _approveTransfer(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.check, color: Colors.white),
                        SizedBox(width: 8),
                        Text('Approve', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ]);
      } else if (preparedStatus == null) {
        return _buildSection('Approval Actions', [
          const Center(
            child: Text(
              'Waiting for Lead approval...',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ),
        ]);
      }
    }

    // Lead approval flow (LEAD, LEAD_QC)
    if (AppRoles.leadQC.contains(userRole)) {
      if (preparedStatus == null) {
        return _buildSection('Approval Actions', [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
                    onPressed: () => _showRejectBottomSheet(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[700],
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.close, color: Colors.white),
                        SizedBox(width: 8),
                        Text('Reject', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
                    onPressed: () => _approveTransfer(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.check, color: Colors.white),
                        SizedBox(width: 8),
                        Text('Approve', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ]);
      } else if (preparedStatus == 'Approved' && approvedStatus == null) {
        return _buildSection('Approval Actions', [
          const Center(
            child: Text(
              'Waiting for Manager approval...',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ),
        ]);
      }
    }

    // Default: waiting state for other roles
    return _buildSection('Approval Actions', [
      Center(
        child: Text(
          preparedStatus == null
              ? 'Waiting for Lead approval...'
              : 'Waiting for Manager approval...',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
      ),
    ]);
  }

  Future<void> _approveTransfer(BuildContext context) async {
    final transferProvider = context.read<FormTransferProvider>();
    final storageService = context.read<StorageService>();
    final token = await storageService.readSessionToken() ?? '';
    final plant = context.read<PlantProvider>().currentPlant;
    final plantId = plant?.code ?? '';
    try {
      await transferProvider.approveTransfer(
        widget.id,
        'Bearer $token',
        plantId,
        level: widget.approvalLevel,
      );

      if (!mounted) return;
      if (context.mounted) {
        showSnackBar('Transfer approved successfully', context);
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (!mounted) return;
      if (context.mounted) {
        showSnackBar('Failed to approve transfer: $e', context);
      }
    }
  }

  Future<void> _rejectTransfer(BuildContext context) async {
    final transferProvider = context.read<FormTransferProvider>();
    final storageService = context.read<StorageService>();
    final token = await storageService.readSessionToken() ?? '';
    final plant = context.read<PlantProvider>().currentPlant;
    final plantId = plant?.code ?? '';

    try {
      await transferProvider.rejectTransfer(
        widget.id,
        'Bearer $token',
        plantId,
        level: widget.approvalLevel,
        remarks:
            remarkController.text.isNotEmpty ? remarkController.text : null,
      );

      if (!mounted) return;
      if (context.mounted) {
        showSnackBar('Transfer rejected', context);
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (!mounted) return;
      if (context.mounted) {
        showSnackBar('Failed to reject transfer: $e', context);
      }
    }
  }

  void _showRejectBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                'Reject Transfer',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.red[800],
                ),
              ),
              const SizedBox(height: 12),
              CustomRemarkField(controller: remarkController),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (remarkController.text.isEmpty) {
                          showSnackBar(
                            'Please provide remarks before rejecting',
                            context,
                          );
                          return;
                        }

                        Navigator.of(context).pop();
                        await _rejectTransfer(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[700],
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Confirm Reject',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildApprovalStatusRow(
    String level,
    String? by,
    String? date,
    String? status,
    String? remarks,
  ) {
    Color statusColor;
    switch (status) {
      case 'Approved':
        statusColor = Colors.green;
        break;
      case 'Rejected':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                level,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF655F5B),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withAlpha((0.1 * 255).toInt()),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status ?? 'Pending',
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          if (by != null && by.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              'By: $by',
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
          if (date != null && date.isNotEmpty) ...[
            Text(
              'Date: ${_formatDateString(date)}',
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
          if (remarks != null && remarks.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              'Remarks: $remarks',
              style: TextStyle(fontSize: 12, color: Colors.red[700]),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF655F5B),
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(value, style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
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

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      title: const Text(
        'Transfer Approval Detail',
        style: TextStyle(color: Color(0xFF655F5B), fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.black),
    );
  }

  String _formatDateString(String? s) {
    if (s == null || s.isEmpty) return '-';
    final dt = DateTime.tryParse(s);
    if (dt != null) {
      return DateFormat('dd MMMM yyyy').format(dt);
    }
    return s;
  }
}
