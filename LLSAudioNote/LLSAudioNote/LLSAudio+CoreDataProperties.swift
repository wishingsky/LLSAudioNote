//
//  LLSAudio+CoreDataProperties.swift
//  LLSAudioNote
//
//  Created by weixiaoyun on 2017/7/22.
//  Copyright © 2017年 com.hujiang. All rights reserved.
//

import Foundation
import CoreData


extension LLSAudio {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LLSAudio> {
        return NSFetchRequest<LLSAudio>(entityName: "LLSAudio")
    }

    @NSManaged public var name: String?
    @NSManaged public var url: String?

}
