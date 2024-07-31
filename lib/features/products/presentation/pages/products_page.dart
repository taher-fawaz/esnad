import 'package:esnad/features/products/presentation/bloc/product_bloc.dart';
import 'package:esnad/features/products/presentation/widgets/products_page/message_display_widget.dart';
import 'package:esnad/features/products/presentation/widgets/products_page/product_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/loading_widget.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppbar() => AppBar(title: Text('Products'));

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is LoadingProductsState) {
            return LoadingWidget();
          } else if (state is LoadedProductsState) {
            return RefreshIndicator(
                onRefresh: () => _onRefresh(context),
                child: ProductListWidget(products: state.products));
          } else if (state is ErrorProductsState) {
            return MessageDisplayWidget(message: state.message);
          }
          return LoadingWidget();
        },
      ),
    );
  }

  Future<void> _onRefresh(BuildContext context) async {
    BlocProvider.of<ProductBloc>(context).add(RefreshProductsEvent());
  }
}
