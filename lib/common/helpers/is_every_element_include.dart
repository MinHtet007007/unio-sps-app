/// Checks if every element in [secondArray] exists in [firstArray].
bool isEveryElementIncluded(List<String> firstArray, List<String> secondArray) {
  // Convert the first list to a Set for faster lookups
  final firstSet = Set<String>.from(firstArray);

  // Check if every element in the second array is included in the first set
  for (final element in secondArray) {
    if (!firstSet.contains(element)) {
      return false;
    }
  }

  return true;
}
