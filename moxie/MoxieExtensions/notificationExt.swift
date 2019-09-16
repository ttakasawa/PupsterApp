//
//  notificationExt.swift
//  moxie
//
//  Created by Tomoki Takasawa on 7/25/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//


import Foundation
import UserNotifications
import UIKit

extension UNNotificationAttachment {
    
    static func create(identifier: String, image: UIImage, options: [NSObject : AnyObject]?) -> UNNotificationAttachment? {
        let fileManager = FileManager.default
        let tmpSubFolderName = ProcessInfo.processInfo.globallyUniqueString
        let tmpSubFolderURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(tmpSubFolderName, isDirectory: true)
        do {
            try fileManager.createDirectory(at: tmpSubFolderURL, withIntermediateDirectories: true, attributes: nil)
            let imageFileIdentifier = identifier+".png"
            let fileURL = tmpSubFolderURL.appendingPathComponent(imageFileIdentifier)
            guard let imageData = UIImagePNGRepresentation(image) else {
                return nil
            }
            try imageData.write(to: fileURL)
            let imageAttachment = try UNNotificationAttachment.init(identifier: imageFileIdentifier, url: fileURL, options: options)
            return imageAttachment
        } catch {
            print("error " + error.localizedDescription)
        }
        return nil
    }
}
