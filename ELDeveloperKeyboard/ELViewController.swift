//
//  ELViewController.swift
//  ELDeveloperKeyboard
//
//  Created by Eric Lin on 2014-07-02.
//  Copyright (c) 2014 Eric Lin. All rights reserved.
//

import UIKit

class ELViewController: UIViewController {
    
    var textView: UITextView!
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func loadView() {
        super.loadView()
        self.view = UIView(frame: UIScreen.mainScreen().applicationFrame)
        self.textView = UITextView(frame: self.view.frame)
        self.textView.scrollEnabled = true
        self.textView.userInteractionEnabled = true
        self.view.addSubview(self.textView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.becomeFirstResponder()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
    }
}