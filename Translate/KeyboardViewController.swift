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
import AudioToolbox

extension String {
    
    var length: Int {
        return (self as NSString).length
    }
    
    var asNSString: NSString {
        return (self as NSString)
    }
    
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
}

extension String.Index{
    
    func predecessor(in string:String) -> String.Index{
        return string.index(before: self)
    }
    
}

extension UIButton {
    
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        let padding = CGFloat(2.75)
        let extendedBounds = bounds.insetBy(dx: -padding, dy: -padding)
        return extendedBounds.contains(point)
    }
    
}

extension UIColor {
    
    class func blueishGray() -> UIColor {
        // CACDD0
        return UIColor(red:0.80, green:0.80, blue:0.82, alpha:1.0)
    }
    
    class func lighterBlack() -> UIColor {
        // 2C2C2C
        return UIColor(red:0.17, green:0.17, blue:0.17, alpha:1.0)
    }
    
    class func evenLighterGray() -> UIColor {
        // 6C6C6C @ 0.75
        return UIColor(red:0.42, green:0.42, blue:0.42, alpha:0.8)
    }
    
    class func veryDifferentWhite() -> UIColor {
        // FAFAFA
        return UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
    }
    
    class func grayShadow() -> UIColor {
        // 909090
        return UIColor(red:0.56, green:0.56, blue:0.56, alpha:1.0)
    }
    
    class func darkerGrayShadow() -> UIColor {
        // 232323
        return UIColor(red:0.14, green:0.14, blue:0.14, alpha:0.5)
    }
    
    class func altDarkKeyColor() -> UIColor {
        // 686868 @ 0.40
        return UIColor(red:0.41, green:0.41, blue:0.41, alpha:0.4)
    }
    
    class func darkKeyColor() -> UIColor {
        // 808080 @ 0.85
        return UIColor(red:0.50, green:0.50, blue:0.50, alpha:0.85)
    }
    
    class func darkKeyColor2() -> UIColor {
        // 808080 @ 0.80
        return UIColor(red:0.50, green:0.50, blue:0.50, alpha:0.80)
    }
    
    class func altWhiteKeyColor() -> UIColor {
        // B2B7BC
        // return UIColor(red:0.70, green:0.72, blue:0.74, alpha:1.0)
        // 9DA2A8
        return UIColor(red:0.62, green:0.64, blue:0.66, alpha:1.0)
    }
    
    class func whiteKeyColor() -> UIColor {
        // FAFAFA
        return UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
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
    var isAlphaNumeric = false
    var selectedLanguage: String = "French"
    var langKey: String = "en"
    var toKey: String = "FR"
    var lastLang: String = "FR"
    var fullString = String()
    var fullNSString = NSString()
    var timer: Timer?
    var tapSendToInput: UITapGestureRecognizer!
    var spaceDoubleTap = UITapGestureRecognizer()
    var longPressRecognizer = UILongPressGestureRecognizer()
    var didInsertAutocorrectText = false
    
    var correctArr = [String]()
    var misSpelledRange = NSRange()
    var lastWord = String()
    var subsRange = NSRange()
    
    var darkModeBool: UserDefaults = UserDefaults(suiteName: "group.Linguaboard")!
    var whiteMinimalModeBool: UserDefaults = UserDefaults(suiteName: "group.Linguaboard")!
    var darkMinimalModeBool: UserDefaults = UserDefaults(suiteName: "group.Linguaboard")!
    var keyBackgroundBool: UserDefaults = UserDefaults(suiteName: "group.Linguaboard")!
    var spaceDoubleTapBool: UserDefaults = UserDefaults(suiteName: "group.Linguaboard")!
    var lastUsedLanguage: UserDefaults = UserDefaults(suiteName: "group.Linguaboard")!

    var keyBackgroundColor = UIColor()
    var altKeyBackgroundColor = UIColor()
    var keyTextColor = UIColor()
    var keyPopUpColor = UIColor()
    var keyPopUpTextColor = UIColor()
    var bgColor = UIColor()
    var blurEffect = UIBlurEffect()
    var keyShadowColor = UIColor.clear
    var altKeyShadowColor = UIColor.clear
    
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
    // sendToInput is btn for view translationg (too lazy to change name)
    @IBOutlet var sendToInput: UIButton!
    // hideView is btn for inserting translation (I know, I know...)
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
        self.shiftKeys()
        
    }
    
    @IBAction func keyPressed(_ sender: UIButton) {
        
        if sender.subviews.count > 1 {
            sender.subviews[1].removeFromSuperview()
        }
        self.textDocumentProxy.insertText(sender.currentTitle!)
        self.isAlphaNumeric = true
        self.shouldAutoCap()
        self.setCapsIfNeeded()
        getAutocorrect()
        self.hideView.isEnabled = true

        /* if shiftStatus == 1 {
            self.shiftKeyPressed(self.shiftButton)
        } */
        
    }
    
    @IBAction func touchDownKey(_ sender: UIButton) {
        
        createPopUp(sender, bool: true)
        
    }
    
    @IBAction func returnKeyPressed(_ sender: UIButton) {
        
        self.hideView.isEnabled = true
        getAutocorrect()
        self.textDocumentProxy.insertText("\n")
        self.shouldAutoCap()
        self.setCapsIfNeeded()
        
    }
    
    @IBAction func spaceKeyPressed(_ sender: UIButton) {
        
        self.hideView.isEnabled = true
        
        self.textDocumentProxy.insertText(" ")
        self.shouldAutoCap()
        self.setCapsIfNeeded()
        getAutocorrect()
        
        if (didInsertAutocorrectText == false && correctArr.count > 0) {
            
            insertAutocorrect(prediction2)
            didInsertAutocorrectText = true
            
        } else if misSpelledRange.length > 0 {
            
            self.misSpelledRange.length -= self.misSpelledRange.length
            getAutocorrect()
            self.correctArr.removeAll()
            doThingsWithButton(prediction1, true)
            doThingsWithButton(prediction2, true)
            doThingsWithButton(prediction3, true)
            
        } else if didInsertAutocorrectText == true && correctArr.count == 0 {
            
            didInsertAutocorrectText = false
            
        }
        
        if !(altBoard.tag == 1 || altBoard.tag == 2) {
            altBoard.tag = 0
            switchKeyBoardMode(self.altBoard)
        }
        
    }
    
    @IBAction func backSpaceButton(_ sender: UIButton) {
        
        if self.fullString.characters.count <= 1 {
            self.hideView.isEnabled = false
            self.isAlphaNumeric = false
            // remove spacebar double tap here only if added
        } else {
            self.hideView.isEnabled = true
        }
        
        self.textDocumentProxy.deleteBackward()
        self.shouldAutoCap()
        self.setCapsIfNeeded()
        getAutocorrect()
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
            altBoard.tag = 0
            switchKeyBoardMode(altBoard)
            
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
            
            // numbers view
            
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
            
            // symbols
            
            self.backspaceButton.removeGestureRecognizer(longPressRecognizer)
            self.backspaceButton2.addGestureRecognizer(longPressRecognizer)
            
            self.symbolsRow1.isHidden = false
            self.symbolsRow2.isHidden = false
            self.symbolsNumbersRow3.isHidden = false
            
            self.symbolsKey.tag = 1
            self.symbolsKey.setImage(UIImage(named: "altBoard")?.withRenderingMode(.alwaysTemplate), for: .normal)
            self.symbolsKey.setImage(UIImage(named: "altBoard_selected")?.withRenderingMode(.alwaysTemplate), for: .highlighted)
            
        default:
            
            // default row
            
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
        
        if !shouldRemoveConstraint {
            
            self.view?.addConstraint(self.heightConstraint)
            
        } else {
            
            self.view.removeConstraint(self.heightConstraint)
            heightConstraint = NSLayoutConstraint(item: self.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: expandedHeight)
            self.view.addConstraint(self.heightConstraint)
            
        }
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if (self.view.traitCollection.verticalSizeClass == UIUserInterfaceSizeClass.compact) {
            self.expandedHeight = 240
            self.shouldRemoveConstraint = true
            self.updateViewConstraints()
            loadInterface()
        } else if (self.view.traitCollection.verticalSizeClass == UIUserInterfaceSizeClass.regular) {
            self.expandedHeight = 270
            self.updateViewConstraints()
            self.shouldRemoveConstraint = true
            loadInterface()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        heightConstraint = NSLayoutConstraint(item: self.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: expandedHeight)
        heightConstraint.priority = 999.0
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
        
        if (!(self.textDocumentProxy.documentContextBeforeInput != nil) && !(self.textDocumentProxy.documentContextAfterInput != nil)) || (self.textDocumentProxy.documentContextBeforeInput == "") && (self.textDocumentProxy.documentContextAfterInput == "") && (sendToInput.currentTitle! != "") {
            
            
            if (fullString.characters.count != 0) && (sendToInput.currentTitle! != "") {
                self.hideView.isEnabled = true
            } else {
                self.correctArr.removeAll()
                doThingsWithButton(prediction1, true)
                doThingsWithButton(prediction2, true)
                doThingsWithButton(prediction3, true)
                self.hideView.isEnabled = false
            }
            
        } else if (!(self.textDocumentProxy.documentContextBeforeInput != nil) && !(self.textDocumentProxy.documentContextAfterInput != nil)) || (self.textDocumentProxy.documentContextBeforeInput == "") && (self.textDocumentProxy.documentContextAfterInput == "") {
            
            self.shiftStatus = 1
            self.shiftKeys()
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
        let spaceDoubleTapDouble = spaceDoubleTapBool.double(forKey: "spaceDoubleTapBool")
        
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
        
        self.prediction2.addTarget(self, action: #selector(self.insertAutocorrect(_:)), for: .touchUpInside)
        self.prediction1.addTarget(self, action: #selector(self.insertAutocorrect(_:)), for: .touchUpInside)
        self.prediction3.addTarget(self, action: #selector(self.insertAutocorrect(_:)), for: .touchUpInside)
        
        // spaceDoubleTap initializers
        
        spaceDoubleTap = UITapGestureRecognizer(target: self, action: #selector(self.spaceKeyDoubleTapped(_:)))
        spaceDoubleTap.numberOfTapsRequired = 2
        spaceDoubleTap.delaysTouchesEnded = false
        
        if spaceDoubleTapDouble == 1 {
            self.spaceButton.addGestureRecognizer(spaceDoubleTap)
        }
        
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
        
        if !fullAccessIsEnabled() {
            hideView.isEnabled = false
            clearTranslation.isEnabled = false
            sendToInput.isEnabled = false
            sendToInput.setTitle("Please Enable Full Access", for: .disabled)
        }
        
     
    }
    
    func fullAccessIsEnabled() -> Bool {
        var hasFullAccess = false
        if #available(iOSApplicationExtension 10.0, *) {
            let pasty = UIPasteboard.general
            if pasty.hasURLs || pasty.hasColors || pasty.hasStrings || pasty.hasImages {
                hasFullAccess = true
            } else {
                pasty.string = "TEST"
                if pasty.hasStrings {
                    hasFullAccess = true
                    pasty.string = ""
                }
            }
        } else {
            // Fallback on earlier versions
            var clippy : UIPasteboard?
            clippy = UIPasteboard.general
            if clippy != nil {
                hasFullAccess = true
            }
        }
        return hasFullAccess
    }
    
    func setColours() {
        
        let keyBackground = keyBackgroundBool.double(forKey: "keyBackgroundBool")
        
        if keyBackground == 1 {
            
            for letter in self.allKeys {
                letter.addTarget(self, action: #selector(self.playKeySound), for: .touchDown)
                letter.layer.cornerRadius = 6
                letter.layer.shadowColor = keyShadowColor.cgColor
                letter.layer.shadowOffset = CGSize(width: 0, height: 0.4)
                letter.layer.shadowRadius = 0.5
                letter.layer.shadowOpacity = 0.5
                letter.layer.shadowPath = UIBezierPath(roundedRect: letter.bounds, cornerRadius: 6).cgPath
                letter.backgroundColor = keyBackgroundColor
                letter.setTitleColor(keyTextColor, for: .normal)
                letter.tintColor = keyTextColor
                letter.titleLabel?.font = UIFont.systemFont(ofSize: 21)
                if letter == sendToInput || letter == hideView || letter == clearTranslation {
                    letter.backgroundColor = UIColor.clear
                    letter.layer.cornerRadius = 0
                    letter.layer.shadowOpacity = 0.0
                }
            }
            
            self.shiftButton.backgroundColor = altKeyBackgroundColor
            self.shiftButton.layer.shadowColor = altKeyShadowColor.cgColor
            self.backspaceButton.backgroundColor = altKeyBackgroundColor
            self.backspaceButton.layer.shadowColor = altKeyShadowColor.cgColor
            self.backspaceButton2.backgroundColor = altKeyBackgroundColor
            self.backspaceButton2.layer.shadowColor = altKeyShadowColor.cgColor
            self.nextKeyboardButton.backgroundColor = altKeyBackgroundColor
            self.nextKeyboardButton.layer.shadowColor = altKeyShadowColor.cgColor
            self.symbolsKey.backgroundColor = altKeyBackgroundColor
            self.symbolsKey.layer.shadowColor = altKeyShadowColor.cgColor
            self.altBoard.backgroundColor = altKeyBackgroundColor
            self.altBoard.layer.shadowColor = altKeyShadowColor.cgColor
            self.returnKey.backgroundColor = altKeyBackgroundColor
            self.returnKey.layer.shadowColor = altKeyShadowColor.cgColor
            self.showPickerBtn.backgroundColor = altKeyBackgroundColor
            self.showPickerBtn.layer.shadowColor = altKeyShadowColor.cgColor
            
            /* if !(blurBG.isHidden) {
                self.blurBG.alpha = 0.7
                for letter in self.allKeys {
                    letter.backgroundColor = UIColor.clear
                }
            } */
            
        } else if keyBackground == 2 {
            
            for letter in self.allKeys {
                letter.addTarget(self, action: #selector(self.playKeySound), for: .touchDown)
                letter.backgroundColor = UIColor.clear
                letter.setTitleColor(keyTextColor, for: .normal)
                letter.tintColor = keyTextColor
                letter.titleLabel?.font = UIFont.systemFont(ofSize: 21)
                if letter == sendToInput || letter == hideView || letter == clearTranslation {
                    letter.backgroundColor = UIColor.clear
                    letter.layer.cornerRadius = 0
                }
            }
            
            self.shiftButton.backgroundColor = UIColor.clear
            self.backspaceButton.backgroundColor = UIColor.clear
            self.backspaceButton2.backgroundColor = UIColor.clear
            self.nextKeyboardButton.backgroundColor = UIColor.clear
            self.symbolsKey.backgroundColor = UIColor.clear
            self.altBoard.backgroundColor = UIColor.clear
            self.returnKey.backgroundColor = UIColor.clear
            self.showPickerBtn.backgroundColor = UIColor.clear
            
        } else {
            
            for letter in self.allKeys {
                letter.addTarget(self, action: #selector(self.playKeySound), for: .touchDown)
                letter.backgroundColor = UIColor.clear
                letter.setTitleColor(keyTextColor, for: .normal)
                letter.tintColor = keyTextColor
                letter.titleLabel?.font = UIFont.systemFont(ofSize: 21)
                if letter == sendToInput || letter == hideView || letter == clearTranslation{
                    letter.backgroundColor = UIColor.clear
                    letter.layer.cornerRadius = 0
                }
            }
            
            self.shiftButton.backgroundColor = UIColor.clear
            self.backspaceButton.backgroundColor = UIColor.clear
            self.backspaceButton2.backgroundColor = UIColor.clear
            self.nextKeyboardButton.backgroundColor = UIColor.clear
            self.symbolsKey.backgroundColor = UIColor.clear
            self.altBoard.backgroundColor = UIColor.clear
            self.returnKey.backgroundColor = UIColor.clear
            self.showPickerBtn.backgroundColor = UIColor.clear
            
        }

        self.view.backgroundColor = bgColor
        self.blurBG.effect = blurEffect
        self.hideView.tintColor = keyTextColor
        self.shiftButton.tintColor = keyTextColor
        self.backspaceButton.tintColor = keyTextColor
        self.backspaceButton2.tintColor = keyTextColor
        self.nextKeyboardButton.tintColor = keyTextColor
        self.symbolsKey.tintColor = keyTextColor
        self.altBoard.tintColor = keyTextColor
        self.returnKey.tintColor = keyTextColor
        self.showPickerBtn.tintColor = keyTextColor
        
        self.sendToInput.setTitleColor(keyTextColor, for: .normal)
        self.prediction1.setTitleColor(keyTextColor, for: .normal)
        self.prediction2.setTitleColor(keyTextColor, for: .normal)
        self.prediction3.setTitleColor(keyTextColor, for: .normal)
        self.moreDetailView.backgroundColor = keyTextColor
        self.moreDetailLabel.textColor = keyBackgroundColor
        
    }
    
    func loadColours(_ thingToLoad: String) {
        
        if thingToLoad == "darkMode" {
            // dark blur mode
            self.keyBackgroundColor = UIColor.darkKeyColor()
            self.altKeyBackgroundColor = UIColor.altDarkKeyColor()
            self.keyTextColor = UIColor.veryDifferentWhite()
            self.keyShadowColor = UIColor.clear
            self.keyPopUpColor = UIColor.veryDifferentWhite()
            self.keyPopUpTextColor = UIColor.lighterBlack()
            self.bgColor = UIColor.clear
            self.blurEffect = UIBlurEffect.init(style: UIBlurEffectStyle.dark)
            self.blurBG.isHidden = false
        } else if thingToLoad == "darkMinimal" {
            self.keyBackgroundColor = UIColor.darkKeyColor()
            self.altKeyBackgroundColor = UIColor.altDarkKeyColor()
            self.keyTextColor = UIColor.veryDifferentWhite()
            self.keyShadowColor = UIColor.darkerGrayShadow()
            self.keyPopUpColor = UIColor.veryDifferentWhite()
            self.keyPopUpTextColor = UIColor.lighterBlack()
            self.bgColor = UIColor.lighterBlack()
            self.blurBG.isHidden = true
        } else if thingToLoad == "whiteMinimal" {
            self.keyBackgroundColor = UIColor.whiteKeyColor()
            self.altKeyBackgroundColor = UIColor.altWhiteKeyColor()
            self.keyTextColor = UIColor.lighterBlack()
            self.keyShadowColor = UIColor.grayShadow()
            self.altKeyShadowColor = UIColor.darkerGrayShadow()
            self.keyPopUpColor = UIColor.lighterBlack()
            self.keyPopUpTextColor = UIColor.blueishGray()
            self.bgColor = UIColor.blueishGray()
            self.blurBG.isHidden = true
        } else if thingToLoad == "whiteMode" {
            // white blur mode
            self.keyBackgroundColor = UIColor.veryDifferentWhite()
            self.altKeyBackgroundColor = UIColor.altWhiteKeyColor()
            self.keyTextColor = UIColor.lighterBlack()
            self.keyShadowColor = UIColor.grayShadow()
            self.altKeyShadowColor = UIColor.darkerGrayShadow()
            self.keyPopUpColor = UIColor.lighterBlack()
            self.keyPopUpTextColor = UIColor.veryDifferentWhite()
            self.bgColor = UIColor.clear
            self.blurEffect = UIBlurEffect.init(style: UIBlurEffectStyle.extraLight)
            self.blurBG.isHidden = false
        }
        
    }
    
    func createPopUp(_ sender: UIButton, bool: Bool) {
        
        var frame: CGRect
        var frame1: CGRect
        let xToUse = (sender.frame.size.width - sender.frame.size.width * 1.4) / 2
        let xLeft = ((sender.frame.size.width - sender.frame.size.width * 1.4) / -5)
        let xRight = ((sender.frame.size.width - sender.frame.size.width * 1.4) * 2)
        // old frame height == 1.11
        frame = CGRect(x: xToUse, y: -60, width: sender.frame.size.width * 1.4, height: sender.frame.size.height * 1.4)
        frame1 = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        
        switch sender {
        case row1.subviews[0]:
            frame = CGRect(x: sender.bounds.origin.x / 2, y: -60, width: sender.frame.size.width * 1.4, height: sender.frame.size.height * 1.4)
        case numbersRow1.subviews[0]:
            frame = CGRect(x: xLeft / 2, y: -60, width: sender.frame.size.width * 1.4, height: sender.frame.size.height * 1.4)
        case numbersRow2.subviews[0]:
            frame = CGRect(x: xLeft / 2, y: -60, width: sender.frame.size.width * 1.4, height: sender.frame.size.height * 1.4)
        case symbolsRow1.subviews[0]:
            frame = CGRect(x: xLeft / 2, y: -60, width: sender.frame.size.width * 1.4, height: sender.frame.size.height * 1.4)
        case symbolsRow2.subviews[0]:
            frame = CGRect(x: xLeft / 2, y: -60, width: sender.frame.size.width * 1.4, height: sender.frame.size.height * 1.4)
        case row1.subviews[9]:
            frame = CGRect(x: xRight / 2, y: -60, width: sender.frame.size.width * 1.4, height: sender.frame.size.height * 1.4)
        case numbersRow1.subviews[9]:
            frame = CGRect(x: xRight / 2, y: -60, width: sender.frame.size.width * 1.4, height: sender.frame.size.height * 1.4)
        case numbersRow2.subviews[9]:
            frame = CGRect(x: xRight / 2, y: -60, width: sender.frame.size.width * 1.4, height: sender.frame.size.height * 1.4)
        case symbolsRow1.subviews[9]:
            frame = CGRect(x: xRight / 2, y: -60, width: sender.frame.size.width * 1.4, height: sender.frame.size.height * 1.4)
        case symbolsRow2.subviews[9]:
            frame = CGRect(x: xRight / 2, y: -60, width: sender.frame.size.width * 1.4, height: sender.frame.size.height * 1.4)
        default:
            frame = CGRect(x: xToUse, y: -60, width: sender.frame.size.width * 1.4, height: sender.frame.size.height * 1.4)
        }
        
        let popUp = UIView(frame: frame)
        let text = UILabel()
        text.frame = frame1
        text.text = sender.currentTitle!
        text.textColor = keyBackgroundColor
        text.textAlignment = .center
        text.font = UIFont.systemFont(ofSize: 30, weight: UIFontWeightSemibold)
        text.layer.cornerRadius = 8
        text.backgroundColor = keyPopUpColor
        text.layer.masksToBounds = true
        popUp.backgroundColor = keyPopUpColor
        popUp.layer.cornerRadius = 8
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
    
    func whichOne(_ int: Int) -> Array<String> {
        
        if int == 0 {
            
            let langNames = [String](langArr.values).sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
            return langNames
            
        } else {
            
            let langCodes = [String](langArr.keys).sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
            return langCodes
            
        }
        
    }
    
    func getAutocorrect() {
        
        // TODO
        // Cursor position (look into fullDocumentContext func)
        
        correctArr.removeAll()
        doThingsWithButton(prediction1, true)
        doThingsWithButton(prediction2, true)
        doThingsWithButton(prediction3, true)
        
        let checker = UITextChecker()
        let range = NSMakeRange(0, fullNSString.length)
        
        fullNSString.enumerateSubstrings(in: range, options: .byWords) { (substring, substringRange, enclosingRange, stop) in
            
            self.subsRange = substringRange
            self.lastWord = substring!
            
        }
        
        misSpelledRange = checker.rangeOfMisspelledWord(in: lastWord, range: NSRange(0..<lastWord.utf16.count), startingAt: 0, wrap: false, language: "en_US")
        
        if misSpelledRange.location != NSNotFound {
            
            let guesses = checker.guesses(forWordRange: misSpelledRange, in: self.lastWord, language: "en_US")
            
            if let guessesFinal = guesses {
                
                switch guessesFinal.count {
                case 1:
                    correctArr.append(guessesFinal[0])
                    prediction2.setTitle(guessesFinal[0], for: .normal)
                    doThingsWithButton(prediction1, true)
                    doThingsWithButton(prediction2, false)
                    doThingsWithButton(prediction3, true)
                case 2:
                    correctArr.append(guessesFinal[0])
                    correctArr.append(guessesFinal[1])
                    prediction2.setTitle(guessesFinal[0], for: .normal)
                    prediction1.setTitle(guessesFinal[1], for: .normal)
                    doThingsWithButton(prediction1, false)
                    doThingsWithButton(prediction2, false)
                    doThingsWithButton(prediction3, true)
                case _ where guessesFinal.count >= 3:
                    correctArr.append(guessesFinal[0])
                    correctArr.append(guessesFinal[1])
                    correctArr.append(guessesFinal[2])
                    prediction2.setTitle(guessesFinal[0], for: .normal)
                    prediction1.setTitle(guessesFinal[1], for: .normal)
                    prediction3.setTitle(guessesFinal[2], for: .normal)
                    doThingsWithButton(prediction1, false)
                    doThingsWithButton(prediction2, false)
                    doThingsWithButton(prediction3, false)
                default:
                    break
                }
                
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
    
    func insertAutocorrect(_ sender: UIButton) {
        
        switch sender {
        case prediction1:
            // left prediction button
            let correctStr = fullNSString.replacingCharacters(in: self.subsRange, with: correctArr[1])
            deleteAllText()
            textDocumentProxy.insertText(correctStr)
            self.didInsertAutocorrectText = true
            doThingsWithButton(prediction1, true)
            doThingsWithButton(prediction2, true)
            doThingsWithButton(prediction3, true)
            shouldAutoCap()
        case prediction2:
            // center prediction button
            let correctStr = fullNSString.replacingCharacters(in: self.subsRange, with: correctArr[0])
            deleteAllText()
            textDocumentProxy.insertText(correctStr)
            self.didInsertAutocorrectText = true
            doThingsWithButton(prediction1, true)
            doThingsWithButton(prediction2, true)
            doThingsWithButton(prediction3, true)
            shouldAutoCap()
        case prediction3:
            // right prediction button
            let correctStr = fullNSString.replacingCharacters(in: self.subsRange, with: correctArr[2])
            deleteAllText()
            textDocumentProxy.insertText(correctStr)
            self.didInsertAutocorrectText = true
            doThingsWithButton(prediction1, true)
            doThingsWithButton(prediction2, true)
            doThingsWithButton(prediction3, true)
            shouldAutoCap()
        default:
            break
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
            self.row1.layer.opacity = 0.1
            self.row2.isUserInteractionEnabled = false
            self.row2.layer.opacity = 0.1
            self.row3.isUserInteractionEnabled = false
            self.row3.layer.opacity = 0.1
            self.row4.isUserInteractionEnabled = false
            self.row4.layer.opacity = 0.1
            self.translateShowView.isUserInteractionEnabled = false
            self.translateShowView.layer.opacity = 0.1
            
        }
        
    }
    
    func setCapsIfNeeded() -> Bool {
        
        if self.shouldAutoCap() {
            switch self.shiftStatus {
            case 0:
                // 0 = off/disabled
                self.shiftStatus = 1
                self.shiftKeys()
            case 1:
                // 1 = on/enabled
                self.shiftStatus = 1
                self.shiftKeys()
            case 2:
                // 2 = locked
                self.shiftStatus = 2
                self.shiftKeys()
            default:
                self.shiftStatus = 1
                self.shiftKeys()
            }
            
            return true
            
        } else {
            switch self.shiftStatus {
            case 0:
                // 0 = off/disabled
                self.shiftStatus = 0
                self.shiftKeys()
            case 1:
                // 1 = on/enabled
                self.shiftStatus = 0
                self.shiftKeys()
            case 2:
                // 2 = locked
                self.shiftStatus = 2
                self.shiftKeys()
            default:
                self.shiftStatus = 0
                self.shiftKeys()
            }
            
            return false
            
        }
        
    }
    
    func shouldAutoCap() -> Bool {
        
        let concurrentQueue = DispatchQueue(label: "com.omar.Linguaboard.Translate", attributes: .concurrent)
        concurrentQueue.sync {
            self.fullString = self.fullDocumentContext()
            self.fullNSString = NSString(string: self.fullDocumentContext())
        }
        
        if fullString.characters.count == 0 {
            self.shiftStatus = 1
            self.shiftKeys()
        }
        
        let traits = self.textDocumentProxy
        
        if let autoCap = traits.autocapitalizationType {
            let docProxy = self.textDocumentProxy
            
            switch autoCap {
            case .none:
                return false
            case .words:
                if let beforeContext = docProxy.documentContextBeforeInput {
                    let previousCharacter = beforeContext[beforeContext.index(before: beforeContext.endIndex)]
                    return self.charIsWhitespace(previousCharacter)
                } else {
                    return true
                }
            case .sentences:
                if let beforeContext = docProxy.documentContextBeforeInput {
                    let offset = min(3, beforeContext.characters.count)
                    var index = beforeContext.endIndex
                    
                    for i in 0 ..< offset {
                        index = index.predecessor(in: beforeContext)
                        let char = beforeContext[index]
                        
                        if charIsPunctuation(char) {
                            if i == 0 {
                                return true
                            } else {
                                return true
                            }
                        } else {
                            if !charIsWhitespace(char) {
                                return false
                            } else if charIsNewline(char) {
                                return true
                            }
                            
                        }
                        
                    }
                    
                    return true
                    
                } else {
                    return true
                }
            
            case .allCharacters:
                return true
                
            default:
                return false
            }
        } else {
            return false
        }
        
    }
    
    func playKeySound() {
        
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                if self.fullAccessIsEnabled() {
                    AudioServicesPlaySystemSound(1104)
                }
            }
        }
        
    }
    
    func charIsNewline(_ char: Character) -> Bool {
        return (char == "\n") || (char == "\r")
    }
    
    func charIsWhitespace(_ char: Character) -> Bool {
        return (char == " ") || (char == "\n") || (char == "\r") || (char == "\t")
    }
    
    func charIsPunctuation(_ char: Character) -> Bool {
        return (char == ".") || (char == "!") || (char == "?")
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
        } else if gesture.state == .ended || gesture.state == .cancelled {
            timer?.invalidate()
            timer = nil
        }
    }
    
    func handleTimer(_ timer: Timer) {
        self.textDocumentProxy.deleteBackward()
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
    
    func dragMoving(_ c: UIControl, withEvent event: Any) {
        // TODO drag from key-to-key
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
        self.shiftKeys()
        
    }
    
    func shiftKeys() {
        
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
