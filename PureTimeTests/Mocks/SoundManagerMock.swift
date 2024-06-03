import Foundation
@testable import PureTime

final class SoundManagerProtocolMock: SoundManagerProtocol {
    
   // MARK: - play

    var playCallsCount = 0
    var playCalled: Bool {
        playCallsCount > 0
    }
    var playClosure: (() -> Void)?

    func play() {
        playCallsCount += 1
        playClosure?()
    }
}
