//
//  CostomTableViewCell.swift
//  OriginalApp
//
//  Created by 坪井衛三 on 2019/09/15.
//  Copyright © 2019 Eizo Tsuboi. All rights reserved.
//

import UIKit
import GoogleMaps

class CostomTableViewCell: UITableViewCell {
    
    
    var mapView:GMSMapView?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var underMapView: UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func  setPostDate(_ postData: PostData){
        captionLabel.text = postData.caption
        titleLabel.text = postData.title
        
        //dateの表示
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        if  let date = postData.date{
            let dateString = formatter.string(from: date)
            dateLabel.text = dateString
        }
        
//        //Mapの表示
//        if let point = postData.point{
//            let camera = GMSCameraPosition.camera(withLatitude: point.latitude, longitude: point.longitude, zoom: 17.0)
//            mapView = GMSMapView.map(withFrame: self.underMapView.frame, camera: camera)
//            self.underMapView.addSubview(mapView!)
//        }else{
//            let camera = GMSCameraPosition.camera(withLatitude: 34.806651, longitude: 135.493011, zoom: 15.0)
//            mapView = GMSMapView.map(withFrame: self.underMapView.frame, camera: camera)
//            self.underMapView.addSubview(mapView!)
//        }
        
       
    }
}
