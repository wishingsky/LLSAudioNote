//
//  LLSAudioListViewController.swift
//  LLSAudioNote
//
//  Created by weixiaoyun on 2017/7/22.
//  Copyright © 2017年 com.hujiang. All rights reserved.
//

import UIKit

private let kLLSAudioListCellIdentifier = "LLSAudioListCell"
private let kHeightOfCell: CGFloat = 60.0

class LLSAudioListViewController: UITableViewController {

    var viewModel = LLSAudioListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.reload = { [weak self] in
            self?.tableView.reloadData()
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.audioArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kHeightOfCell
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kLLSAudioListCellIdentifier, for: indexPath) as! LLSAudioListCell
        cell.bindAudio(audio: viewModel.audioArray[indexPath.row],
                       playStatus: viewModel.playStatusArray[indexPath.row],
                       index: indexPath.row)
        cell.triggerPlay = { [weak self] index in
            self?.viewModel.play(index)
            self?.tableView.reloadData()
        }
        return cell
    }
}
