//
//  Calcular.swift
//  valorReal
//
//  Created by user139409 on 5/3/18.
//  Copyright © 2018 Usuário Convidado. All rights reserved.
//

import Foundation
import CoreData

class Calcular {
    
    let formatter = NumberFormatter()
    static let shared = Calcular()
    
    
    //Retorna o Valor do Produto em Real
    func totCompraReal (vlTotCompra: Double, pDolar: Double) -> Double {
        return vlTotCompra * pDolar
    }
    
    //Calcula Valor Final em dolar do produto com taxas
    func calculate(pCompra: Double, pTaxState: Double, pIof: Double, useCard: Bool) -> Double {
        //Retorna o Valor da Taxa do estado em cima do total do Produto
        let  stateTaxValue: Double = pCompra * pTaxState/100
        
        var vlFinal = pCompra + stateTaxValue
        
        if useCard {
            //Retorna o Valor gasto em IOF do Produto
            let vlIofCompra = (pCompra + pTaxState) * pIof/100
            vlFinal += vlIofCompra
        }
        
        return vlFinal
        
    }
    
    //Formata para Moeda
    func getFormattedValue(of value: Double, withCurrency currency: String) -> String {
        formatter.numberStyle = .currency
        formatter.currencySymbol = currency
        formatter.alwaysShowsDecimalSeparator = true
        return formatter.string(for: value)!
    }
    
    func convertDouble (_ string: String) -> Double {
        formatter.locale = Locale.current // (Locale(identifier: "pt-BR"))
        formatter.numberStyle = .none
        return formatter.number(from: string)!.doubleValue
        
    }
    
    func verificaSinal(_ string: String) -> String {
        var sinal = "."
        
        if Locale.current.currencyCode == "BRL" {
            sinal=","
        }
        else
        {
            sinal="."
        }
        
        let decimals = Set("0123456789\(sinal)")
        var filtered = String( string.filter{decimals.contains($0)} )
        filtered = filtered.components(separatedBy:sinal)    // separate on decimal point
            .prefix(2)                      // only keep first two parts
            .joined(separator:sinal)
        
        return filtered
    }
    
    
    private init () {
        
        formatter.usesGroupingSeparator = true
        
        
        
    }
    
    var products: [Product] = []
    
    func loadProducts (with context: NSManagedObjectContext) {
        let fetchResquest: NSFetchRequest<Product> = Product.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        fetchResquest.sortDescriptors = [sortDescriptor]
        
        do {
            products = try context.fetch(fetchResquest)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    
    
}

