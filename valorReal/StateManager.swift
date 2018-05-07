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
    var states: [State] = []
    
    func loadStates (with context: NSManagedObjectContext) {
        let fetchResquest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        fetchResquest.sortDescriptors = [sortDescriptor]
        
        do {
            states = try context.fetch(fetchResquest)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func deleteState(index: Int,with context: NSManagedObjectContext) {
        let states = self.states[index]
        
        context.delete(states)
        
        do {
            try context.save()
            self.states.remove(at: index)
            
            
        } catch{
            print(error.localizedDescription)
        }
    }
    
    private init()
    {
        
    }
}
