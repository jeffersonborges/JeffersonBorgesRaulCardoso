//
//  ProdutoTableViewCell.swift
//  valorReal
//
//  Created by user139409 on 5/2/18.
//  Copyright © 2018 Usuário Convidado. All rights reserved.
//

import UIKit

class ProdutoTableViewCell: UITableViewCell {
    @IBOutlet weak var imgProduto: UIImageView!
    @IBOutlet weak var lbNome: UILabel!
    @IBOutlet weak var lbValor: UILabel!
    
    var conf = Calcular.shared
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func prepare(witch produto: Produto) {
        lbNome.text = produto.nome ?? ""
        lbValor.text = conf.getFormattedValue(of: produto.valor, withCurrency: "U$ ")
        if let image = produto.image as? UIImage {
            imgProduto.image = image
        }
        else {
            imgProduto.image = UIImage(named: "Unknown")
        }
    }
    
}
