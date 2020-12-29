//
//  EditViewController.swift
//  ToDoList
//
//  Created by Mohamed Jaber on 13/12/2020.
//

import UIKit
import RealmSwift
import ChameleonFramework

class EditViewController: UIViewController {

    var edit = ItemsR()
    let vc=TodoListViewController()
    let realm=try! Realm()
    @IBOutlet weak var editTextView: UITextView!
    var color: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor=UIColor(hexString: color)
        editTextView.text=edit.title
        navigationController?.navigationBar.tintColor=ContrastColorOf(UIColor(hexString: color)!, returnFlat: true)
        editTextView.backgroundColor=UIColor(hexString: color)
        editTextView.textColor=ContrastColorOf(UIColor(hexString: color)!, returnFlat: true)
    }
   
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        do{
            try realm.write{
                vc.textTitle=editTextView.text
            }
        }catch{
            print("error saving done status \(error)")
        }
    }
}
    
