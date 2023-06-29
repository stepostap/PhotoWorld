//
//  ViewController.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 15.04.2023.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {

    var mediaItems: PickedMediaItems?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // let view = TestView(viewModel: RegViewModel(navcontroller: navigationController))
        //let view = LoginView(viewModel: LoginViewModel())
//        let view = ResetPasswordSuccessView()
//        let hosting = UIHostingController(rootView: view)
//        hosting.navigationController?.setNavigationBarHidden(true, animated: false)
//        hosting.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
//        hosting.title = "yoyoyo"
//
//        let appearance = UINavigationBarAppearance()
//        appearance.titleTextAttributes = [.foregroundColor: UIColor.red, .backgroundColor: UIColor(ColorConstants.Bluegray900)]
//        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.red]
//        hosting.navigationItem.standardAppearance = appearance
        
        //let view = TestView(viewModel: PhotoChoiceViewModel())
//        var mediaItems = PickedMediaItems()
//        let hosting = UIHostingController(rootView: AccountImageView(accountImage: mediaItems, sendData: {}))
//        //let hosting = UIHostingController(rootView: view)
//        let label = UILabel()
//        label.text = "Создание профиля фотографа"
//        label.textColor = UIColor(ColorConstants.WhiteA700)
//        label.font = UIFont.systemFont(ofSize: 20)
//        hosting.navigationItem.titleView = label
        //navigationController!.navigationBar.barTintColor = UIColor.green
//        let hosting = UIHostingController(rootView: HomePageView())
//        navigationController?.pushViewController(hosting, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let mediaItems = mediaItems {
            print(mediaItems.items.count)
        }
    }
    
    
}
