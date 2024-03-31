//transform natiolanity name to short name
String transformNationalityName(String originalName) {
  if (originalName == 'Slovak Republic') {
    return 'SVK';
  }
  if (originalName == 'Czech Republic') {
    return 'CZE';
  }
  if (originalName == 'Germany') {
    return 'DEU';
  }
  if (originalName == 'France') {
    return 'FRA';
  }
  if (originalName == 'Italy') {
    return 'ITA';
  }
  if (originalName == 'Spain') {
    return 'ESP';
  }
  if (originalName == 'Ukraine') {
    return 'UKR';
  }
  if (originalName == 'Poland') {
    return 'POL';
  }

  return originalName;
}
