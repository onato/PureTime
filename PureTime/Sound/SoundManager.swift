import AVFoundation
import Foundation
import MediaPlayer

protocol SoundManagerProtocol: AnyObject {
    func didTapPlay()
    func didTapPause()
}

class SoundManager: NSObject {
    weak var delegate: SoundManagerProtocol?
    
    lazy var player: AVAudioPlayer? = {
        let url = Bundle.main.url(forResource: "bell", withExtension: "mp3")!
        return try? AVAudioPlayer(contentsOf: url)
    }()

    lazy var silentPlayer: AVAudioPlayer? = {
        let url = Bundle.main.url(forResource: "silence", withExtension: "mp3")!
        var player = try? AVAudioPlayer(contentsOf: url)
        player?.delegate = self
        player?.numberOfLoops = -1 // Infinite loop
        return player
    }()

    override init() {
        super.init()
        configureRemoteTransportControls()
        setupAudioSession()
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
    
    private func playSound() {
        player!.play()
    }
}

extension SoundManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully _: Bool) {
        if player == silentPlayer {
            silentPlayer?.play()
        }
    }
}
