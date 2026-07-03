import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../design_system/atoms/casona_button.dart';
import '../design_system/molecules/casona_section_card.dart';
import '../viewmodels/visual_search_viewmodel.dart';
import '../widgets/empty_state.dart';
import '../widgets/product_card.dart';

class VisualSearchScreen extends StatelessWidget {
  const VisualSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final visualSearch = context.watch<VisualSearchViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Busqueda visual')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: CasonaButton(
              text: 'Tomar foto',
              icon: Icons.photo_camera_outlined,
              isLoading: visualSearch.isLoading,
              onPressed: visualSearch.isLoading
                  ? null
                  : visualSearch.searchFromCamera,
            ),
          ),
          if (visualSearch.detectedCategories.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CasonaSectionCard(
                icon: Icons.auto_awesome,
                title: 'Detectado',
                subtitle: visualSearch.detectedCategories.join(', '),
                child: const SizedBox.shrink(),
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
                        'La camara detectara prendas y mostrara similares.',
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
