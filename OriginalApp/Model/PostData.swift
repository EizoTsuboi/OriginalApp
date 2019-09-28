//
//  PostData.swift
//  OriginalApp
//
//  Created by 坪井衛三 on 2019/09/11.
//  Copyright © 2019 Eizo Tsuboi. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class PostData: NSObject {
//    var id: String?
    var image: [UIImage] = []
    var imageString: [String] = []
    var title: String?
    var caption: String?
    var date: Date?
    var point: GeoPoint?
//    var likes: [String] = []
//    var isLiked: Bool = false
//    var comments: [String] = []
//    var commentNames: [String] = []
    
    init(snapshot: QueryDocumentSnapshot) {
        
        let valueDictionary = snapshot.data()
        self.image = []
        
        
        if let imageArray = valueDictionary["image"]{
            let iA = imageArray as! [String]
        
            for iStr  in iA{
                self.imageString.insert(iStr, at: 0)
                self.image.insert(UIImage(data: Data(base64Encoded: iStr, options: .ignoreUnknownCharacters)!)!, at: 0)
            }
       
        
        }
        
        
        if let time = valueDictionary["time"] as? String{
            self.date = Date(timeIntervalSinceReferenceDate: TimeInterval(time)!)
        }
        self.title = valueDictionary["title"] as? String
        self.caption = valueDictionary["caption"] as? String
        self.point = valueDictionary["point"] as? GeoPoint
        
    }
}

