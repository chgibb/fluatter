class NextNonEmptyElementResult {
  String element;
  int i;
}

NextNonEmptyElementResult nextNonEmptyElement(List<String> elements, int i) {
  while (i != elements.length) {
    if (elements[i] != null && elements[i] != "") {
      return NextNonEmptyElementResult()
        ..element = elements[i]
        ..i = i;
    }
    ++i;
  }

  return null;
}
