//
//  CheckViewController.swift
//  OriginalApp
//
//  Created by 坪井衛三 on 2019/09/28.
//  Copyright © 2019 Eizo Tsuboi. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps

class CheckViewController: UIViewController, GMSMapViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
        
        
    
    
    let db = Firestore.firestore()
    var post: PostData?
    var mapView:GMSMapView?
    var marker = GMSMarker()
    var inputImage:[UIImage] = []
        
        
        
    @IBOutlet weak var imageCollection: UICollectionView!
    @IBOutlet weak var viewMap: UIView! //mapを表示するView
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var captionTextView: UITextView!
    
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageCollection.delegate = self
        imageCollection.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        titleLabel.text = post?.title
        captionTextView.text = post?.caption
        
    }
        
    //MapViewの表示
    //UIViewのFrameを取得して、MapViewの位置を設定
    override func viewDidLayoutSubviews() {
        super .viewDidLayoutSubviews()
        _ = self.initViewLayout //初回だけ呼び出し
    }
    private lazy var initViewLayout : Void = {
        print(self.view.frame)
        let camera = GMSCameraPosition.camera(withLatitude: 34.806651, longitude: 135.493011, zoom: 15.0)
        mapView = GMSMapView.map(withFrame: self.viewMap.frame, camera: camera)
        mapView!.isMyLocationEnabled = true
        self.view.addSubview(mapView!)
        print("check: MapView")
        mapView?.delegate = self
    }()
    

    
    //選択した写真を表示するCollectionViewの設定
    //
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.post?.image != []{
            return (self.post?.image.count)!
        }else{
            return 1
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        if let image = cell.contentView.viewWithTag(1) as? UIImageView {
          
            image.image = self.post?.image[indexPath.row]
        }
        return cell
    }
    
    
    //戻るボタン
    @IBAction func returnButton(_ sender: Any) {
        //全てのモーダルを閉じる
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
    }

}
