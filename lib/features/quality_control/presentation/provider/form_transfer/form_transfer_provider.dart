import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/form_transfer/form_transfer_detail_model.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/form_transfer/form_transfer_header_model.dart';
import 'package:logsheet_app/features/quality_control/data/repositories/form_transfer/form_transfer_repository.dart';

class FormTransferProvider extends ChangeNotifier {
  final FormTransferRepository repository;

  FormTransferProvider({required this.repository});

  // State variables
  bool isLoading = false;
  String? error;
  List<FormTransferHeaderModel> transfers = [];
  FormTransferHeaderModel? currentTransfer;
  List<FormTransferDetailModel> detailDrafts = [];

  // Private helper methods for state management
  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    error = message;
    notifyListeners();
  }

  void _clearError() {
    error = null;
  }

  String _formatErrorMessage(Object error) {
    final message = error.toString();
    return message.replaceFirst('Exception: ', '');
  }

  /// Load all form transfers from the API
  Future<void> loadTransfers(
    String token, {
    String? transactionDate,
    String? status,
  }) async {
    log('Loading form transfers...');
    _setLoading(true);
    _clearError();

    try {
      transfers = await repository.getFormTransfers(
        token,
        transactionDate: transactionDate,
        status: status,
      );
      log('Loaded ${transfers.length} form transfers');
      _setLoading(false);
    } catch (e) {
      log('Error loading form transfers: $e');
      _setError(_formatErrorMessage(e));
      _setLoading(false);
    }
  }

  /// Create a new form transfer
  Future<void> createTransfer(
    FormTransferHeaderModel transfer,
    String token,
  ) async {
    log('Creating form transfer...');
    _setLoading(true);
    _clearError();

    try {
      final body = transfer.toJson();
      final response = await repository.createFormTransfer(body, token);
      log('Form transfer created with ID: ${response.idHeader}');

      // Refresh the list after creation
      await loadTransfers(token);
      _setLoading(false);
    } catch (e) {
      log('Error creating form transfer: $e');
      _setError('Failed to create form transfer: $e');
      _setLoading(false);
    }
  }

  /// Update an existing form transfer
  Future<void> updateTransfer(
    String id,
    FormTransferHeaderModel transfer,
    String token,
  ) async {
    log('Updating form transfer: $id');
    _setLoading(true);
    _clearError();

    try {
      final body = transfer.toJson();
      final response = await repository.updateFormTransfer(id, body, token);
      log('Form transfer updated: ${response.message}');

      // Refresh the list after update
      await loadTransfers(token);
      _setLoading(false);
    } catch (e) {
      log('Error updating form transfer: $e');
      _setError('Failed to update form transfer: $e');
      _setLoading(false);
    }
  }

  /// Delete a form transfer
  Future<void> deleteTransfer(String id, String token) async {
    log('Deleting form transfer: $id');
    _setLoading(true);
    _clearError();

    try {
      final response = await repository.deleteFormTransfer(id, token);
      log('Form transfer deleted: ${response.message}');

      // Remove from local list
      transfers.removeWhere((t) => t.jsonId == id);

      // Clear current transfer if it matches
      if (currentTransfer?.jsonId == id) {
        currentTransfer = null;
      }

      _setLoading(false);
    } catch (e) {
      log('Error deleting form transfer: $e');
      _setError('Failed to delete form transfer: $e');
      _setLoading(false);
    }
  }

  /// Approve a form transfer
  /// [level] - 'prepared', 'approved' (2-step approval: Lead -> Manager)
  Future<void> approveTransfer(String id, String token, {String? level}) async {
    log('Approving form transfer: $id, level: $level');
    _setLoading(true);
    _clearError();

    try {
      final response = await repository.approveFormTransfer(
        id,
        token,
        level: level,
      );
      log('Form transfer approved: ${response.message}');

      // Refresh the list after approval
      await loadTransfers(token);
      _setLoading(false);
    } catch (e) {
      log('Error approving form transfer: $e');
      _setError('Failed to approve form transfer: $e');
      _setLoading(false);
    }
  }

  /// Reject a form transfer
  /// [level] - 'prepared', 'approved' (2-step approval: Lead -> Manager)
  /// [remarks] - Required remarks for rejection
  Future<void> rejectTransfer(
    String id,
    String token, {
    String? level,
    String? remarks,
  }) async {
    log('Rejecting form transfer: $id, level: $level');
    _setLoading(true);
    _clearError();

    try {
      final response = await repository.rejectFormTransfer(
        id,
        token,
        level: level,
        remarks: remarks,
      );
      log('Form transfer rejected: ${response.message}');

      // Refresh the list after rejection
      await loadTransfers(token);
      _setLoading(false);
    } catch (e) {
      log('Error rejecting form transfer: $e');
      _setError('Failed to reject form transfer: $e');
      _setLoading(false);
    }
  }

  /// Load pending approvals filtered by approval level
  /// [level] - 'prepared', 'approved' (2-step approval: Lead -> Manager)
  Future<void> loadPendingApprovals(String token, String level) async {
    log('Loading pending approvals for level: $level');
    _setLoading(true);
    _clearError();

    try {
      transfers = await repository.getPendingApprovals(token, level);
      log('Loaded ${transfers.length} pending approvals for level: $level');
      _setLoading(false);
    } catch (e) {
      log('Error loading pending approvals: $e');
      _setError('Failed to load pending approvals: $e');
      _setLoading(false);
    }
  }

  /// Set the current transfer being viewed/edited
  void setCurrentTransfer(FormTransferHeaderModel? transfer) {
    currentTransfer = transfer;
    notifyListeners();
  }

  /// Add a detail to the draft list
  void addDetail(FormTransferDetailModel detail) {
    detailDrafts.add(detail);
    notifyListeners();
    log('Added detail to draft. Total drafts: ${detailDrafts.length}');
  }

  /// Remove a detail from the draft list by index
  void removeDetail(int index) {
    if (index >= 0 && index < detailDrafts.length) {
      detailDrafts.removeAt(index);
      notifyListeners();
      log(
        'Removed detail at index $index. Total drafts: ${detailDrafts.length}',
      );
    } else {
      log('Invalid index $index for detail drafts');
    }
  }

  /// Update a detail in the draft list by index
  void updateDetailDraft(int index, FormTransferDetailModel detail) {
    if (index >= 0 && index < detailDrafts.length) {
      detailDrafts[index] = detail;
      notifyListeners();
      log('Updated detail at index $index');
    } else {
      log('Invalid index $index for detail drafts');
    }
  }

  /// Clear all detail drafts
  void clearDetailDrafts() {
    detailDrafts.clear();
    notifyListeners();
    log('Cleared all detail drafts');
  }

  /// Clear the current error message
  void clearError() {
    _setError(null);
  }

  /// Reset the provider state
  void reset() {
    isLoading = false;
    error = null;
    transfers = [];
    currentTransfer = null;
    detailDrafts = [];
    notifyListeners();
    log('FormTransferProvider state reset');
  }
}
