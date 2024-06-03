import AVFoundation
import Foundation
import MediaPlayer

class TimerViewModel: NSObject, ObservableObject {
    @Published var selectedNumber = 5
    @Published var isPlaying = false
    @Published var elapsedTime = 0
    
    var soundManager: SoundManagerProtocol = SoundManager()
    
    var timer: Timer?
    
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
    
    func startTimer() {
        elapsedTime = 0
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateTimer()
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    internal func updateTimer() {
        elapsedTime += 1
        if elapsedTime % (selectedNumber*60) == 0 {
            soundManager.play()
        }
        updateNowPlayingInfo()
    }
    
    private func updateNowPlayingInfo() {
        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = "Pure Time"
        nowPlayingInfo[MPMediaItemPropertyArtist] = "Ringing every \(selectedNumber) minutes"
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = selectedNumber * 60
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = elapsedTime % (selectedNumber*60)
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
}
