String? requiredText(String? value, String label, {int? maxLength}) {
  final text = value?.trim() ?? '';
  if (text.isEmpty) return '$label tidak boleh kosong!';
  if (maxLength != null && text.length > maxLength) {
    return '$label maksimal $maxLength karakter.';
  }
  return null;
}

String? optionalUrl(String? value) {
  final text = value?.trim() ?? '';
  if (text.isEmpty) return null;
  final uri = Uri.tryParse(text);
  if (text.length > 200 ||
      RegExp(r'\s').hasMatch(text) ||
      uri == null ||
      !['http', 'https'].contains(uri.scheme) ||
      uri.host.isEmpty ||
      !uri.host.contains('.')) {
    return 'Masukkan URL http/https yang valid (maksimal 200 karakter).';
  }
  return null;
}
