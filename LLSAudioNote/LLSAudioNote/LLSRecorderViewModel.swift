//
//  LLSRecorderViewModel.swift
//  LLSAudioNote
//
//  Created by weixiaoyun on 2017/7/22.
//  Copyright © 2017年 com.hujiang. All rights reserved.
//

import UIKit
import AVFoundation

public enum PlayStatus {
    case play
    case stop
}

public class LLSRecorderViewModel: NSObject {
    fileprivate var recorder: AVAudioRecorder?
    fileprivate var player:AVAudioPlayer?
    fileprivate var meterTimer:Timer?
    fileprivate var audioFileURL:URL!
    
    private var format = DateFormatter()
    
    public var updateMeter: ((String) -> Void)?
    public var showPlayButton: ((Bool) -> Void)?
    public var updatePlayButtonStatus: ((PlayStatus) -> Void)?
    
    override public init() {
        super.init()
        format.dateFormat="yyyy-MM-dd HH:mm:ss"
    }
    
    deinit {
        recorder = nil
        player = nil
    }
    
    // MARK: ---- Public-----------
    
    /**
     *  开始录制
     *
     */
    public func beginRecord() {
        if let player = player, player.isPlaying {
            player.stop()
        }
        showPlayButton?(false)
        
        guard let recorder = recorder else {
            record(true)
            return
        }
        
        if recorder.isRecording {
            recorder.pause()
        } else {
            print("recording")
            record(false)
        }
    }
    
    /**
     *  停止录制
     *
     */
    public func stopRecord() {
        recorder?.stop()
        meterTimer?.invalidate()
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(false)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /**
     *  播放音频
     *
     */
    public func playAudio() {
        if let player = player, player.isPlaying {
            player.stop()
            updatePlayButtonStatus?(.stop)
            return
        }
        var url: URL = audioFileURL
        if let recorder = recorder {
            url = recorder.url
        }
        print("playing \(String(describing: url))")
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.delegate = self
            player?.prepareToPlay()
            player?.volume = 1.0
            player?.play()
            updatePlayButtonStatus?(.play)
        } catch {
            player = nil
            print(error.localizedDescription)
        }
    }

    // MARK: -------Private--------
    
    
    /**
     *  初始化录音器
     *
     */
    private func setupRecorder() {
        let currentFileName = "\(format.string(from: Date())).m4a"
        print(currentFileName)
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        self.audioFileURL = documentsDirectory.appendingPathComponent(currentFileName)
        if FileManager.default.fileExists(atPath: audioFileURL.absoluteString) {
            print("audiofile \(audioFileURL.absoluteString) exists")
        }
        
        let recordSettings:[String : Any] = [
            AVFormatIDKey:             kAudioFormatAppleLossless,
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
            AVEncoderBitRateKey :      32000,
            AVNumberOfChannelsKey:     2,
            AVSampleRateKey :          44100.0
        ]
        
        do {
            recorder = try AVAudioRecorder(url: audioFileURL, settings: recordSettings)
            recorder?.delegate = self
            recorder?.isMeteringEnabled = true
            recorder?.prepareToRecord()
        } catch {
            recorder = nil
            print(error.localizedDescription)
        }
    }
    
    /**
     *  请求麦克风权限，判断是否可以进行录制
     *
     *  @return 是否需有权限录制
     *
     */
    private func canRecord() -> Bool {
        var bCanRecord = false
        AVAudioSession.sharedInstance().requestRecordPermission() { granted in
            bCanRecord = granted
        }
        return bCanRecord
    }
    
    /**
     *  录制
     *
     *  @param setup 是否需要创建录音器
     *
     */
    private func record(_ setup:Bool) {
        if canRecord() {
            DispatchQueue.main.async {
                print("Permission to record granted")
                self.setSessionPlayAndRecord()
                if setup {
                    self.setupRecorder()
                }
                self.recorder?.record()
                self.meterTimer = Timer.scheduledTimer(timeInterval: 0.1,
                                                       target:self,
                                                       selector:#selector(LLSRecorderViewModel.updateRecorderMeter(_:)),
                                                       userInfo:nil,
                                                       repeats:true)
            }
        }
    }
    
    /**
     *  配置音频会话并激活
     *
     */
    private func setSessionPlayAndRecord() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
        } catch {
            print("could not set session category")
            print(error.localizedDescription)
        }
        
        do {
            try session.setActive(true)
        } catch {
            print("could not make session active")
            print(error.localizedDescription)
        }
    }
    
    /**
     *  刷新录音时间
     *
     */
    @objc private func updateRecorderMeter(_ timer:Timer) {
        if let recorder = recorder, recorder.isRecording{
            let min = Int(recorder.currentTime / 60)
            let sec = Int(recorder.currentTime.truncatingRemainder(dividingBy: 60))
            let timeSting = String(format: "%02d:%02d", min, sec)
            updateMeter?(timeSting)
            recorder.updateMeters()
        }
    }
}

// MARK:  --- AVAudioRecorderDelegate

extension LLSRecorderViewModel : AVAudioRecorderDelegate {
    public func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder,
                                         successfully flag: Bool) {
        print("finished recording \(flag)")
        let name = audioFileURL.lastPathComponent
        LLSDataManager.shared.save(name: name, url: audioFileURL.absoluteString)
        self.showPlayButton?(true)
        self.recorder = nil
    }
    
    public func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder,
                                          error: Error?) {
        if let e = error {
            print("\(e.localizedDescription)")
        }
    }
}

// MARK: --- AVAudioPlayerDelegate

extension LLSRecorderViewModel : AVAudioPlayerDelegate {
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("finished playing \(flag)")
    }
    
    public func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let e = error {
            print("\(e.localizedDescription)")
        }
    }
}

