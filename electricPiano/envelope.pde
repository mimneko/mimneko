float[] ADSR(int FS, float inputA, float inputD, float inputS, float inputR, float inputGate, float inputDuration) {
  int A = (int)(FS * inputA);
  int D = (int)(FS * inputD);
  int S = (int)(FS * inputS);
  int R = (int)(FS * inputR);
  int gate = (int)(FS * inputGate);
  int duration = (int)(FS * inputDuration);
  float[] e = new float[duration];
  
  if (A != 0) {
    for (int n = 0; n < A; n++) {
      e[n] = (1 - exp(-5 * n / A)) / (1 - exp(-5));
    }
  }
  
  if (D != 0) {
    for (int n = A; n < gate; n++) {
      e[n] = 1 + (S - 1) * (1 - exp(-5 * (n - A) / D));
    }
  } else {
    for (int n = A; n < gate; n++) {
      e[n] = S;
    }
  }
  
  if (R != 0) {
    for (int n = gate; n < duration; n++) {
      e[n] = e[gate - 1] - e[gate - 1] * (1 - exp(-5 * (n - gate + 1) / R));
    }
  }
  
  return e;
}
