part of 'product_bloc.dart';

sealed class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductsInitial extends ProductState {}

class LoadingProductsState extends ProductState {}

class LoadedProductsState extends ProductState {
  final List<Product> products;

  LoadedProductsState({required this.products});

  @override
  List<Object> get props => [products];
}

class ErrorProductsState extends ProductState {
  final String message;

  ErrorProductsState({required this.message});

  @override
  List<Object> get props => [message];
}
