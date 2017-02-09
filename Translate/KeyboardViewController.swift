//
//  KeyboardViewController.swift
//  Translate
//
//  Created by Omar Abbasi on 2017-02-08.
//  Copyright © 2017 Omar Abbasi. All rights reserved.
//

import UIKit
import Alamofire

class KeyboardViewController: UIInputViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: - Variables declaration
    
    var langArr: [String : String] = ["fa": "Persian", "mg": "Malagasy", "ig": "Igbo", "pl": "Polish", "ro": "Romanian", "tl": "Filipino", "bn": "Bengali", "id": "Indonesian", "la": "Latin", "st": "Sesotho", "xh": "Xhosa", "sk": "Slovak", "da": "Danish", "lo": "Lao", "si": "Sinhala", "pt": "Portuguese", "bg": "Bulgarian", "tg": "Tajik", "gd": "Scots Gaelic", "te": "Telugu", "pa": "Punjabi", "ha": "Hausa", "ps": "Pashto", "ne": "Nepali", "sq": "Albanian", "et": "Estonian", "cy": "Welsh", "ms": "Malay", "bs": "Bosnian", "sw": "Swahili", "is": "Icelandic", "fi": "Finnish", "eo": "Esperanto", "sl": "Slovenian", "en": "English", "mi": "Maori", "es": "Spanish", "ny": "Chichewa", "km": "Khmer", "ja": "Japanese", "tr": "Turkish", "sd": "Sindhi", "kn": "Kannada", "az": "Azerbaijani", "kk": "Kazakh", "zh-TW": "Chinese (Traditional)", "no": "Norwegian", "fy": "Frisian", "uz": "Uzbek", "de": "German", "ko": "Korean", "lt": "Lithuanian", "ky": "Kyrgyz", "sm": "Samoan", "be": "Belarusian", "mn": "Mongolian", "ta": "Tamil", "eu": "Basque", "gu": "Gujarati", "gl": "Galician", "uk": "Ukrainian", "el": "Greek", "ml": "Malayalam", "vi": "Vietnamese", "mt": "Maltese", "it": "Italian", "so": "Somali", "ceb": "Cebuano", "hr": "Croatian", "lv": "Latvian", "zh": "Chinese (Simplified)", "ht": "Haitian Creole", "su": "Sundanese", "ur": "Urdu", "ca": "Catalan", "cs": "Czech", "sr": "Serbian", "my": "Myanmar (Burmese)", "am": "Amharic", "af": "Afrikaans", "hu": "Hungarian", "co": "Corsican", "lb": "Luxembourgish", "ru": "Russian", "mr": "Marathi", "ga": "Irish", "ku": "Kurdish (Kurmanji)", "hmn": "Hmong", "hy": "Armenian", "sn": "Shona", "sv": "Swedish", "th": "Thai", "ka": "Georgian", "jw": "Javanese", "mk": "Macedonian", "haw": "Hawaiian", "yo": "Yoruba", "zu": "Zulu", "nl": "Dutch", "yi": "Yiddish", "iw": "Hebrew", "hi": "Hindi", "ar": "Arabic", "fr": "French"]
    
    var shiftStatus: Int! // 0: off, 1: on, 2: lock
    var expandedHeight: CGFloat = 250
    var heightConstraint: NSLayoutConstraint!
    var shouldRemoveConstraint = false
    var didOpenPicker1 = false
    var didOpenPicker2 = false
    
    // MARK: - IBActions and IBOutlets
    
    @IBOutlet var keyCollection: [UIButton]!
    @IBOutlet var nextKeyboardButton: UIButton!
    @IBOutlet var shiftButton: UIButton!
    @IBOutlet var spaceButton: UIButton!
    @IBOutlet var translateButton: UIButton!
    @IBOutlet var fromButton: UIButton!
    @IBOutlet var toButton: UIButton!
    
    @IBOutlet var row1: UIView!
    @IBOutlet var row2: UIView!
    @IBOutlet var row3: UIView!
    
    @IBOutlet var pickerViewFrom: UIPickerView!
    
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
    
    // MARK: - Default override functions
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if (self.view.traitCollection.verticalSizeClass == UIUserInterfaceSizeClass.compact) {
            if !shouldRemoveConstraint {
                print("if")
                self.expandedHeight = 200
                self.updateViewConstraints()
                self.shouldRemoveConstraint = true
            } else {
                print("else")
                self.expandedHeight = 200
                self.updateViewConstraints()
                self.shouldRemoveConstraint = true
            }
        } else if (self.view.traitCollection.verticalSizeClass == UIUserInterfaceSizeClass.regular) {
            if shouldRemoveConstraint {
                print("ran this")
                self.expandedHeight = 250
                self.updateViewConstraints()
                self.shouldRemoveConstraint = true
            }
        }

    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()

        loadBoardHeight(expandedHeight, shouldRemoveConstraint)
        
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
        fromButton.setTitle(arr[row], for: .normal)
        
    }
    
    // MARK: - Functions
    
    func loadInterface() {
        
        self.shiftStatus = 1
        
        self.pickerViewFrom.delegate = self
        self.pickerViewFrom.dataSource = self
        
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
        // self.translateButton.imageView?.contentMode = .scaleAspectFit
        
        self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        
    }
    
    func loadBoardHeight(_ expanded: CGFloat, _ removeOld: Bool) {
        
        if !removeOld {
            heightConstraint = NSLayoutConstraint(item: self.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: expanded)
            self.heightConstraint.priority = UILayoutPriorityDefaultHigh
            self.view?.addConstraint(heightConstraint)
        } else if removeOld {
            self.inputView?.removeConstraint(heightConstraint)
            heightConstraint = NSLayoutConstraint(item: self.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: expanded)
            self.heightConstraint.priority = UILayoutPriorityDefaultHigh
            self.view?.addConstraint(heightConstraint)
        }
        
    }
    
    func deleteAllText() {
        
        if let text = self.textDocumentProxy.documentContextBeforeInput {
            for _ in text.characters {
                self.textDocumentProxy.deleteBackward()
            }
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
    
    func translateCaller() {
        
        let inputText = (textDocumentProxy.documentContextBeforeInput ?? "") + (textDocumentProxy.documentContextAfterInput ?? "")
        
        var keyFrom = ""
        var keyTo = ""
        
        var buttonFrom = ""
        var buttonTo = ""
        
        buttonFrom = toButton.currentTitle!
        buttonTo = toButton.currentTitle!
        
        let keyFromArr = (langArr as NSDictionary).allKeys(for: buttonFrom)
        for key in keyFromArr {
            keyFrom = key as! String
        }
        
        let keyToArr = (langArr as NSDictionary).allKeys(for: buttonTo)
        for key in keyToArr {
            keyTo = key as! String
        }
        
        googleTranslate(inputText, keyFrom, keyTo)
        
    }
    
    func googleTranslate(_ text: String, _ langFrom: String, _ langTo: String) {
        
        let spacelessString = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        Alamofire.request("https://translation.googleapis.com/language/translate/v2?key=AIzaSyAVrMMcGIKmC-PrPgQzTOGJGFIEc6MUTGw&source=\(langFrom)&target=\(langTo)&q=\(spacelessString!)").responseJSON { (Response) in
            
            if let value = Response.result.value {
                
                let json = JSON(value)
                
                for translation in json["data"]["translations"].arrayValue {
                    
                    let text = translation["translatedText"].stringValue
                    print(text)
                    
                }
            }
            
        }
        
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
