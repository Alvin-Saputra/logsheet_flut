import 'package:dio/dio.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/form_transfer/response/approve_form_transfer_response.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/form_transfer/response/create_form_transfer_response.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/form_transfer/response/delete_form_transfer_response.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/form_transfer/response/fetch_form_transfer_response.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/form_transfer/response/update_form_transfer_response.dart';
import 'package:retrofit/retrofit.dart';

part 'form_transfer_api_service.g.dart';

@RestApi()
abstract class FormTransferApiService {
  factory FormTransferApiService(Dio dio, {String baseUrl}) =
      _FormTransferApiService;

  @GET("/form-transfer")
  Future<FetchFormTransferResponse> getFormTransfers(
    @Header("Authorization") String token,
    @Query("transaction_date") String? transactionDate,
    @Query("status") String? status,
  );

  @POST("/form-transfer")
  Future<CreateFormTransferResponse> createFormTransfer(
    @Body() Map<String, dynamic> body,
    @Header("Authorization") String token,
  );

  @PUT("/form-transfer/{id}")
  Future<UpdateFormTransferResponse> updateFormTransfer(
    @Header("Authorization") String token,
    @Path("id") String id,
    @Body() Map<String, dynamic> body,
  );

  @DELETE("/form-transfer/{id}")
  Future<DeleteFormTransferResponse> deleteFormTransfer(
    @Header("Authorization") String token,
    @Path("id") String id,
  );

  @PUT("/form-transfer/{id}/approve")
  Future<ApproveFormTransferResponse> approveFormTransfer(
    @Header("Authorization") String token,
    @Path("id") String id,
    @Field("level") String level,
    @Field("status") String status,
    @Field("remarks") String? remarks,
  );

  @GET("/form-transfer/pending")
  Future<FetchFormTransferResponse> getPendingApprovals(
    @Header("Authorization") String token,
    @Query("level") String level,
  );
}
