import 'package:logsheet_app/features/master_data/data/datasources/master/cryztallizer_mysql_service.dart';
import 'package:logsheet_app/features/master_data/data/model/master/crystallizer_entity.dart';

class CrystallizerRepository {
  final CrystallizerMySQLService _mySQLService;

  CrystallizerRepository(this._mySQLService);

  Future<List<CrystallizerEntity>> fetchCrystallizer() async {
    final List<Map<String, dynamic>> crystallizerMaps =
        await _mySQLService.fetchCrystallizer();

    return crystallizerMaps
        .map((map) => CrystallizerEntity.fromMap(map))
        .toList();
  }
}
