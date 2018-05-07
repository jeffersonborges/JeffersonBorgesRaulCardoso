//
//  EstadoTableViewCell.swift
//  ComprarUSA
//
//  Created by user139409 on 5/3/18.
//  Copyright © 2018 Usuário Convidado. All rights reserved.
//

import UIKit

class StateTableViewCell: UITableViewCell {

    @IBOutlet weak var lbtitle: UILabel!
    @IBOutlet weak var lbTax: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func prepare(witch state: State) {
        lbtitle.text = state.name ?? ""
        lbTax.text = String(state.tax)
    }

}
