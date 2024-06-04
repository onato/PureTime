@testable import PureTime
import MediaPlayer
import XCTest
import Nimble

final class TimerTests: XCTestCase {
    func test_whenReachingInterval_shouldPlaySound() throws {
        let sut = TimerViewModel()
        let soundManager = SoundManagerProtocolMock()
        sut.soundManager = soundManager
        
        sut.selectedNumber = 5 // 5 minutes = 5*60 seconds
        sut.elapsedTime = 299
        sut.updateTimer()
        
        expect(soundManager.playCalled) == true
    }
    
    func test_whenStartingTheTimer_shouldStartTheSoundManager() throws {
        let sut = TimerViewModel()
        let soundManager = SoundManagerProtocolMock()
        sut.soundManager = soundManager
        
        sut.startTimer()
        
        expect(soundManager.startCalled) == true
    }

    
    func test_whenRunning_shouldUpdateNowPlayingInfo() {
        let sut = TimerViewModel()
        let soundManager = SoundManagerProtocolMock()
        sut.soundManager = soundManager
        
        sut.startTimer()
        sut.selectedNumber = 5 // 5 minutes = 5*60 seconds
        sut.elapsedTime = 300
        
        expect(MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] as? Int).toEventually(equal(3), timeout: .seconds(5))
        let nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo!
        expect(nowPlayingInfo[MPMediaItemPropertyArtist] as? String) == "Ringing every 5 minutes"
    }
}
