//
//  KeyboardViewController.swift
//  Translate
//
//  Created by Omar Abbasi on 2017-02-08.
//  Copyright © 2017 Omar Abbasi. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {

    var shiftStatus: Int! // 0: off, 1: on, 2: lock
    
    @IBOutlet var nextKeyboardButton: UIButton!
    @IBOutlet var shiftButton: UIButton!
    @IBOutlet var spaceButton: UIButton!
    @IBOutlet var translateButton: UIButton!
    
    @IBOutlet var row1: UIView!
    @IBOutlet var row2: UIView!
    @IBOutlet var row3: UIView!
    
    @IBAction func shiftKeyPressed(_ sender: UIButton) {
        
        self.shiftStatus = self.shiftStatus > 0 ? 0 : 1
        
        self.shiftKeys(row1)
        self.shiftKeys(row2)
        self.shiftKeys(row3)
        
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
    
    @IBAction func spaceKeyPressed(_ sender: UIButton) {
        
        self.textDocumentProxy.insertText(" ")
        
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
        
        // spaceDoubleTap initializers
        let spaceDoubleTap = UITapGestureRecognizer(target: self, action: #selector(self.spaceKeyDoubleTapped(_:)))
        spaceDoubleTap.numberOfTapsRequired = 2
        spaceDoubleTap.delaysTouchesEnded = false
        self.spaceButton.addGestureRecognizer(spaceDoubleTap)
        
        // shift key double and triple hold
        let shiftDoubleTap = UITapGestureRecognizer(target: self, action: #selector(self.shiftKeyDoubleTapped(_:)))
        let shiftTripleTap = UITapGestureRecognizer(target: self, action: #selector(self.shiftKeyPressed(_:)))
        
        shiftDoubleTap.numberOfTapsRequired = 2
        shiftTripleTap.numberOfTapsRequired = 3
        
        shiftDoubleTap.delaysTouchesEnded = false
        shiftTripleTap.delaysTouchesEnded = false
        
        self.shiftButton.addGestureRecognizer(shiftDoubleTap)
        self.shiftButton.addGestureRecognizer(shiftTripleTap)
        
        // button ui
        let image = UIImage(named: "translate")?.withRenderingMode(.alwaysTemplate)
        let image2 = UIImage(named: "translate_selected")?.withRenderingMode(.alwaysTemplate)
        self.translateButton.setImage(image, for: .normal)
        self.translateButton.setImage(image2, for: .highlighted)
        self.translateButton.tintColor = UIColor.white
        self.translateButton.imageView?.contentMode = .scaleAspectFit
        
        self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        
    }
    
    func spaceKeyDoubleTapped(_ sender: UIButton) {
        
        self.textDocumentProxy.deleteBackward()
        self.textDocumentProxy.insertText(". ")
        
        if shiftStatus == 0 {
            self.shiftKeyPressed(self.shiftButton)
        }
        
    }
    
    func shiftKeyDoubleTapped(_ sender: UIButton) {
        
        self.shiftStatus = 2
        
        self.shiftKeys(row1)
        self.shiftKeys(row2)
        self.shiftKeys(row3)
        
    }
    
    func shiftKeys(_ containerView: UIView) {
        
        if shiftStatus == 0 {
            
            for view in containerView.subviews {
                if let button = view as? UIButton {
                    let buttonTitle = button.titleLabel?.text!
                    let text = buttonTitle?.lowercased()
                    button.setTitle("\(text!)", for: .normal)
                    button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
                }
            }
            
        } else {
            
            for view in containerView.subviews {
                if let button = view as? UIButton {
                    let buttonTitle = button.titleLabel?.text!
                    let text = buttonTitle?.uppercased()
                    button.setTitle("\(text!)", for: .normal)
                    button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
                }
            }
        }
        
    }
    
    
}
