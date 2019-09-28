//
//  MapViewController.swift
//  OriginalApp
//
//  Created by 坪井衛三 on 2019/09/10.
//  Copyright © 2019 Eizo Tsuboi. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase

class MapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    var postArray:[PostData] = []
    var markers: [GMSMarker] = []
    let dataService = DataService()
    let db = Firestore.firestore()
    var mapView:GMSMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.camera(withLatitude: 34.806651, longitude: 135.493011, zoom: 15.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
       
        self.view = mapView
        mapView?.delegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //データベースからデータを受け取る
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
                    self.makeMarker(post: postData)
                    
                }
            }
        }
    }
    
    //データベースから受け取ったデータの位置情報をマーカー設置
    func makeMarker(post: PostData) -> [GMSMarker] {
        let marker = GMSMarker()
        let point = post.point
        if point == nil{
            return [marker]
        }else{
            let latitude = point!.latitude
            let longitude = point!.longitude
            
            marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            marker.title = "\(post.title!)"
            marker.tracksInfoWindowChanges = true //情報ウィンドウを自動的に更新するように設定する
            marker.appearAnimation = GMSMarkerAnimation.pop //マーカーの表示にアニメーションをつける
            mapView!.selectedMarker = marker //デフォルトで情報ウィンドウを表示
            marker.map = self.mapView!
            
            markers = [marker]
            
            return markers
        }
        
    }
    
    
}
