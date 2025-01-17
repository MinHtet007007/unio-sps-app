String calculateBMIInText(double value) {
  if (value <= 0) return '';
  if (value <= 18.5) return '(Underweight)';
  if (value <= 24.5) return '(Healthy)';
  if (value <= 29.5) return '(Overweight)';
  if (value <= 39.5) return '(Obese)';
  return '(Extremely Obese)';
}
