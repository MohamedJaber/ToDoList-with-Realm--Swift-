//
//  CategoryViewController.swift
//  ToDoList
//
//  Created by Mohamed Jaber on 08/12/2020.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

    let realm = try! Realm()
    var categoryArray : Results<CategoryR>?//Results read its defination
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategorys()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.backgroundColor=UIColor(hexString: "1D9BF6")
        tableView.backgroundColor=UIColor(hexString: "1D9BF6")
    }
    //MARK: -  TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.numberOfLines=0
        cell.textLabel?.text=categoryArray?[indexPath.row].name ?? "No Categories added yet"
        //cell.backgroundColor=UIColor(hexString: categoryArray?[indexPath.row].color ?? "1D9BF6")
        if let color=UIColor(hexString: categoryArray?[indexPath.row].color ?? "1D9BF6"){
        cell.backgroundColor=color
            cell.textLabel?.textColor=ContrastColorOf(color, returnFlat: true)}
        return cell
    }
  //MARK: -  Add New Category
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField=UITextField()
        let alert=UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        let action=UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory=CategoryR()
            newCategory.name=textField.text!
            newCategory.color=UIColor.randomFlat().hexValue()
            self.saveCategory(category: newCategory)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        alert.addAction(cancel)
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder="Create new Category"
            alertTextField.autocapitalizationType = .sentences
            //alertTextField.addConstraint(alertTextField.heightAnchor.constraint(equalToConstant: 100))
            
            textField=alertTextField
        }
        present(alert, animated: true, completion: nil)
    }
    //MARK: -  Data Manipulation Methods
    func loadCategorys(){
        categoryArray=realm.objects(CategoryR.self)
    }
    func saveCategory(category: CategoryR){
        do{
            try realm.write{
                realm.add(category)
            }
        }catch{
            print("Error in Saving data \(error)")
        }
        tableView.reloadData()
    }
   
 //MARK: -  Delete Data by Swipe
    override func deleteModel(at indexPath: IndexPath) {
                    if let category=self.categoryArray?[indexPath.row]{
                    do{
                        try self.realm.write{
                            self.realm.delete(category)
                        }
                    }catch{
                        print("error saving done status \(error)")
                    }
                    }
    }
    //MARK: -  TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC=segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory=categoryArray?[indexPath.row]
        }
    }
  
}

