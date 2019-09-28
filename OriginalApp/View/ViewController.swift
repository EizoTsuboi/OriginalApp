//
//  ViewController.swift
//  OriginalApp
//
//  Created by 坪井衛三 on 2019/09/09.
//  Copyright © 2019 Eizo Tsuboi. All rights reserved.
//

import UIKit
import Firebase
import ESTabBarController

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupTab()
    }
    func setupTab(){
        //画像のファイル名を指定してESTabBarControllerを作成する
        let tabBarController: ESTabBarController! = ESTabBarController(tabIconNames: ["home", "search", "map", "setting"])
        //背景色、選択時の色を設定する
        tabBarController.selectedColor = UIColor.hex(string: "5C821A", alpha: 1.0)
        tabBarController.buttonsBackgroundColor = UIColor.hex(string: "C6D166", alpha: 1.0)
        tabBarController.selectionIndicatorHeight = 2
        
        //作成したESTabBarControllerを親のViewControllerに追加
        addChild(tabBarController)
        let tabBarView = tabBarController.view!
        tabBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tabBarView)
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tabBarView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tabBarView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tabBarView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tabBarView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
            ])
        tabBarController.didMove(toParent: self)
        
        //タブをタップしたときに表示するViewControllerを設定
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: "Home")
        let searchViewController = storyboard?.instantiateViewController(withIdentifier: "Search")
        let mapViewController = storyboard?.instantiateViewController(withIdentifier: "Map")
        let settingViewController = storyboard?.instantiateViewController(withIdentifier: "Setting")
        
        tabBarController.setView(homeViewController, at: 0)
        tabBarController.setView(searchViewController, at: 1)
        tabBarController.setView(mapViewController, at: 2)
        tabBarController.setView(settingViewController, at: 3)
        
    }

}

