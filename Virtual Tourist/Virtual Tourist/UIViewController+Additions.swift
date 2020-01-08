//
//  UIViewController.swift
//  Virtual Tourist
//
//  Created by Enas Alrehaili on 2019-12-24.
//  Copyright © 2019 Enas Alrehaili. All rights reserved.
//

import UIKit

extension UIViewController {
    func alert(title: String , message: String?) {
        let alert = UIAlertController (title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction (title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}

