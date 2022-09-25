//
//  MainViewController.swift
//  iOS-Bootcamp-Hafta2-Proje2
//
//  Created by Muhammed Karakul on 24.09.2022.
//

import UIKit
import CoreData

final class MainViewController: UIViewController {
    
    // open: Subclass ve override işlemlerini modüller arasında açar.
    // public: Modüller arasında erişime açık.
    // internal: Varsayılan erişim denetimi subclass erişimi ve override.
    // fileprivate: Dosya içerisinde erişime açık, dışarıya kapalı.
    // private(set): Subclass ve diğer class'lardan erişilemez.
    
    //private var listItems = [NSManagedObject]()
    
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    private var isFiltering: Bool = false {
        didSet {
            tableView.reloadData()
        }
    }
    
    var items = [NSManagedObject]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var filteredItems = [NSManagedObject]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "ProgressTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ProgressTableViewCell")
        
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        
        fetchItems()
    }
    
    @IBAction private func didTapTrashBarButtonItem(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Warning",
                                                message: "Do you want to remove all items form list?", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK",
                                          style: .default) { _ in
            
            for item in self.items {
                DBManager.shared.delete(entityName: "ListItem",
                                        object: item) { error in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                }
            }
            self.items.removeAll()
        }
        alertController.addAction(defaultAction)
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    @IBAction private func didTapAddBarButtonItem(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Add New Item",
                                                message: nil,
                                                preferredStyle: .alert)
        
        alertController.addTextField()
        
        let defaultAction = UIAlertAction(title: "OK",
                                          style: .default) { _ in
            guard let text = alertController.textFields?.first?.text else {
                return
            }
            
            let values = ["title" : text,
                          "progress" : round(100 * Float.random(in: 0...1)) / 100]
            
            self.createItem(values: values)
        }
        alertController.addAction(defaultAction)
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    private func fetchItems() {
        DBManager.shared.read() { objects, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let objects = objects else {
                return
            }
            self.items = objects
        }
    }
    
    private func createItem(values: [String : Any]) {
        DBManager.shared.create(entityName: "ListItem",
                                values: values) { object, error in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let object = object else {
                return
            }
            self.items.append(object)
        }
    }
    
    private func remove(at indexPath: IndexPath) {
        let object = isFiltering ? filteredItems[indexPath.row] : items[indexPath.row]
        
        DBManager.shared.delete(entityName: "ListItem",
                                object: object) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let index = isFiltering ? filteredItems.firstIndex(of: object) : items.firstIndex(of: object) else {
                return
            }
            
            _ = isFiltering ? filteredItems.remove(at: index) : items.remove(at: index)
            fetchItems()
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isFiltering ? filteredItems.count : items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = isFiltering ? filteredItems[indexPath.row] :  items[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProgressTableViewCell") as? ProgressTableViewCell,
              let title = item.value(forKey: "title") as? String,
              let progress = item.value(forKey: "progress") as? Float else {
            fatalError("UITableViewCell not found.")
        }
        
        cell.title = title
        cell.progress = progress
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    //    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    //
    //        .delete, .insert
    //    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            remove(at: indexPath)
            //tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}

// iOS Storage Options
// UserDefaults: Kullanıcı ayarlarını(bildirim ayarları, kullanıcı adı vb.) depolamak için kullanılır. Bu bilgiler plist dosylarında saklanır.
// CoreData: Daha büyük ve karmaşık verileri depolamamızı sağlar. Arkaplanda SQLite kullanılır. VT'deki relationship seçenekleri burada mevcut.(realm.io)
// Keychain: Tutulan veriler şifrelenir. Hassas bilgiler burada tutulur.

// MARK: - UISearchResultsUpdating
extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, text.count > .zero {
            filteredItems = items.filter { item in
                if let title = item.value(forKey: "title") as? String {
                    return title.lowercased().contains(text.lowercased())
                }
                return false
            }
            isFiltering = true
        } else {
            filteredItems.removeAll()
            isFiltering = false
        }
    }
}
