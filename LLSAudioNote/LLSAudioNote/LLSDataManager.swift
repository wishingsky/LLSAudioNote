//
//  LLSDataManager.swift
//  LLSAudioNote
//
//  Created by weixiaoyun on 2017/7/22.
//  Copyright © 2017年 com.hujiang. All rights reserved.
//

import UIKit
import CoreData

class LLSDataManager {
    static let shared = LLSDataManager()
    
    let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let myEntityName = "LLSAudio"
    
    /**
     *  保存音频记录
     *
     *  @param name 音频名字
     *  @param url  音频地址
     */
    func save(name: String, url: String) {
        let audio =
            NSEntityDescription.insertNewObject(
                forEntityName: myEntityName, into: moc)
                as! LLSAudio
        
        audio.name = name
        audio.url = url
        
        do {
            try moc.save()
        } catch {
            fatalError("\(error)")
        }
    }
    
    /**
     *  读取所有音频记录
     *
     *  @return 音频记录
     */
    func read() -> [LLSAudio]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: myEntityName)
        do {
            let results =
                try moc.fetch(request) as! [LLSAudio]
            return results
        } catch {
            fatalError("\(error)")
        }
        return nil
    }
}
