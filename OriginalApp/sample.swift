//
//  File.swift
//  OriginalApp
//
//  Created by 坪井衛三 on 2019/09/20.
//  Copyright © 2019 Eizo Tsuboi. All rights reserved.
//

import Foundation
import GoogleMaps

class Map_ViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate{
    
    var mapManager: CLLocationManager = CLLocationManager()
    var latitude: CLLocationDegrees! = CLLocationDegrees()
    var longitude: CLLocationDegrees! = CLLocationDegrees()
    var gmaps: GMSMapView!
    var postArray: [PostData] = []
    var markers: [GMSMarker] = []
    var observing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapManager.delegate = self
        mapManager.requestWhenInUseAuthorization()
        mapManager.requestAlwaysAuthorization()
        mapManager.desiredAccuracy = kCLLocationAccuracyBest
        mapManager.distanceFilter = 1000
        mapManager.startUpdatingLocation()
        
        gmaps = GMSMapView(frame: CGRect(x:0, y:0, width:self.view.bounds.width, height:self.view.bounds.width))
        self.view.addSubview(gmaps)
        gmaps.isMyLocationEnabled = true
        gmaps.settings.compassButton = true
        
        self.view = gmaps
        gmaps.delegate = self
        
        if Auth.auth().currentUser != nil {
            if self.observing == false {
                
                let postsRef = Database.database().reference().child("messages")
                postsRef.observe(.childAdded, with: { snapshot in
                    
                    if let uid = Auth.auth().currentUser?.uid {
                        let postData = PostData(snapshot: snapshot, myId: uid)
                        self.postArray.insert(postData, at: 0)
                        self.makeMrker(postData: postData)
                    }
                })
            }
        }
    }
    
    func makeMrker(postData: PostData) -> [GMSMarker] {
        
        let marker = GMSMarker()
        let latitude = Double(postData.latitude!)
        let longitude = Double(postData.longitude!)
        
        marker.position = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        
        marker.title = "\(postData.text!)"
        marker.tracksInfoWindowChanges = true //情報ウィンドウを自動的に更新するように設定する
        marker.appearAnimation = GMSMarkerAnimation.pop //マーカーの表示にアニメーションをつける
        gmaps.selectedMarker = marker //デフォルトで情報ウィンドウを表示
        marker.map = self.gmaps
        
        markers = [marker]
        
        return markers
    }
    
    //現在地の読み込み完了時に呼ばれるメソッド
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        latitude = userLocation.coordinate.latitude
        longitude = userLocation.coordinate.longitude
        let now :GMSCameraPosition = GMSCameraPosition.camera(withLatitude: latitude,longitude:longitude,zoom:14)
        gmaps.camera = now
    }
}
