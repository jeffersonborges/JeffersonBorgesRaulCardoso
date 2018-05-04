//
//  Configuracao.swift
//  valorReal
//
//  Created by user139409 on 5/3/18.
//  Copyright © 2018 Usuário Convidado. All rights reserved.
//

import Foundation

enum UserDefaultsKeys: String {
    case cotDolar = "dolar"
    case imIOF = "iof"
}

class Configuracao {
    let defaults = UserDefaults.standard
    static var shared: Configuracao = Configuracao()
    
    var calc = Calcular.shared
    
    var cotDolar: String {
        get {
            return defaults.value(forKey: UserDefaultsKeys.cotDolar.rawValue) as! String
        }
        set {
            defaults.set(newValue, forKey: UserDefaultsKeys.cotDolar.rawValue)
        }
    }
    
    var txIOF: String {
        get {
            return defaults.value(forKey: UserDefaultsKeys.imIOF.rawValue) as! String
        }
        set {
            defaults.set(newValue, forKey: UserDefaultsKeys.imIOF.rawValue)
        }
    }
    
    private init() {
        
        if ((defaults.value(forKey: UserDefaultsKeys.cotDolar.rawValue)) == nil) {
            defaults.set(calc.getFormattedValue(of: 3.41, withCurrency: ""), forKey: UserDefaultsKeys.cotDolar.rawValue)
            defaults.synchronize()
        }
        
        if ((defaults.value(forKey: UserDefaultsKeys.imIOF.rawValue)) == nil) {
            defaults.set(calc.getFormattedValue(of: 6.38, withCurrency: ""), forKey: UserDefaultsKeys.imIOF.rawValue)
            defaults.synchronize()
        }
        
    }
    
}

