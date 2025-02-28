import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getCachedProducts();
  Future<Unit> cacheProducts(List<ProductModel> productModels);
}

const CACHED_productS = "CACHED_productS";

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final SharedPreferences sharedPreferences;

  ProductLocalDataSourceImpl({required this.sharedPreferences});
  @override
  Future<Unit> cacheProducts(List<ProductModel> productModels) {
    List productModelsToJson = productModels
        .map<Map<String, dynamic>>((productModel) => productModel.toJson())
        .toList();
    sharedPreferences.setString(
        CACHED_productS, json.encode(productModelsToJson));
    return Future.value(unit);
  }

  @override
  Future<List<ProductModel>> getCachedProducts() {
    final jsonString = sharedPreferences.getString(CACHED_productS);
    if (jsonString != null) {
      List decodeJsonData = json.decode(jsonString);
      List<ProductModel> jsonToProductModels = decodeJsonData
          .map<ProductModel>(
              (jsonProductModel) => ProductModel.fromJson(jsonProductModel))
          .toList();
      return Future.value(jsonToProductModels);
    } else {
      throw EmptyCacheException();
    }
  }
}
