//
//  InputViewController.swift
//  OriginalApp
//
//  Created by 坪井衛三 on 2019/09/10.
//  Copyright © 2019 Eizo Tsuboi. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import DKImagePickerController
import SVProgressHUD

class InputViewController: UIViewController, GMSMapViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    
    
    let db = Firestore.firestore()
    var post: PostData?
    var mapView:GMSMapView?
    var inputCoordinate: CLLocationCoordinate2D?
    var marker = GMSMarker()
    var inputImage:[UIImage] = []
    @IBOutlet weak var imageSelectButton: UIButton!
    
    @IBOutlet weak var imageCollection: UICollectionView!
    //mapViewを表示するUIView
    @IBOutlet weak var viewMap: UIView! //mapを表示するView
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var captionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //imageSelectButton
        imageSelectButton.layer.borderWidth = 0.5
        imageSelectButton.layer.borderColor = UIColor.hex(string: "4F8F00", alpha: 1.0).cgColor

        //テキストフィールドのプロパティ設定
        captionTextView.layer.borderWidth = 0.5
        captionTextView.layer.borderColor = UIColor.hex(string: "4F8F00", alpha: 1.0).cgColor
        titleTextField.layer.borderWidth = 0.5
        titleTextField.layer.borderColor = UIColor.hex(string: "4F8F00", alpha: 1.0).cgColor
        viewMap.reloadInputViews()
        
        
        imageCollection.delegate = self
        imageCollection.dataSource = self
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
    
    //Mapを長押したとき、マーカーを表示し座標を取得
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        self.makeMarker(coordinate)
        inputCoordinate = coordinate
        print("Test1:\(String(describing: inputCoordinate))")
    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.imageCollection.reloadData()
//    }
//
    //Mapにマーカーを表示
    func makeMarker(_ coordinate: CLLocationCoordinate2D){
        marker.position = coordinate
        //情報ウィンドウを自動的に更新するように設定する７
        marker.tracksInfoWindowChanges = true
        //マーカーの表示にアニメーションをつける
        marker.appearAnimation = GMSMarkerAnimation.pop
        
        //デフォルトで情報ウィンドウを表示
        mapView!.selectedMarker = marker
        marker.map = self.mapView!
    }
    
    //画像を選択
    @IBAction func selectImageButton(_ sender: Any) {
        let pickerController = DKImagePickerController()
        // 選択可能な枚数を20にする
        pickerController.maxSelectableCount = 20
        pickerController.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
            self.inputImage = []
        // 選択された画像はassetsに入れて返却されるのでfetchして取り出す
            for asset in assets {
                            asset.fetchFullScreenImage(completeBlock: { (image, info) in
                                // ここで取り出せる
                                
                                self.inputImage.insert(image!, at: 0)
                                self.imageCollection.reloadData()
                                })
            }
            self.imageCollection.reloadData()
        }
        self.present(pickerController, animated: true) {}
    }
    
    //選択した写真を表示するCollectionViewの設定
    //
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("確認2:\(inputImage.count)")
        return self.inputImage.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        if let image = cell.contentView.viewWithTag(1) as? UIImageView {
                   // CollectionViewCellのUILabelを取得し、絵文字をに代入する
            image.image = inputImage[indexPath.row]
        }
        print("確認3:\(inputImage[indexPath.row])")
        return cell
    }
    
    //ボタンを押した時の処理
    //入力ボタン
    @IBAction func tupButton(_ sender: Any) {
        //imageViewから画像を取得
        var imageString:[String] = []
        if inputImage == []{
            
            for imageData in inputImage{
                let data = imageData.jpegData(compressionQuality: 0.5)
                imageString.insert(data!.base64EncodedString(options: .lineLength64Characters), at: 0)
            }
        }
        //postDataに必要な情報を取得しておく
        let time = Date.timeIntervalSinceReferenceDate
        let inputGeoPoint = GeoPoint(latitude: inputCoordinate!.latitude, longitude: inputCoordinate!.longitude)
    
//      DBに保存
        let postDic:[String:Any] = ["title": titleTextField.text, "caption": captionTextView.text!, "image":imageString, "time": String(time), "point": inputGeoPoint]
        let ref = db.collection(Const.PostPath)
        ref.addDocument(data: postDic){ err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        //HUDで投稿完了を表示する
        SVProgressHUD.showSuccess(withStatus: "投稿しました")
        //全てのモーダルを閉じる
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    //キャンセルボタン
    @IBAction func cancelButton(_ sender: Any) {
        
        titleTextField.text = ""
        captionTextView.text = ""
        inputImage = []
        inputCoordinate = nil
        //全てのモーダルを閉じる
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
}
