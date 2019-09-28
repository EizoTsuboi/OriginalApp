//
//  HomeViewController.swift
//  OriginalApp
//
//  Created by 坪井衛三 on 2019/09/10.
//  Copyright © 2019 Eizo Tsuboi. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    var postArray:[PostData] = []
    var postData:PostData?
    let dataService = DataService()
    let db = Firestore.firestore()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.allowsSelection = false
        
        let nib = UINib(nibName: "CostomTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        
        //Tableのrowの高さをAutoLayoutで自動調整する
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UIScreen.main.bounds.width + 100
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
    
        //データが追加された時に呼ばれる
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
                    self.tableView.reloadData()
                    print("確認1:\(self.postArray)")
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(postArray.count)
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CostomTableViewCell
        
        postData = postArray[indexPath.row]
        cell.setPostDate(postData!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        postData = self.postArray[indexPath.row]
        performSegue(withIdentifier: "cellSegue", sender: self.tableView)
        print("確認5: didSelectRow")
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "cellSegue") {
            let checkViewController: CheckViewController = segue.destination as! CheckViewController
            
            checkViewController.post = self.postData

        }
    }
    
    
}
