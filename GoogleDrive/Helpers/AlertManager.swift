//
//  AlertManager.swift
//  GoogleDrive
//
//  Created by Шахова Анастасия on 25.11.2023.
//

import UIKit

final class AlertManager {
    
    static func showBasicAlert(on vc: UIViewController, title: String, message: String?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let alertAction = UIAlertAction.init(title: "OK", style: .default)
            alert.addAction(alertAction)
            vc.present(alert, animated: true)
        }
    }
}
