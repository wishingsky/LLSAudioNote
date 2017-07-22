//
//  LLSRecorderViewController.swift
//  LLSAudioNote
//
//  Created by weixiaoyun on 2017/7/22.
//  Copyright © 2017年 com.hujiang. All rights reserved.
//

import UIKit
import AVFoundation

class LLSRecorderViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    var viewModel: LLSRecorderViewModel = LLSRecorderViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playButton.alpha = 0.0
        bindViewModel()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func bindViewModel() {
        viewModel.updateMeter = { [weak self] timeString in
            self?.timeLabel.text = timeString
        }
        
        viewModel.showPlayButton = { [weak self] show in
            self?.showPlayButton(show: show)
        }
        
        viewModel.updatePlayButtonStatus = { [weak self] status in
           self?.updatePlayButton(status: status)
        }
    }
    
    @IBAction func touchDownRecordButton(_ sender: Any) {
        viewModel.beginRecord()
    }

    @IBAction func touchUpRecordButton(_ sender: Any) {
        viewModel.stopRecord()
    }
    
    @IBAction func tapPlayButton(_ sender: Any) {
        viewModel.playAudio()
    }
    
    /**
     *  显示播放按钮
     *
     *  @param show 显示或隐藏
     *
     */
    private func showPlayButton(show: Bool) {
        if show {
            UIView.animate(withDuration: 0.3, animations: {
                self.playButton.alpha = 1.0
                self.updatePlayButton(status: .stop)
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.playButton.alpha = 0.0
            })
        }
    }
    
    /**
     *  更新播放按钮状态
     *
     *  @param status 播放状态
     *
     */
    private func updatePlayButton(status: PlayStatus) {
        switch status {
        case .play:
            playButton.setTitle("停止播放", for: .normal)
        case .stop:
            playButton.setTitle("开始播放", for: .normal)
        }
    }
}


