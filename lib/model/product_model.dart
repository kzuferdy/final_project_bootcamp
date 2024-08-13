class Product {
  final String id;
  final String title;
  final String description;
  final String category;
  final String image;
  final double price;
  final int stock; // Menambahkan field stok

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.image,
    required this.price,
    required this.stock, // Menambahkan stok ke dalam constructor
  });

  factory Product.fromJson(String id, Map<String, dynamic> json) {
    return Product(
      id: id,
      title: json['title'],
      description: json['description'],
      category: json['category'],
      image: json['image'],
      price: (json['price'] as num).toDouble(),
      stock: json['stock'] ?? 0, // Mendapatkan stok dari JSON, default 0 jika tidak ada
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'image': image,
      'price': price,
      'stock': stock, // Menambahkan stok ke dalam JSON
    };
  }
}

