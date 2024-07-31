import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:esnad/core/error/failures.dart';
import 'package:esnad/core/strings/failures.dart';
import 'package:esnad/features/products/domain/entities/product.dart';
import 'package:esnad/features/products/domain/usecases/get_all_products.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetAllProductsUsecase getAllProducts;
  ProductBloc({
    required this.getAllProducts,
  }) : super(ProductsInitial()) {
    on<ProductEvent>((event, emit) async {
      if (event is GetAllProductsEvent) {
        emit(LoadingProductsState());

        final failureOrProducts = await getAllProducts();
        emit(_mapFailureOrProductsToState(failureOrProducts));
      } else if (event is RefreshProductsEvent) {
        emit(LoadingProductsState());

        final failureOrProducts = await getAllProducts();
        emit(_mapFailureOrProductsToState(failureOrProducts));
      }
    });
  }

  ProductState _mapFailureOrProductsToState(
      Either<Failure, List<Product>> either) {
    return either.fold(
      (failure) => ErrorProductsState(message: _mapFailureToMessage(failure)),
      (products) => LoadedProductsState(
        products: products,
      ),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case EmptyCacheFailure:
        return EMPTY_CACHE_FAILURE_MESSAGE;
      case OfflineFailure:
        return OFFLINE_FAILURE_MESSAGE;
      default:
        return "Unexpected Error , Please try again later .";
    }
  }
}
