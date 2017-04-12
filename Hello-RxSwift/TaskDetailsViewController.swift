//
//  TaskDetailsViewController.swift
//  Hello-RxSwift
//
//  Created by Mohammad Azam on 4/11/17.
//  Copyright © 2017 Mohammad Azam. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class TaskDetailsViewController : UIViewController {
    
    @IBOutlet weak var passButton :UIButton!
    @IBOutlet weak var taskTitleTextField :UITextField!
    
    private var disposeBag = DisposeBag()
    
    let task = PublishSubject<Task>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func passButtonPressed() {
        
        self.task.onNext(Task(title: self.taskTitleTextField.text!))
    }
}
