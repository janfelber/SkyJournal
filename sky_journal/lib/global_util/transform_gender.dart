String transformGender(String originalName) {
  if (originalName == 'Female') {
    return 'F';
  }
  if (originalName == 'Male') {
    return 'M';
  }
  return originalName;
}
