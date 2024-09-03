import SwiftUI
import WatchKit

struct ContentView: View {
    @State private var isVibrating = false
    @State private var heartRate: Int = 65
    @State private var timer: Timer?
    
    var body: some View {
        VStack {
            Text("Heart Rate: \(heartRate) bpm")
                .font(.system(.headline, design: .rounded))
            
            Button(action: {
                isVibrating.toggle()
                if isVibrating {
                    startVibration()
                } else {
                    stopVibration()
                }
            }) {
                Text(isVibrating ? "Stop" : "Start")
                    .font(.system(.title2, design: .rounded))
                    .foregroundColor(isVibrating ? .red : .green)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .focusable()
        .digitalCrownRotation(
            detent: $heartRate,
            from: 50,
            through: 120,
            by: 1
        ) { _ in
            if isVibrating {
                stopVibration()
                startVibration()
            }
        }
    }
    
    private func startVibration() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0 / (Double(heartRate) * 1.3 / 60.0), repeats: true) { _ in
            WKInterfaceDevice.current().play(.click)
        }
    }
    
    private func stopVibration() {
        timer?.invalidate()
        timer = nil
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
