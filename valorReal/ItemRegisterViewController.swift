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

    @IBOutlet weak var nomeProduto: UITextField!
    @IBOutlet weak var imgProduto: UIImageView!
    @IBOutlet weak var ufProduto: UITextField!
    @IBOutlet weak var valorProduto: UITextField!
    @IBOutlet weak var swCartao: UISwitch!
    
    var fetchedResultController: NSFetchedResultsController<Estado>!
    
    let formatter = NumberFormatter()
    var calc = Calcular.shared
    
    lazy var tcEstado: UIPickerView = {
        let tcEstado = UIPickerView()
        tcEstado.delegate = self
        tcEstado.dataSource = self
        return tcEstado
    }()
    
    // MARK: - Properties
    var smallImage: UIImage!
    var produto: Produto!
    
    @IBOutlet weak var btnEdtSave: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let btEspaco = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.items = [btCancel,btEspaco,btDone]
        
        ufProduto.inputView = tcEstado
        ufProduto.inputAccessoryView = toolbar
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadEstados()
        
        if produto != nil {
            btnEdtSave.setTitle("ALTERAR", for: .normal)
            nomeProduto.text = produto.nome
            if smallImage == nil {
                if let image = produto.image as? UIImage {
                    imgProduto.image = image
                    self.smallImage = image
                }
                else
                {
                    imgProduto.image = UIImage(named: "Unknown")
                }
            }
            
            swCartao.setOn(produto.cartao, animated: true)
            ufProduto.text = produto.estado?.nome
            valorProduto.text = calc.getFormattedValue(of: produto.valor, withCurrency: "")
        }
        else
        {
            btnEdtSave.setTitle("CADASTRAR", for: .normal)
        }
        
    }
    
    func loadEstados() {
        let fetchRequest: NSFetchRequest<Estado> = Estado.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "nome", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try    fetchedResultController.performFetch()
        } catch  {
            print(error.localizedDescription)
        }
        
        
    }
    
    @objc func cancel() {
        ufProduto.resignFirstResponder()
    }
    
    @objc func done() {
        
        if tcEstado.numberOfRows(inComponent: 0) > 0 {
            let estadoSelecionado = fetchedResultController.fetchedObjects![tcEstado.selectedRow(inComponent: 0)]
            ufProduto.text = estadoSelecionado.nome
        }
        cancel()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addEditProduto(_ sender: UIButton) {
        if produto == nil{
            produto = Produto(context: context)
        }
        produto.nome = nomeProduto.text
        produto.image = imgProduto.image
        if let valor = formatter.number(from: valorProduto.text!)?.doubleValue{
            produto.valor = valor
        }
        produto.cartao = swCartao.isOn
        let estado = fetchedResultController.fetchedObjects?.filter({$0.nome == ufProduto.text}).first
        produto.estado = estado
        do{
            try context.save()
        }catch{
            print(error.localizedDescription)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addImageProduto(_ sender: Any) {
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
        let estado = fetchedResultController.fetchedObjects?[row].nome
        return estado
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
        
        imgProduto.image = self.smallImage
        
        
        dismiss(animated: true, completion: nil)
        
    }
}
