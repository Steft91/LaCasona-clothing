import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/routes/app_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/app_utils.dart';
import '../../domain/entities/product_entity.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    required this.product,
    this.onFavorite,
    this.isFavorite = false,
    super.key,
  });

  final ProductEntity product;
  final VoidCallback? onFavorite;
  final bool isFavorite;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => context.pushNamed(
          AppRouter.productDetail,
          pathParameters: {'id': product.id},
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: AppTheme.woodGradient,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppTheme.lineGold, width: 1.2),
            boxShadow: const [
              BoxShadow(
                color: AppTheme.heavyShadow,
                blurRadius: 24,
                offset: Offset(0, 14),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 5, 9),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppTheme.ivoryWall,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: AppTheme.burnishedGold),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            product.imagenUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  decoration: const BoxDecoration(
                                    gradient: AppTheme.parchmentGradient,
                                  ),
                                  child: const Icon(
                                    Icons.image_not_supported_outlined,
                                    color: AppTheme.carvedWood,
                                  ),
                                ),
                          ),
                          Positioned.fill(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.black.withValues(alpha: 0.08),
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.2),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          if (onFavorite != null)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: isFavorite
                                      ? const LinearGradient(
                                          colors: [
                                            AppTheme.roseClay,
                                            AppTheme.mahogany,
                                          ],
                                        )
                                      : AppTheme.goldGradient,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: AppTheme.softGold),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: AppTheme.warmShadow,
                                      offset: Offset(0, 5),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  onPressed: onFavorite,
                                  icon: Icon(
                                    isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: isFavorite
                                        ? AppTheme.lightText
                                        : AppTheme.deepWood,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(11),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.nombre,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  color: AppTheme.inkBrown,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                          const SizedBox(height: 8),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: AppTheme.goldGradient,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppTheme.burnishedGold),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 5,
                              ),
                              child: Text(
                                AppUtils.formatCurrency(product.precio),
                                style: Theme.of(context).textTheme.labelMedium
                                    ?.copyWith(
                                      color: AppTheme.deepWood,
                                      fontWeight: FontWeight.w900,
                                    ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            product.stock <= 0
                                ? 'Sin stock'
                                : 'Solo quedan ${product.stock}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: product.stock <= 0
                                      ? AppTheme.errorColor
                                      : AppTheme.mutedText,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
