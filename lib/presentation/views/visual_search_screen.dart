import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/visual_search_viewmodel.dart';
import '../widgets/empty_state.dart';
import '../widgets/product_card.dart';

class VisualSearchScreen extends StatelessWidget {
  const VisualSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final visualSearch = context.watch<VisualSearchViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Búsqueda visual')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: visualSearch.isLoading
                    ? null
                    : visualSearch.searchFromCamera,
                icon: const Icon(Icons.photo_camera_outlined),
                label: const Text('Tomar foto'),
              ),
            ),
          ),
          if (visualSearch.detectedCategories.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Detectado: ${visualSearch.detectedCategories.join(', ')}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          Expanded(
            child: visualSearch.isLoading
                ? const Center(child: CircularProgressIndicator())
                : visualSearch.results.isEmpty
                ? EmptyState(
                    icon: Icons.camera_alt_outlined,
                    title: 'Busca con una foto',
                    message:
                        visualSearch.error ??
                        'La cámara detectará prendas y mostrará similares.',
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: visualSearch.results.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          childAspectRatio: 0.68,
                        ),
                    itemBuilder: (context, index) {
                      return ProductCard(product: visualSearch.results[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
