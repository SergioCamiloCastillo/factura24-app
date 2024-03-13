import 'package:formz/formz.dart';

enum FileUploadError { empty }

// Extend FormzInput and provide the input type and error type for file upload
class FileUpload extends FormzInput<String?, FileUploadError> {
  // Call super.pure to represent an unmodified form input.
  const FileUpload.pure() : super.pure(null);

  // Call super.dirty to represent a modified form input.
  const FileUpload.dirty(String? value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (error == FileUploadError.empty) return 'Por favor, sube un archivo o imagen';

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  FileUploadError? validator(String? value) {
    if (value == null) return FileUploadError.empty;

    return null;
  }
}
