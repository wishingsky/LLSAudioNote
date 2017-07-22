//
//  LLSAudioListViewModel.swift
//  LLSAudioNote
//
//  Created by weixiaoyun on 2017/7/22.
//  Copyright © 2017年 com.hujiang. All rights reserved.
//

import UIKit
import AVFoundation

class LLSAudioListViewModel: NSObject {
    var audioArray = [LLSAudio]()
    var playStatusArray = [PlayStatus]()
    
    var player:AVAudioPlayer!
    
    var reload: (() -> Void)?
    
    override init() {
        super.init()
        if let audioList = LLSDataManager.shared.read() {
            audioArray = audioList
        }
        initPlayStatusArray()
    }
    
    /**
     *  初始化播放状态
     *
     */
    func initPlayStatusArray() {
        for _ in audioArray {
            playStatusArray.append(.stop)
        }
    }
    
    /**
     *  播放音频
     *
     *  @param index 第几个音频
     *
     */
    func play(_ index: Int) {
        guard let url = audioArray[index].url else { return }
        do {
            self.player = try AVAudioPlayer(contentsOf: URL(string: url)!)
            player.prepareToPlay()
            player.delegate = self
            player.volume = 1.0
            player.play()
            updateStatus(index: index)
        } catch {
            self.player = nil
            print(error.localizedDescription)
        }
    }
    
    /**
     *  更新播放状态
     *
     *  @param index 第几个音频
     *
     */
    func updateStatus(index: Int) {
        var status = playStatusArray[index]
        if status == .play {
            status = .stop
        } else {
            status = .play
        }
        playStatusArray.removeAll()
        for (i, _) in audioArray.enumerated() {
            if i == index {
                playStatusArray.append(status)
            } else {
                playStatusArray.append(.stop)
            }
        }
    }
    
    /**
     *  重置播放状态
     *
     */
    func resetStatus() {
        playStatusArray.removeAll()
        initPlayStatusArray()
    }
}

// MARK: --- AVAudioPlayerDelegate

extension LLSAudioListViewModel : AVAudioPlayerDelegate {
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("finished playing \(flag)")
        resetStatus()
        reload?()
    }
    
    public func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let e = error {
            print("\(e.localizedDescription)")
        }
    }
}

