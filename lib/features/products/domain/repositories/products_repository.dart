import '../entities/product.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

abstract class ProductsRepository {
  Future<Either<Failure, List<Product>>> getAllProducts();
}
