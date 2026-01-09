import 'package:logsheet_app/features/master_data/data/datasources/master/rfi_mysql_service.dart';
import 'package:logsheet_app/features/master_data/data/model/master/rfi_entity.dart';

class RfiRepository {
  final RfiMySQLService _mySQLService;

  RfiRepository(this._mySQLService);

  Future<List<RfiEntity>> fetchRFI() async {
    final List<Map<String, dynamic>> crystallizerMaps =
        await _mySQLService.fetchRFI();

    return crystallizerMaps.map((map) => RfiEntity.fromMap(map)).toList();
  }
}
