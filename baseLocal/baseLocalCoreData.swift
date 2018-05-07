//
//  UIViewController.swift
//  ComprarUSA
//
//  Created by user139409 on 5/2/18.
//  Copyright © 2018 Usuário Convidado. All rights reserved.
//

import CoreData
import UIKit

extension UIViewController {
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    var context: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
}
