//
//  ProdutoTableViewCell.swift
//  valorReal
//
//  Created by user139409 on 5/2/18.
//  Copyright © 2018 Usuário Convidado. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbValue: UILabel!
    
    var conf = Calcular.shared
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func prepare(witch product: Product) {
        lbName.text = product.name ?? ""
        lbValue.text = conf.getFormattedValue(of: product.value, withCurrency: "U$ ")
        if let image = product.image as? UIImage {
            productImg.image = image
        }
        else {
            productImg.image = UIImage(named: "Unknown")
        }
    }
    
}
