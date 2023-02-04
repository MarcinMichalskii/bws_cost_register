import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'form_controller.g.dart';

@CopyWith()
class CostFormState {
  final int? nettoValue;
  final DateTime selectedDate;
  final String? person;
  final String? category;
  final String? subcategory;
  final List<Uint8List> photos;
  final Uint8List? pdfFile;

  CostFormState(
      {this.nettoValue,
      this.person,
      this.category,
      this.subcategory,
      required this.photos,
      required this.selectedDate,
      this.pdfFile});
}

class FormNotifier extends StateNotifier<CostFormState> {
  FormNotifier()
      : super(CostFormState(photos: [], selectedDate: DateTime.now()));
  static final provider =
      StateNotifierProvider.autoDispose<FormNotifier, CostFormState>((ref) {
    return FormNotifier();
  });

  void setNettoValue(int? nettoValue) {
    state = state.copyWith(nettoValue: nettoValue);
  }

  void setPerson(String? name) {
    state = state.copyWith(person: name);
  }

  void setCategory(String? category) {
    state = state.copyWith(category: category, subcategory: null);
  }

  void setSubcategory(String? subcategory) {
    state = state.copyWith(subcategory: subcategory);
  }

  void addPhoto(Uint8List value) {
    var photos = state.photos;
    photos.add(value);
    state = state.copyWith(photos: photos);
  }

  void removePhoto(int index) {
    if (index >= state.photos.length) return;
    var photos = state.photos;
    photos.removeAt(index);
    state = state.copyWith(photos: photos);
  }

  void setPdfFile(Uint8List? pdfFile) {
    state = state.copyWith(pdfFile: pdfFile);
  }

  void setDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  String? getValidationError() {
    if (state.nettoValue == null) {
      return "Sprawdź wartość netto";
    }
    if (state.person == null) {
      return "Sprawdź osobę";
    }
    if (state.category == null) {
      return "Sprawdź kategorie";
    }
    if (state.subcategory == null) {
      return "Sprawdź podkategorie";
    }
    if (state.photos.isEmpty && state.pdfFile == null) {
      return "Dodaj zdjęcie lub plik pdf";
    }

    return null;
  }

  void clearForm() {
    state = CostFormState(
        nettoValue: null,
        person: null,
        category: null,
        subcategory: null,
        photos: [],
        pdfFile: null,
        selectedDate: DateTime.now());
  }
}
