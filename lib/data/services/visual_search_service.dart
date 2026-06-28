import 'dart:io';

import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/constants/app_constants.dart';

class VisualSearchService {
  VisualSearchService({ImagePicker? picker, ImageLabeler? labeler})
    : _picker = picker ?? ImagePicker(),
      _labeler =
          labeler ??
          ImageLabeler(options: ImageLabelerOptions(confidenceThreshold: 0.55));

  final ImagePicker _picker;
  final ImageLabeler _labeler;

  Future<List<String>> pickAndDetectCategories() async {
    final image = await _picker.pickImage(source: ImageSource.camera);
    if (image == null) return [];

    final labels = await _labeler.processImage(
      InputImage.fromFile(File(image.path)),
    );

    final categories = <String>{};
    for (final label in labels) {
      final text = label.label.toLowerCase();
      if (!AppConstants.clothingLabels.any(text.contains)) continue;
      categories.addAll(_mapLabelToCategories(text));
    }

    return categories.toList();
  }

  List<String> _mapLabelToCategories(String label) {
    if (label.contains('dress') || label.contains('skirt')) {
      return ['Vestidos'];
    }
    if (label.contains('jacket') ||
        label.contains('coat') ||
        label.contains('outerwear')) {
      return ['Outerwear'];
    }
    if (label.contains('pants') ||
        label.contains('trousers') ||
        label.contains('jeans')) {
      return ['Pantalones'];
    }
    return ['Tops'];
  }

  Future<void> close() => _labeler.close();
}
