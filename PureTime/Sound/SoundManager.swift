import AVFoundation
import Foundation
import MediaPlayer

protocol SoundManagerDelegate: AnyObject {
    func didTapPlay()
    func didTapPause()
}

protocol SoundManagerProtocol: AnyObject {
    func play()
    func start()
}

class SoundManager: NSObject, SoundManagerProtocol {
    weak var delegate: SoundManagerDelegate?
    
    lazy var player: AVAudioPlayer! = {
        let url = Bundle.main.url(forResource: "bell", withExtension: "mp3")!
        return try! AVAudioPlayer(contentsOf: url)
    }()

    lazy var silentPlayer: AVAudioPlayer! = {
        let url = Bundle.main.url(forResource: "silence", withExtension: "mp3")!
        var player = try! AVAudioPlayer(contentsOf: url)
        player.delegate = self
        player.numberOfLoops = -1 // Infinite loop
        return player
    }()

    init(delegate: SoundManagerDelegate) {
        super.init()
        configureRemoteTransportControls()
        setupAudioSession()
        self.delegate = delegate
    }
    
    func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session for background playback: \(error)")
        }
    }
    
    private func configureRemoteTransportControls() {
        UIApplication.shared.beginReceivingRemoteControlEvents()
        let commandCenter = MPRemoteCommandCenter.shared()

        commandCenter.playCommand.addTarget { [unowned self] _ in
            delegate?.didTapPlay()
            return .success
        }

        commandCenter.pauseCommand.addTarget { [unowned self] _ in
            delegate?.didTapPause()
            return .success
        }
    }
    
    internal func play() {
        player.play()
    }
    internal func start() {
        silentPlayer.play()
    }
}

extension SoundManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully _: Bool) {
        if player == silentPlayer {
            silentPlayer.play()
        }
    }
}
