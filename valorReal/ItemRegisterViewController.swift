//
//  ItemRegisterViewController.swift
//  valorReal
//
//  Created by Usuário Convidado on 23/04/18.
//  Copyright © 2018 Usuário Convidado. All rights reserved.
//

import UIKit
import CoreData

class ItemRegisterViewController: UIViewController {

    @IBOutlet weak var productName: UITextField!
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var ufProduct: UITextField!
    @IBOutlet weak var valueProduct: UITextField!
    @IBOutlet weak var swCard: UISwitch!
    
    var fetchedResultController: NSFetchedResultsController<State>!
    
    let formatter = NumberFormatter()
    var calc = Calcular.shared
    
    lazy var tcState: UIPickerView = {
        let tcState = UIPickerView()
        tcState.delegate = self
        tcState.dataSource = self
        return tcState
    }()
    
    // MARK: - Properties
    var smallImage: UIImage!
    var product: Product!
    
    @IBOutlet weak var btnEdtSave: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let btEspaco = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.items = [btCancel,btEspaco,btDone]
        
        ufProduct.inputView = tcState
        ufProduct.inputAccessoryView = toolbar
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadStates()
        
        if product != nil {
            btnEdtSave.setTitle("ALTERAR", for: .normal)
            productName.text = product.name
            if smallImage == nil {
                if let image = product.image as? UIImage {
                    productImg.image = image
                    self.smallImage = image
                }
                else
                {
                    productImg.image = UIImage(named: "Unknown")
                }
            }
            
            swCard.setOn(product.card, animated: true)
            ufProduct.text = product.state?.name
            valueProduct.text = calc.getFormattedValue(of: product.value, withCurrency: "")
        }
        else
        {
            btnEdtSave.setTitle("CADASTRAR", for: .normal)
        }
        
    }
    
    func loadStates() {
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try    fetchedResultController.performFetch()
        } catch  {
            print(error.localizedDescription)
        }
        
        
    }
    
    @objc func cancel() {
        ufProduct.resignFirstResponder()
    }
    
    @objc func done() {
        
        if tcState.numberOfRows(inComponent: 0) > 0 {
            let selectedState = fetchedResultController.fetchedObjects![tcState.selectedRow(inComponent: 0)]
            ufProduct.text = selectedState.name
        }
        cancel()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addEditProduct(_ sender: UIButton) {
        
        var erros:String = ""
        
        if(productName.text?.isEmpty == true){
            erros.append("Nome do produto requerido!\n")
        }
        
        if(valueProduct.text?.isEmpty == true){
            erros.append("Valor do produto requerido\n")
        }
        
        if(ufProduct.text?.isEmpty == true){
            erros.append("Estado de compra requerido!")
        }
        
        if(erros.description != "" && erros.description.isEmpty == false){
            self.showAlert(ptitle: "Validacao", pMsg: erros)
        }else{
            
            if product == nil{
                product = Product(context: context)
            }
            product.name = productName.text
            product.image = productImg.image
            if let value = formatter.number(from: valueProduct.text!)?.doubleValue{
                product.value = value
            }
            product.card = swCard.isOn
            let state = fetchedResultController.fetchedObjects?.filter({$0.name == ufProduct.text}).first
            product.state = state
            
            do{
                try context.save()
            }catch{
                print(error.localizedDescription)
            }
            navigationController?.popViewController(animated: true)
        }
    }
    
    func showAlert(ptitle: String, pMsg: String) {
        
        let alertController = UIAlertController(title: ptitle, message: pMsg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func addImageProduct(_ sender: Any) {
        //Criando o alerta que será apresentado ao usuário
        let alert = UIAlertController(title: "Selecionar poster", message: "De onde você quer escolher o poster?", preferredStyle: .actionSheet)
        
        //Verificamos se o device possui câmera. Se sim, adicionamos a devida UIAlertAction
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default, handler: { (action: UIAlertAction) in
                self.selectPicture(sourceType: .camera)
            })
            alert.addAction(cameraAction)
        }
        
        //As UIAlertActions de Biblioteca de fotos e Álbum de fotos também são criadas e adicionadas
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        
        let photosAction = UIAlertAction(title: "Álbum de fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        }
        alert.addAction(photosAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK:  Methods
    func selectPicture(sourceType: UIImagePickerControllerSourceType) {
        //Criando o objeto UIImagePickerController
        let imagePicker = UIImagePickerController()
        
        //Definimos seu sourceType através do parâmetro passado
        imagePicker.sourceType = sourceType
        
        //Definimos a MovieRegisterViewController como sendo a delegate do imagePicker
        imagePicker.delegate = self
        
        //Apresentamos a imagePicker ao usuário
        present(imagePicker, animated: true, completion: nil)
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

extension ItemRegisterViewController: UIPickerViewDelegate,  UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (fetchedResultController.fetchedObjects?.count)!
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let state = fetchedResultController.fetchedObjects?[row].name
        return state
    }
    
}

extension ItemRegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            print("erro")
            return
        }
        
        let size = CGSize(width: image.size.width*0.2, height: image.size.height*0.2)
        //let size = CGSize(width: 350, height:150)
        UIGraphicsBeginImageContext(size)
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        self.smallImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        productImg.image = self.smallImage
        
        
        dismiss(animated: true, completion: nil)
        
    }
}
