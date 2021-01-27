List<String> noiseLevels = [
  'No sound',
  'Breathing',
  'Whispers',
  'Low voice conversation',
  'Library',
  'Moderate rain',
  'Normal conversation',
  'Busy street',
  'Factory noise',
  'Chainsaw'
];

String noiseLabel(int dB) {
  if (dB >= 0 && dB <= 10) {
    return noiseLevels[0];
  } else if (dB > 10 && dB <= 20) {
    return noiseLevels[1];
  } else if (dB > 20 && dB <= 30) {
    return noiseLevels[2];
  } else if (dB > 30 && dB <= 40) {
    return noiseLevels[3];
  } else if (dB > 40 && dB <= 50) {
    return noiseLevels[4];
  } else if (dB > 50 && dB <= 60) {
    return noiseLevels[5];
  } else if (dB > 60 && dB <= 70) {
    return noiseLevels[6];
  } else if (dB > 70 && dB <= 80) {
    return noiseLevels[7];
  } else if (dB > 80 && dB <= 90) {
    return noiseLevels[8];
  } else if (dB > 90 && dB <= 100) {
    return noiseLevels[9];
  } else
    return 'Very very loud';
}
