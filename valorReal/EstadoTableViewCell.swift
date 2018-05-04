//
//  EstadoTableViewCell.swift
//  valorReal
//
//  Created by user139409 on 5/3/18.
//  Copyright © 2018 Usuário Convidado. All rights reserved.
//

import UIKit

class EstadoTableViewCell: UITableViewCell {

    @IBOutlet weak var lbtitle: UILabel!
    @IBOutlet weak var lbImposto: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func prepare(witch estado: Estado) {
        lbtitle.text = estado.nome ?? ""
        lbImposto.text = String(estado.imposto)
    }

}
