//
//  EstadoManager.swift
//  valorReal
//
//  Created by user139409 on 5/3/18.
//  Copyright © 2018 Usuário Convidado. All rights reserved.
//

import Foundation
import CoreData


class EstadoManager {
    static let shared = EstadoManager()
    var estados: [Estado] = []
    
    func loadEstados (with context: NSManagedObjectContext) {
        let fetchResquest: NSFetchRequest<Estado> = Estado.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "nome", ascending: true)
        
        fetchResquest.sortDescriptors = [sortDescriptor]
        
        do {
            estados = try context.fetch(fetchResquest)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func deleteEstado(index: Int,with context: NSManagedObjectContext) {
        let estado = self.estados[index]
        
        context.delete(estado)
        
        do {
            
            try context.save()
            estados.remove(at: index)
            
            
        } catch{
            print(error.localizedDescription)
        }
    }
    
    private init()
    {
        
    }
}
