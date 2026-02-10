// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:logsheet_app/features/daily_production/data/model/daily_production/daily_production_refinery_entity.dart';
// import 'package:logsheet_app/features/master_data/data/model/master/data_form_no_entity.dart';
// import 'package:logsheet_app/features/daily_production/presentation/pages/daily_production/refinery/ref_daily_production_detail_page.dart';
// import 'package:logsheet_app/features/daily_production/presentation/pages/daily_production/refinery/ref_daily_production_input_page.dart';
// import 'package:logsheet_app/features/daily_production/presentation/provider/daily_production/daily_production_refinery_provider.dart';
// import 'package:logsheet_app/features/master_data/presentation/provider/master/plant_provider.dart';
// import 'package:logsheet_app/features/master_data/presentation/provider/master/user_provider.dart';
// import 'package:logsheet_app/features/master_data/presentation/provider/master/value_provider.dart';
// import 'package:provider/provider.dart';

// class DailyProductionRefineryListPage extends StatefulWidget {
//   const DailyProductionRefineryListPage({super.key, required this.dataForm});
//   final DataFormNoEntity dataForm;

//   @override
//   State<DailyProductionRefineryListPage> createState() =>
//       _DailyProductionRefineryListPageState();
// }

// class _DailyProductionRefineryListPageState
//     extends State<DailyProductionRefineryListPage> {
//   @override
//   void initState() {
//     super.initState();
//     final username = context.read<UserProvider>().currentUser?.username;
//     final role = context.read<UserProvider>().currentUser?.role;
//     final plantCode = context.read<PlantProvider>().currentPlant?.code ?? "";
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
//       await context.read<DailyProductionRefineryProvider>().fetchAllTickets(
//         null,
//         null,
//         username ?? "",
//         role ?? "",
//         plantCode,
//       );
//       if (!mounted) return;
//       await context.read<ValueProvider>().fetchAllInitialData();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: _buildAppBar(),
//       body: _buildBody(),
//       floatingActionButton: Consumer<UserProvider>(
//         builder:
//             (context, provider, child) => FloatingActionButton.extended(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder:
//                         (context) => DailyProductionRefineryInputPage(
//                           dataForm: widget.dataForm,
//                           userName: provider.currentUser?.username ?? "",
//                         ),
//                   ),
//                 );
//               },
//               label: const Text("Tambah Ticket"),
//               icon: Icon(Icons.add),
//               backgroundColor: Color(0xFFB91C1C),
//               foregroundColor: Colors.white,
//             ),
//       ),
//     );
//   }

//   String _displayTime(TimeOfDay? time) {
//     if (time == null) return "-";
//     return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
//   }

//   Widget _buildBody() {
//     return Consumer3<
//       DailyProductionRefineryProvider,
//       PlantProvider,
//       UserProvider
//     >(
//       builder: (
//         context,
//         dailyProdFracProvider,
//         plantprovider,
//         userProvider,
//         child,
//       ) {
//         // 1. Filter raw list
//         List<DailyProductionRefineryEntity> rawList =
//             dailyProdFracProvider.reportsList
//                 .where(
//                   (e) => e.preparedStatus == null && e.checkedStatus == null,
//                 )
//                 .toList();

//         // 2. Grouping Logic (Fixed)
//         // Key: Tanggal + Plant + WorkCenter (Tanpa Shift)
//         Map<String, List<DailyProductionRefineryEntity>> groupedMap = {};

//         for (var item in rawList) {
//           if (item.transactionDate != null) {
//             String dateKey = DateFormat(
//               'yyyy-MM-dd',
//             ).format(item.transactionDate!);
//             String wc = item.workCenter ?? "UNKNOWN";
//             // KUNCI GROUPING: Date - Plant - WorkCenter
//             String compositeKey = "$dateKey | ${item.plant} | $wc";

//             if (!groupedMap.containsKey(compositeKey)) {
//               groupedMap[compositeKey] = [];
//             }
//             groupedMap[compositeKey]!.add(item);
//           }
//         }

//         // Ambil keys untuk iterasi
//         var groupedKeys = groupedMap.keys.toList();

//         // 3. Handling Loading & Error
//         if (dailyProdFracProvider.isLoading) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (dailyProdFracProvider.errorMessage != null) {
//           return Center(
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     'Error: ${dailyProdFracProvider.errorMessage!}',
//                     style: const TextStyle(color: Colors.red, fontSize: 16),
//                     textAlign: TextAlign.center,
//                   ),
//                   OutlinedButton(
//                     onPressed: () async {
//                       final plantCode = plantprovider.currentPlant?.code ?? "";
//                       await dailyProdFracProvider.fetchAllTickets(
//                         null,
//                         null,
//                         userProvider.currentUser?.username ?? "",
//                         userProvider.currentUser?.role ?? "",
//                         plantCode,
//                       );
//                     },
//                     child: const Text("Refresh"),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }

//         if (groupedKeys.isEmpty) {
//           return Center(
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Text(
//                     'No data',
//                     style: TextStyle(fontSize: 16, color: Colors.grey),
//                   ),
//                   OutlinedButton(
//                     onPressed: () async {
//                       final plantCode = plantprovider.currentPlant?.code ?? "";
//                       await dailyProdFracProvider.fetchAllTickets(
//                         null,
//                         null,
//                         userProvider.currentUser?.username ?? "",
//                         userProvider.currentUser?.role ?? "",
//                         plantCode,
//                       );
//                     },
//                     child: const Text("Refresh"),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }

//         // 4. Build ListView berdasarkan Group Key
//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//           child: ListView.builder(
//             padding: const EdgeInsets.only(bottom: 88),
//             itemCount:
//                 groupedKeys.length, // Gunakan panjang group, bukan rawList
//             itemBuilder: (context, index) {
//               String currentKey = groupedKeys[index];
//               // Ambil list item untuk group ini (berisi berbagai shift)
//               List<DailyProductionRefineryEntity> itemsInGroup =
//                   groupedMap[currentKey]!;


//               Map<String, List<DailyProductionRefineryEntity>> shiftMap = {};

//               for (var item in itemsInGroup) {
//                 String shiftKey = item.shift ?? "Unknown";
//                 if (!shiftMap.containsKey(shiftKey)) {
//                   shiftMap[shiftKey] = [];
//                 }
//                 shiftMap[shiftKey]!.add(item);
//               }

//               // Urutkan key shift agar rapi (Shift 1, Shift 2, dst)
//               var sortedShiftKeys = shiftMap.keys.toList()..sort();

//               // Ambil data pertama untuk menampilkan Header Title (Tanggal & WC sama)
//               final firstItem = itemsInGroup.first;
//               String titleDate = DateFormat(
//                 'dd MMM yyyy',
//               ).format(firstItem.transactionDate!);
//               String titleWC = firstItem.workCenter ?? "-";

//               return Card(
//                 elevation: 2,
//                 margin: const EdgeInsets.only(bottom: 8),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: ExpansionTile(
//                   leading: const Icon(
//                     Icons.drag_handle_outlined,
//                     color: Colors.blueGrey,
//                   ),
//                   // Judul Group: Tanggal dan Work Center
//                   title: Text(
//                     titleDate,
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   subtitle: Text("Plant: ${firstItem.plant} • WC: $titleWC"),
//                   childrenPadding: const EdgeInsets.all(8),

//                   // Isi Detail: List Card berdasarkan Shift
//                   children:
//                       sortedShiftKeys.map((shiftKey) {
//                         // Ambil LIST item yang spesifik untuk shift ini saja (misal: isi 3 data)
//                         List<DailyProductionRefineryEntity> itemsInThisShift =
//                             shiftMap[shiftKey]!;

//                         // Ambil item pertama di shift ini untuk status visual (opsional)
//                         var representativeItem = itemsInThisShift.first;

//                         return ListTile(
//                           leading: const Icon(Icons.domain_verification_sharp),
//                           trailing: const Icon(
//                             Icons.keyboard_double_arrow_right_outlined,
//                           ),

//                           // Judul hanya nama Shift
//                           title: Text('Shift $shiftKey'),

//                           // Subtitle status (mengambil sample dari item pertama di shift tersebut)
//                           subtitle: Text(
//                             (representativeItem.isCompleted == true)
//                                 ? "Close"
//                                 : "Open",
//                             style: TextStyle(
//                               color:
//                                   (representativeItem.isCompleted == true)
//                                       ? Colors.red
//                                       : Colors.green,
//                             ),
//                           ),

//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder:
//                                     (
//                                       context,
//                                     ) => DailyProductionRefineryDetailPage(
//                                       dataForm: widget.dataForm,
//                                       // PENTING: Di sini kita passing LIST yang berisi 3 data tersebut
//                                       listItem: itemsInThisShift,
//                                     ),
//                               ),
//                             );
//                           },
//                         );
//                       }).toList(),
//                   // children: itemsInGroup.map((report) {
//                   //   return _buildDetailCard(report);
//                   // }).toList(),
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }

//   // Helper widget untuk membuat kartu detail (per Shift)

//   AppBar _buildAppBar() {
//     return AppBar(
//       title: Text("Refinery List (${widget.dataForm.code})"),
//       actions: [
//         context.watch<DailyProductionRefineryProvider>().isLoading
//             ? CircularProgressIndicator()
//             : IconButton(
//               onPressed: () async {
//                 final username =
//                     context.read<UserProvider>().currentUser?.username;
//                 final role = context.read<UserProvider>().currentUser?.role;
//                 final plantCode =
//                     context.read<PlantProvider>().currentPlant?.code ?? "";
//                 await context
//                     .read<DailyProductionRefineryProvider>()
//                     .fetchAllTickets(
//                       null,
//                       null,
//                       username ?? "",
//                       role ?? "",
//                       plantCode,
//                     );
//               },
//               icon: Consumer<DailyProductionRefineryProvider>(
//                 builder: (context, provider, child) {
//                   if (provider.isLoading) {
//                     return const CircularProgressIndicator();
//                   }
//                   return const Icon(Icons.replay);
//                 },
//               ),
//             ),
//       ],
//     );
//   }

//   String _getStatusText(DailyProductionRefineryEntity report) {
//     if (report.checkedStatus == "Approved") {
//       return "Approved";
//     }

//     if (report.checkedStatus == "Rejected") {
//       return "Rejected";
//     }
//     if (report.preparedStatus == "Approved") {
//       return "Prepared ${report.shift}";
//     }

//     if (report.preparedStatus == "Rejected") {
//       return "Rejected";
//     }
//     return "Submitted";
//   }

//   String _getIsCompletedStatus(DailyProductionRefineryEntity report) {
//     if (report.isCompleted == true) {
//       return "Close";
//     } else {
//       return "Open";
//     }
//   }

//   Color _getStatusColor(DailyProductionRefineryEntity report) {
//     if (report.checkedStatus == "Approved") {
//       return Colors.green;
//     }

//     if (report.checkedStatus == "Rejected") {
//       return Colors.red;
//     }

//     if (report.preparedStatus == "Approved") {
//       return Colors.orangeAccent;
//     }

//     if (report.preparedStatus == "Rejected") {
//       return Colors.red;
//     }
//     return Colors.grey;
//   }
// }
