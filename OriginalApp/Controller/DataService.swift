//
//  Service.swift
//  OriginalApp
//
//  Created by 坪井衛三 on 2019/09/15.
//  Copyright © 2019 Eizo Tsuboi. All rights reserved.
//

import Foundation
import Firebase

class DataService{
    var postArray:[PostData] = []
    let db = Firestore.firestore()
    
    func loadPostData() -> [PostData]{
        
        let ref = db.collection(Const.PostPath)
        ref.addSnapshotListener { querySnapshot, err in
            if let err = err {
                print("Error fetching documents: \(err)")
            } else {
                self.postArray = []
                for document in querySnapshot!.documents {
                    //querySnapshotをPostDataオブジェクトに
                    let postData = PostData(snapshot: document)
                    self.postArray.insert(postData, at: 0)
                    print("確認1:\(self.postArray)")
                }
            }
        }
        print("確認2:\(self.postArray)")
        return self.postArray
    }
                
//        var ref = db.collection(Const.PostPath).getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                for document in querySnapshot!.documents {
//                    print("\(document.documentID) => \(document.data())")
//                }
//            }
//        }
//    }
//
}
