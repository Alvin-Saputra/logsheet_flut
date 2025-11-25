import 'package:logsheet_app/features/master_data/data/model/master/product_entity.dart';
import 'package:logsheet_app/features/master_data/data/datasources/master/product_mysql_service.dart';

class ProductRepository {
  final ProductMySQLService _mySQLService;

  ProductRepository(this._mySQLService);

  Future<List<ProductEntity>> fetchProducts() async {
    final List<Map<String, dynamic>> productMaps =
        await _mySQLService.fetchProducts();
    return productMaps.map((map) => ProductEntity.fromMap(map)).toList();
  }
}
