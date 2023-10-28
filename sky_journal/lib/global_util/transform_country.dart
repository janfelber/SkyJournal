String transformCountryName(String originalName) {
  if (originalName == 'Slovakia') {
    return 'Slovak Republic';
  }
  if (originalName == 'Czech') {
    return 'Czech Republic';
  }
  return originalName;
}
