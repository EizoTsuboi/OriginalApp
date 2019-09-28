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
    @IBOutlet weak var cellImageView: UIImageView!
    

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
        //imageView
        if postData.image != []{
            cellImageView.image = postData.image[0]
        }
        
    }
}
