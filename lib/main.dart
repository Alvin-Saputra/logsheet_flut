import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logsheet_app/core/config/app_env.dart';
import 'package:logsheet_app/core/network/api_config.dart';
import 'package:logsheet_app/core/theme/app_theme.dart';
import 'package:logsheet_app/features/auth/data/datasources/local/storage_service/storage_service.dart';
import 'package:logsheet_app/features/auth/data/datasources/remote/auth_api_service.dart';
import 'package:logsheet_app/features/auth/presentation/pages/login_page.dart';
import 'package:logsheet_app/features/auth/presentation/provider/auth_provider.dart';
import 'package:logsheet_app/features/daily_production/data/datasources/daily_production/daily_production_fractionation_mysql_service.dart';
import 'package:logsheet_app/features/daily_production/data/datasources/daily_production/daily_production_refinery_mysql_service.dart';
import 'package:logsheet_app/features/daily_production/data/repository/daily_production/daily_production_fractionation_repository.dart';
import 'package:logsheet_app/features/daily_production/data/repository/daily_production/daily_production_refinery_repository.dart';
import 'package:logsheet_app/features/daily_production/presentation/provider/daily_production/daily_production_fractionation_provider.dart';
import 'package:logsheet_app/features/daily_production/presentation/provider/daily_production/daily_production_refinery_provider.dart';
import 'package:logsheet_app/features/form_transfer/data/datasources/remote/form_transfer_api_service.dart';
import 'package:logsheet_app/features/form_transfer/data/repository/form_transfer_repository.dart';
import 'package:logsheet_app/features/form_transfer/presentation/provider/form_transfer_provider.dart';
import 'package:logsheet_app/features/maintenance/data/datasources/change_product_checklist/change_product_checklist_mysql_service.dart';
import 'package:logsheet_app/features/maintenance/data/datasources/maintenance_lamps_and_glass_mysql_service.dart';
import 'package:logsheet_app/features/maintenance/data/datasources/start_up_produksi_checklist/start_up_produksi_checklist_mysql_service.dart';
import 'package:logsheet_app/features/maintenance/data/repository/change_product_checklist_repository/change_product_checklist_repository.dart';
import 'package:logsheet_app/features/maintenance/data/repository/maintenance_lamps_and_glass_repository.dart';
import 'package:logsheet_app/features/maintenance/data/repository/start_up_produksi_checklist_repository/start_up_produksi_checklist_repository.dart';
import 'package:logsheet_app/features/maintenance/presentation/provider/change_product_checklist/maintenance_change_product_checklist_provider.dart';
import 'package:logsheet_app/features/maintenance/presentation/provider/maintenance_lamps_and_glass_provider.dart';
import 'package:logsheet_app/features/maintenance/presentation/provider/start_up_produksi_checklist/maintenance_start_up_produksi_checklist_provider.dart';
import 'package:logsheet_app/features/master_data/data/datasources/master/business_unit_mysql_service.dart';
import 'package:logsheet_app/features/master_data/data/datasources/master/cryztallizer_mysql_service.dart';
import 'package:logsheet_app/features/master_data/data/datasources/master/data_form_no_mysql_service.dart';
import 'package:logsheet_app/features/master_data/data/datasources/master/plant_mysql_service.dart';
import 'package:logsheet_app/features/master_data/data/datasources/master/product_mysql_service.dart';
import 'package:logsheet_app/features/master_data/data/datasources/master/user_mysql_service.dart';
import 'package:logsheet_app/features/master_data/data/datasources/master/value_mysql_service.dart';
import 'package:logsheet_app/features/master_data/data/repository/master/business_unit_repository.dart';
import 'package:logsheet_app/features/master_data/data/repository/master/crystallizer_repository.dart';
import 'package:logsheet_app/features/master_data/data/repository/master/data_form_no_repository.dart';
import 'package:logsheet_app/features/master_data/data/repository/master/plant_repository.dart';
import 'package:logsheet_app/features/master_data/data/repository/master/product_repository.dart';
import 'package:logsheet_app/features/master_data/data/repository/master/user_repository.dart';
import 'package:logsheet_app/features/master_data/data/repository/master/value_repository.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/business_unit_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/crystallizer_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/data_form_no_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/plant_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/product_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/value_provider.dart';
import 'package:logsheet_app/features/production/data/datasources/dry_fractionation/dry_fractionation_api_service.dart';
import 'package:logsheet_app/features/production/data/datasources/logsheet/deodorizing_filtration_mysql_service.dart';
import 'package:logsheet_app/features/production/data/datasources/logsheet/pretreatment_bleaching_filtration_mysql_service.dart';
import 'package:logsheet_app/features/production/data/repository/logsheet/deodorizing_filtration_repository.dart';
import 'package:logsheet_app/features/production/data/repository/logsheet/pretreatment_bleaching_filtration_repository.dart';
import 'package:logsheet_app/features/production/presentation/provider/dry_fractionation/dry_fractionation_provider.dart';
import 'package:logsheet_app/features/production/presentation/provider/logsheet/deodorizing_filtration_provider.dart';
import 'package:logsheet_app/features/production/presentation/provider/logsheet/pretreatment_bleaching_filtration_provider.dart';
import 'package:logsheet_app/features/quality_control/data/datasources/local/analytical_result_incoming_material_by_vessel/analytical_result_incoming_material_by_vessel_mysql_service.dart';
import 'package:logsheet_app/features/quality_control/data/datasources/local/daily_quality_composite_fractionation/daily_quality_composite_fractionation_mysql_service.dart';
import 'package:logsheet_app/features/quality_control/data/datasources/local/daily_storage_tank_analytical/daily_storage_tank_analytical_mysql_service.dart';
import 'package:logsheet_app/features/quality_control/data/datasources/local/quality_report/quality_report_production_mysql_service.dart';
import 'package:logsheet_app/features/quality_control/data/datasources/local/quality_report/quality_report_qc_mysql_service.dart';
import 'package:logsheet_app/features/quality_control/data/datasources/remote/analytical_result_incoming_material_by_truck/analytical_result_incoming_material_by_truck_api_service.dart';
import 'package:logsheet_app/features/quality_control/data/datasources/remote/analytical_result_incoming_material_by_vessel/analytical_result_incoming_material_by_vessel_api_service.dart';
import 'package:logsheet_app/features/quality_control/data/datasources/remote/analytical_result_incoming_plant_chemical_ingredient/analytical_result/analytical_result_incoming_plant_chemical_ingredient_api_service.dart';
import 'package:logsheet_app/features/quality_control/data/datasources/remote/analytical_result_incoming_plant_chemical_ingredient/certificate_of_analysis/certificate_of_analysis_incoming_plant_chemical_ingredient_api_service.dart';
import 'package:logsheet_app/features/quality_control/data/datasources/remote/analytical_result_incoming_plant_fuel/analytical_result_incoming_plant_fuel_api_service.dart';
import 'package:logsheet_app/features/quality_control/data/datasources/remote/analytical_result_outgoing_shipment_product_by_truck/analytical_result_outgoing_shipment_product_by_truck_api_service.dart';
import 'package:logsheet_app/features/quality_control/data/repositories/analytical_result_incoming_material_by_vessel/analytical_result_incoming_material_by_vessel_repository.dart';
import 'package:logsheet_app/features/quality_control/data/repositories/daily_quality_composite_fractionation/daily_quality_composite_fractionation_repository.dart';
import 'package:logsheet_app/features/quality_control/data/repositories/daily_storage_tank_analytical/daily_storage_tank_analytical_repository.dart';
import 'package:logsheet_app/features/quality_control/data/repositories/quality_report/quality_report_production_repository.dart';
import 'package:logsheet_app/features/quality_control/data/repositories/quality_report/quality_report_qc_repository.dart';
import 'package:logsheet_app/features/quality_control/presentation/provider/analytical_result_incoming_material_by_truck/analytical_result_incoming_material_by_truck_provider.dart';
import 'package:logsheet_app/features/quality_control/presentation/provider/analytical_result_incoming_material_by_vessel/analytical_result_incoming_material_by_vessel_provider.dart';
import 'package:logsheet_app/features/quality_control/presentation/provider/analytical_result_incoming_plant_chemical_ingredient/analytical_result/analytical_result_incoming_plant_chemical_ingredient_provider.dart';
import 'package:logsheet_app/features/quality_control/presentation/provider/analytical_result_incoming_plant_chemical_ingredient/certificate_of_analysis/certificate_of_analysis_incoming_plant_chemical_ingredient_provider.dart';
import 'package:logsheet_app/features/quality_control/presentation/provider/analytical_result_incoming_plant_fuel/analytical_result_incoming_plant_fuel_provider.dart';
import 'package:logsheet_app/features/quality_control/presentation/provider/analytical_result_outgoing_shipment_product_by_truck/analytical_result_outgoing_shipment_product_by_truck_provider.dart';
import 'package:logsheet_app/features/quality_control/presentation/provider/daily_quality_composite_fractionation/daily_quality_composite_fractionation_provider.dart';
import 'package:logsheet_app/features/quality_control/presentation/provider/daily_storage_tank_analytical/daily_storage_tank_analytical_provider.dart';
import 'package:logsheet_app/features/quality_control/presentation/provider/quality_report/quality_report_production_provider.dart';
import 'package:logsheet_app/features/quality_control/presentation/provider/quality_report/quality_report_qc_provider.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:provider/provider.dart';

import 'core/database/app_database.dart';
import 'core/database/dao/business_unit_dao.dart';
import 'core/database/database_instance.dart'; // <-- ini penting
import 'features/master_data/presentation/provider/master/user_provider.dart';

void main() async {
  db =
      AppDatabase(); // ✅ inisialisasi instance ke variabel global di database_instance.dart
  // await dotenv.load(fileName: ".env");

  if (AppEnv.isProd) {
    await dotenv.load(fileName: "production.env");
  } else {
    await dotenv.load(fileName: "development.env");
  }

  final dioClient = DioClient();
  final loginApiService = AuthApiService(dioClient.dio);
  final storageService = StorageService();

  final analyticalResultIncomingMaterialByVesselApiService =
      AnalyticalResultIncomingMaterialByVesselApiService(dioClient.dio);

  final analyticalResultIncomingMaterialByTruckApiService =
      AnalyticalResultIncomingMaterialByTruckApiService(dioClient.dio);

  final certificateOfAnalysisIncomingPlantChemicalIngredientApiService =
      CertificateOfAnalysisIncomingPlantChemicalIngredientApiService(
        dioClient.dio,
      );

  final analyticalResultIncomingPlantChemicalIngredientApiService =
      AnalyticalResultIncomingPlantChemicalIngredientApiService(dioClient.dio);

  final analyticalResultIncomingPlantFuelApiService =
      AnalyticalResultIncomingPlantFuelApiService(dioClient.dio);

  final analyticalResultOutgoingShipmentProductByTruckApiService =
      AnalyticalResultOutgoingShipmentProductByTruckApiService(dioClient.dio);

  final formTransferApiService = FormTransferApiService(dioClient.dio);

  final dryFractionationApiService = DryFractionationApiService(dioClient.dio);

  runApp(
    MultiProvider(
      providers: [
        // Provide UserMySQL Service
        Provider<UserMySQLService>(create: (context) => UserMySQLService()),
        // Provide BusinessUnitMySQL Service
        Provider<BusinessUnitMySQLService>(
          create: (context) => BusinessUnitMySQLService(),
        ),
        // provide ValueMySQL Service
        Provider<ValueMySQLService>(create: (context) => ValueMySQLService()),
        // Provide PlantMySQL Service
        Provider<PlantMySQLService>(create: (context) => PlantMySQLService()),
        // Provide ProductMySQL Service
        Provider<ProductMySQLService>(
          create: (context) => ProductMySQLService(),
        ),

        Provider<CrystallizerMySQLService>(
          create: (context) => CrystallizerMySQLService(),
        ),

        // Provide Quality Report QC MySQL Service
        Provider<QualityReportQCMySQLService>(
          create: (context) => QualityReportQCMySQLService(),
        ),
        // Provide Quality Report Production MySQL Service
        Provider<QualityReportProductionMySQLService>(
          create: (context) => QualityReportProductionMySQLService(),
        ),
        // Provide Daily Production Refinery MySQL Service
        Provider<DailyProductionRefineryMySQLService>(
          create: (context) => DailyProductionRefineryMySQLService(),
        ),
        // Provide Daily Production Fractionation MySQL Service
        Provider<DailyProductionFractionationMySQLService>(
          create: (context) => DailyProductionFractionationMySQLService(),
        ),
        // Provide Dry Production MySQL Service
        // Provider<DryFractionationMySQLService>(
        //   create: (context) => DryFractionationMySQLService(),
        // ),

        // Provider Maintenance Lamps And Glass MySQL Service
        Provider<MaintenanceLampsAndGlassMySQLService>(
          create: (context) => MaintenanceLampsAndGlassMySQLService(),
        ),
        // Provider Maintenance Lamps And Glass MySQL Service
        Provider<DataFormNoMySQLService>(
          create: (context) => DataFormNoMySQLService(),
        ),
        Provider<PretreatmentBleachingFiltrationMySQLService>(
          create: (context) => PretreatmentBleachingFiltrationMySQLService(),
        ),
        Provider<DeodorizingFiltrationMySQLService>(
          create: (context) => DeodorizingFiltrationMySQLService(),
        ),
        Provider<ChangeProductChecklistMySQLService>(
          create: (context) => ChangeProductChecklistMySQLService(),
        ),
        Provider<StartUpProduksiChecklistMySQLService>(
          create: (context) => StartUpProduksiChecklistMySQLService(),
        ),

        Provider<DailyStorageTankAnalyticalMySQLService>(
          create: (context) => DailyStorageTankAnalyticalMySQLService(),
        ),

        Provider<DailyQualityCompositeFractionationMysqlService>(
          create: (context) => DailyQualityCompositeFractionationMysqlService(),
        ),

        Provider<AnalyticalResultIncomingMaterialByVesselMySQLService>(
          create:
              (context) =>
                  AnalyticalResultIncomingMaterialByVesselMySQLService(),
        ),

        // Provide User Repository
        Provider<UserRepository>(
          create:
              (context) => UserRepository(
                context.read<UserMySQLService>(),
                loginApiService,
              ),
        ),
        // Provide Business Unit Repository
        Provider<BusinessUnitRepository>(
          create:
              (context) => BusinessUnitRepository(
                context.read<BusinessUnitMySQLService>(),
              ),
        ),
        // Provide Value Repository
        Provider<ValueRepository>(
          create:
              (context) => ValueRepository(
                mySQLService: context.read<ValueMySQLService>(),
              ),
        ),
        // Provide Plant Repository
        Provider<PlantRepository>(
          create:
              (context) => PlantRepository(context.read<PlantMySQLService>()),
        ),
        // Provide Product Repository
        Provider<ProductRepository>(
          create:
              (context) =>
                  ProductRepository(context.read<ProductMySQLService>()),
        ),

        Provider<CrystallizerRepository>(
          create:
              (context) => CrystallizerRepository(
                context.read<CrystallizerMySQLService>(),
              ),
        ),

        // Provide Quality Report QC Repository
        Provider<QualityReportQCRepository>(
          create:
              (context) => QualityReportQCRepository(
                context.read<QualityReportQCMySQLService>(),
              ),
        ),
        // Provide Quality Report Production Repository
        Provider<QualityReportProductionRepository>(
          create:
              (context) => QualityReportProductionRepository(
                context.read<QualityReportProductionMySQLService>(),
              ),
        ),
        // Provide Daily Production Refinery Repository
        Provider<DailyProductionRefineryRepository>(
          create:
              (context) => DailyProductionRefineryRepository(
                context.read<DailyProductionRefineryMySQLService>(),
              ),
        ),
        // Provide Daily Production Fractionation Repository
        Provider<DailyProductionFractionationRepository>(
          create:
              (context) => DailyProductionFractionationRepository(
                context.read<DailyProductionFractionationMySQLService>(),
              ),
        ),
        // Provide Maintenance Lamps And Glass Repository
        Provider<MaintenanceLampsAndGlassRepository>(
          create:
              (context) => MaintenanceLampsAndGlassRepository(
                context.read<MaintenanceLampsAndGlassMySQLService>(),
              ),
        ),
        // Provide Data Form No Repository
        Provider<DataFormNoRepository>(
          create:
              (context) =>
                  DataFormNoRepository(context.read<DataFormNoMySQLService>()),
        ),
        // Pretreatment Bleaching Filtration Repository
        Provider<PretreatmentBleachingFiltrationRepository>(
          create:
              (context) => PretreatmentBleachingFiltrationRepository(
                context.read<PretreatmentBleachingFiltrationMySQLService>(),
              ),
        ),
        // Pretreatment Bleaching Filtration Repository
        Provider<DeodorizingFiltrationRepository>(
          create:
              (context) => DeodorizingFiltrationRepository(
                context.read<DeodorizingFiltrationMySQLService>(),
              ),
        ),
        // Provider<DryFractionationRepository>(
        //   create:
        //       (context) => DryFractionationRepository(
        //         context.read<DryFractionationMySQLService>(),
        //       ),
        // ),
        Provider<ChangeProductChecklistRepository>(
          create:
              (context) => ChangeProductChecklistRepository(
                context.read<ChangeProductChecklistMySQLService>(),
              ),
        ),

        Provider<StartUpProduksiChecklistRepository>(
          create:
              (context) => StartUpProduksiChecklistRepository(
                context.read<StartUpProduksiChecklistMySQLService>(),
              ),
        ),

        Provider<DailyStorageTankAnalyticalRepository>(
          create:
              (context) => DailyStorageTankAnalyticalRepository(
                context.read<DailyStorageTankAnalyticalMySQLService>(),
              ),
        ),

        Provider<DailyQualityCompositeFractionationRepository>(
          create:
              (context) => DailyQualityCompositeFractionationRepository(
                context.read<DailyQualityCompositeFractionationMysqlService>(),
              ),
        ),

        Provider<AnalyticalResultIncomingMaterialByVesselRepository>(
          create:
              (context) => AnalyticalResultIncomingMaterialByVesselRepository(
                context
                    .read<
                      AnalyticalResultIncomingMaterialByVesselMySQLService
                    >(),
              ),
        ),

        // Provide The User Provider
        ChangeNotifierProvider(
          create:
              (context) =>
                  UserProvider(context.read<UserRepository>(), loginApiService),
        ),

        Provider<StorageService>.value(value: storageService),

        ChangeNotifierProvider(
          create: (context) => AuthProvider(loginApiService, storageService),
        ),
        // Provide the Business Unit Provider
        ChangeNotifierProvider(
          create:
              (context) =>
                  BusinessUnitProvider(context.read<BusinessUnitRepository>()),
        ),
        ChangeNotifierProvider(
          create: (context) => ValueProvider(context.read<ValueRepository>()),
        ),
        // Provide Plant Provider
        ChangeNotifierProvider(
          create: (context) => PlantProvider(context.read<PlantRepository>()),
        ),
        // Provide Product Provider
        ChangeNotifierProvider(
          create:
              (context) => ProductProvider(context.read<ProductRepository>()),
        ),

        ChangeNotifierProvider(
          create:
              (context) =>
                  CrystallizerProvider(context.read<CrystallizerRepository>()),
        ),
        // Provide Quality Report QC Provider
        ChangeNotifierProvider(
          create:
              (context) => QualityReportQCProvider(
                context.read<QualityReportQCRepository>(),
              ),
        ),
        // Provide Quality Report Production Provider
        ChangeNotifierProvider(
          create:
              (context) => QualityReportProductionProvider(
                context.read<QualityReportProductionRepository>(),
              ),
        ),
        // Provide Daily Production Fractionation Provider
        ChangeNotifierProvider(
          create:
              (context) => DailyProductionFractionationProvider(
                context.read<DailyProductionFractionationRepository>(),
              ),
        ),
        //  Provide Daily Production Refinery Provider
        ChangeNotifierProvider(
          create:
              (context) => DailyProductionRefineryProvider(
                context.read<DailyProductionRefineryRepository>(),
              ),
        ),
        // Provide Maintenance Lamps And Glass Provider
        ChangeNotifierProvider(
          create:
              (context) => MaintenanceLampsAndGlassProvider(
                context.read<MaintenanceLampsAndGlassRepository>(),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (context) =>
                  DataFormNoProvider(context.read<DataFormNoRepository>()),
        ),
        ChangeNotifierProvider(
          create:
              (context) => PretreatmentBleachingFiltrationProvider(
                context.read<PretreatmentBleachingFiltrationRepository>(),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (context) => DeodorizingFiltrationProvider(
                context.read<DeodorizingFiltrationRepository>(),
              ),
        ),
        // ChangeNotifierProvider(
        //   create:
        //       (context) => DryFractionationProvider(
        //         context.read<DryFractionationRepository>(),
        //       ),
        // ),
        ChangeNotifierProvider(
          create:
              (context) => ChangeProductChecklistProvider(
                context.read<ChangeProductChecklistRepository>(),
              ),
        ),

        ChangeNotifierProvider(
          create:
              (context) => MaintenanceStartUpProduksiChecklistProvider(
                context.read<StartUpProduksiChecklistRepository>(),
              ),
        ),

        ChangeNotifierProvider(
          create:
              (context) => DailyStorageTankAnalyticalProvider(
                context.read<DailyStorageTankAnalyticalRepository>(),
              ),
        ),

        ChangeNotifierProvider(
          create:
              (context) => DailyQualityCompositeFractionationProvider(
                context.read<DailyQualityCompositeFractionationRepository>(),
              ),
        ),

        ChangeNotifierProvider(
          create:
              (context) => AnalyticalResultIncomingMaterialByVesselProvider(
                context
                    .read<AnalyticalResultIncomingMaterialByVesselRepository>(),
                storageService,
                analyticalResultIncomingMaterialByVesselApiService,
              ),
        ),

        ChangeNotifierProvider(
          create:
              (context) => AnalyticalResultIncomingMaterialByTruckProvider(
                analyticalResultIncomingMaterialByTruckApiService,
                storageService,
              ),
        ),

        ChangeNotifierProvider(
          create:
              (
                context,
              ) => CertificateOfAnalysisIncomingPlantChemicalIngredientProvider(
                certificateOfAnalysisIncomingPlantChemicalIngredientApiService,
                storageService,
              ),
        ),

        ChangeNotifierProvider(
          create:
              (context) =>
                  AnalyticalResultIncomingPlantChemicalIngredientProvider(
                    analyticalResultIncomingPlantChemicalIngredientApiService,
                    storageService,
                  ),
        ),

        ChangeNotifierProvider(
          create:
              (context) => AnalyticalResultIncomingPlantFuelProvider(
                analyticalResultIncomingPlantFuelApiService,
                storageService,
              ),
        ),

        ChangeNotifierProvider(
          create:
              (context) =>
                  AnalyticalResultOutgoingShipmentProductByTruckProvider(
                    analyticalResultOutgoingShipmentProductByTruckApiService,
                    storageService,
                  ),
        ),

        // Provide Form Transfer Provider
        ChangeNotifierProvider(
          create:
              (context) => FormTransferProvider(
                repository: FormTransferRepository(
                  apiService: formTransferApiService,
                ),
              ),
        ),

        ChangeNotifierProvider(
          create:
              (context) => DryFractionationProvider(
                dryFractionationApiService,
                storageService,
              ),
        ),

        //Provide Business Unit DAO
        Provider<BusinessUnitDao>(create: (_) => BusinessUnitDao(db)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // final dummyEntity = UserEntity(
    //   userid: "123",
    //   username: "ADMIN",
    //   password: "",
    //   role: "ADM",
    //   isActive: "T",
    // );

    return MaterialApp(
      localizationsDelegates: const [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        MonthYearPickerLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      title: 'Logsheet Automation',
      theme: AppTheme.lightTheme,
      home: const LoginPage(),
      // home: const MaintenanceLampsGlassPage(userName: "ADMIN"),
      // home: ApprovalListScreen(),
      // home: AdminHomePage(userEntity: dummyEntity, userName: "ADMIN"),
      // home: UserHomePage(userEntity: dummyEntity),
      // home: AuthWrapper(),
    );
  }
}
