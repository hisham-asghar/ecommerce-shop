Future<void> delay([int milliseconds = 2000]) async {
  await Future.delayed(Duration(milliseconds: milliseconds));
}
