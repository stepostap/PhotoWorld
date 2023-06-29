//
//  FlowCoordinator.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 19.04.2023.
//

import Foundation
import UIKit

protocol FlowCoordinator {
    var navigationController: UINavigationController { get set }
    
    func start()
    func finish()
}

extension FlowCoordinator {
    func createTitleLabel(title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textColor = UIColor(ColorConstants.WhiteA700)
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }
    
    func showAlert(error: NetworkError) {
        let alertController = UIAlertController(title: "Ошибка!", message: error.title, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in alertController.dismiss(animated: true)}))
        navigationController.present(alertController, animated: true)
    }
}
