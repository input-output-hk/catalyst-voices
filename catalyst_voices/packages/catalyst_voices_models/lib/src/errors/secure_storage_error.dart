enum SecureStorageError implements Comparable<SecureStorageError> {
  canNotReadData('Cannot Read Data From Secure Storage'),
  canNotSaveData('Cannot Save Data From Secure Storage');

  final String description;

  const SecureStorageError(this.description);

  @override
  int compareTo(SecureStorageError other) {
    return description.compareTo(other.description);
  }

  @override
  String toString() => 'SecureStorageError(description: $description)';
}
