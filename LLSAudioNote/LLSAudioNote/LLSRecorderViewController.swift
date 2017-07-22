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
        
        viewModel.showPermissionAlert = { [weak self] in
            let alert = UIAlertController(title: "没有麦克风权限", message: "请去设置中找到该应用来打开麦克风权限", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .cancel, handler: nil))
            self?.present(alert, animated: true, completion: nil)
        }
        
        viewModel.showPlayButton = { [weak self] show in
            if show {
                UIView.animate(withDuration: 0.3, animations: {
                    self?.playButton.alpha = 1.0
                })
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self?.playButton.alpha = 0.0
                })
            }
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
}


