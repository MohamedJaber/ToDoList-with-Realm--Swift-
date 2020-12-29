//
//  TodoListViewController.swift
//  ToDoList
//
//  Created by Mohamed Jaber on 05/12/2020.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    let realm=try! Realm()
    var itemArray: Results<ItemsR>?
    var textTitle: String?=""
    var selectedCategory: CategoryR?{
        didSet{
            loadItems()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate=self
        tableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {//It's the right place for naviController for not being nil.
        super.viewWillAppear(animated)
        if let color=selectedCategory?.color{
            title=selectedCategory!.name
            tableView.backgroundColor=UIColor(hexString: color)
            navigationController?.navigationBar.tintColor=ContrastColorOf(UIColor(hexString: color)!, returnFlat: true)
            searchBar.barTintColor=UIColor(hexString: color)
            print(color)
            navigationController?.navigationBar.largeTitleTextAttributes=[NSAttributedString.Key.foregroundColor: ContrastColorOf(UIColor(hexString: color)!, returnFlat: true)]
            navigationController?.navigationBar.barTintColor=UIColor(hexString: color)}
    }
    
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.numberOfLines=0
        if let item=itemArray?[indexPath.row]{
            cell.textLabel?.text=item.title
            if let color=UIColor(hexString: selectedCategory!.color)?.darken(byPercentage:
                                                //it takes the precentage of how that cell will be darker
                                                CGFloat(indexPath.row)/CGFloat(itemArray!.count)){
                
                cell.backgroundColor=color
                cell.textLabel?.textColor=ContrastColorOf(color, returnFlat: true)
                //adjust the text color when the background is dark.
            }
           /* if item.done==true{
                cell.accessoryType = .checkmark
            }else {
                cell.accessoryType = .none
            }*/}
        else {
            cell.textLabel?.text="There are no Items."
        }
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "itemToEdit", sender: self)
        textTitle=(itemArray?[indexPath.row].title)
        /*
        if let item=itemArray?[indexPath.row]{
            do{
                try realm.write{
                    //realm.delete(item)
                    item.done = !item.done
                }
            }catch{
                print("error saving done status \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)*/
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinaionVC=segue.destination as! EditViewController
        if let indexPath=tableView.indexPathForSelectedRow{
            destinaionVC.edit = (itemArray?[indexPath.row])!
            destinaionVC.color = (selectedCategory?.color)!
        }
    }
    //MARK: -  Add New Category
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField=UITextField()
        let alert = UIAlertController(title: "Add new Item", message: "", preferredStyle: .alert)
        let action=UIAlertAction(title: "Add Action", style: .default) { (action) in
            if let currentCategory = self.selectedCategory{
                
                do{
                    try self.realm.write{
                        let newItem=ItemsR()
                        newItem.title=textField.text!
                        newItem.dateCreated=Date()
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    print("error in saving items \(error)")
                }
            }
            self.tableView.reloadData()
            print("successed")
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        alert.addAction(cancel)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder="Create new item"
            alertTextField.autocapitalizationType = .sentences
            textField=alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }   
    //MARK: -  Data Manipulation Methods
    func loadItems(){
        
        itemArray=selectedCategory!.items.sorted(byKeyPath: "title", ascending: true)
    }
    override func deleteModel(at indexPath: IndexPath){
        
        if let item=self.itemArray?[indexPath.row]{
            do{
                try realm.write{
                    realm.delete(item)}
            }catch{
                print("This item can't be deleted")}
            
        }
    }
}
//MARK: -  SearchBar Methods
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        itemArray=itemArray?.filter(" title CONTAINS[sd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count==0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()//to make keyboard and the cursor disappear
            }
        }
    }
}
