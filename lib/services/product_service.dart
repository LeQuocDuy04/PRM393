import '../models/product.dart';

class ProductService {
  final List<Product> products;
  ProductService(this.products);

  List<Product> belowPrice(double maximumPrice) =>
      products.where((product) => product.price < maximumPrice).toList();

  List<String> productNames() => products.map((product) => product.name).toList();
}
