//
//  ViewController.swift
//  Hello-RxSwift
//
//  Created by Mohammad Azam on 4/11/17.
//  Copyright © 2017 Mohammad Azam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var slider :UISlider!
    @IBOutlet weak var label :UILabel! 
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.slider.rx.value
            .subscribe(onNext :{ value in
                self.label.text = "\(value)"
            }).addDisposableTo(disposeBag)
     
    }
}

