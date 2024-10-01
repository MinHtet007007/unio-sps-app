const INITIAL_PHASE = 'Initial Phase';
const CONTINUOUS_PHASE = 'Continuation Phase';

const INITIAL_REGIMEN = 'Initial Regimen';
const RETREATMENT_REGIMEN = 'Retreatment Regimen';
const CHILDHOOD_REGIMEN = 'Childhood Regimen';
const MODIFIED_REGIMEN = 'Modified Regimen';
String getCounselingPhase(String dotsStartDate, String treatmentRegimen) {
  DateTime now = DateTime.now();
  DateTime formattedDotsStartDate = DateTime.parse(dotsStartDate);
  if (treatmentRegimen == RETREATMENT_REGIMEN) {
    if (now.isBefore(formattedDotsStartDate.add(const Duration(days: 84)))) {
      return INITIAL_PHASE;
    }
    return CONTINUOUS_PHASE;
  }
  if (now.isBefore(formattedDotsStartDate.add(const Duration(days: 56)))) {
    return INITIAL_PHASE;
  }
  return CONTINUOUS_PHASE;
}
