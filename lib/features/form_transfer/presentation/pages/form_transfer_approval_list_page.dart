import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/features/auth/data/datasources/local/storage_service/storage_service.dart';
import 'package:logsheet_app/features/form_transfer/data/model/remote/form_transfer_header_model.dart';
import 'package:logsheet_app/features/form_transfer/presentation/pages/form_transfer_detail_page.dart';
import 'package:logsheet_app/features/form_transfer/presentation/provider/form_transfer_provider.dart';
import 'package:provider/provider.dart';

/// Approval list page for Form Transfer
///
/// Shows items pending at a specific approval level.
/// Each instance should only show items for ONE approval level.
///
/// [approvalLevel] - 'prepared', 'checked', 'approved', or 'acknowledged'
class FormTransferApprovalListPage extends StatefulWidget {
  final String approvalLevel;

  const FormTransferApprovalListPage({super.key, required this.approvalLevel});

  @override
  State<FormTransferApprovalListPage> createState() =>
      _FormTransferApprovalListPageState();
}

class _FormTransferApprovalListPageState
    extends State<FormTransferApprovalListPage> {
  final StorageService _storageService = StorageService();

  @override
  void initState() {
    super.initState();
    _loadPendingApprovals();
  }

  Future<void> _loadPendingApprovals() async {
    final token = await _storageService.readSessionToken();
    if (token != null && mounted) {
      await context.read<FormTransferProvider>().loadPendingApprovals(
        'Bearer $token',
        widget.approvalLevel,
      );
    }
  }

  Future<void> _onRefresh() async {
    final token = await _storageService.readSessionToken();
    if (token != null && mounted) {
      await context.read<FormTransferProvider>().loadPendingApprovals(
        'Bearer $token',
        widget.approvalLevel,
      );
    }
  }

  String get _pageTitle {
    switch (widget.approvalLevel) {
      case 'prepared':
        return 'Approval - Prepared';
      case 'checked':
        return 'Approval - Checked';
      case 'approved':
        return 'Approval - Approved';
      case 'acknowledged':
        return 'Approval - Acknowledged';
      default:
        return 'Approval List';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitle),
        backgroundColor: const Color(0xFFB91C1C),
        foregroundColor: Colors.white,
        actions: [
          Consumer<FormTransferProvider>(
            builder: (context, provider, child) {
              return provider.isLoading
                  ? const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  )
                  : IconButton(
                    onPressed: _onRefresh,
                    icon: const Icon(Icons.refresh),
                  );
            },
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Consumer<FormTransferProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.error != null) {
          return _buildErrorWidget(provider.error!);
        }

        // Filter to show only items pending at current level
        final pendingItems = _filterPendingAtCurrentLevel(provider.transfers);

        if (pendingItems.isEmpty) {
          return _buildEmptyWidget();
        }

        return _buildApprovalList(pendingItems);
      },
    );
  }

  /// Filter list to show only items pending at the current approval level
  List<FormTransferHeaderModel> _filterPendingAtCurrentLevel(
    List<FormTransferHeaderModel> transfers,
  ) {
    return transfers.where((transfer) {
      switch (widget.approvalLevel) {
        case 'prepared':
          // Show items where prepared is pending/null/empty and not yet approved
          return _isPending(transfer.jsonPreparedStatus);
        case 'checked':
          // Show items where prepared is approved but checked is pending
          return _isApproved(transfer.jsonPreparedStatus) &&
              _isPending(transfer.jsonCheckedStatus);
        case 'approved':
          // Show items where checked is approved but approved is pending
          return _isApproved(transfer.jsonCheckedStatus) &&
              _isPending(transfer.jsonApprovedStatus);
        case 'acknowledged':
          // Show items where approved is approved but acknowledged is pending
          return _isApproved(transfer.jsonApprovedStatus) &&
              _isPending(transfer.jsonAcknowledgedStatus);
        default:
          return false;
      }
    }).toList();
  }

  bool _isPending(String? status) {
    if (status == null || status.isEmpty) return true;
    final lowerStatus = status.toLowerCase();
    return lowerStatus == 'pending' ||
        lowerStatus == 'null' ||
        lowerStatus == 'draft';
  }

  bool _isApproved(String? status) {
    if (status == null || status.isEmpty) return false;
    return status.toLowerCase() == 'approved';
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              'Terjadi kesalahan:',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _onRefresh,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Tidak ada item yang menunggu approval',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tarik ke bawah untuk menyegarkan',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApprovalList(List<FormTransferHeaderModel> transfers) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        itemCount: transfers.length,
        itemBuilder: (context, index) {
          final transfer = transfers[index];
          return _buildApprovalCard(transfer);
        },
      ),
    );
  }

  Widget _buildApprovalCard(FormTransferHeaderModel transfer) {
    return InkWell(
      onTap: () => _navigateToDetail(transfer),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12.0),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      transfer.jsonId,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildStatusBadge(widget.approvalLevel),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatDate(transfer.jsonTransactionDate),
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.arrow_forward, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Dari: ${transfer.jsonFromDept ?? '-'}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.arrow_back, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Ke: ${transfer.jsonToDept ?? '-'}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildApprovalProgressIndicator(transfer),
            ],
          ),
        ),
      ),
    );
  }

  /// Build color-coded status badge for current approval level
  Widget _buildStatusBadge(String level) {
    Color backgroundColor;
    Color textColor;
    String label;
    IconData icon;

    switch (level) {
      case 'prepared':
        backgroundColor = Colors.blue[100]!;
        textColor = Colors.blue[800]!;
        label = 'Prepared';
        icon = Icons.edit;
        break;
      case 'checked':
        backgroundColor = Colors.orange[100]!;
        textColor = Colors.orange[800]!;
        label = 'Checked';
        icon = Icons.fact_check;
        break;
      case 'approved':
        backgroundColor = Colors.purple[100]!;
        textColor = Colors.purple[800]!;
        label = 'Approved';
        icon = Icons.approval;
        break;
      case 'acknowledged':
        backgroundColor = Colors.teal[100]!;
        textColor = Colors.teal[800]!;
        label = 'Acknowledged';
        icon = Icons.check_circle;
        break;
      default:
        backgroundColor = Colors.grey[200]!;
        textColor = Colors.grey[700]!;
        label = 'Pending';
        icon = Icons.hourglass_empty;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: textColor.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  /// Build mini progress indicator showing approval flow
  Widget _buildApprovalProgressIndicator(FormTransferHeaderModel transfer) {
    final steps = [
      {
        'label': 'P',
        'status': transfer.jsonPreparedStatus,
        'color': Colors.blue,
      },
      {
        'label': 'C',
        'status': transfer.jsonCheckedStatus,
        'color': Colors.orange,
      },
      {
        'label': 'A',
        'status': transfer.jsonApprovedStatus,
        'color': Colors.purple,
      },
      {
        'label': 'K',
        'status': transfer.jsonAcknowledgedStatus,
        'color': Colors.teal,
      },
    ];

    return Row(
      children: [
        const Text(
          'Progress: ',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        ...steps.asMap().entries.map((entry) {
          final index = entry.key;
          final step = entry.value;
          final status = step['status'] as String?;
          final color = step['color'] as Color;
          final isApproved = _isApproved(status);
          final isCurrentLevel =
              _getLevelFromIndex(index) == widget.approvalLevel;

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color:
                      isApproved
                          ? color
                          : isCurrentLevel
                          ? color.withValues(alpha: 0.3)
                          : Colors.grey[300],
                  shape: BoxShape.circle,
                  border:
                      isCurrentLevel
                          ? Border.all(color: color, width: 2)
                          : null,
                ),
                child: Center(
                  child:
                      isApproved
                          ? const Icon(
                            Icons.check,
                            size: 14,
                            color: Colors.white,
                          )
                          : Text(
                            step['label'] as String,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isCurrentLevel ? color : Colors.grey[600],
                            ),
                          ),
                ),
              ),
              if (index < steps.length - 1)
                Container(
                  width: 12,
                  height: 2,
                  color: isApproved ? color : Colors.grey[300],
                ),
            ],
          );
        }),
      ],
    );
  }

  String _getLevelFromIndex(int index) {
    switch (index) {
      case 0:
        return 'prepared';
      case 1:
        return 'checked';
      case 2:
        return 'approved';
      case 3:
        return 'acknowledged';
      default:
        return '';
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return '-';
    }
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat('dd-MM-yyyy').format(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  void _navigateToDetail(FormTransferHeaderModel transfer) {
    log('Navigating to approval detail for: ${transfer.jsonId}');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormTransferDetailPage(item: transfer),
      ),
    ).then((_) {
      _onRefresh();
    });
  }
}
