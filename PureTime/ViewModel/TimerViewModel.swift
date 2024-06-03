import AVFoundation
import Foundation
import MediaPlayer

class TimerViewModel: NSObject, ObservableObject {
    @Published var selectedNumber = 5
    @Published var isPlaying = false
    @Published var elapsedTime = 0
    
    var formattedTime: String {
        let hours = elapsedTime / 3600
        let minutes = (elapsedTime / 60) % 60
        let seconds = elapsedTime % 60
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
}

extension TimerViewModel {
    func togglePlay() {
        isPlaying.toggle()
    }
}
