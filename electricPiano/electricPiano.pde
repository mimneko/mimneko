import ddf.minim.*;

Minim minim; 
AudioSample sample;


void draw() {
}

final int FS = 16000;

void setup(){
  size(100, 100);
  background(255);
  minim = new Minim(this);
  sample = minim.loadSample("sin440.wav");
  
  int noteNumber = 72;
  int gate = 4;
  
  float f0 = 440 * pow(2, float(noteNumber - 69)/12.0);
  float[] signal = electric_piano(f0, gate);

  sample = minim.createSample(signal, sample.getFormat());
  sample.trigger();
  fill(0);
  textAlign(CENTER, CENTER);
  textSize(90);
  text(noteNumber,width/2,height/2);
}

float[] electric_piano(float f0, int gate){
  int duration = gate + 1;

  int length_of_s = FS * duration;
  float[] sa = new float[length_of_s];
  float[] sb = new float[length_of_s];
  float[] s = new float[length_of_s];

  float[] VCO_A = {0, 0, 0, 0};
  float[] VCO_D = {0, 0, 0, 0};
  float[] VCO_S = {1, 1, 1, 1};
  float[] VCO_R = {0, 0, 0, 0};
  int[] VCO_gate = {duration, duration, duration, duration};
  int[] VCO_duration = {duration, duration, duration, duration};
  float[] VCO_ofFSet = {14 * f0, 1 * f0, 1 * f0, 1 * f0};
  float[] VCO_depth = {0, 0, 0, 0};

  float[] VCA_A = {0, 0, 0, 0};
  float[] VCA_D = {1, 1, 2, 4};
  float[] VCA_S = {0, 0, 0, 0};
  float[] VCA_R = {1, 0.1, 2, 0.1};
  int[] VCA_gate = {gate, gate, gate, gate};
  int[] VCA_duration = {duration, duration, duration, duration};
  float[] VCA_ofFSet = {0, 0, 0, 0};
  float[] VCA_depth = {1, 1, 1, 1};

  // A part
  float[] vco_m = ADSR(FS, VCO_A[0], VCO_D[0], VCO_S[0], VCO_R[0], VCO_gate[0], VCO_duration[0]);
  for (int n = 0; n < length_of_s; n++) {
    vco_m[n] = VCO_ofFSet[0] + vco_m[n] * VCO_depth[0];
  }

  float[] vca_m = ADSR(FS, VCA_A[0], VCA_D[0], VCA_S[0], VCA_R[0], VCA_gate[0], VCA_duration[0]);
  for (int n = 0; n < length_of_s; n++) {
    vca_m[n] = VCA_ofFSet[0] + vca_m[n] * VCA_depth[0];
  }

  float[] vco_c = ADSR(FS, VCO_A[1], VCO_D[1], VCO_S[1], VCO_R[1], VCO_gate[1], VCO_duration[1]);
  for (int n = 0; n < length_of_s; n++) {
    vco_c[n] = VCO_ofFSet[1] + vco_c[n] * VCO_depth[1];
  }

  float[] vca_c = ADSR(FS, VCA_A[1], VCA_D[1], VCA_S[1], VCA_R[1], VCA_gate[1], VCA_duration[1]);
  for (int n = 0; n < length_of_s; n++) {
    vca_c[n] = VCA_ofFSet[1] + vca_c[n] * VCA_depth[1];
  }

  float xm = 0;
  float xc = 0;
  for (int n = 0; n < length_of_s; n++) {
    sa[n] = vca_c[n] * sin(2 * PI * xc + vca_m[n] * sin(2 * PI * xm));
    float delta_m = vco_m[n] / FS;
    xm += delta_m;
    if (xm >= 1) {
      xm -= 1;
    }

    float delta_c = vco_c[n] / FS;
    xc += delta_c;
    if (xc >= 1) {
      xc -= 1;
    }
  }

  // B part
  vco_m = ADSR(FS, VCO_A[2], VCO_D[2], VCO_S[2], VCO_R[2], VCO_gate[2], VCO_duration[2]);
  for (int n = 0; n < length_of_s; n++) {
    vco_m[n] = VCO_ofFSet[2] + vco_m[n] * VCO_depth[2];
  }

  vca_m = ADSR(FS, VCA_A[2], VCA_D[2], VCA_S[2], VCA_R[2], VCA_gate[2], VCA_duration[2]);
  for (int n = 0; n < length_of_s; n++) {
    vca_m[n] = VCA_ofFSet[2] + vca_m[n] * VCA_depth[2];
  }

  vco_c = ADSR(FS, VCO_A[3], VCO_D[3], VCO_S[3], VCO_R[3], VCO_gate[3], VCO_duration[3]);
  for (int n = 0; n < length_of_s; n++) {
    vco_c[n] = VCO_ofFSet[3] + vco_c[n] * VCO_depth[3];
  }

  vca_c = ADSR(FS, VCA_A[3], VCA_D[3], VCA_S[3], VCA_R[3], VCA_gate[3], VCA_duration[3]);
  for (int n = 0; n < length_of_s; n++) {
    vca_c[n] = VCA_ofFSet[3] + vca_c[n] * VCA_depth[3];
  }

  xm = 0;
  xc = 0;
  for (int n = 0; n < length_of_s; n++) {
    sb[n] = vca_c[n] * sin(2 * PI * xc + vca_m[n] * sin(2 * PI * xm));
    float delta_m = vco_m[n] / FS;
    xm += delta_m;
    if (xm >= 1) {
      xm -= 1;
    }

    float delta_c = vco_c[n] / FS;
    xc += delta_c;
    if (xc >= 1) {
      xc -= 1;
    }
  }

  for (int i = 0; i < length_of_s; i++) {
    s[i] = sa[i] * 0.5 + sb[i] * 0.5;
  }
  
  // 最大値
  float maxAbsValue = abs(s[0]);
  for (int i = 1; i < s.length; i++) {
    float absValue = abs(s[i]);
    if (maxAbsValue < absValue) {
      maxAbsValue = absValue;
    }
  }

  for (int i = 0; i < length_of_s; i++) {
    s[i] *= 1.0 / maxAbsValue;
  }
  
  int length_of_s_master = length_of_s + FS * 3;
  
  int ofFSet = FS * 1;
  float[] s_master = new float[length_of_s_master];

  System.arraycopy(s, 0, s_master, ofFSet, length_of_s);
  
  return s_master;
}
