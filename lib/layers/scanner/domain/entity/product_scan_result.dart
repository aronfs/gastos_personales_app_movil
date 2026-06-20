import 'package:equatable/equatable.dart';

class ProductScanResult extends Equatable {
  final String name;
  final String presentation;
  final double price;
  final String imagePath; // Path de la imagen capturada por la cámara

  const ProductScanResult({
    required this.name,
    required this.presentation,
    required this.price,
    required this.imagePath,
  });

  ProductScanResult copyWith({
    String? name,
    String? presentation,
    double? price,
    String? imagePath,
  }) {
    return ProductScanResult(
      name: name ?? this.name,
      presentation: presentation ?? this.presentation,
      price: price ?? this.price,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  @override
  List<Object?> get props => [name, presentation, price, imagePath];
}
