DateTime utcToLocal(String date) {
  return DateTime.parse(date).toLocal();
}

DateTime? utcToLocalOptional(String? date) {
  if (date == null) {
    return null;
  }
  return DateTime.parse(date).toLocal();
}
