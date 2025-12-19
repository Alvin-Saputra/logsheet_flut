// import 'package:flutter/material.dart';
// import 'package:logsheet_app/features/master_data/data/model/master/data_form_no_entity.dart';
// import 'package:logsheet_app/features/master_data/presentation/provider/master/data_form_no_provider.dart';
// import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_plant_chemical_ingredient/analytical_result/analytical_result_incoming_plant_chemical_ingredient_header_entity.dart';
// import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_plant_chemical_ingredient/certificate_of_analysis/certificate_of_analysis_incoming_plant_chemical_ingredient_header_entity.dart';
// import 'package:logsheet_app/features/quality_control/presentation/pages/analytical_result_incoming_plant_chemical_ingredient/analytical_result/analytical_result_incoming_plant_chemical_ingredient_input_page.dart';
// import 'package:logsheet_app/features/quality_control/presentation/pages/analytical_result_incoming_plant_chemical_ingredient/certificate_of_analysis/certificate_of_analysis_incoming_plant_chemical_ingredient_input_page.dart';
// import 'package:provider/provider.dart';

// class ParentAnalyticalResultIncomingPlantChemicalIngredient
//     extends StatefulWidget {
//   const ParentAnalyticalResultIncomingPlantChemicalIngredient({super.key});

//   @override
//   State<ParentAnalyticalResultIncomingPlantChemicalIngredient> createState() =>
//       _ParentAnalyticalResultIncomingPlantChemicalIngredientState();
// }

// class _ParentAnalyticalResultIncomingPlantChemicalIngredientState
//     extends State<ParentAnalyticalResultIncomingPlantChemicalIngredient> {
//   DataFormNoEntity? formData;

//   CertificateOfAnalysisIncomingPlantChemicalIngredientHeaderEntity? coaHeader;

//   AnalyticalResultIncomingPlantChemicalIngredientHeaderEntity? analyticalHeader;

//   int step = 1;

//   void onCoaFormFinished(
//     CertificateOfAnalysisIncomingPlantChemicalIngredientHeaderEntity data,
//   ) {
//     setState(() {
//       coaHeader = data;
//       step = 2;
//     });
//   }

//   void onBackToCoa() {
//     setState(() {
//       step = 1;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: _buildAppBar(),
//       body:
//           step == 1
//               ? CertificateOfAnalysisIncomingPlantChemicalIngredientInputPage(
//                 onFinished: onCoaFormFinished,
//               )
//               : AnalyticalResultIncomingPlantChemicalIngredientInputPage(
//                 coaHeader: coaHeader!,
//                 onBack: () {
//                   onBackToCoa();
//                 },
//               ),
//     );
//   }

//   AppBar _buildAppBar() {
//     formData = context.read<DataFormNoProvider>().dataFormNoList.firstWhere(
//       (form) =>
//           form.isMenu == "Analytical_Result_Of_Incoming_Material_By_Truck",
//     );

//     return AppBar(
//       title: Text(
//         "Analytical Result Incoming Material By Truck Input (${formData!.code})",
//       ),
//     );
//   }
// }
