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

extension String {
    
    var length: Int {
        return (self as NSString).length
    }
    
    var asNSString: NSString {
        return (self as NSString)
    }
    
}

public extension UIView {
    
    func fadeIn(withDuration duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        })
    }
    
    func fadeOut(withDuration duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, animations: { 
            self.alpha = 1.0
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
    
}

class KeyboardViewController: UIInputViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - Variables declaration
    
    var langArr: [String : String] = ["fa": "Persian", "mg": "Malagasy", "ig": "Igbo", "pl": "Polish", "ro": "Romanian", "tl": "Filipino", "bn": "Bengali", "id": "Indonesian", "la": "Latin", "st": "Sesotho", "xh": "Xhosa", "sk": "Slovak", "da": "Danish", "lo": "Lao", "si": "Sinhala", "pt": "Portuguese", "bg": "Bulgarian", "tg": "Tajik", "gd": "Scots Gaelic", "te": "Telugu", "pa": "Punjabi", "ha": "Hausa", "ps": "Pashto", "ne": "Nepali", "sq": "Albanian", "et": "Estonian", "cy": "Welsh", "ms": "Malay", "bs": "Bosnian", "sw": "Swahili", "is": "Icelandic", "fi": "Finnish", "eo": "Esperanto", "sl": "Slovenian", "en": "English", "mi": "Maori", "es": "Spanish", "ny": "Chichewa", "km": "Khmer", "ja": "Japanese", "tr": "Turkish", "sd": "Sindhi", "kn": "Kannada", "az": "Azerbaijani", "kk": "Kazakh", "zh-TW": "Chinese (Traditional)", "no": "Norwegian", "fy": "Frisian", "uz": "Uzbek", "de": "German", "ko": "Korean", "lt": "Lithuanian", "ky": "Kyrgyz", "sm": "Samoan", "be": "Belarusian", "mn": "Mongolian", "ta": "Tamil", "eu": "Basque", "gu": "Gujarati", "gl": "Galician", "uk": "Ukrainian", "el": "Greek", "ml": "Malayalam", "vi": "Vietnamese", "mt": "Maltese", "it": "Italian", "so": "Somali", "ceb": "Cebuano", "hr": "Croatian", "lv": "Latvian", "zh": "Chinese (Simplified)", "ht": "Haitian Creole", "su": "Sundanese", "ur": "Urdu", "ca": "Catalan", "cs": "Czech", "sr": "Serbian", "my": "Myanmar (Burmese)", "am": "Amharic", "af": "Afrikaans", "hu": "Hungarian", "co": "Corsican", "lb": "Luxembourgish", "ru": "Russian", "mr": "Marathi", "ga": "Irish", "ku": "Kurdish (Kurmanji)", "hmn": "Hmong", "hy": "Armenian", "sn": "Shona", "sv": "Swedish", "th": "Thai", "ka": "Georgian", "jw": "Javanese", "mk": "Macedonian", "haw": "Hawaiian", "yo": "Yoruba", "zu": "Zulu", "nl": "Dutch", "yi": "Yiddish", "iw": "Hebrew", "hi": "Hindi", "ar": "Arabic", "fr": "French"]
    
    var shiftStatus: Int! // 0: off, 1: on, 2: lock
    var whichAutoCap: Int! // 0: none, 1: all chars, 2: sentences, 3: words
    var expandedHeight: CGFloat = 270
    var heightConstraint: NSLayoutConstraint!
    var shouldRemoveConstraint = false
    var didOpenPicker2 = true
    var selectedLanguage: String = "French"
    var langKey: String = "en"
    var toKey: String = "FR"
    var lastLang: String = "FR"
    var fullString = String()
    var timer: Timer?
    var predictionArr = [String]()
    var correctArr = [String]()
    var tapSendToInput: UITapGestureRecognizer!
    var longPressRecognizer = UILongPressGestureRecognizer()
    var didInsertAutocorrectText = false
    var missSpelledRange = NSRange()
    
    // var wordsBeingTyped = NSString()
    // var lastWord = String()
    var range = NSRange()
    
    var darkModeBool: UserDefaults = UserDefaults(suiteName: "group.Linguaboard")!
    var whiteMinimalModeBool: UserDefaults = UserDefaults(suiteName: "group.Linguaboard")!
    var darkMinimalModeBool: UserDefaults = UserDefaults(suiteName: "group.Linguaboard")!
    var keyBackgroundBool: UserDefaults = UserDefaults(suiteName: "group.Linguaboard")!
    var lastUsedLanguage: UserDefaults = UserDefaults(suiteName: "group.Linguaboard")!

    var keyBackgroundColor: UIColor = UIColor.white
    var keyPopUpColor: UIColor = UIColor(red:0.11, green:0.11, blue:0.11, alpha:1.0)
    var bgColor: UIColor = UIColor.clear
    var blurEffect: UIBlurEffect = UIBlurEffect.init(style: UIBlurEffectStyle.extraLight)
    
    // MARK: - IBActions and IBOutlets
    
    @IBOutlet var keyCollection: [UIButton]!
    @IBOutlet var allKeys: [UIButton]!
    @IBOutlet var keyPopKeys: [UIButton]!
    @IBOutlet var nextKeyboardButton: UIButton!
    @IBOutlet var shiftButton: UIButton!
    @IBOutlet var spaceButton: UIButton!
    @IBOutlet var showPickerBtn: UIButton!
    @IBOutlet var backspaceButton: UIButton!
    @IBOutlet var backspaceButton2: UIButton!
    @IBOutlet var altBoard: UIButton!
    @IBOutlet var returnKey: UIButton!
    @IBOutlet var symbolsKey: UIButton!
    
    @IBOutlet var moreDetailView: UIView!
    @IBOutlet var moreDetailLabel: UILabel!
    @IBOutlet var blurBG: UIVisualEffectView!
    @IBOutlet var translateShowView: UIView!
    @IBOutlet var clearTranslation: UIButton!
    @IBOutlet var sendToInput: UIButton!
    @IBOutlet var hideView: UIButton!
    
    @IBOutlet var predictionView: UIView!
    @IBOutlet var prediction1: UIButton!
    @IBOutlet var prediction2: UIButton!
    @IBOutlet var prediction3: UIButton!
    
    @IBOutlet var row1: UIView!
    @IBOutlet var numbersRow1: UIView!
    @IBOutlet var symbolsRow1: UIView!
    @IBOutlet var row2: UIView!
    @IBOutlet var numbersRow2: UIView!
    @IBOutlet var symbolsRow2: UIView!
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
        
        if sender.subviews.count > 1 {
            sender.subviews[1].removeFromSuperview()
        }
        self.textDocumentProxy.insertText(sender.currentTitle!)
        self.shouldAutoCap()
        // autocorrectCaller()
        autocorrect()
        self.hideView.isEnabled = true

        if shiftStatus == 1 {
            self.shiftKeyPressed(self.shiftButton)
        }
        
    }
    
    @IBAction func touchDownKey(_ sender: UIButton) {
        
        createPopUp(sender, bool: true)
        
    }
    
    @IBAction func returnKeyPressed(_ sender: UIButton) {
        
        self.hideView.isEnabled = true
        self.shouldAutoCap()
        autocorrect()
        self.textDocumentProxy.insertText("\n")
        
        if didInsertAutocorrectText == false && correctArr.count > 0 {
            
            addCorrectionToText(prediction2)
            
        } else if didInsertAutocorrectText == true && correctArr.count == 0 {
            
            didInsertAutocorrectText = false
            
        }
        
    }
    
    @IBAction func spaceKeyPressed(_ sender: UIButton) {
        
        self.hideView.isEnabled = true
        
        self.textDocumentProxy.insertText(" ")
        self.shouldAutoCap()
        autocorrect()
        print(missSpelledRange.length)
        print("range above")
        
        // Fool misspelled range into thinking it autocorrected
        // subtract misspelled range length from range when actually running autocorrect() so it "ignores" that word/range
        
        if (didInsertAutocorrectText == false && correctArr.count > 0) {
            
            print("ran this1")
            
            addCorrectionToText(prediction2)
            didInsertAutocorrectText = true
            
        } else if missSpelledRange.length > 0 {
            
            print("missSpelledRange: ", "\(missSpelledRange.length)")
            self.missSpelledRange.length -= self.missSpelledRange.length
            print("missSpelledRange2: ", "\(missSpelledRange.length)")
            autocorrect()
            self.correctArr.removeAll()
            doThingsWithButton(prediction1, true)
            doThingsWithButton(prediction2, true)
            doThingsWithButton(prediction3, true)
            
        } else if didInsertAutocorrectText == true && correctArr.count == 0 {
            
            didInsertAutocorrectText = false
            
        }
        
    }
    
    @IBAction func backSpaceButton(_ sender: UIButton) {
        
        if self.fullString.characters.count <= 1 {
            self.hideView.isEnabled = false
        } else {
            self.hideView.isEnabled = true
        }
        
        self.textDocumentProxy.deleteBackward()
        self.shouldAutoCap()
        autocorrect()
    }
    
    @IBAction func showPickerTwo(_ button: UIButton) {
        
        if didOpenPicker2 == true {
            
            row4.subviews[0].isUserInteractionEnabled = false
            row4.subviews[1].isUserInteractionEnabled = false
            row4.subviews[2].isUserInteractionEnabled = false
            row4.subviews[4].isUserInteractionEnabled = false
            translateShowView.isUserInteractionEnabled = false
            row4.subviews[0].layer.opacity = 0.3
            row4.subviews[1].layer.opacity = 0.3
            row4.subviews[2].layer.opacity = 0.3
            row4.subviews[4].layer.opacity = 0.3
            translateShowView.layer.opacity = 0.3
            didOpenPicker2 = false
            pickerViewTo.isHidden = false
            self.row1.isHidden = !didOpenPicker2
            self.row2.isHidden = !didOpenPicker2
            self.row3.isHidden = !didOpenPicker2
            self.numbersRow1.isHidden = !didOpenPicker2
            self.numbersRow2.isHidden = !didOpenPicker2
            self.symbolsRow1.isHidden = !didOpenPicker2
            self.symbolsRow2.isHidden = !didOpenPicker2
            self.symbolsNumbersRow3.isHidden = !didOpenPicker2
            
        } else {
            
            row4.subviews[0].isUserInteractionEnabled = true
            row4.subviews[1].isUserInteractionEnabled = true
            row4.subviews[2].isUserInteractionEnabled = true
            row4.subviews[4].isUserInteractionEnabled = true
            translateShowView.isUserInteractionEnabled = true
            row4.subviews[0].layer.opacity = 1
            row4.subviews[1].layer.opacity = 1
            row4.subviews[2].layer.opacity = 1
            row4.subviews[4].layer.opacity = 1
            translateShowView.layer.opacity = 1
            didOpenPicker2 = true
            pickerViewTo.isHidden = true
            self.row1.isHidden = !didOpenPicker2
            self.row2.isHidden = !didOpenPicker2
            self.row3.isHidden = !didOpenPicker2
            self.numbersRow1.isHidden = didOpenPicker2
            self.numbersRow2.isHidden = didOpenPicker2
            self.symbolsRow1.isHidden = didOpenPicker2
            self.symbolsRow2.isHidden = didOpenPicker2
            self.symbolsNumbersRow3.isHidden = didOpenPicker2
            
        }
        
        
    }
    
    @IBAction func switchKeyBoardMode(_ button: UIButton) {
        
        self.numbersRow1.isHidden = true
        self.numbersRow2.isHidden = true
        self.symbolsRow1.isHidden = true
        self.symbolsRow2.isHidden = true
        self.symbolsNumbersRow3.isHidden = true
        
        switch (button.tag) {
            
        case 1:
            
            self.backspaceButton.removeGestureRecognizer(longPressRecognizer)
            self.backspaceButton2.addGestureRecognizer(longPressRecognizer)
            
            self.row1.isHidden = true
            self.row2.isHidden = true
            self.row3.isHidden = true
            self.symbolsRow1.isHidden = true
            self.symbolsRow2.isHidden = true
            self.numbersRow1.isHidden = false
            self.numbersRow2.isHidden = false
            self.symbolsNumbersRow3.isHidden = false
            
            self.altBoard.setImage(UIImage(named: "abcBoard")?.withRenderingMode(.alwaysTemplate), for: .normal)
            self.altBoard.setImage(UIImage(named: "abcBoard_selected")?.withRenderingMode(.alwaysTemplate), for: .highlighted)
            self.altBoard.tag = 0
            
            self.symbolsKey.setImage(UIImage(named: "symbols")?.withRenderingMode(.alwaysTemplate), for: .normal)
            self.symbolsKey.setImage(UIImage(named: "symbols_selected")?.withRenderingMode(.alwaysTemplate), for: .highlighted)
            self.symbolsKey.tag = 2
            
        case 2:

            self.backspaceButton.removeGestureRecognizer(longPressRecognizer)
            self.backspaceButton2.addGestureRecognizer(longPressRecognizer)
            
            self.symbolsRow1.isHidden = false
            self.symbolsRow2.isHidden = false
            self.symbolsNumbersRow3.isHidden = false
            
            self.symbolsKey.tag = 1
            self.symbolsKey.setImage(UIImage(named: "altBoard")?.withRenderingMode(.alwaysTemplate), for: .normal)
            self.symbolsKey.setImage(UIImage(named: "altBoard_selected")?.withRenderingMode(.alwaysTemplate), for: .highlighted)
            
        default:
            
            self.backspaceButton2.removeGestureRecognizer(longPressRecognizer)
            self.backspaceButton.addGestureRecognizer(longPressRecognizer)
            
            self.row1.isHidden = false
            self.row2.isHidden = false
            self.row3.isHidden = false
            self.symbolsRow1.isHidden = true
            self.symbolsRow2.isHidden = true
            self.numbersRow1.isHidden = true
            self.numbersRow2.isHidden = true
            self.symbolsNumbersRow3.isHidden = true
            self.altBoard.setImage(UIImage(named: "altBoard")?.withRenderingMode(.alwaysTemplate), for: .normal)
            self.altBoard.setImage(UIImage(named: "altBoard_selected")?.withRenderingMode(.alwaysTemplate), for: .highlighted)
            self.altBoard.tag = 1
            
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
            self.expandedHeight = 170
            self.updateViewConstraints()
        } else if (self.view.traitCollection.verticalSizeClass == UIUserInterfaceSizeClass.regular) {
            self.expandedHeight = 270
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
        
        print("didReceiveMemoryWarning")
        
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        
        // self.hideView.isEnabled = true
        
        if (!(self.textDocumentProxy.documentContextBeforeInput != nil) && !(self.textDocumentProxy.documentContextAfterInput != nil)) || (self.textDocumentProxy.documentContextBeforeInput == "") && (self.textDocumentProxy.documentContextAfterInput == "") && (sendToInput.currentTitle! != "") {
            
            if (fullString.characters.count != 0) && (sendToInput.currentTitle! != "") {
                self.hideView.isEnabled = true
            } else {
                self.hideView.isEnabled = false
            }
            
        } else if (!(self.textDocumentProxy.documentContextBeforeInput != nil) && !(self.textDocumentProxy.documentContextAfterInput != nil)) || (self.textDocumentProxy.documentContextBeforeInput == "") && (self.textDocumentProxy.documentContextAfterInput == "") {
            
            self.shiftStatus = 1
            self.shiftKeys(row1)
            self.shiftKeys(row2)
            self.shiftKeys(row3)
            
            self.hideView.isEnabled = false
        }
        
    }
    
    // MARK: - Picker view data source
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let arr = whichOne(0)
        let titleData = arr[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSForegroundColorAttributeName:keyPopUpColor])
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
            self.lastLang = self.selectedLanguage
            self.lastUsedLanguage.set(self.lastLang, forKey: "lastUsedLang")
            self.showPickerBtn.setTitle(self.toKey.uppercased(), for: .normal)
        }
    }
    
    // MARK: - Functions
    
    // TODO
    // didInsertAutocorrectText (stop calling autocorrect if not wanting to autocorrect)
    
    func loadInterface() {
        
        let darkMode = darkModeBool.double(forKey: "darkBool")
        let whiteMinimal = whiteMinimalModeBool.double(forKey: "whiteMinimalBool")
        let darkMinimal = darkMinimalModeBool.double(forKey: "darkMinimalBool")
        
        if darkMode == 1 {
            loadColours("darkMode")
        } else if whiteMinimal == 1 {
            loadColours("whiteMinimal")
        } else if darkMinimal == 1 {
            loadColours("darkMinimal")
        } else {
            loadColours("whiteMode")
        }
        
        setColours()
        shouldAutoCap()
        
        pickerViewTo.delegate = self
        pickerViewTo.dataSource = self
        pickerViewTo.isHidden = true
        
        moreDetailLabel.numberOfLines = 0
        
        hideView.isEnabled = false
        clearTranslation.isEnabled = false
        symbolsRow1.isHidden = true
        symbolsRow2.isHidden = true
        numbersRow1.isHidden = true
        numbersRow2.isHidden = true
        symbolsNumbersRow3.isHidden = true
        moreDetailView.isHidden = true
        moreDetailView.layer.shadowColor = UIColor.black.cgColor
        moreDetailView.layer.shadowRadius = 10
        moreDetailView.layer.shadowOpacity = 0.3
        moreDetailView.layer.shadowOffset = CGSize(width: 0, height: 5)
        moreDetailView.layer.shadowPath = UIBezierPath(rect: moreDetailView.bounds).cgPath
        
        if self.lastUsedLanguage.object(forKey: "lastUsedLang") == nil {
            self.lastLang = "French"
        } else {
            self.lastLang = self.lastUsedLanguage.object(forKey: "lastUsedLang") as! String
        }
        let arr = whichOne(0)
        let indexTo = arr.index(of: self.lastLang)
        let keyToArr = (langArr as NSDictionary).allKeys(for: self.lastLang)
        self.toKey = String(describing: keyToArr[0]).uppercased()
        
        pickerViewTo.selectRow(indexTo!, inComponent: 0, animated: true)
        
        // prediction things
        
        doThingsWithButton(prediction1, true)
        doThingsWithButton(prediction2, true)
        doThingsWithButton(prediction3, true)
        
        self.prediction2.addTarget(self, action: #selector(self.addCorrectionToText(_:)), for: .touchUpInside)
        self.prediction1.addTarget(self, action: #selector(self.addCorrectionToText(_:)), for: .touchUpInside)
        self.prediction3.addTarget(self, action: #selector(self.addCorrectionToText(_:)), for: .touchUpInside)
        
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
        
        // backspace longpress
        
        self.longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressHandler(_:)))
        backspaceButton.addGestureRecognizer(longPressRecognizer)
        
        for letterKey in self.keyPopKeys {
            letterKey.addTarget(self, action: #selector(self.touchUpOutside(_:)), for: .touchUpOutside)
        }
        
        self.tapSendToInput = UITapGestureRecognizer(target: self, action: #selector(self.showDetailView))
        self.tapSendToInput.numberOfTapsRequired = 1
        self.tapSendToInput.numberOfTouchesRequired = 1
        self.sendToInput.tag = 1
        self.sendToInput.setTitle("", for: .normal)
        self.sendToInput.titleLabel?.lineBreakMode = .byTruncatingTail
        self.sendToInput.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        
        self.hideView.setImage(UIImage(named: "appLogo")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.hideView.setImage(UIImage(named: "appLogo_selected")?.withRenderingMode(.alwaysTemplate), for: .highlighted)
        
        self.shiftButton.setImage(UIImage(named: "shift0_selected")?.withRenderingMode(.alwaysTemplate), for: .normal)
        
        self.backspaceButton.setImage(UIImage(named: "bk")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.backspaceButton.setImage(UIImage(named: "bk_selected")?.withRenderingMode(.alwaysTemplate), for: .highlighted)
        
        self.backspaceButton2.setImage(UIImage(named: "bk")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.backspaceButton2.setImage(UIImage(named: "bk_selected")?.withRenderingMode(.alwaysTemplate), for: .highlighted)
        
        self.nextKeyboardButton.setImage(UIImage(named: "otherBoard")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.nextKeyboardButton.setImage(UIImage(named: "otherBoard")?.withRenderingMode(.alwaysTemplate), for: .highlighted)
        
        self.symbolsKey.setImage(UIImage(named: "symbols")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.symbolsKey.setImage(UIImage(named: "symbols_selected")?.withRenderingMode(.alwaysTemplate), for: .highlighted)
        
        self.altBoard.setImage(UIImage(named: "altBoard")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.altBoard.setImage(UIImage(named: "altBoard_selected")?.withRenderingMode(.alwaysTemplate), for: .highlighted)
        self.altBoard.tag = 1
        
        self.returnKey.setImage(UIImage(named: "return")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.returnKey.setImage(UIImage(named: "return_selected")?.withRenderingMode(.alwaysTemplate), for: .highlighted)
        
        self.clearTranslation.setImage(UIImage(named: "close")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.clearTranslation.setImage(UIImage(named: "close_selected")?.withRenderingMode(.alwaysTemplate), for: .highlighted)
        
        self.showPickerBtn.setTitle(self.toKey, for: .normal)
        
        self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        self.hideView.addTarget(self, action: #selector(self.translateCaller), for: .touchUpInside)
        self.clearTranslation.addTarget(self, action: #selector(self.clearButton(_:)), for: .touchUpInside)
        
    }
    
    func loadBoardHeight(_ expanded: CGFloat, _ removeOld: Bool) {
        
        if !removeOld {
            heightConstraint = NSLayoutConstraint(item: self.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: expanded)
            self.heightConstraint.priority = UILayoutPriorityDefaultHigh
            self.view?.addConstraint(heightConstraint)
        } else if removeOld {
            self.view?.removeConstraint(heightConstraint)
            heightConstraint = NSLayoutConstraint(item: self.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: expanded)
            self.heightConstraint.priority = UILayoutPriorityDefaultHigh
            self.view?.addConstraint(heightConstraint)
        }
        
    }
    
    func setColours() {
        
        let keyBackground = keyBackgroundBool.double(forKey: "keyBackgroundBool")
        
        if keyBackground == 1 {
            
            for letter in self.allKeys {
                letter.layer.cornerRadius = 5
                letter.backgroundColor = keyBackgroundColor
                letter.setTitleColor(keyPopUpColor, for: .normal)
                letter.tintColor = keyPopUpColor
                letter.titleLabel?.font = UIFont.systemFont(ofSize: 21)
                if letter == sendToInput || letter == hideView {
                    letter.backgroundColor = UIColor.clear
                    letter.layer.cornerRadius = 0
                }
            }
            
        } else if keyBackground == 2 {
            
            for letter in self.allKeys {
                letter.backgroundColor = UIColor.clear
                letter.setTitleColor(keyPopUpColor, for: .normal)
                letter.tintColor = keyPopUpColor
                letter.titleLabel?.font = UIFont.systemFont(ofSize: 21)
                if letter == sendToInput || letter == hideView {
                    letter.backgroundColor = UIColor.clear
                    letter.layer.cornerRadius = 0
                }
            }
            
        } else {
            
            for letter in self.allKeys {
                letter.backgroundColor = UIColor.clear
                letter.setTitleColor(keyPopUpColor, for: .normal)
                letter.tintColor = keyPopUpColor
                letter.titleLabel?.font = UIFont.systemFont(ofSize: 21)
                if letter == sendToInput || letter == hideView {
                    letter.backgroundColor = UIColor.clear
                    letter.layer.cornerRadius = 0
                }
            }
            
        }
        
        self.view.backgroundColor = bgColor
        self.blurBG.effect = blurEffect
        self.hideView.tintColor = keyPopUpColor
        self.shiftButton.tintColor = keyPopUpColor
        self.backspaceButton.tintColor = keyPopUpColor
        self.backspaceButton2.tintColor = keyPopUpColor
        self.nextKeyboardButton.tintColor = keyPopUpColor
        self.symbolsKey.tintColor = keyPopUpColor
        self.altBoard.tintColor = keyPopUpColor
        self.clearTranslation.tintColor = keyPopUpColor
        self.sendToInput.setTitleColor(keyPopUpColor, for: .normal)
        self.prediction1.setTitleColor(keyPopUpColor, for: .normal)
        self.prediction2.setTitleColor(keyPopUpColor, for: .normal)
        self.prediction3.setTitleColor(keyPopUpColor, for: .normal)
        self.moreDetailView.backgroundColor = keyBackgroundColor
        self.moreDetailLabel.textColor = keyPopUpColor
        
    }
    
    func loadColours(_ thingToLoad: String) {
        
        if thingToLoad == "darkMode" {
            // dark blur mode
            self.keyPopUpColor = UIColor.white
            self.keyBackgroundColor = UIColor(red:0.11, green:0.11, blue:0.11, alpha:1.0)
            self.bgColor = UIColor.clear
            self.blurEffect = UIBlurEffect.init(style: UIBlurEffectStyle.dark)
            self.blurBG.isHidden = false
        } else if thingToLoad == "darkMinimal" {
            self.keyPopUpColor = UIColor.white
            self.keyBackgroundColor = UIColor(red:0.11, green:0.11, blue:0.11, alpha:1.0)
            self.bgColor = UIColor(red:0.15, green:0.15, blue:0.15, alpha:1.0)
            self.blurBG.isHidden = true
        } else if thingToLoad == "whiteMinimal" {
            self.keyPopUpColor = UIColor(red:0.11, green:0.11, blue:0.11, alpha:1.0)
            self.keyBackgroundColor = UIColor(red:0.91, green:0.92, blue:0.93, alpha:1.0)
            self.bgColor = UIColor.white
            self.blurBG.isHidden = true
        } else if thingToLoad == "whiteMode" {
            // white blur mode
            self.keyPopUpColor = UIColor(red:0.11, green:0.11, blue:0.11, alpha:1.0)
            self.keyBackgroundColor = UIColor.white
            self.bgColor = UIColor.clear
            self.blurEffect = UIBlurEffect.init(style: UIBlurEffectStyle.extraLight)
            self.blurBG.isHidden = false
        }
        
    }
    
    func createPopUp(_ sender: UIButton, bool: Bool) {
        
        var frame: CGRect
        var frame1: CGRect
        let xToUse = (sender.frame.size.width - sender.frame.size.width * 1.3919) / 2
        let xLeft = ((sender.frame.size.width - sender.frame.size.width * 1.3919) / -5)
        let xRight = ((sender.frame.size.width - sender.frame.size.width * 1.3919) * 2)
        frame = CGRect(x: xToUse, y: -50, width: sender.frame.size.width * 1.3919, height: sender.frame.size.height * 1.1071428571)
        frame1 = CGRect(x: 0, y: 0, width: sender.frame.size.width * 1.3919, height: sender.frame.size.height * 1.1071428571)
        
        switch sender {
        case row1.subviews[0]:
            frame = CGRect(x: sender.bounds.origin.x / 2, y: -50, width: sender.frame.size.width * 1.3919, height: sender.frame.size.height * 1.1071428571)
        case numbersRow1.subviews[0]:
            frame = CGRect(x: xLeft / 2, y: -50, width: sender.frame.size.width * 1.3919, height: sender.frame.size.height * 1.1071428571)
        case numbersRow2.subviews[0]:
            frame = CGRect(x: xLeft / 2, y: -50, width: sender.frame.size.width * 1.3919, height: sender.frame.size.height * 1.1071428571)
        case symbolsRow1.subviews[0]:
            frame = CGRect(x: xLeft / 2, y: -50, width: sender.frame.size.width * 1.3919, height: sender.frame.size.height * 1.1071428571)
        case symbolsRow2.subviews[0]:
            frame = CGRect(x: xLeft / 2, y: -50, width: sender.frame.size.width * 1.3919, height: sender.frame.size.height * 1.1071428571)
        case row1.subviews[9]:
            frame = CGRect(x: xRight / 2, y: -50, width: sender.frame.size.width * 1.3919, height: sender.frame.size.height * 1.1071428571)
        case numbersRow1.subviews[9]:
            frame = CGRect(x: xRight / 2, y: -50, width: sender.frame.size.width * 1.3919, height: sender.frame.size.height * 1.1071428571)
        case numbersRow2.subviews[9]:
            frame = CGRect(x: xRight / 2, y: -50, width: sender.frame.size.width * 1.3919, height: sender.frame.size.height * 1.1071428571)
        case symbolsRow1.subviews[9]:
            frame = CGRect(x: xRight / 2, y: -50, width: sender.frame.size.width * 1.3919, height: sender.frame.size.height * 1.1071428571)
        case symbolsRow2.subviews[9]:
            frame = CGRect(x: xRight / 2, y: -50, width: sender.frame.size.width * 1.3919, height: sender.frame.size.height * 1.1071428571)
        default:
            frame = CGRect(x: xToUse, y: -50, width: sender.frame.size.width * 1.3919, height: sender.frame.size.height * 1.1071428571)
        }
        
        let popUp = UIView(frame: frame)
        let text = UILabel()
        text.frame = frame1
        text.text = sender.currentTitle!
        text.textColor = keyBackgroundColor
        text.textAlignment = .center
        text.font = UIFont.boldSystemFont(ofSize: 30)
        text.layer.cornerRadius = 5
        text.backgroundColor = keyPopUpColor
        text.layer.masksToBounds = true
        popUp.backgroundColor = keyPopUpColor
        popUp.layer.cornerRadius = 5
        popUp.layer.shadowColor = UIColor.gray.cgColor
        popUp.layer.shadowRadius = 2
        popUp.layer.shadowOpacity = 0.15
        popUp.layer.shadowOffset = CGSize(width: 0, height: 4)
        popUp.layer.shadowPath = UIBezierPath(rect: popUp.bounds).cgPath
        popUp.layer.shouldRasterize = true
        popUp.layer.rasterizationScale = UIScreen.main.scale
        popUp.addSubview(text)
        sender.addSubview(popUp)
        
    }
    
    func touchUpOutside(_ sender: UIButton) {
        
        if sender.subviews.count > 1 {
            sender.subviews[1].removeFromSuperview()
        }

    }
    /*
    func switchView() {
        
     // default was true
     
        if translationViewIsOpen {
            self.translateShowView.isHidden = true
            self.predictionView.isHidden = false
            self.translationViewIsOpen = false
            self.translateShowView.removeGestureRecognizer(swipeGesture)
            self.predictionView.addGestureRecognizer(swipeGesture)
        } else if translationViewIsOpen == false {
            self.translateShowView.isHidden = false
            self.predictionView.isHidden = true
            self.translationViewIsOpen = true
            self.translateShowView.removeGestureRecognizer(swipeGesture)
            self.predictionView.addGestureRecognizer(swipeGesture)
        }
        
    }
    */
    
    func whichOne(_ int: Int) -> Array<String> {
        
        if int == 0 {
            
            let langNames = [String](langArr.values).sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
            return langNames
            
        } else {
            
            let langCodes = [String](langArr.keys).sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
            return langCodes
            
        }
        
    }
    
    func autocorrect() {
        
        predictionArr.removeAll()
        correctArr.removeAll()
        
        doThingsWithButton(prediction1, true)
        doThingsWithButton(prediction2, true)
        doThingsWithButton(prediction3, true)
        
        // self.wordsBeingTyped = fullString.asNSString
        // self.lastWord = String()
        self.range = NSMakeRange(0, fullString.length)
        /* wordsBeingTyped.enumerateSubstrings(in: range, options: NSString.EnumerationOptions.byWords, using: { (substring, substringRange, enclosingRange, stop) in
            self.lastWord = substring!
        }) */
        
        let textChecker = UITextChecker()
        let checkRange = NSMakeRange(0, fullString.characters.count)
        print("missSpelledRangeFunctionBeforeCheck: ", "\(missSpelledRange.length)")
        missSpelledRange = textChecker.rangeOfMisspelledWord(in: fullString, range: checkRange, startingAt: 0, wrap: false, language: "en_US")
        print("missSpelledRangeFunction: ", "\(missSpelledRange.length)")
        
        if missSpelledRange.location != NSNotFound {
            let guesses = textChecker.guesses(forWordRange: missSpelledRange, in: fullString, language: "en_US")
            // let nsText = lastWord.asNSString
            // self.correctStr = (nsText.replacingCharacters(in: missSpelledRange, with: (guesses?.first)!))
            // nsText.replacingCharacters(in: missSpelledRange, with: correctStr)

            if let guessesFinal = guesses {
                
                if guessesFinal.count == 1 {
                    let nsText = fullString.asNSString
                    correctArr.append(nsText.replacingCharacters(in: missSpelledRange, with: guessesFinal[0]))
                    // predictionArr.append(guessesFinal[0])
                    prediction2.setTitle(guessesFinal[0], for: .normal)
                    doThingsWithButton(prediction1, true)
                    doThingsWithButton(prediction2, false)
                    doThingsWithButton(prediction3, true)
                } else if guessesFinal.count == 2 {
                    let nsText = fullString.asNSString
                    correctArr.append(nsText.replacingCharacters(in: missSpelledRange, with: guessesFinal[0]))
                    correctArr.append(nsText.replacingCharacters(in: missSpelledRange, with: guessesFinal[1]))
                    // predictionArr.append(guessesFinal[0])
                    // predictionArr.append(guessesFinal[1])
                    prediction2.setTitle(guessesFinal[0], for: .normal)
                    prediction1.setTitle(guessesFinal[1], for: .normal)
                    doThingsWithButton(prediction1, false)
                    doThingsWithButton(prediction2, false)
                    doThingsWithButton(prediction3, true)
                } else if guessesFinal.count >= 3 {
                    let nsText = fullString.asNSString
                    correctArr.append(nsText.replacingCharacters(in: missSpelledRange, with: guessesFinal[0]))
                    correctArr.append(nsText.replacingCharacters(in: missSpelledRange, with: guessesFinal[1]))
                    correctArr.append(nsText.replacingCharacters(in: missSpelledRange, with: guessesFinal[2]))
                    // predictionArr.append(guessesFinal[0])
                    // predictionArr.append(guessesFinal[1])
                    // predictionArr.append(guessesFinal[2])
                    prediction2.setTitle(guessesFinal[0], for: .normal)
                    prediction1.setTitle(guessesFinal[1], for: .normal)
                    prediction3.setTitle(guessesFinal[2], for: .normal)
                    doThingsWithButton(prediction1, false)
                    doThingsWithButton(prediction2, false)
                    doThingsWithButton(prediction3, false)
                }
                
            } else {
                print("not safely unwrapped")
            }
            
        } else {
            doThingsWithButton(prediction1, true)
            doThingsWithButton(prediction2, true)
            doThingsWithButton(prediction3, true)
        }
        
        /* let autoCom = textChecker.completions(forPartialWordRange: NSMakeRange(0, fullString.characters.count), in: fullString, language: "en_US")
        
        if autoCom?.count != 0 {
         
         if autoCom?.count == 1 {
         prediction2.setTitle(autoCom?.first!, for: .normal)
         addCorrectionToText(prediction2)
         } else if autoCom?.count == 2 {
         predictionArr.append((autoCom?[0])!)
         predictionArr.append((autoCom?[1])!)
         prediction1.setTitle((autoCom?[1])! as String, for: .normal)
         prediction2.setTitle((autoCom?.first)!, for: .normal)
         } else if (autoCom?.count)! >= 3 {
         predictionArr.append((autoCom?[0])!)
         predictionArr.append((autoCom?[1])!)
         predictionArr.append((autoCom?[2])!)
         prediction1.setTitle((autoCom?[1])! as String, for: .normal)
         prediction2.setTitle((autoCom?.first)!, for: .normal)
         prediction3.setTitle((autoCom?[2])!, for: .normal)
         }
         
         } */
        
    }
    
    func addCorrectionToText(_ sender: UIButton) {
        
        if sender == prediction2 {
            // center prediction button
            self.deleteAllText()
            self.textDocumentProxy.insertText(correctArr[0])
            self.didInsertAutocorrectText = true
            doThingsWithButton(prediction1, true)
            doThingsWithButton(prediction2, true)
            doThingsWithButton(prediction3, true)
            shouldAutoCap()
        } else if sender == prediction1 {
            // left prediction button
            self.deleteAllText()
            self.textDocumentProxy.insertText(correctArr[1])
            self.didInsertAutocorrectText = true
            doThingsWithButton(prediction1, true)
            doThingsWithButton(prediction2, true)
            doThingsWithButton(prediction3, true)
            shouldAutoCap()
        } else if sender == prediction3 {
            // right prediction button
            self.deleteAllText()
            self.textDocumentProxy.insertText(correctArr[2])
            self.didInsertAutocorrectText = true
            doThingsWithButton(prediction1, true)
            doThingsWithButton(prediction2, true)
            doThingsWithButton(prediction3, true)
            shouldAutoCap()
        }
        
    }
    
    func doThingsWithButton(_ button: UIButton, _ bool: Bool) {
        
        if bool {
            button.setTitle("", for: .normal)
            button.setTitle("", for: .disabled)
            button.isEnabled = false
        } else if bool == false {
            button.isEnabled = true
        }
        
    }
    
    func showDetailView() {
        
        if self.sendToInput.tag == 0 {
            
            self.moreDetailView.isHidden = true
            self.sendToInput.tag = 1
            self.sendToInput.isEnabled = true
            
            if self.moreDetailView.gestureRecognizers == nil || (self.moreDetailView.gestureRecognizers?.isEmpty)! {
                
            } else {
                
                self.sendToInput.addGestureRecognizer(self.tapSendToInput)
                
            }
            
            self.row1.isUserInteractionEnabled = true
            self.row1.layer.opacity = 1
            self.row2.isUserInteractionEnabled = true
            self.row2.layer.opacity = 1
            self.row3.isUserInteractionEnabled = true
            self.row3.layer.opacity = 1
            self.row4.isUserInteractionEnabled = true
            self.row4.layer.opacity = 1
            self.translateShowView.isUserInteractionEnabled = true
            self.translateShowView.layer.opacity = 1
            
        } else {
            
            self.moreDetailView.isHidden = false
            self.sendToInput.tag = 0
            self.sendToInput.isEnabled = false
            
            self.sendToInput.removeGestureRecognizer(self.tapSendToInput)
            self.moreDetailView.addGestureRecognizer(self.tapSendToInput)
            
            self.moreDetailView.isHidden = false
            self.sendToInput.tag = 0
            self.sendToInput.isEnabled = false
            self.row1.isUserInteractionEnabled = false
            self.row1.layer.opacity = 0.3
            self.row2.isUserInteractionEnabled = false
            self.row2.layer.opacity = 0.3
            self.row3.isUserInteractionEnabled = false
            self.row3.layer.opacity = 0.3
            self.row4.isUserInteractionEnabled = false
            self.row4.layer.opacity = 0.3
            self.translateShowView.isUserInteractionEnabled = false
            self.translateShowView.layer.opacity = 0.3
            
        }
        
    }
    
    func shouldAutoCap(_ sender: UIButton? = nil) {
        
        /* let newSender = sender ?? clearTranslation
        
        if textDocumentProxy.autocapitalizationType == UITextAutocapitalizationType.none {
            self.shiftStatus = 0
            self.whichAutoCap = 0
            self.shiftKeys(row1)
            self.shiftKeys(row2)
            self.shiftKeys(row3)
            print("none")
        } else if textDocumentProxy.autocapitalizationType == UITextAutocapitalizationType.allCharacters {
            self.shiftStatus = 2
            self.whichAutoCap = 1
            self.shiftKeys(row1)
            self.shiftKeys(row2)
            self.shiftKeys(row3)
            print("allCharacters")
        } else if textDocumentProxy.autocapitalizationType == UITextAutocapitalizationType.sentences {
            self.shiftStatus = 1
            self.whichAutoCap = 2
            self.shiftKeys(row1)
            self.shiftKeys(row2)
            self.shiftKeys(row3)
            print("sentences")
        } else if textDocumentProxy.autocapitalizationType == UITextAutocapitalizationType.words {
            self.shiftStatus = 1
            self.whichAutoCap = 3
            self.shiftKeys(row1)
            self.shiftKeys(row2)
            self.shiftKeys(row3)
            print("words")
        } */
        
        let concurrentQueue = DispatchQueue(label: "com.omar.Linguaboard.Translate", attributes: .concurrent)
        concurrentQueue.sync {
            self.fullString = self.fullDocumentContext()
        }
        
        if fullString.characters.count == 0 {
            self.shiftStatus = 1
            self.shiftKeys(row1)
            self.shiftKeys(row2)
            self.shiftKeys(row3)
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
    
    func clearButton(_ sender: UIButton) {
        
        self.hideView.removeTarget(self, action: #selector(self.addToText), for: .touchUpInside)
        self.hideView.addTarget(self, action: #selector(self.translateCaller), for: .touchUpInside)
        self.hideView.setImage(UIImage(named: "appLogo")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.hideView.setImage(UIImage(named: "appLogo_selected")?.withRenderingMode(.alwaysTemplate), for: .highlighted)
        
        self.sendToInput.setTitle("", for: .normal)
        self.clearTranslation.isEnabled = false 
        
    }
    
    func deleteAllText() {
        
        if let text = self.textDocumentProxy.documentContextBeforeInput {
            for _ in text.characters {
                self.textDocumentProxy.deleteBackward()
            }
        }
        
    }
    
    func longPressHandler(_ gesture: UILongPressGestureRecognizer) {
        
        if gesture.state == .began {
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleTimer(_:)), userInfo: nil, repeats: true)
            if fullString.characters.count == 0 {
                self.shiftStatus = 1
                self.shiftKeys(row1)
                self.shiftKeys(row2)
                self.shiftKeys(row3)
            }
        } else if gesture.state == .ended || gesture.state == .cancelled {
            if fullString.characters.count == 0 {
                self.shiftStatus = 1
                self.shiftKeys(row1)
                self.shiftKeys(row2)
                self.shiftKeys(row3)
            }
            timer?.invalidate()
            timer = nil
        }
    }
    
    func handleTimer(_ timer: Timer) {
        self.textDocumentProxy.deleteBackward()
        if fullString.characters.count == 0 {
            self.shiftStatus = 1
            self.shiftKeys(row1)
            self.shiftKeys(row2)
            self.shiftKeys(row3)
        }
    }
    
    func addToText() {
        
        self.hideView.setImage(UIImage(named: "appLogo")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.hideView.setImage(UIImage(named: "appLogo_selected")?.withRenderingMode(.alwaysTemplate), for: .highlighted)
        
        deleteAllText()
        self.textDocumentProxy.insertText(self.sendToInput.currentTitle!)
        self.shouldAutoCap()
        self.sendToInput.setTitle("", for: .normal)
        self.sendToInput.removeGestureRecognizer(tapSendToInput)
        self.clearTranslation.isEnabled = false
        self.hideView.removeTarget(self, action: #selector(self.addToText), for: .touchUpInside)
        self.hideView.addTarget(self, action: #selector(self.translateCaller), for: .touchUpInside)
        self.hideView.isEnabled = false
        
    }
    
    func translateCaller() {
        
        self.hideView.setImage(UIImage(named: "translateUp")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.hideView.setImage(UIImage(named: "translateUp_selected")?.withRenderingMode(.alwaysTemplate), for: .highlighted)
        
        let inputText = (textDocumentProxy.documentContextBeforeInput ?? "") + (textDocumentProxy.documentContextAfterInput ?? "")
        
        googleTranslate(inputText, "en", self.toKey)
        
        if (hideView.actions(forTarget: self, forControlEvent: .touchUpInside)!.contains("addToText")) {
            
            self.hideView.removeTarget(self, action: #selector(self.addToText), for: .touchUpInside)
            
        } else {
            
            self.hideView.removeTarget(self, action: #selector(self.translateCaller), for: .touchUpInside)
            self.hideView.addTarget(self, action: #selector(self.addToText), for: .touchUpInside)
            
        }
        
        self.clearTranslation.isEnabled = true
        
    }
    
    func googleTranslate(_ text: String, _ langFrom: String, _ langTo: String) {
        
        let spacelessString = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        Alamofire.request("https://translation.googleapis.com/language/translate/v2?key=AIzaSyAVrMMcGIKmC-PrPgQzTOGJGFIEc6MUTGw&source=\(langFrom)&target=\(langTo)&q=\(spacelessString!)").responseJSON { (Response) in
            
            if let value = Response.result.value {
                
                let json = JSON(value)
                for translation in json["data"]["translations"].arrayValue {
                    
                    let text = translation["translatedText"].stringValue
                    self.sendToInput.setTitle(text.stringByDecodingHTMLEntities, for: .normal)
                    self.moreDetailLabel.text = text.stringByDecodingHTMLEntities
                    self.sendToInput.addGestureRecognizer(self.tapSendToInput)
                    
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
