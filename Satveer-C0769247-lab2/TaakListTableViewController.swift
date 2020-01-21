//
//  TaakListTableViewController.swift
//  Satveer-C0769247-lab2
//
//  Created by Simran Chakkal on 2020-01-19.
//  Copyright © 2020 satveer. All rights reserved.
//

import UIKit
import CoreData
class TaakListTableViewController: UITableViewController {
 var tasks: [TaskName]?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        loadCoreData()
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

                       tasks?.append(TaskName(taskname:task,lastdate: Int(taskdays) ?? 0))
                        tableView.reloadData()
                    }
                }

            } catch {
                print(error)
            }

        }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasks?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = tasks![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskcell")
    
// Configure the cell...
        cell?.textLabel?.text = task.taskname
        cell?.detailTextLabel?.text = "\(task.lastdate) days"
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

       
       let deleteaction = UITableViewRowAction(style: .normal, title: "Delete") { (rowaction, indexPath) in
           
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                  let ManagedContext = appDelegate.persistentContainer.viewContext
                  let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
           do{
               let data = try ManagedContext.fetch(fetchRequest)
               let taskitem = data[indexPath.row] as? NSManagedObject
               self.tasks?.remove(at: indexPath.row)
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
              deleteaction.backgroundColor = UIColor.red
              return [deleteaction]
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
        if let detailView = segue.destination as? task_DetailViewController {
            detailView.taskView = self
            detailView.tasks = tasks
        }
        
    }
    

}
