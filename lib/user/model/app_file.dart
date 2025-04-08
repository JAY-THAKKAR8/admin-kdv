// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

class AppFile {
  final Uint8List bytes;
  final String? name;
  final String? mimeType;
  final String? path;
  AppFile({
    required this.bytes,
    this.name,
    this.mimeType,
    this.path,
  });
}
