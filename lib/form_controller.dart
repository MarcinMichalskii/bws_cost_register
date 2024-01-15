import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

part 'form_controller.g.dart';

@CopyWith()
class CostFormState {
  final String id;
  final int? bruttoValue;
  final DateTime selectedDate;
  final String? person;
  final String? category;
  final String? subcategory;
  final String? orderNumber;
  final List<Uint8List> photos;
  final Uint8List? pdfFile;
  final bool isSent;

  CostFormState(
      {required this.id,
      this.bruttoValue,
      this.person,
      this.category,
      this.subcategory,
      this.orderNumber,
      required this.photos,
      required this.selectedDate,
      this.pdfFile,
      this.isSent = false});

  factory CostFormState.fromSharedPreferences(Map<String, dynamic> data) {
    return CostFormState(
      id: data['id'],
      bruttoValue: data['bruttoValue'],
      person: data['person'],
      category: data['category'],
      subcategory: data['subcategory'],
      orderNumber: data['orderNumber'],
      photos: [],
      pdfFile: null,
      isSent: data['isSent'],
      selectedDate: DateTime.parse(data['selectedDate']),
    );
  }

  Map<String, dynamic> toSharedPreferences() {
    return {
      'id': id,
      'bruttoValue': bruttoValue,
      'person': person,
      'category': category,
      'subcategory': subcategory,
      'orderNumber': orderNumber,
      'photos': photos.map((item) => item.toList()).toList(),
      'selectedDate': selectedDate.toIso8601String(),
      'pdfFile': pdfFile?.toList(),
      'isSent': isSent,
    };
  }
}

class FormNotifier extends StateNotifier<CostFormState> {
  FormNotifier()
      : super(CostFormState(
            id: const Uuid().v4().toString(),
            photos: [],
            selectedDate: DateTime.now()));
  static final provider =
      StateNotifierProvider.autoDispose<FormNotifier, CostFormState>((ref) {
    return FormNotifier();
  });

  void setBruttoValue(int? bruttoValue) {
    state = state.copyWith(bruttoValue: bruttoValue);
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

  void setOrderNumber(String? orderNumber) {
    state = state.copyWith(orderNumber: orderNumber);
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
    if (state.bruttoValue == null) {
      return "Sprawdź wartość brutto";
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

    if (state.category?.toLowerCase() == 'zlecenia' &&
        (state.orderNumber == null ||
            state.orderNumber?.trim().isEmpty == true)) {
      return "Wymagany numer zlecenia";
    }
    final String? category = state.category?.toLowerCase();
    final isSubcategoryEmptyOrNill =
        state.subcategory == null || state.subcategory?.trim().isEmpty == true;
    if (category == 'inne' && isSubcategoryEmptyOrNill) {
      return "Wymagana podkategoria";
    }

    return null;
  }

  void clearForm() {
    state = CostFormState(
        id: const Uuid().v4().toString(),
        bruttoValue: null,
        person: null,
        category: null,
        subcategory: null,
        photos: [],
        pdfFile: null,
        selectedDate: DateTime.now());
  }
}
