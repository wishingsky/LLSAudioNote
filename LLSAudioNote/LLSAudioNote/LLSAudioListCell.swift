//
//  LLSAudioListCell.swift
//  LLSAudioNote
//
//  Created by weixiaoyun on 2017/7/22.
//  Copyright © 2017年 com.hujiang. All rights reserved.
//

import UIKit

enum PlayStatus {
    case play
    case stop
}

class LLSAudioListCell: UITableViewCell {

    var nameLabel: UILabel!
    var playButton: UIButton!
    
    var playIndex: Int = 0
    
    var triggerPlay: ((Int) -> Void)?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nameLabel = UILabel(frame: CGRect(x: 20, y: 0, width: 230, height: 60))
        addSubview(nameLabel)
        playButton = UIButton(frame: CGRect(x: self.frame.width - 60, y: 10, width: 50, height: 40))
        playButton.setTitleColor(UIColor.blue, for: .normal)
        playButton.setTitle("play", for: .normal)
        addSubview(playButton)
        playButton.addTarget(self, action: #selector(LLSAudioListCell.playAudio), for: .touchUpInside)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindAudio(audio: LLSAudio, playStatus: PlayStatus, index: Int) {
        nameLabel.text = audio.name
        updatePlayButton(status: playStatus)
        playIndex = index
    }
    
    func playAudio() {
        triggerPlay?(playIndex)
    }
    
    func updatePlayButton(status: PlayStatus) {
        switch status {
        case .play:
            playButton.setTitle("stop", for: .normal)
        case .stop:
            playButton.setTitle("play", for: .normal)
        }
    }
}
