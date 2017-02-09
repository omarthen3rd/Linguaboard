//
//  KeyboardViewController.swift
//  Translate
//
//  Created by Omar Abbasi on 2017-02-08.
//  Copyright © 2017 Omar Abbasi. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {

    var shiftStatus: Int! // 0: off, 1: on, 2: caps-lock
    
    @IBOutlet var nextKeyboardButton: UIButton!
    @IBOutlet var shiftButton: UIButton!
    @IBOutlet var spaceButton: UIButton!
    
    @IBAction func shiftKeyPressed(_ sender: UIButton) {
        
        self.shiftStatus = self.shiftStatus > 0 ? 0 : 1
        
        self.shiftKeys()
        
        
    }
    
    @IBAction func keyPressed(_ sender: UIButton) {
        
        self.textDocumentProxy.insertText(sender.currentTitle!)
        
        if shiftStatus == 1 {
            self.shiftKeyPressed(self.shiftButton)
        }
        
        
    }
    
    @IBAction func returnKeyPressed(_ sender: UIButton) {
        
        self.textDocumentProxy.insertText("\n")
        
    }
    
    @IBAction func backSpaceButton(_ sender: UIButton) {
        
        self.textDocumentProxy.deleteBackward()
        
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
                
        let heightConstraint = NSLayoutConstraint(item: self.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: 250)
        heightConstraint.priority = UILayoutPriorityDefaultHigh
        self.view?.addConstraint(heightConstraint)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        loadInterface()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        
    }
    
    func loadInterface() {
        
        self.shiftStatus = 1
        
        // initializers
        let spaceDoubleTap = UITapGestureRecognizer(target: <#T##Any?#>, action: <#T##Selector?#>)
        
        self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        
    }
    
    func shiftKeyDoubleTapped(_ sender: UIButton) {
        
        self.shiftStatus = 2
        
        self.shiftKeys()
        
    }
    
    func shiftKeys() {
        
        if shiftStatus == 0 {
            
            
            
        } else {
            
            
            
        }
        
    }
    
    
}
