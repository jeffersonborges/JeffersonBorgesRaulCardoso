//
//  AlertError.swift
//  valorReal
//
//  Created by user139409 on 5/6/18.
//  Copyright © 2018 Usuário Convidado. All rights reserved.
//

import UIKit
import Foundation

class AlertError:UIViewController {
    
    func showAlert(ptitle: String, pMsg: String) {
        
        let alertController = UIAlertController(title: ptitle, message: pMsg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
}
