@testable import PureTime
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
}
