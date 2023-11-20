String transformNationalityName(String originalName) {
  if (originalName == 'Slovak Republic') {
    return 'SVK';
  }
  if (originalName == 'Czech') {
    return 'CZE';
  }
  if (originalName == 'Cyprus') {
    return 'CYP';
  }
  return originalName;
}
