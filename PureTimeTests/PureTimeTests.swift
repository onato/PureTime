import XCTest
import Nimble
@testable import PureTime

final class PureTimeTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func test_whenStarting_shouldShowZero() throws {
        let sut = TimerViewModel()
        sut.elapsedTime = 0
        XCTAssertEqual(sut.formattedTime, "00:00")
    }
    
    func test_whenUnderHour_shouldShowMinutesAndSeconds() throws {
        let sut = TimerViewModel()
        sut.elapsedTime = 250
        XCTAssertEqual(sut.formattedTime, "04:10")
    }

    func test_whenOverHour_shouldShowMinutesAndSeconds() throws {
        let sut = TimerViewModel()
        sut.elapsedTime = 9250
        XCTAssertEqual(sut.formattedTime, "02:34:10")
    }
    
    func test_whenToggling_shouldUpdateState() {
        let sut = TimerViewModel()
        
        expect(sut.isPlaying) == false
        sut.togglePlay()
        expect(sut.isPlaying) == true
        expect(sut.timer?.isValid) == true
        sut.togglePlay()
        expect(sut.timer).to(beNil())
    }
}
