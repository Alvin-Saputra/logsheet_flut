import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/core/widgets/custom_date_field.dart';
import 'package:logsheet_app/core/widgets/custom_remark_field.dart';
import 'package:logsheet_app/core/widgets/custom_save_button.dart';
import 'package:logsheet_app/core/widgets/custom_section_card.dart';
import 'package:logsheet_app/core/widgets/custom_snack_bar.dart';
import 'package:logsheet_app/core/widgets/custom_text_field.dart';
import 'package:logsheet_app/features/auth/data/datasources/local/storage_service/storage_service.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/form_transfer/form_transfer_detail_model.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/form_transfer/form_transfer_header_model.dart';
import 'package:logsheet_app/features/quality_control/presentation/provider/form_transfer/form_transfer_provider.dart';
import 'package:logsheet_app/features/master_data/data/model/master/data_form_no_entity.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/business_unit_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/data_form_no_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/plant_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/user_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/value_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class FormTransferInputPage extends StatefulWidget {
  const FormTransferInputPage({super.key});

  @override
  State<FormTransferInputPage> createState() => _FormTransferInputPageState();
}

class _DetailFormControllers {
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController fromRefineryFractionationController =
      TextEditingController();
  final TextEditingController fromOtherController = TextEditingController();
  final TextEditingController toRefineryFractionationController =
      TextEditingController();
  final TextEditingController toOtherController = TextEditingController();
  final TextEditingController qualityMAndIController = TextEditingController();
  final TextEditingController qualityFfaController = TextEditingController();
  final TextEditingController qualityLovColorRController =
      TextEditingController();
  final TextEditingController qualityLovColorYController =
      TextEditingController();
  final TextEditingController qualityCpTempController = TextEditingController();
  final TextEditingController qualitySmpController = TextEditingController();
  final TextEditingController qualityPvController = TextEditingController();
  final TextEditingController qualityIvController = TextEditingController();
  final TextEditingController detailRemarkController = TextEditingController();

  String? selectedOilType;
  String? selectedFromStorageTankNo;
  String? selectedToStorageTankNo;

  void dispose() {
    quantityController.dispose();
    fromRefineryFractionationController.dispose();
    fromOtherController.dispose();
    toRefineryFractionationController.dispose();
    toOtherController.dispose();
    qualityMAndIController.dispose();
    qualityFfaController.dispose();
    qualityLovColorRController.dispose();
    qualityLovColorYController.dispose();
    qualityCpTempController.dispose();
    qualitySmpController.dispose();
    qualityPvController.dispose();
    qualityIvController.dispose();
    detailRemarkController.dispose();
  }
}

class _FormTransferInputPageState extends State<FormTransferInputPage> {
  final _formKey = GlobalKey<FormState>();
  DataFormNoEntity? formData;

  // Header Controllers
  final TextEditingController transactionDateController =
      TextEditingController();
  final TextEditingController fromDeptController = TextEditingController();
  final TextEditingController toDeptController = TextEditingController();

  final List<_DetailFormControllers> _detailForms = [];

  @override
  void initState() {
    super.initState();
    _detailForms.add(_DetailFormControllers());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFormData();
      context.read<ValueProvider>().fetchOilTypes();
      context.read<ValueProvider>().fetchTankSourceLists();
    });
  }

  void _loadFormData() {
    final dataFormNoProvider = context.read<DataFormNoProvider>();
    try {
      formData =
          dataFormNoProvider.dataFormNoList
              .where(
                (form) =>
                    form.isMenu == "Form_Transfer" && form.isActive == "T",
              )
              .first;
      setState(() {});
    } catch (e) {
      log('Form data not found for Form_Transfer: $e');
    }
  }

  @override
  void dispose() {
    transactionDateController.dispose();
    fromDeptController.dispose();
    toDeptController.dispose();
    for (final detail in _detailForms) {
      detail.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      iconTheme: const IconThemeData(color: Color(0xFF655F5B)),
      title: Text(
        'Form Transfer${formData != null ? ' (${formData!.code})' : ''}',
        style: const TextStyle(
          color: Color(0xFF655F5B),
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            setState(() {
              _loadFormData();
            });
          },
        ),
      ],
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: Stack(
        children: [
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeaderSection(),
                  const SizedBox(height: 16),
                  _buildDetailSection(),
                  const SizedBox(height: 24),
                  Consumer<FormTransferProvider>(
                    builder: (context, provider, child) {
                      return provider.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : CustomSaveButton(onPressed: _onSubmit);
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return CustomSectionCard('Header Information', [
      CustomDateField(
        controller: transactionDateController,
        label: 'Transaction Date',
        icon: Icons.event,
      ),
      const SizedBox(height: 12),
      CustomTextField(
        controller: fromDeptController,
        label: 'From Department',
        icon: Icons.business,
        isRequired: true,
      ),
      CustomTextField(
        controller: toDeptController,
        label: 'To Department',
        icon: Icons.business_outlined,
        isRequired: true,
      ),
    ]);
  }

  Widget _buildDetailSection() {
    return Column(
      children: [
        ..._detailForms.asMap().entries.map((entry) {
          final index = entry.key;
          final detail = entry.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Row ${index + 1}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF655F5B),
                    ),
                  ),
                  if (_detailForms.length > 1)
                    IconButton(
                      onPressed: () => _removeDetail(index),
                      icon: const Icon(Icons.delete_rounded, color: Colors.red),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              CustomSectionCard('Oil Information', [
                _buildOilTypeDropdown(
                  selectedValue: detail.selectedOilType,
                  onChanged:
                      (value) => setState(() => detail.selectedOilType = value),
                ),
                CustomTextField(
                  controller: detail.quantityController,
                  label: 'Quantity (Kg)',
                  icon: Icons.scale,
                  isNumeric: true,
                  allowDecimal: true,
                  isRequired: true,
                ),
              ]),
              const SizedBox(height: 12),
              CustomSectionCard('From Location', [
                _buildTankDropdown(
                  selectedValue: detail.selectedFromStorageTankNo,
                  onChanged:
                      (value) => setState(
                        () => detail.selectedFromStorageTankNo = value,
                      ),
                  hintText: 'Pilih Storage Tank No',
                ),
                CustomTextField(
                  controller: detail.fromRefineryFractionationController,
                  label: 'Refinery/Fractionation',
                  icon: Icons.factory,
                ),
                CustomTextField(
                  controller: detail.fromOtherController,
                  label: 'Other',
                  icon: Icons.more_horiz,
                ),
              ]),
              const SizedBox(height: 12),
              CustomSectionCard('To Location', [
                _buildTankDropdown(
                  selectedValue: detail.selectedToStorageTankNo,
                  onChanged:
                      (value) => setState(
                        () => detail.selectedToStorageTankNo = value,
                      ),
                  hintText: 'Pilih Storage Tank No',
                ),
                CustomTextField(
                  controller: detail.toRefineryFractionationController,
                  label: 'Refinery/Fractionation',
                  icon: Icons.factory,
                ),
                CustomTextField(
                  controller: detail.toOtherController,
                  label: 'Other',
                  icon: Icons.more_horiz,
                ),
              ]),
              const SizedBox(height: 12),
              CustomSectionCard('Quality Parameters', [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: CustomTextField(
                          controller: detail.qualityMAndIController,
                          label: 'M&I (%)',
                          icon: Icons.water_drop,
                          isNumeric: true,
                          allowDecimal: true,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: CustomTextField(
                          controller: detail.qualityFfaController,
                          label: 'FFA (%)',
                          icon: Icons.bubble_chart,
                          isNumeric: true,
                          allowDecimal: true,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: CustomTextField(
                          controller: detail.qualityLovColorRController,
                          label: 'Color R',
                          icon: Icons.color_lens,
                          isNumeric: true,
                          allowDecimal: true,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: CustomTextField(
                          controller: detail.qualityLovColorYController,
                          label: 'Color Y',
                          icon: Icons.color_lens_outlined,
                          isNumeric: true,
                          allowDecimal: true,
                        ),
                      ),
                    ),
                  ],
                ),
                CustomTextField(
                  controller: detail.qualityCpTempController,
                  label: 'CP Temp (°C)',
                  icon: Icons.thermostat,
                  isNumeric: true,
                  allowDecimal: true,
                ),
                CustomTextField(
                  controller: detail.qualitySmpController,
                  label: 'SMP (°C)',
                  icon: Icons.thermostat_outlined,
                  isNumeric: true,
                  allowDecimal: true,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: CustomTextField(
                          controller: detail.qualityPvController,
                          label: 'PV',
                          icon: Icons.science,
                          isNumeric: true,
                          allowDecimal: true,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: CustomTextField(
                          controller: detail.qualityIvController,
                          label: 'IV',
                          icon: Icons.science_outlined,
                          isNumeric: true,
                          allowDecimal: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ]),
              const SizedBox(height: 12),
              CustomRemarkField(controller: detail.detailRemarkController),
              const SizedBox(height: 16),
            ],
          );
        }),
        Align(
          alignment: Alignment.centerLeft,
          child: ElevatedButton.icon(
            onPressed: _addDetail,
            icon: const Icon(Icons.add),
            label: const Text('Add Row'),
          ),
        ),
      ],
    );
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) {
      showSnackBar('Mohon lengkapi semua field', context);
      return;
    }

    if (transactionDateController.text.trim().isEmpty) {
      showSnackBar('Transaction Date wajib diisi', context);
      return;
    }

    if (!_validateDetail()) return;

    final bool isSuccess = await _submitForm();
    if (!mounted) return;
    if (isSuccess) {
      showSnackBar('Berhasil menyimpan data', context);
      Navigator.of(context).pop();
    } else {
      showSnackBar('Gagal menyimpan data', context);
    }
  }

  bool _validateDetail() {
    for (int i = 0; i < _detailForms.length; i++) {
      final detail = _detailForms[i];
      if (detail.selectedOilType == null ||
          detail.selectedOilType!.trim().isEmpty) {
        showSnackBar('Oil Type wajib diisi (Row ${i + 1})', context);
        return false;
      }
      if (detail.quantityController.text.trim().isEmpty) {
        showSnackBar('Quantity wajib diisi (Row ${i + 1})', context);
        return false;
      }
    }
    return true;
  }

  Future<bool> _submitForm() async {
    final plant = context.read<PlantProvider>().currentPlant;
    final user = context.read<UserProvider>();
    final businessUnit =
        context.read<BusinessUnitProvider>().currentBusinessUnit;
    final storageService = context.read<StorageService>();
    final provider = context.read<FormTransferProvider>();
    final token = await storageService.readSessionToken() ?? '';

    try {
      final uuid = const Uuid();
      final headerId = uuid.v4();
      final details =
          _detailForms.map((detail) {
            final detailId = uuid.v4();
            return FormTransferDetailModel(
              jsonId: detailId,
              jsonIdHdr: headerId,
              jsonOilType: detail.selectedOilType,
              jsonQuantity: _parseNumString(detail.quantityController.text),
              jsonFromStorageTankNo: detail.selectedFromStorageTankNo,
              jsonFromRefineryFractionation:
                  detail.fromRefineryFractionationController.text,
              jsonFromOther: detail.fromOtherController.text,
              jsonToStorageTankNo: detail.selectedToStorageTankNo,
              jsonToRefineryFractionation:
                  detail.toRefineryFractionationController.text,
              jsonToAutoFillingTank: null,
              jsonToOther: detail.toOtherController.text,
              jsonQualityMAndI: _parseNum(detail.qualityMAndIController.text),
              jsonQualityFfa: _parseNum(detail.qualityFfaController.text),
              jsonQualityLovColorR: _parseNum(
                detail.qualityLovColorRController.text,
              ),
              jsonQualityLovColorY: _parseNum(
                detail.qualityLovColorYController.text,
              ),
              jsonQualityCpTemp: _parseNum(detail.qualityCpTempController.text),
              jsonQualitySmp: _parseNum(detail.qualitySmpController.text),
              jsonQualityPv: _parseNum(detail.qualityPvController.text),
              jsonQualityIv: _parseNum(detail.qualityIvController.text),
              jsonRemark: detail.detailRemarkController.text,
              jsonDeletedAt: null,
            );
          }).toList();

      // Build header model with details array
      final header = FormTransferHeaderModel(
        jsonId: headerId,
        jsonCompany: businessUnit?.buCode,
        jsonPlant: plant?.code,
        jsonTransactionDate: _formatTransactionDate(
          transactionDateController.text,
        ),
        jsonToDept: toDeptController.text,
        jsonFromDept: fromDeptController.text,
        jsonFormNo: formData?.code,
        jsonDateIssued:
            formData?.dateIssued != null
                ? DateFormat('yyyy-MM-dd').format(formData!.dateIssued!)
                : null,
        jsonRevisionNo: formData?.revisionNo,
        jsonRevisionDate:
            formData?.revisionDate != null
                ? DateFormat('yyyy-MM-dd').format(formData!.revisionDate!)
                : null,
        jsonFlag: 'I',
        jsonEntryBy: user.currentUser?.username,
        jsonEntryDate: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
        jsonPreparedBy: null,
        jsonPreparedDate: null,
        jsonPreparedStatus: null,
        jsonPreparedStatusRemarks: null,
        jsonApprovedBy: null,
        jsonApprovedDate: null,
        jsonApprovedStatus: null,
        jsonApprovedStatusRemarks: null,
        jsonUpdatedBy: null,
        jsonUpdatedDate: null,
        jsonDeletedAt: null,
        jsonDetail: details,
      );

      if (!mounted) return false;

      await provider.createTransfer(header, 'Bearer $token');

      return true;
    } catch (e) {
      log('Error submitting form transfer: $e');
      return false;
    }
  }

  num? _parseNum(String? value) {
    if (value == null) return null;
    final raw = value.trim();
    if (raw.isEmpty) return null;

    var cleaned = raw.replaceAll(' ', '');
    if (cleaned.contains(',')) {
      cleaned = cleaned.replaceAll('.', '');
      cleaned = cleaned.replaceAll(',', '.');
    } else {
      cleaned = cleaned.replaceAll('.', '');
    }

    return num.tryParse(cleaned);
  }

  String? _parseNumString(String? value) {
    final parsed = _parseNum(value);
    return parsed?.toString();
  }

  String? _formatTransactionDate(String? value) {
    if (value == null || value.isEmpty) return null;
    try {
      final inputFormat = DateFormat('dd-MM-yyyy');
      final dateTime = inputFormat.parse(value);
      return DateFormat('yyyy-MM-dd').format(dateTime);
    } catch (e) {
      log('Error formatting transaction date: $e');
      return null;
    }
  }

  Widget _buildOilTypeDropdown({
    required String? selectedValue,
    required ValueChanged<String?> onChanged,
  }) {
    return _buildOilTypeDropdownInternal(
      selectedValue: selectedValue,
      onChanged: onChanged,
    );
  }

  Widget _buildOilTypeDropdownInternal({
    required String? selectedValue,
    required ValueChanged<String?> onChanged,
  }) {
    return Consumer<ValueProvider>(
      builder: (context, provider, child) {
        if (provider.isOilTypeLoading) {
          return DropdownButtonFormField<String>(
            value: null,
            items: const [],
            onChanged: null,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF0ECE9),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              hintText: 'Loading Materials...',
              prefixIcon: const Padding(
                padding: EdgeInsets.all(12.0),
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
          );
        }

        if (provider.oilTypeLists.isEmpty) {
          return TextFormField(
            readOnly: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF0ECE9),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              hintText: 'Materials Tidak Ditemukan',
              prefixIcon: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Icon(Icons.warning_amber_rounded),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => context.read<ValueProvider>().fetchOilTypes(),
              ),
            ),
          );
        }

        return DropdownButtonFormField<String>(
          value: selectedValue,
          items:
              provider.oilTypeLists.map((item) {
                return DropdownMenuItem<String>(
                  value: item.name,
                  child: Text(
                    "${item.name}",
                    style: const TextStyle(fontSize: 14),
                  ),
                );
              }).toList(),
          onChanged: (value) => setState(() => onChanged(value)),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF0ECE9),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            hintText: 'Pilih Oil Type',
            prefixIcon: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Icon(Icons.oil_barrel),
            ),
          ),
        );
      },
    );
  }

  void _addDetail() {
    setState(() {
      _detailForms.add(_DetailFormControllers());
    });
  }

  void _removeDetail(int index) {
    if (_detailForms.length <= 1) return;
    setState(() {
      _detailForms[index].dispose();
      _detailForms.removeAt(index);
    });
  }

  Widget _buildTankDropdown({
    required String? selectedValue,
    required ValueChanged<String?> onChanged,
    required String hintText,
  }) {
    return Consumer<ValueProvider>(
      builder: (context, provider, child) {
        if (provider.isTankSourceLoading) {
          return DropdownButtonFormField<String>(
            value: null,
            items: const [],
            onChanged: null,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF0ECE9),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              hintText: 'Loading Tanks...',
              prefixIcon: const Padding(
                padding: EdgeInsets.all(12.0),
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
          );
        }

        if (provider.tankSourceList.isEmpty) {
          return TextFormField(
            readOnly: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF0ECE9),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              hintText: 'Tank List tidak ditemukan.',
              prefixIcon: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Icon(Icons.warning_amber_rounded),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.refresh),
                onPressed:
                    () => context.read<ValueProvider>().fetchTankSourceLists(),
              ),
            ),
          );
        }

        return DropdownButtonFormField<String>(
          value: selectedValue,
          isExpanded: true,
          items:
              provider.tankSourceList.map((tank) {
                return DropdownMenuItem<String>(
                  value: tank.code,
                  child: Text(tank.code, style: const TextStyle(fontSize: 14)),
                );
              }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF0ECE9),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            hintText: hintText,
            prefixIcon: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Icon(Icons.storage),
            ),
          ),
        );
      },
    );
  }
}
