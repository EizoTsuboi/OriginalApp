//
//  InputHomeViewController.swift
//  OriginalApp
//
//  Created by 坪井衛三 on 2019/09/11.
//  Copyright © 2019 Eizo Tsuboi. All rights reserved.
//

import UIKit

class InputHomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func transIntputView(_ sender: Any) {
        self.performSegue(withIdentifier: "inputSegue", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
