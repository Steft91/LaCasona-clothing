import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/app_utils.dart';
import '../../domain/entities/product_entity.dart';
import '../design_system/atoms/casona_button.dart';
import '../design_system/molecules/casona_section_card.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/cart_viewmodel.dart';
import '../viewmodels/product_viewmodel.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({required this.productId, super.key});

  final String productId;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String? _selectedSize;
  String? _selectedColor;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProductEntity>(
      future: context.read<ProductViewModel>().getProduct(widget.productId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: Text('Producto no encontrado')),
          );
        }

        final product = snapshot.data!;
        _selectedSize ??= product.tallas.isNotEmpty ? product.tallas.first : '';
        _selectedColor ??= product.colores.isNotEmpty
            ? product.colores.first
            : '';

        return Scaffold(
          appBar: AppBar(title: Text(product.nombre)),
          body: ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.network(
                      product.imagenUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: AppTheme.warmStone.withValues(alpha: 0.18),
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          color: AppTheme.carvedWood,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CasonaSectionCard(
                      title: product.nombre,
                      subtitle: product.descripcion,
                      child: Row(
                        children: [
                          Text(
                            AppUtils.formatCurrency(product.precio),
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(color: AppTheme.carvedWood),
                          ),
                          const SizedBox(width: 12),
                          if (product.precioOriginal > product.precio)
                            Text(
                              AppUtils.formatCurrency(product.precioOriginal),
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    color: AppTheme.mutedText,
                                  ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _Selector(
                      title: 'Color',
                      values: product.colores,
                      selected: _selectedColor,
                      onSelected: (value) => setState(() {
                        _selectedColor = value;
                      }),
                    ),
                    const SizedBox(height: 16),
                    _Selector(
                      title: 'Talla',
                      values: product.tallas,
                      selected: _selectedSize,
                      onSelected: (value) => setState(() {
                        _selectedSize = value;
                      }),
                    ),
                    const SizedBox(height: 28),
                    CasonaButton(
                      text: product.stock <= 0
                          ? 'Sin stock'
                          : 'Agregar al carrito',
                      icon: Icons.shopping_bag_outlined,
                      onPressed: product.stock <= 0 ? null : () => _add(product),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _add(ProductEntity product) async {
    final user = context.read<AuthViewModel>().user;
    if (user == null) return;

    await context.read<CartViewModel>().addProduct(
      userId: user.id,
      product: product,
      talla: _selectedSize ?? '',
      color: _selectedColor ?? '',
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Producto agregado al carrito')),
    );
  }
}

class _Selector extends StatelessWidget {
  const _Selector({
    required this.title,
    required this.values,
    required this.selected,
    required this.onSelected,
  });

  final String title;
  final List<String> values;
  final String? selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) return const SizedBox.shrink();

    return CasonaSectionCard(
      title: title,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: values
            .map(
              (value) => ChoiceChip(
                label: Text(
                  value,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppTheme.deepWood,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                selected: value == selected,
                selectedColor: AppTheme.softGold,
                backgroundColor: AppTheme.warmStone,
                side: BorderSide(
                  color: value == selected
                      ? AppTheme.antiqueGold
                      : AppTheme.dividerColor,
                ),
                onSelected: (_) => onSelected(value),
              ),
            )
            .toList(),
      ),
    );
  }
}
