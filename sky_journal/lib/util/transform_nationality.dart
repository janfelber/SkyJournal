String transformNationalityName(String originalName) {
  if (originalName == 'Slovakia') {
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
