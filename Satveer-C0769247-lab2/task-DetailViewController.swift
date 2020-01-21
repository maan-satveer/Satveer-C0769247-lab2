//
//  task-DetailViewController.swift
//  Satveer-C0769247-lab2
//
//  Created by Simran Chakkal on 2020-01-19.
//  Copyright © 2020 satveer. All rights reserved.
//

import UIKit
import CoreData
class task_DetailViewController: UIViewController {
    // outlets of all fields
    
   
    
    @IBOutlet var tasktextfield: UITextField!
    
    @IBOutlet var daysnumber: UITextField!
    var tasks: [TaskName]?
    var taskView : TaakListTableViewController?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        saveCoreData()
        NotificationCenter.default.addObserver(self, selector: #selector(saveCoreData), name: UIApplication.willResignActiveNotification, object: nil)
    }
    func getFilePath() -> String{
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        if documentPath.count > 0 {
            let documentDirectory = documentPath[0]
            let filePath = documentDirectory.appending("/task.txt")
            return filePath
        }
        return ""
    }
  
    
    // to save any task
    @IBAction func savenotes(_ sender: UIButton) {
        let name = tasktextfield.text ?? ""
        let days = daysnumber.text ?? ""
        let task = TaskName(taskname: name,lastdate: Int(days) ?? 0)
        tasks?.append(task)
        tasktextfield.text = ""
        daysnumber.text = ""
        tasktextfield.resignFirstResponder()
        }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let TaskTable = segue.destination as? TaakListTableViewController{
//            TaskTable.tasks = self.tasks
//
//        }
//      //  print(tasks)
//    }
    @objc func saveCoreData() {
          // call clear core data
        
          clearCoreData()

          // create an instance of app delegate
          let appDelegate = UIApplication.shared.delegate as! AppDelegate
          // second step is context
          let managedContext = appDelegate.persistentContainer.viewContext

          for task in tasks! {
              let taskEntity = NSEntityDescription.insertNewObject(forEntityName: "Task", into: managedContext)
              taskEntity.setValue(task.taskname, forKey: "name")
            taskEntity.setValue(task.lastdate, forKey: "days")


              // save context
              do {
                  try managedContext.save()
              } catch {
                  print(error)
              }
          }
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
                   }
               }

           } catch {
               print(error)
           }

       }
       func clearCoreData() {
           // create an instance of app delegate
           let appDelegate = UIApplication.shared.delegate as! AppDelegate
           // second step is context
           let managedContext = appDelegate.persistentContainer.viewContext
           // create a fetch request
           let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")

           fetchRequest.returnsObjectsAsFaults = false

           do {
               let results = try managedContext.fetch(fetchRequest)
               for managedObjects in results {
                   if let managedObjectData = managedObjects as? NSManagedObject {
                       managedContext.delete(managedObjectData)
                   }
               }
           } catch {
               print(error)
           }

       }
       
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func viewWillDisappear(_ animated: Bool) {
        
        taskView?.updateTask(taskArray: tasks!)
    }

}

