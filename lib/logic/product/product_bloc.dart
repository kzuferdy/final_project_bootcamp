import 'package:bloc/bloc.dart';
import '../../services/product_services.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductService productService;

  ProductBloc(this.productService) : super(ProductInitial()) {
    on<FetchProducts>((event, emit) async {
      emit(ProductLoading());
      try {
        final products = await productService.fetchProducts();
        print('Fetched Products: ${products.length}'); // Tambahkan logging
        emit(ProductLoaded(products));
      } catch (e) {
        print('Error: ${e.toString()}'); // Tambahkan logging
        emit(ProductError('Failed to fetch products'));
      }
    });

    on<UpdateProduct>((event, emit) async {
      try {
        await productService.updateProduct(event.product);
        if (state is ProductLoaded) {
          final updatedProducts = (state as ProductLoaded).products.map((product) {
            return product.id == event.product.id ? event.product : product;
          }).toList();
          emit(ProductLoaded(updatedProducts));
        }
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });

    on<SearchProducts>((event, emit) async {
      emit(ProductLoading());
      try {
        final products = await productService.fetchProducts();
        final filteredProducts = products.where((product) {
          final titleLower = product.title.toLowerCase();
          final searchLower = event.query.toLowerCase();
          return titleLower.contains(searchLower);
        }).toList();
        emit(ProductLoaded(filteredProducts));
      } catch (e) {
        print('Error: ${e.toString()}'); // Tambahkan logging
        emit(ProductError('Failed to fetch products'));
      }
    });
  }
}
