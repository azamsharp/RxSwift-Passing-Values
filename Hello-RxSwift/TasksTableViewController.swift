//
//  TasksTableViewController.swift
//  Hello-RxSwift
//
//  Created by Mohammad Azam on 4/11/17.
//  Copyright © 2017 Mohammad Azam. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

struct Task {
    var title :String
}

class TasksTableViewController : UITableViewController {
    
    @IBOutlet weak var addTaskBarButton :UIBarButtonItem! 
    
    var tasks :Variable<[Task]> = Variable([])
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
        
        bindUI()
    }
    
    private func bindUI() {
        
        bindAddTaskButtonTap()
        bindTableView()
        bindTableViewSelected()
    }
    
    private func bindTableViewSelected() {
        
        tableView
            .rx
            .modelSelected(Task.self)
            .subscribe(onNext :{ [weak self] _ in
                
                guard let strongSelf = self else { return }
                
                guard let taskDetailsVC = strongSelf.storyboard?.instantiateViewController(withIdentifier: "TaskDetailsViewController") as? TaskDetailsViewController else {
                    fatalError("TaskDetailsViewController not found")
                }
                
                strongSelf.navigationController?.pushViewController(taskDetailsVC, animated: true)
                
                
            }).addDisposableTo(disposeBag)

    }
    
    private func bindTableView() {
        
        tasks.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { row, element, cell in
                
                cell.textLabel?.text = element.title
                
            }.addDisposableTo(disposeBag)
        
        // just adding an item for demoing purposes!
        tasks.value.append(Task(title: "Feed the dog"))
    }
    
    private func bindAddTaskButtonTap() {
       
        self.addTaskBarButton.rx.tap
            .throttle(0.5, latest: false, scheduler: MainScheduler.instance)
            .subscribe { [weak self] _ in
                
                guard let strongSelf = self else { return }
                
                // show the task details view controller
                guard let taskDetailsVC = strongSelf.storyboard?.instantiateViewController(withIdentifier: "TaskDetailsViewController") as? TaskDetailsViewController else {
                    fatalError("TaskDetailsViewController not found")
                }
                
                taskDetailsVC.task.subscribe(onNext :{ [weak self] task in
                    
                    self?.tasks.value.append(task)
                    taskDetailsVC.dismiss(animated: true, completion: nil)
                    
                }).addDisposableTo(strongSelf.disposeBag)
                
                strongSelf.present(taskDetailsVC, animated: true, completion: nil)

            }.addDisposableTo(disposeBag)
    }
    
}
