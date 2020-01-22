//
//  TaakListTableViewController.swift
//  Satveer-C0769247-lab2
//
//  Created by Simran Chakkal on 2020-01-19.
//  Copyright © 2020 satveer. All rights reserved.
//

import UIKit
import CoreData
class TaakListTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet var searchBar: UISearchBar!
    
    var tasks: [TaskName]?
    var filterArray: [TaskName]?
    var days = "0"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCoreData()
        filterArray = tasks!
        searchBar.delegate = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    func loadCoreData() {
            tasks = [TaskName]()
            // create an instance of app delegate
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            // second step is context
            let managedContext = appDelegate.persistentContainer.viewContext

            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")

            do {
                let results = try managedContext.fetch(fetchRequest)
                if results is [NSManagedObject] {
                    for result in results as! [NSManagedObject] {
                        let task = result.value(forKey: "name") as! String
                        let taskdays = result.value(forKey: "days") as! Int
                        let date = result.value(forKey: "date") as? String
                        tasks?.append(TaskName(taskname:task,lastdate: Int(taskdays) ?? 0,date:date ?? ""))
                   //     tableView.reloadData()
                    }
                }

            } catch {
                print(error)
            }

        }

    // MARK: - Table view data sour

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filterArray?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = filterArray![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskcell")
    
// Configure the cell...
        cell?.textLabel?.text = task.taskname
       // cell?.detailTextLabel?.text = "\(task.lastdate) days"
        cell?.detailTextLabel?.text = "\(task.lastdate) days and \(task.countdown) completed days " + "\(task.date)"
        if task.countdown == task.lastdate
           {
                       cell?.backgroundColor = UIColor.gray
                       cell?.textLabel?.text = "Task Completed"
                       cell?.detailTextLabel?.text = ""
                       
                   }
        return cell!
    }
    
    
    func updateTask(taskArray: [TaskName]){
        tasks = taskArray
        tableView.reloadData()
    }
    

   
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

       let Adddays = UITableViewRowAction(style: .normal, title: "Add Day") { (rowaction, indexPath) in
                     
        let alertcontroller = UIAlertController(title: "Add number of Day", message: "Enter a day for task", preferredStyle: .alert)
                                       
                                       alertcontroller.addTextField { (textField ) in
                                                       textField.placeholder = "Number of days"
                                        self.days = textField.text!
                                        print(self.days)
                                        
                                           textField.text = ""
                                        }
                                       let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                                       CancelAction.setValue(UIColor.red, forKey: "titleTextColor")
                                       let AddAction = UIAlertAction(title: "Add Item", style: .default){
                                           (action) in
                                        let count = alertcontroller.textFields?.first?.text
                                        self.filterArray?[indexPath.row].countdown += Int(count!) ?? 0
                                        
                                            self.tableView.reloadData()
                                    }
                                AddAction.setValue(UIColor.black, forKey: "titleTextColor")
                                                     alertcontroller.addAction(CancelAction)
                                                     alertcontroller.addAction(AddAction)
                                                     self.present(alertcontroller, animated: true, completion: nil)}
                 Adddays.backgroundColor = UIColor.gray
       let deletetask = UITableViewRowAction(style: .normal, title: "Delete") { (rowaction, indexPath) in
           
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                  let ManagedContext = appDelegate.persistentContainer.viewContext
                  let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
           do{
               let data = try ManagedContext.fetch(fetchRequest)
               let taskitem = data[indexPath.row] as? NSManagedObject
               self.filterArray?.remove(at: indexPath.row)
            ManagedContext.delete(taskitem!)
               tableView.reloadData()
               do{
                           try ManagedContext.save()
                   }
           catch{
                print(error)
            }
           }
           catch{
               print(error)
           }
                  }
              deletetask.backgroundColor = UIColor.red
              return [deletetask,Adddays]
    }
  

  
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
                    tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
 

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let taskView = segue.destination as? task_DetailViewController {
            taskView.taskView = self
            taskView.tasks = self.tasks
        }
        
    }
    
    
    @IBAction func sortbytitle(_ sender: UIBarButtonItem) {
        let sorttitle = self.filterArray!
                         self.filterArray! = sorttitle.sorted { $0.taskname < $1.taskname }
                            self.tableView.reloadData()
        
    }
   
    
    @IBAction func sortBydate(_ sender: UIBarButtonItem) {
        let sorttitle = self.filterArray!
        self.filterArray! = sorttitle.sorted { $0.date < $1.date }
           self.tableView.reloadData()
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
         filterArray = searchText.isEmpty ? tasks : tasks?.filter({ (name: TaskName) -> Bool in
             
             return name.taskname.range(of: searchText, options:  .caseInsensitive) != nil
         })
         tableView.reloadData()
     }
    override func viewWillAppear(_ animated: Bool) {
        filterArray = tasks!
        tableView.reloadData()
    }

    
    
}
