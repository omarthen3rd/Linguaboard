//
//  KeyboardViewController.swift
//  Translate
//
//  Created by Omar Abbasi on 2017-02-08.
//  Copyright © 2017 Omar Abbasi. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class KeyboardViewController: UIInputViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: - Variables declaration
    
    var langArr: [String : String] = ["fa": "Persian", "mg": "Malagasy", "ig": "Igbo", "pl": "Polish", "ro": "Romanian", "tl": "Filipino", "bn": "Bengali", "id": "Indonesian", "la": "Latin", "st": "Sesotho", "xh": "Xhosa", "sk": "Slovak", "da": "Danish", "lo": "Lao", "si": "Sinhala", "pt": "Portuguese", "bg": "Bulgarian", "tg": "Tajik", "gd": "Scots Gaelic", "te": "Telugu", "pa": "Punjabi", "ha": "Hausa", "ps": "Pashto", "ne": "Nepali", "sq": "Albanian", "et": "Estonian", "cy": "Welsh", "ms": "Malay", "bs": "Bosnian", "sw": "Swahili", "is": "Icelandic", "fi": "Finnish", "eo": "Esperanto", "sl": "Slovenian", "en": "English", "mi": "Maori", "es": "Spanish", "ny": "Chichewa", "km": "Khmer", "ja": "Japanese", "tr": "Turkish", "sd": "Sindhi", "kn": "Kannada", "az": "Azerbaijani", "kk": "Kazakh", "zh-TW": "Chinese (Traditional)", "no": "Norwegian", "fy": "Frisian", "uz": "Uzbek", "de": "German", "ko": "Korean", "lt": "Lithuanian", "ky": "Kyrgyz", "sm": "Samoan", "be": "Belarusian", "mn": "Mongolian", "ta": "Tamil", "eu": "Basque", "gu": "Gujarati", "gl": "Galician", "uk": "Ukrainian", "el": "Greek", "ml": "Malayalam", "vi": "Vietnamese", "mt": "Maltese", "it": "Italian", "so": "Somali", "ceb": "Cebuano", "hr": "Croatian", "lv": "Latvian", "zh": "Chinese (Simplified)", "ht": "Haitian Creole", "su": "Sundanese", "ur": "Urdu", "ca": "Catalan", "cs": "Czech", "sr": "Serbian", "my": "Myanmar (Burmese)", "am": "Amharic", "af": "Afrikaans", "hu": "Hungarian", "co": "Corsican", "lb": "Luxembourgish", "ru": "Russian", "mr": "Marathi", "ga": "Irish", "ku": "Kurdish (Kurmanji)", "hmn": "Hmong", "hy": "Armenian", "sn": "Shona", "sv": "Swedish", "th": "Thai", "ka": "Georgian", "jw": "Javanese", "mk": "Macedonian", "haw": "Hawaiian", "yo": "Yoruba", "zu": "Zulu", "nl": "Dutch", "yi": "Yiddish", "iw": "Hebrew", "hi": "Hindi", "ar": "Arabic", "fr": "French"]
    
    var shiftStatus: Int! // 0: off, 1: on, 2: lock
    var expandedHeight: CGFloat = 250
    var heightConstraint: NSLayoutConstraint!
    var shouldRemoveConstraint = false
    var didOpenPicker2 = true
    var selectedLanguage: String = "French"
    var langKey: String = "en"
    var toKey: String = ""
    var fullString: String = ""
    
    // MARK: - IBActions and IBOutlets
    
    @IBOutlet var keyCollection: [UIButton]!
    @IBOutlet var allKeys: [UIButton]!
    @IBOutlet var nextKeyboardButton: UIButton!
    @IBOutlet var shiftButton: UIButton!
    @IBOutlet var spaceButton: UIButton!
    @IBOutlet var backspaceButton: UIButton!
    @IBOutlet var altBoard: UIButton!
    @IBOutlet var returnKey: UIButton!

    @IBOutlet var translateShowView: UIView!
    @IBOutlet var sendToInput: UIButton!
    @IBOutlet var hideView: UIButton!
    
    @IBOutlet var row1: UIView!
    @IBOutlet var numbersRow1: UIView!
    @IBOutlet var row2: UIView!
    @IBOutlet var numbersRow2: UIView!
    @IBOutlet var row3: UIView!
    @IBOutlet var symbolsNumbersRow3: UIView!
    @IBOutlet var row4: UIView!
    
    @IBOutlet var pickerViewTo: UIPickerView!
    
    @IBAction func shiftKeyPressed(_ sender: UIButton) {
        
        self.shiftStatus = self.shiftStatus > 0 ? 0 : 1
        
        self.shiftKeys(row1)
        self.shiftKeys(row2)
        self.shiftKeys(row3)
        
    }
    
    @IBAction func keyPressed(_ sender: UIButton) {
        
        self.textDocumentProxy.insertText(sender.currentTitle!)
        
        self.shouldAutoCap()
        
         if shiftStatus == 1 {
            self.shiftKeyPressed(self.shiftButton)
        }
        
    }
    
    @IBAction func returnKeyPressed(_ sender: UIButton) {
        
        self.textDocumentProxy.insertText("\n")
        self.shouldAutoCap()
    }
    
    @IBAction func spaceKeyPressed(_ sender: UIButton) {
        
        self.textDocumentProxy.insertText(" ")
        self.shouldAutoCap()
    }
    
    @IBAction func backSpaceButton(_ sender: UIButton) {
        
        self.textDocumentProxy.deleteBackward()
        self.shouldAutoCap()
    }
    
    @IBAction func showPickerTwo(_ button: UIButton) {
        
        if didOpenPicker2 == true {
            
            row4.subviews[0].isUserInteractionEnabled = false
            row4.subviews[1].isUserInteractionEnabled = false
            row4.subviews[2].isUserInteractionEnabled = false
            row4.subviews[3].isUserInteractionEnabled = false
            row4.subviews[0].layer.opacity = 0.3
            row4.subviews[1].layer.opacity = 0.3
            row4.subviews[2].layer.opacity = 0.3
            row4.subviews[3].layer.opacity = 0.3
            didOpenPicker2 = false
            pickerViewTo.isHidden = false
            self.row1.isHidden = !didOpenPicker2
            self.row2.isHidden = !didOpenPicker2
            self.row3.isHidden = !didOpenPicker2
            
        } else {
            
            row4.subviews[0].isUserInteractionEnabled = true
            row4.subviews[1].isUserInteractionEnabled = true
            row4.subviews[2].isUserInteractionEnabled = true
            row4.subviews[3].isUserInteractionEnabled = true
            row4.subviews[0].layer.opacity = 1
            row4.subviews[1].layer.opacity = 1
            row4.subviews[2].layer.opacity = 1
            row4.subviews[3].layer.opacity = 1
            didOpenPicker2 = true
            pickerViewTo.isHidden = true
            self.row1.isHidden = !didOpenPicker2
            self.row2.isHidden = !didOpenPicker2
            self.row3.isHidden = !didOpenPicker2
            
        }

        
    }
    
    @IBAction func switchKeyBoardMode(_ button: UIButton) {
        
        self.numbersRow1.isHidden = true
        self.numbersRow2.isHidden = true
        self.symbolsNumbersRow3.isHidden = true
        
        switch (button.tag) {
            
        case 1:
            
            self.row1.isHidden = true
            self.row2.isHidden = true
            self.row3.isHidden = true
            self.numbersRow1.isHidden = false
            self.numbersRow2.isHidden = false
            self.symbolsNumbersRow3.isHidden = false
            
            self.altBoard.setImage(UIImage(named: "abcBoard")?.withRenderingMode(.alwaysTemplate), for: .normal)
            self.altBoard.setImage(UIImage(named: "abcBoard_selected")?.withRenderingMode(.alwaysTemplate), for: .highlighted)
            self.altBoard.tag = 0
            self.altBoard.tintColor = UIColor.black
            
        default:
            
            self.row1.isHidden = false
            self.row2.isHidden = false
            self.row3.isHidden = false
            self.numbersRow1.isHidden = true
            self.numbersRow2.isHidden = true
            self.symbolsNumbersRow3.isHidden = true
            self.altBoard.setImage(UIImage(named: "altBoard")?.withRenderingMode(.alwaysTemplate), for: .normal)
            self.altBoard.setImage(UIImage(named: "altBoard_selected")?.withRenderingMode(.alwaysTemplate), for: .highlighted)
            self.altBoard.tag = 1
            self.altBoard.tintColor = UIColor.black
            
        }
        
    }
    
    // MARK: - Default override functions
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        loadBoardHeight(expandedHeight, shouldRemoveConstraint)
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if (self.view.traitCollection.verticalSizeClass == UIUserInterfaceSizeClass.compact) {
            print("compact")
            self.expandedHeight = 130
            self.updateViewConstraints()
        } else if (self.view.traitCollection.verticalSizeClass == UIUserInterfaceSizeClass.regular) {
            print("regular")
            self.expandedHeight = 250
            self.updateViewConstraints()
            self.shouldRemoveConstraint = true
        }

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
    
    // MARK: - Picker view data source
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let arr = whichOne(0)
        let titleData = arr[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSForegroundColorAttributeName:UIColor.white])
        return myTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let arr = whichOne(0)
        return arr[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return langArr.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let arr = whichOne(0)
        self.selectedLanguage = arr[row]
        
        let keyToArr = (langArr as NSDictionary).allKeys(for: selectedLanguage)
        for key in keyToArr {
            self.toKey = key as! String
            self.hideView.setTitle(self.toKey.uppercased(), for: .normal)
        }
        
    
    }
    
    // MARK: - Functions
    
    func loadInterface() {
        
        self.shiftStatus = 1
        
        pickerViewTo.delegate = self
        pickerViewTo.dataSource = self
        pickerViewTo.selectRow(26, inComponent: 0, animated: true)
        pickerViewTo.isHidden = true
        
        numbersRow1.isHidden = true
        numbersRow2.isHidden = true
        symbolsNumbersRow3.isHidden = true
        self.altBoard.tag = 1
        
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
        
        for letter in self.allKeys {
            letter.layer.cornerRadius = 5
            letter.setTitleColor(UIColor.black, for: .normal)
            // letter.layer.masksToBounds = true
            // letter.backgroundColor = UIColor.darkGray
            // letter.setBackgroundColor(color: UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0), forState: .highlighted)
            if letter == sendToInput {
                letter.backgroundColor = UIColor.clear
                // letter.setTitleColor(UIColor.init(white: 1.0, alpha: 0.85), for: .normal)
                // letter.setBackgroundColor(color: UIColor.clear, forState: .highlighted)
            } else if letter == hideView {
                letter.layer.cornerRadius = 5
            }
        }
        
        self.sendToInput.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        self.sendToInput.titleLabel?.layer.opacity = 0.7
        
        self.shiftButton.setImage(UIImage(named: "shift0_selected")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.shiftButton.tintColor = UIColor.black
        
        self.hideView.setTitle(self.toKey, for: .normal)
        self.hideView.setTitleColor(UIColor.black, for: .normal)
        
        self.backspaceButton.setImage(UIImage(named: "bk")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.backspaceButton.setImage(UIImage(named: "bk_selected")?.withRenderingMode(.alwaysTemplate), for: .highlighted)
        self.backspaceButton.tintColor = UIColor.black
        
        self.nextKeyboardButton.setImage(UIImage(named: "otherBoard")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.nextKeyboardButton.setImage(UIImage(named: "otherBoard")?.withRenderingMode(.alwaysTemplate), for: .highlighted)
        self.nextKeyboardButton.tintColor = UIColor.black
        
        self.altBoard.setImage(UIImage(named: "altBoard")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.altBoard.setImage(UIImage(named: "altBoard_selected")?.withRenderingMode(.alwaysTemplate), for: .highlighted)
        self.altBoard.tintColor = UIColor.black
        
        self.returnKey.setImage(UIImage(named: "return")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.returnKey.setImage(UIImage(named: "return_selected")?.withRenderingMode(.alwaysTemplate), for: .highlighted)
        self.returnKey.tintColor = UIColor.black

        self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        self.hideView.addTarget(self, action: #selector(self.translateCaller), for: .touchUpInside)
        
    }
    
    func loadBoardHeight(_ expanded: CGFloat, _ removeOld: Bool) {
        
        if !removeOld {
            print("ran !removeOld")
            heightConstraint = NSLayoutConstraint(item: self.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: expanded)
            self.heightConstraint.priority = UILayoutPriorityDefaultHigh
            self.view?.addConstraint(heightConstraint)
        } else if removeOld {
            print("ran removeOld")
            self.view?.removeConstraint(heightConstraint)
            heightConstraint = NSLayoutConstraint(item: self.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: expanded)
            self.heightConstraint.priority = UILayoutPriorityDefaultHigh
            self.view?.addConstraint(heightConstraint)
        }
        
    }
    
    func whichOne(_ int: Int) -> Array<String> {
        
        if int == 0 {
            
            let langNames = [String](langArr.values).sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
            return langNames
            
        } else {
            
            let langCodes = [String](langArr.keys).sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
            return langCodes
            
        }
        
    }
    
    func shouldAutoCap() {
        
        let concurrentQueue = DispatchQueue(label: "com.omar.Linguaboard.Translate", attributes: .concurrent)
        concurrentQueue.sync {
            // self.fullString = self.fullDocumentContext()
            // print(self.fullString)
        }
        
    }
    
    func fullDocumentContext() -> String {
        let textDocumentProxy = self.textDocumentProxy
        
        var before = textDocumentProxy.documentContextBeforeInput
        
        var completePriorString = "";
        
        // Grab everything before the cursor
        while (before != nil && !before!.isEmpty) {
            completePriorString = before! + completePriorString
            
            let length = before!.lengthOfBytes(using: String.Encoding.utf8)
            
            textDocumentProxy.adjustTextPosition(byCharacterOffset: -length)
            Thread.sleep(forTimeInterval: 0.01)
            before = textDocumentProxy.documentContextBeforeInput
        }
        
        // Move the cursor back to the original position
        self.textDocumentProxy.adjustTextPosition(byCharacterOffset: completePriorString.characters.count)
        Thread.sleep(forTimeInterval: 0.01)
        
        var after = textDocumentProxy.documentContextAfterInput
        
        var completeAfterString = "";
        
        // Grab everything after the cursor
        while (after != nil && !after!.isEmpty) {
            completeAfterString += after!
            
            let length = after!.lengthOfBytes(using: String.Encoding.utf8)
            
            textDocumentProxy.adjustTextPosition(byCharacterOffset: length)
            Thread.sleep(forTimeInterval: 0.01)
            after = textDocumentProxy.documentContextAfterInput
        }
        
        // Go back to the original cursor position
        self.textDocumentProxy.adjustTextPosition(byCharacterOffset: -(completeAfterString.characters.count))
        
        let completeString = completePriorString + completeAfterString
        
        return completeString
        
    }
    
    func deleteAllText() {
        
        if let text = self.textDocumentProxy.documentContextBeforeInput {
            for _ in text.characters {
                self.textDocumentProxy.deleteBackward()
            }
        }
        
    }
    
    func addToText() {
        
        deleteAllText()
        self.textDocumentProxy.insertText(self.sendToInput.currentTitle!)
        self.shouldAutoCap()
        self.sendToInput.titleLabel?.text = ""
        self.hideView.removeTarget(self, action: #selector(self.addToText), for: .touchUpInside)
        self.hideView.addTarget(self, action: #selector(self.translateCaller), for: .touchUpInside)
        
    }
    
    func translateCaller() {
        
        let inputText = (textDocumentProxy.documentContextBeforeInput ?? "") + (textDocumentProxy.documentContextAfterInput ?? "")
        
        // detectLanguage(inputText)
        print("transcall")
        googleTranslate(inputText, "en", self.toKey)
        
        if (hideView.actions(forTarget: self, forControlEvent: .touchUpInside)!.contains("addToText")) {
            
            self.hideView.removeTarget(self, action: #selector(self.addToText), for: .touchUpInside)
            
        } else {
            
            self.hideView.removeTarget(self, action: #selector(self.translateCaller), for: .touchUpInside)
            self.hideView.addTarget(self, action: #selector(self.addToText), for: .touchUpInside)
            
            
        }
        
    }
    
    func detectLanguage(_ text: String) {
        
        let spacelessString = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        Alamofire.request("https://translation.googleapis.com/language/translate/v2/detect?key=AIzaSyAVrMMcGIKmC-PrPgQzTOGJGFIEc6MUTGw&q=\(spacelessString!)").responseJSON { (Response) in
            
            if let value = Response.result.value {
                
                let json = JSON(value)
                for translation in json["data"]["detections"].arrayValue {
                    
                    self.langKey = translation["language"].stringValue
                }
            }
        }
        
    }
    
    func googleTranslate(_ text: String, _ langFrom: String, _ langTo: String) {
        
        let spacelessString = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        Alamofire.request("https://translation.googleapis.com/language/translate/v2?key=AIzaSyAVrMMcGIKmC-PrPgQzTOGJGFIEc6MUTGw&source=\(langFrom)&target=\(langTo)&q=\(spacelessString!)").responseJSON { (Response) in
            
            if let value = Response.result.value {
                
                let json = JSON(value)
                for translation in json["data"]["translations"].arrayValue {
                    
                    let text = translation["translatedText"].stringValue
                    self.sendToInput.setTitle(text.stringByDecodingHTMLEntities, for: .normal)
                    
                }
                
            }
        }
        
    }

    func spaceKeyDoubleTapped(_ sender: UIButton) {
        
        self.textDocumentProxy.deleteBackward()
        self.textDocumentProxy.insertText(". ")
        self.shouldAutoCap()
        
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
            
            self.shiftButton.setImage(UIImage(named: "shift0")?.withRenderingMode(.alwaysTemplate), for: .normal)
            
            for letter in self.keyCollection {
                letter.setTitle(letter.titleLabel?.text?.lowercased(), for: .normal)
            }
            
        } else if shiftStatus == 1 {
            
            self.shiftButton.setImage(UIImage(named: "shift0_selected")?.withRenderingMode(.alwaysTemplate), for: .normal)
            
            for letter in self.keyCollection {
                letter.setTitle(letter.titleLabel?.text?.uppercased(), for: .normal)
            }
        } else {
            
            self.shiftButton.setImage(UIImage(named: "shift1_selected")?.withRenderingMode(.alwaysTemplate), for: .normal)
            
            for letter in self.keyCollection {
                letter.setTitle(letter.titleLabel?.text?.uppercased(), for: .normal)
            }
            
        }
        
    }
    
    
}
