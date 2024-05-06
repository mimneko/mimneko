import processing.sound.*;
import java.util.HashSet;

AudioSample sample;
Instrument instrumentInstance;
HashMap<Character, Integer> keyToNum = new HashMap<>();  // キーと音高
HashSet<Character> pressedKeys = new HashSet<>(); // 押されているキー

// 56(G#3) ~ 75(D#5)
final float[] frequencies = {
  207.65, 220.00, 233.08, 246.94, 261.63, 
  277.18, 293.66, 311.13, 329.63, 349.23, 
  369.99, 392.00, 415.30, 440.00, 466.16, 
  493.88, 523.25, 554.37, 587.33, 622.25
};
final int FS = 16000;
final int AMPLITUDE = 70;
int waveOffset = 0;
float velocity = 1f;
float[] signal;


void setup() {
  // 基本設定
  size(800, 200);
  surface.setIcon(loadImage(sketchPath("icon.png")));
  strokeWeight(1);
  instrumentInstance = new SinewaveInstrument();

  // キーと音高の対応
  keyToNum.put('a', 0);  // G#3
  keyToNum.put('z', 1);  // A3
  keyToNum.put('s', 2);  // A#3
  keyToNum.put('x', 3);  // B3
  keyToNum.put('c', 4);  // C4
  keyToNum.put('f', 5);  // C#4
  keyToNum.put('v', 6);  // D4
  keyToNum.put('g', 7);  // D#4
  keyToNum.put('b', 8);  // E4
  keyToNum.put('n', 9);  // F4
  keyToNum.put('j', 10); // F#4
  keyToNum.put('m', 11); // G4
  keyToNum.put('k', 12); // G#4
  keyToNum.put(',', 13); // A4
  keyToNum.put('l', 14); // A#4
  keyToNum.put('.', 15); // B4
  keyToNum.put('/', 16); // C5
  keyToNum.put(':', 17); // C#5
  keyToNum.put('_', 18); // D5
  keyToNum.put('\\',18); // D5
  keyToNum.put(']', 19); // D#5  
}

void keyPressed() {

  // 音色の切り替え
  switch (key) {
    case '1':
      instrumentInstance = new SinewaveInstrument();
      break;
    case '2':
      instrumentInstance = new SquarewaveInstrument();
      break;
    case '3':
      instrumentInstance = new SawtoothInstrument();
      break;
  }
  
  // 無関係のキーならスキップ
  if (!keyToNum.containsKey(key)) return;
  
  // 押されたキーをセットに追加
  pressedKeys.add(key);

  // 再生
  playSound();
}

void keyReleased() {  
  // 離されたキーをセットから削除
  pressedKeys.remove(key);
  
  // 再生・停止
  if (pressedKeys.isEmpty()) stopSound();
  else playSound();
  
}

void playSound() {
  // 押されているキーに対応する音高のリスト
  ArrayList<Integer> notes = new ArrayList<>();
  
  // キー判定
  for (char k : pressedKeys) {
    if (keyToNum.containsKey(k)) {
      notes.add(keyToNum.get(k));
    }
  }
  
  // 信号作成
  signal = instrumentInstance.generateSample(notes);
  
  // 停止
  stopSound();
  
  // 音作成
  if (signal != null){
    sample = new AudioSample(this, signal, FS);
    sample.play();
  }
  
}

void stopSound(){
  // 前の音を停止
  if (sample != null) {
    sample.stop();
  }
}

void draw() {
  background(255);
  
  if (signal == null || pressedKeys.isEmpty()) {
    // 横一線
    line(0, height/2, width, height/2);
    
  } else {
    // 波形を表示
    for (int n = 0; n < width-1; n++) {
      // 位置調整
      float idx = (n + waveOffset) % signal.length;
      float y1 = map(signal[(int)(idx + 0) % signal.length], 
                 -velocity, velocity, 
                 height/2-AMPLITUDE, height/2+AMPLITUDE);
      float y2 = map(signal[(int)(idx + 1) % signal.length], 
                 -velocity, velocity, 
                 height/2-AMPLITUDE, height/2+AMPLITUDE);

      // 波形を描画
      line(width-n, y1, width-n-1, y2);
    }
    
    // 進む
    waveOffset++;
    waveOffset %= signal.length;  
  }
}
