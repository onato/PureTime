import AVFoundation
import Foundation
import MediaPlayer

class TimerViewModel: NSObject, ObservableObject {
    @Published var selectedNumber = 5
    @Published var isPlaying = false
    @Published var elapsedTime = 0
    
    lazy var soundManager: SoundManagerProtocol = {
        SoundManager(delegate: self)
    }()
    
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
        if isPlaying {
            stopTimer()
        } else {
            startTimer()
        }
    }
    
    func startTimer() {
        elapsedTime = 0
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateTimer()
        }
        soundManager.start()
        isPlaying = true
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
        isPlaying = false
    }
    
    internal func updateTimer() {
        elapsedTime += 1
        if elapsedTime % (selectedNumber*60) == 0 {
            soundManager.play()
        }
        updateNowPlayingInfo()
    }
    
    private func updateNowPlayingInfo() {
        guard isPlaying else {
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
            return
        }
        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = "Pure Time"
        nowPlayingInfo[MPMediaItemPropertyArtist] = "Ringing every \(selectedNumber) minutes"
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = selectedNumber * 60
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = elapsedTime % (selectedNumber*60)
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
}

extension TimerViewModel: SoundManagerDelegate {
    func didTapPlay() {
        startTimer()
    }
    
    func didTapPause() {
        stopTimer()
    }
}
