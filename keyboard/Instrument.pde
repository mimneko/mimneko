
interface Instrument {
  float[] generateSample(ArrayList<Integer> notes);
}

class SinewaveInstrument implements Instrument {
  SinewaveInstrument() {
    stroke(215, 0, 74);
    velocity = 1f;
    println("正弦波");
  }
  
  @Override
  public float[] generateSample(ArrayList<Integer> notes) {
    int numNotes = notes.size();
    float[] signal = new float[FS];
    
    // サンプルごとに音高の信号を合算
    for (int n = 0; n < signal.length; n++) {
      float sum = 0f;
      for (int note : notes) {
        sum += sin(TWO_PI * frequencies[note] * n / FS);
      }
      // 標準化
      signal[n] = sum / numNotes * velocity;
    }

    return signal;
  }
}

class SquarewaveInstrument implements Instrument {
  SquarewaveInstrument() {
    stroke(0, 98, 172);
    velocity = 0.55;
    println("矩形波");
  }
  
  @Override
  public float[] generateSample(ArrayList<Integer> notes) {
    int numNotes = notes.size();
    float[] signal = new float[FS];

    // サンプルごとに音高の信号を合算
    for (int n = 0; n < signal.length; n++) {
      float sum = 0f;
      for (int note : notes) {
        if (sin(TWO_PI * frequencies[note] * n / FS) >= 0) sum += 1;
        else sum -= 1;
      }
      // 標準化
      signal[n] = sum / numNotes * velocity;
    }

    return signal;
  }
}

class SawtoothInstrument implements Instrument {
  SawtoothInstrument() {
    stroke(0, 145, 64);
    velocity = 0.65;
    println("ノコギリ波");
  }
  
  @Override
  public float[] generateSample(ArrayList<Integer> notes) {
    int numNotes = notes.size();
    float[] signal = new float[FS];

    // サンプルごとに音高の信号を合算
    for (int n = 0; n < signal.length; n++) {
      float sum = 0f;
      for (int note : notes) {
        float tf = (float)n / FS*frequencies[note];
        sum += 2 * (tf - floor(tf + 0.5));
      }
      // 標準化
      signal[n] = sum / numNotes * velocity;
    }

    return signal;
  }
}
