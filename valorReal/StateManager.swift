//
//  EstadoManager.swift
//  valorReal
//
//  Created by user139409 on 5/3/18.
//  Copyright © 2018 Usuário Convidado. All rights reserved.
//

import Foundation
import CoreData


class StateManager {
    static let shared = StateManager()
    var fetchedResultsControllerState: NSFetchedResultsController<State>!
    
    func loadStates (with context: NSManagedObjectContext) {
        let fetchResquest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        fetchResquest.sortDescriptors = [sortDescriptor]
        
        /*do {
            states = try context.fetch(fetchResquest)
        } catch {
            print(error.localizedDescription)
        }*/
        
        
        fetchedResultsControllerState = NSFetchedResultsController(fetchRequest: fetchResquest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try    fetchedResultsControllerState.performFetch()
        } catch  {
            print(error.localizedDescription)
        }
        
    }
    
    func deleteState(index: Int,with context: NSManagedObjectContext) {
        guard let state = fetchedResultsControllerState.fetchedObjects?[index] else {return}
        
        if state.product!.count > 0 {
            
            let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "state.name = %@", state.name!)
            
            let entityDescription = NSEntityDescription.entity(forEntityName: "Product", in: context)
            fetchRequest.entity = entityDescription
            
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            //deleteRequest.resultType = .resultTypeCount
            deleteRequest.resultType = .resultTypeObjectIDs
            
            
            
            do {
                try context.execute(deleteRequest)
                
                
                try context.save()
                context.reset()
                context.delete(state)
                try context.save()
                
            } catch{
                print(error.localizedDescription)
            }
            
        }
        else
        {
            do {
                context.delete(state)
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private init()
    {
        
    }
}
