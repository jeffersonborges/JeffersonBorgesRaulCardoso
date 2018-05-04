//
//  EstadoViewController.swift
//  valorReal
//
//  Created by user139409 on 5/3/18.
//  Copyright © 2018 Usuário Convidado. All rights reserved.
//

import UIKit
import CoreData

class EstadoViewController: UIViewController {
    
    var estadoManager = EstadoManager.shared
    
    let config = Configuracao.shared
    var calc = Calcular.shared

    @IBOutlet weak var tfCotacao: UITextField!
    @IBOutlet weak var tf_iof: UITextField!
    @IBOutlet weak var tvEstados: UITableView!
    @IBOutlet weak var btnAddEstado: UIButton!
    
    var label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = "Lista de estados vazia."
        label.textAlignment = .center
        loadValores()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadEstados()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //aqui grava
        if tf_iof.text?.isEmpty == false {
            config.txIOF = calc.verificaSinal(tf_iof.text!)
            
        }
        
        if tfCotacao.text?.isEmpty == false {
            config.cotDolar = calc.verificaSinal(tfCotacao.text!)
        }
    }
    
    func loadValores() {
        //aqui apresenta
        tfCotacao.text = config.cotDolar
        tf_iof.text = config.txIOF
        
        
    }
    func loadEstados() {
        estadoManager.loadEstados(with: context)
        tvEstados.reloadData()
    }
    
    @IBAction func btAddEditEstado(_ sender: Any) {
        showAlert(with: nil)
        
    }
    
    func showAlert(with estado: Estado?) {
        let title = estado == nil ? "Adicionar Estado" : "Editar Estado"
        let btTitle = estado == nil ? "Adicionar" : "Alterar"
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Nome do Estado"
            if let estUSA = estado?.nome {
                textField.text = estUSA
            }
        }
        
        alert.addTextField { (txtTaxa) in
            txtTaxa.placeholder = "Imposto"
            txtTaxa.keyboardType = UIKeyboardType.decimalPad
            
            if let estTaxa = estado?.imposto {
                txtTaxa.text = self.calc.getFormattedValue(of: estTaxa, withCurrency: "")
            }
        }
        
        alert.addAction(UIAlertAction(title: btTitle, style: .default, handler: {(action) in
            var errors: String = ""
            let estado = estado ?? Estado(context: self.context)
            
            if alert.textFields?[0].text != nil && alert.textFields?[0].text?.isEmpty == false {
                estado.nome = alert.textFields?[0].text
            }
            else
            {
                errors.append("Preencha o Estado.")
            }
            
            if alert.textFields?[1].text != nil && alert.textFields?[1].text?.isEmpty == false {
                let vlTax: String = self.calc.verificaSinal((alert.textFields?[1].text)!)
                //conforme consulta google existem estados com taxa 0
                estado.imposto = self.calc.convertDouble(vlTax)
            }
            else
            {
                errors.append("\n Preencher Taxa.")
            }
            
            if errors.description != "" && errors.description.isEmpty == false {
                self.showMsg(ptitle: "Inclusão não realizada.",pMsg: errors.description)
            }
            else
            {
                do
                {
                    try self.context.save()
                    self.loadEstados()
                }
                catch {
                    print()
                }
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func showMsg(ptitle: String, pMsg: String) {
        
        let alertController = UIAlertController(title: ptitle, message: pMsg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension EstadoViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = estadoManager.estados.count
        
        tvEstados.backgroundView = count == 0 ? label : nil
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tvEstados.dequeueReusableCell(withIdentifier: "estadocell", for: indexPath) as! EstadoTableViewCell
        let estado = estadoManager.estados[indexPath.row]
        cell.prepare(witch: estado)
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tf_iof.resignFirstResponder()
        tfCotacao.resignFirstResponder()
        tvEstados.deselectRow(at: indexPath, animated: false)
        
        let estado = estadoManager.estados[indexPath.row]
        showAlert(with: estado)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            estadoManager.deleteEstado(index: indexPath.row, with: context)
            //estadoManager.estados.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
