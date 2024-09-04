import SwiftUI
import WatchKit

struct ContentView: View {
    @State private var isVibrating = false
    @State private var heartRate: Double = 65
    @State private var timer: Timer?
    enum HapticTypes: String, CaseIterable, Identifiable {
           case notification, success, failure, retry, start, stop, click, directionUp, directionDown
           var id: Self { self }

           func toWKHapticType() -> WKHapticType {
               switch self {
               case .notification:
                   return .notification
               case .success:
                   return .success
               case .failure:
                   return .failure
               case .retry:
                   return .retry
               case .start:
                   return .start
               case .stop:
                   return .stop
               case .click:
                   return .click
               case .directionUp:
                   return .directionUp
               case .directionDown:
                   return .directionDown
               }
           }
       }
//    let hapticTypes: [WKHapticType] = [.notification, .directionUp, .directionDown, .success, .failure, .retry, .start, .stop, .click]
    @State private var selectedHaptic: HapticTypes  = .click
    
    var body: some View {
        VStack {
            Text("Heart Rate: \(heartRate) bpm")
                .font(.system(.headline, design: .rounded))
           
            Slider(value: $heartRate, in: 50...120, step: 1).frame(height: 40)
            
            Picker("Haptic Type", selection: $selectedHaptic) {
                    ForEach(HapticTypes.allCases) { hapticType in
                        Text(hapticType.rawValue.capitalized)
                            .tag(hapticType)
                }
            }
            .pickerStyle(.wheel)
            
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
    }
    
    private func startVibration() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0 / (Double(heartRate) * 1.3 / 60.0), repeats: true) { _ in
            WKInterfaceDevice.current().play(selectedHaptic.toWKHapticType())
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
