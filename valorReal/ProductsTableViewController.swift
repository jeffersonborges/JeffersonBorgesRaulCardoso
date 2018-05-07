//
//  ProdutosTableViewController.swift
//  valorReal
//
//  Created by Usuário Convidado on 23/04/18.
//  Copyright © 2018 Usuário Convidado. All rights reserved.
//

import UIKit
import CoreData

class ProductsTableViewController: UITableViewController {

    var label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 22))
    var fetchedResultController: NSFetchedResultsController<Product>!
    var products: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.estimatedRowHeight = 106
        tableView.rowHeight = UITableViewAutomaticDimension
        label.text = "Sua lista está vazia"
        label.textAlignment = .center
        label.textColor = .black
        loadProducts()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == "sgEditProduct" {
            let vc = segue.destination as! ItemRegisterViewController
            if let prods = fetchedResultController.fetchedObjects {
                vc.product = prods[tableView.indexPathForSelectedRow!.row]
            }
        }
    }
    
    func loadProducts(){
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let sortDescritor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescritor]
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultController.delegate = self
        do{
            self.products = try context.fetch(fetchRequest)
            try fetchedResultController.performFetch()
        }catch{
            print(error.localizedDescription)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        let count = fetchedResultController.fetchedObjects?.count ?? 0
        
        tableView.backgroundView = count == 0 ? label : nil
        return count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductTableViewCell

        guard let product = fetchedResultController.fetchedObjects?[indexPath.row] else { return cell }
        
        cell.prepare(witch: product)
        
        // Configure the cell...

        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            guard let product = fetchedResultController.fetchedObjects?[indexPath.row] else {return}
            do {
                context.delete(product)
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

extension ProductsTableViewController: NSFetchedResultsControllerDelegate{
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject:
        Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .delete:
            if let indexPath = indexPath {
                do{
                    try context.save()
                    products.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }catch{
                    print(error.localizedDescription)
                }
            }
            break
        default:
            tableView.reloadData()
        }
    }
}
