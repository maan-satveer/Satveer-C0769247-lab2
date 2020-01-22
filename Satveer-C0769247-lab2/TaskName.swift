//
//  TaskName.swift
//  Satveer-C0769247-lab2
//
//  Created by Simran Chakkal on 2020-01-20.
//  Copyright © 2020 satveer. All rights reserved.
//

import Foundation
import Foundation
class TaskName{
   
    var taskname: String
    var lastdate: Int
    var date : String
    var countdown = 0
  
    init(taskname: String, lastdate: Int,date:String) {
        self.taskname = taskname
        self.lastdate = lastdate
        self.date=date
    }
    
}
