//
//  DataController.swift
//  Virtual Tourist
//
//  Created by Enas Alrehaili on 2019-12-23.
//  Copyright © 2019 Enas Alrehaili. All rights reserved.
//

import Foundation
import CoreData

class DataController{
    static let sharedInstance = DataController()
    let persistentContainer = NSPersistentContainer (name: "VirtualTourist")
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    func load () {
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
        }
    }
}
