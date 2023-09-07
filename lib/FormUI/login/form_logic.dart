import 'package:bws_agreement_creator/FormUI/components/bordered_input.dart';
import 'package:bws_agreement_creator/FormUI/components/button_icon_title.dart';
import 'package:bws_agreement_creator/FormUI/components/default_bordered_button.dart';
import 'package:bws_agreement_creator/FormUI/components/dropdown_button.dart';
import 'package:bws_agreement_creator/FormUI/components/photo_tile.dart';
import 'package:bws_agreement_creator/FormUI/components/select_date_button.dart';
import 'package:bws_agreement_creator/app_state.dart';
import 'package:bws_agreement_creator/form_controller.dart';
import 'package:bws_agreement_creator/utils/auth_service.dart';
import 'package:bws_agreement_creator/utils/colors.dart';
import 'package:bws_agreement_creator/utils/date_extensions.dart';
import 'package:bws_agreement_creator/utils/google_drive_service.dart';
import 'package:bws_agreement_creator/utils/google_sheets_service.dart';
import 'package:bws_agreement_creator/utils/use_build_effect.dart';
import 'package:collection/collection.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

class FormLogic extends HookConsumerWidget {
  const FormLogic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setWageHidden = useState(false);
    final wageFormatter =
        CurrencyTextInputFormatter(symbol: 'zł', locale: 'pl_pl');
    final setWage = useCallback((String? formattedValue) {
      final wageInCents = wageFormatter.getUnformattedValue() * 100;
      if (formattedValue?.isEmpty == true) {
        ref.read(FormNotifier.provider.notifier).setNettoValue(null);
      } else {
        ref
            .read(FormNotifier.provider.notifier)
            .setNettoValue(wageInCents.toInt());
      }
    }, [wageFormatter]);

    final config = ref.watch(userConfigProvider);

    Future<void> readConfig() async {
      try {
        await GoogleDriveService().getConfigFromDrive(ref);
      } catch (e) {
        ref.read(errorProvider.notifier).state = e.toString();
        print(e);

        AuthService(ref: ref).signOut();
      }
    }

    final pdfIcon = useState<Uint8List?>(null);
    Future<void> readDefaultPdfIcon() async {
      final data = await rootBundle.load('assets/pdf.png');
      pdfIcon.value = data.buffer.asUint8List();
    }

    final takePhoto = useCallback(() async {
      final ImagePicker _picker = ImagePicker();
      final XFile? photo = await _picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 50,
          maxHeight: 1920,
          maxWidth: 1920);

      if (photo != null) {
        ref
            .read(FormNotifier.provider.notifier)
            .addPhoto(await photo.readAsBytes());
      }
    }, []);

    final pickPdfFromFiles = useCallback(() async {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          allowedExtensions: ['pdf'], type: FileType.custom, withData: true);

      if (result != null &&
          lookupMimeType('', headerBytes: result.files.single.bytes) ==
              'application/pdf') {
        ref
            .read(FormNotifier.provider.notifier)
            .setPdfFile(result.files.single.bytes);
      } else {
        ref.read(errorProvider.notifier).state =
            'Nie udało się pobrać pliku lub jest w niewłaściwym formacie (pdf)';
      }
    }, []);

    final pickImageFromFiles = useCallback(() async {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          allowMultiple: true,
          allowedExtensions: ['jpg', 'png', 'jpeg'],
          type: FileType.custom,
          withData: true);

      if (result != null) {
        result.files.forEach((platformFile) async {
          List<int> compressedImage = kIsWeb
              ? platformFile.bytes!
              : await FlutterImageCompress.compressWithList(platformFile.bytes!,
                  quality: 70);
          if (platformFile.bytes != null) {
            ref
                .read(FormNotifier.provider.notifier)
                .addPhoto(platformFile.bytes!);
          }
        });
      } else {
        ref.read(errorProvider.notifier).state =
            'Nie udało się pobrać zdjęcia lub jest w niewłaściwym formacie';
      }
    }, []);

    final selectedCategory = ref.watch(FormNotifier.provider).category;
    final subcategories = config?.categories
            .firstWhereOrNull(
              (element) => element.name == selectedCategory,
            )
            ?.subCategories ??
        [];

    final selectedPhotos = ref.watch(FormNotifier.provider).photos;
    final selectedPdf = ref.watch(FormNotifier.provider).pdfFile;

    final authData = ref.watch(userAuthProvider);
    final formState = ref.watch(FormNotifier.provider);
    final isLoading = ref.watch(isFormLoadingProvider);

    final onSendTapped = useCallback(() async {
      final validationError =
          ref.read(FormNotifier.provider.notifier).getValidationError();
      if (validationError != null) {
        ref.read(errorProvider.notifier).state = validationError;
        return;
      }
      setWageHidden.value = true;
      await Future.delayed(Duration(milliseconds: 10));
      setWageHidden.value = false;
      ref.read(isFormLoadingProvider.notifier).state = true;
      try {
        await GoogleSheetsService().addNewEntry(formState, ref);
      } catch (er) {
        ref.read(errorProvider.notifier).state =
            "Coś poszło nie tak i nie udało się wysłać tego pliku, jeśli plik na pewno jest poprawny spróbuj ponownie.";
      }
      ref.read(isFormLoadingProvider.notifier).state = false;
      ref.read(FormNotifier.provider.notifier).clearForm();
    }, [formState]);

    final selectedDate = ref.watch(FormNotifier.provider).selectedDate;

    useBuildEffect(() {
      readConfig();
      readDefaultPdfIcon();
    }, []);
    if (config == null) {
      return Container(
          color: Colors.black,
          child: const Center(
            child: CircularProgressIndicator(
              color: CustomColors.applicationColorMain,
            ),
          ));
    }
    return Column(
      children: [
        if (setWageHidden.value == false)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: BorderedInput(
              inputType: TextInputType.number,
              onChanged: setWage,
              placeholder: 'Kwota brutto (od 01.09)',
              inputFormatters: [wageFormatter],
            ),
          ),
        Container(
          margin: const EdgeInsets.fromLTRB(24, 8, 24, 8),
          child: SelectDateButton(
              dateText: selectedDate,
              headerText: "Data",
              onDateSelected: ref.read(FormNotifier.provider.notifier).setDate),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(24, 8, 24, 8),
          child: MenuButton(
              header: 'Osoba',
              dropdownValue: ref.watch(FormNotifier.provider).person,
              items: config.employees,
              onChanged: ref.read(FormNotifier.provider.notifier).setPerson),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(24, 8, 24, 8),
          child: MenuButton(
              header: 'Kategoria',
              dropdownValue: ref.watch(FormNotifier.provider).category,
              items: config.categories.map((e) => e.name).toList(),
              onChanged: ref.read(FormNotifier.provider.notifier).setCategory),
        ),
        if (subcategories.isEmpty == false)
          Container(
            margin: const EdgeInsets.fromLTRB(24, 8, 24, 8),
            child: MenuButton(
                header: 'Podkategoria',
                dropdownValue: ref.watch(FormNotifier.provider).subcategory,
                items: subcategories,
                onChanged:
                    ref.read(FormNotifier.provider.notifier).setSubcategory),
          ),
        if (subcategories.isEmpty == true)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: BorderedInput(
              onChanged:
                  ref.read(FormNotifier.provider.notifier).setSubcategory,
              placeholder: 'Podkategoria',
            ),
          ),
        Container(
          margin: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (selectedPdf == null && !kIsWeb)
                ButtonIconTitle(
                  onTap: takePhoto,
                  title: "Zrób zdjęcie",
                  icon: Icons.camera_alt_outlined,
                ),
              if (selectedPdf == null)
                ButtonIconTitle(
                  onTap: pickImageFromFiles,
                  title: "Wybierz z galerii",
                  icon: Icons.image_outlined,
                ),
              if (selectedPhotos.isEmpty && selectedPdf == null)
                ButtonIconTitle(
                  onTap: pickPdfFromFiles,
                  title: "Dodaj PDF",
                  icon: Icons.picture_as_pdf_outlined,
                )
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 24),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...selectedPhotos
                  .mapIndexed((index, photo) => PhotoTile(
                        data: photo,
                        onTap: () => {
                          ref
                              .read(FormNotifier.provider.notifier)
                              .removePhoto(index)
                        },
                      ))
                  .toList(),
              if (selectedPdf != null && pdfIcon.value != null)
                PhotoTile(
                    onTap: () {
                      ref.read(FormNotifier.provider.notifier).setPdfFile(null);
                    },
                    title: selectedDate.formattedDateWithDays,
                    data: pdfIcon.value!)
            ],
          ),
        ),
        isLoading
            ? const CircularProgressIndicator(
                color: CustomColors.applicationColorMain,
              )
            : DefaultBorderedButton(
                onTap: () async {
                  onSendTapped();
                },
                text: "Wyślij")
      ],
    );
  }
}
