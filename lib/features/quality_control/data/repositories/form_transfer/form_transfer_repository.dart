import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:logsheet_app/features/quality_control/data/datasources/remote/form_transfer/form_transfer_api_service.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/form_transfer/form_transfer_header_model.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/form_transfer/response/approve_form_transfer_response.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/form_transfer/response/create_form_transfer_response.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/form_transfer/response/delete_form_transfer_response.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/form_transfer/response/fetch_form_transfer_response.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/form_transfer/response/update_form_transfer_response.dart';

class FormTransferRepository {
  final FormTransferApiService apiService;

  FormTransferRepository({required this.apiService});

  Future<List<FormTransferHeaderModel>> getFormTransfers(
    String token,
    String plantId, {
    String? transactionDate,
    String? status,
  }) async {
    try {
      log('Fetching form transfers...');
      final FetchFormTransferResponse response = await apiService
          .getFormTransfers(token, plantId, transactionDate, status);
      log('Fetched ${response.data.length} form transfers');
      return response.data;
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        final message = data['message']?.toString();
        if (message != null && message.isNotEmpty) {
          throw Exception(message);
        }
      }
      throw Exception('Failed to fetch form transfers: ${e.message}');
    } catch (e) {
      log('Error fetching form transfers: $e');
      throw Exception('Failed to fetch form transfers: $e');
    }
  }

  Future<CreateFormTransferResponse> createFormTransfer(
    Map<String, dynamic> body,
    String token,
  ) async {
    try {
      log('Creating form transfer...');
      final CreateFormTransferResponse response = await apiService
          .createFormTransfer(body, token);
      log('Form transfer created with ID: ${response.idHeader}');
      return response;
    } catch (e) {
      log('Error creating form transfer: $e');
      throw Exception('Failed to create form transfer: $e');
    }
  }

  Future<UpdateFormTransferResponse> updateFormTransfer(
    String id,
    Map<String, dynamic> body,
    String token,
  ) async {
    try {
      log('Updating form transfer: $id');
      final UpdateFormTransferResponse response = await apiService
          .updateFormTransfer(token, id, body);
      log('Form transfer updated: ${response.message}');
      return response;
    } catch (e) {
      log('Error updating form transfer: $e');
      throw Exception('Failed to update form transfer: $e');
    }
  }

  Future<DeleteFormTransferResponse> deleteFormTransfer(
    String id,
    String token,
  ) async {
    try {
      log('Deleting form transfer: $id');
      final DeleteFormTransferResponse response = await apiService
          .deleteFormTransfer(token, id);
      log('Form transfer deleted: ${response.message}');
      return response;
    } catch (e) {
      log('Error deleting form transfer: $e');
      throw Exception('Failed to delete form transfer: $e');
    }
  }

  Future<ApproveFormTransferResponse> approveFormTransfer(
    String id,
    String token, {
    String? level,
    String? remarks,
  }) async {
    try {
      log('Approving form transfer: $id, level: $level');
      final ApproveFormTransferResponse response = await apiService
          .approveFormTransfer(token, id, level ?? '', 'Approved', remarks);
      log('Form transfer approved: ${response.message}');
      return response;
    } catch (e) {
      log('Error approving form transfer: $e');
      throw Exception('Failed to approve form transfer: $e');
    }
  }

  Future<ApproveFormTransferResponse> rejectFormTransfer(
    String id,
    String token, {
    String? level,
    String? remarks,
  }) async {
    try {
      log('Rejecting form transfer: $id, level: $level');
      final ApproveFormTransferResponse response = await apiService
          .approveFormTransfer(token, id, level ?? '', 'Rejected', remarks);
      log('Form transfer rejected: ${response.message}');
      return response;
    } catch (e) {
      log('Error rejecting form transfer: $e');
      throw Exception('Failed to reject form transfer: $e');
    }
  }

  /// Get pending approvals filtered by approval level
  /// [level] - 'prepared', 'checked', 'approved', 'acknowledged'
  Future<List<FormTransferHeaderModel>> getPendingApprovals(
    String token,
    String level,
  ) async {
    try {
      log('Fetching pending approvals for level: $level');
      final FetchFormTransferResponse response = await apiService
          .getPendingApprovals(token, level);
      log(
        'Fetched ${response.data.length} pending approvals for level: $level',
      );
      return response.data;
    } catch (e) {
      log('Error fetching pending approvals: $e');
      throw Exception('Failed to fetch pending approvals: $e');
    }
  }
}
