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

public extension UIView {
    
    func fadeIn(withDuration duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        })
    }
    
    func fadeOut(withDuration duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, animations: { 
            // self.bounds.origin.y += 10
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
    var expandedHeight: CGFloat = 250
    var heightConstraint: NSLayoutConstraint!
    var shouldRemoveConstraint = false
    var didOpenPicker2 = true
    var translationViewIsOpen = true
    var selectedLanguage: String = "French"
    var langKey: String = "en"
    var toKey: String = "FR"
    var lastLang: String = "FR"
    var fullString: String = ""
    var timer: Timer?
    var checker: UITextChecker = UITextChecker()
    var predictionArr: Array = [""]
    var tapSendToInput: UITapGestureRecognizer!
    var correctStr = ""
    var swipeGesture: UISwipeGestureRecognizer!
    
    var darkModeBool: UserDefaults = UserDefaults(suiteName: "group.Linguaboard")!
    var whiteMinimalModeBool: UserDefaults = UserDefaults(suiteName: "group.Linguaboard")!
    var darkMinimalModeBool: UserDefaults = UserDefaults(suiteName: "group.Linguaboard")!
    var lastUsedLanguage: UserDefaults = UserDefaults(suiteName: "group.Linguaboard")!
    
    var globalTintColor: UIColor = UIColor.white
    var altGlobalTintColor: UIColor = UIColor.darkGray
    var backgroundColor: UIColor = UIColor.clear
    
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
            sender.subviews[2].removeFromSuperview()
            sender.subviews[1].removeFromSuperview()
        }
        self.textDocumentProxy.insertText(sender.currentTitle!)
        
        self.hideView.isEnabled = true
        // createPopUp(sender, bool: false)
        // checkText(fullString)
        self.shouldAutoCap()
        autocorrect()
        self.shouldAutoCap()

        if shiftStatus == 1 {
            self.shiftKeyPressed(self.shiftButton)
        }
        
    }
    
    @IBAction func touchDownKey(_ sender: UIButton) {
        
        createPopUp(sender, bool: true)
        
    }
    
    @IBAction func returnKeyPressed(_ sender: UIButton) {
        
        self.hideView.isEnabled = true
        
        self.textDocumentProxy.insertText("\n")
        self.shouldAutoCap()
    }
    
    @IBAction func spaceKeyPressed(_ sender: UIButton) {
        
        self.hideView.isEnabled = true
        
        self.textDocumentProxy.insertText(" ")
        // checkText(fullString)
        self.shouldAutoCap()
        autocorrect()
        self.shouldAutoCap()
    }
    
    @IBAction func backSpaceButton(_ sender: UIButton) {
        
        if self.fullString.characters.count <= 1 {
            self.hideView.isEnabled = false
        } else {
            self.hideView.isEnabled = true
        }
        
        self.textDocumentProxy.deleteBackward()
        // checkText(fullString)
        self.shouldAutoCap()
        autocorrect()
        self.shouldAutoCap()
    }
    
    @IBAction func showPickerTwo(_ button: UIButton) {
        
        if didOpenPicker2 == true {
            
            row4.subviews[0].isUserInteractionEnabled = false
            row4.subviews[1].isUserInteractionEnabled = false
            row4.subviews[2].isUserInteractionEnabled = false
            row4.subviews[3].isUserInteractionEnabled = false
            translateShowView.isUserInteractionEnabled = false
            row4.subviews[0].layer.opacity = 0.3
            row4.subviews[1].layer.opacity = 0.3
            row4.subviews[2].layer.opacity = 0.3
            row4.subviews[3].layer.opacity = 0.3
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
            row4.subviews[3].isUserInteractionEnabled = true
            translateShowView.isUserInteractionEnabled = true
            row4.subviews[0].layer.opacity = 1
            row4.subviews[1].layer.opacity = 1
            row4.subviews[2].layer.opacity = 1
            row4.subviews[3].layer.opacity = 1
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
            self.altBoard.tintColor = globalTintColor
            
            self.symbolsKey.setImage(UIImage(named: "symbols")?.withRenderingMode(.alwaysTemplate), for: .normal)
            self.symbolsKey.setImage(UIImage(named: "symbols_selected")?.withRenderingMode(.alwaysTemplate), for: .highlighted)
            self.symbolsKey.tintColor = globalTintColor
            self.symbolsKey.tag = 2
            
        case 2:
            
            self.symbolsRow1.isHidden = false
            self.symbolsRow2.isHidden = false
            self.symbolsNumbersRow3.isHidden = false
            
            self.symbolsKey.tag = 1
            self.symbolsKey.setImage(UIImage(named: "altBoard")?.withRenderingMode(.alwaysTemplate), for: .normal)
            self.symbolsKey.setImage(UIImage(named: "altBoard_selected")?.withRenderingMode(.alwaysTemplate), for: .highlighted)
            self.symbolsKey.tintColor = globalTintColor
            
        default:
            
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
            self.altBoard.tintColor = globalTintColor
            
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
            self.expandedHeight = 150
            self.updateViewConstraints()
        } else if (self.view.traitCollection.verticalSizeClass == UIUserInterfaceSizeClass.regular) {
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
        
        print("didReceiveMemoryWarning")
        
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        
        self.hideView.isEnabled = true
        
        if (!(self.textDocumentProxy.documentContextBeforeInput != nil) && !(self.textDocumentProxy.documentContextAfterInput != nil)) || (self.textDocumentProxy.documentContextBeforeInput == "") && (self.textDocumentProxy.documentContextAfterInput == "") && (sendToInput.currentTitle! != "") {
            
            // self.hideView.isEnabled = true
            
        } else if (!(self.textDocumentProxy.documentContextBeforeInput != nil) && !(self.textDocumentProxy.documentContextAfterInput != nil)) || (self.textDocumentProxy.documentContextBeforeInput == "") && (self.textDocumentProxy.documentContextAfterInput == "") {
            
            self.shiftStatus = 1
            self.shiftKeys(row1)
            self.shiftKeys(row2)
            self.shiftKeys(row3)
            /* if (self.fullString != "") && (self.sendToInput.currentTitle! != "") {
                self.hideView.isEnabled = true
            } else if self.sendToInput.currentTitle == "" {
                self.hideView.isEnabled = false
            } */
            self.hideView.isEnabled = false
        }
        
    }
    
    // MARK: - Picker view data source
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let arr = whichOne(0)
        let titleData = arr[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSForegroundColorAttributeName:globalTintColor])
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
    
    func loadInterface() {
        
        let darkMode = darkModeBool.double(forKey: "darkBool")
        let whiteMinimal = whiteMinimalModeBool.double(forKey: "whiteMinimalBool")
        let darkMinimal = darkMinimalModeBool.double(forKey: "darkMinimalBool")
        
        switch darkMode {
        case 1:
            let blurEffect = UIBlurEffect.init(style: UIBlurEffectStyle.dark)
            self.blurBG.effect = blurEffect
            self.globalTintColor = UIColor.white
            self.altGlobalTintColor = UIColor.darkGray
        case 2:
            let blurEffect = UIBlurEffect.init(style: UIBlurEffectStyle.extraLight)
            self.blurBG.effect = blurEffect
            self.globalTintColor = UIColor.darkGray
            self.altGlobalTintColor = UIColor.white
        case 0:
            let blurEffect = UIBlurEffect.init(style: UIBlurEffectStyle.extraLight)
            self.blurBG.effect = blurEffect
            self.globalTintColor = UIColor.darkGray
            self.altGlobalTintColor = UIColor.white
        default:
            print("")
        }
        
        switch whiteMinimal {
        case 1:
            self.blurBG.isHidden = true
            self.view.backgroundColor = UIColor.white
            self.globalTintColor = UIColor.darkGray
            self.altGlobalTintColor = UIColor.white
        case 2:
            self.blurBG.isHidden = false
            let blurEffect = UIBlurEffect.init(style: UIBlurEffectStyle.extraLight)
            self.blurBG.effect = blurEffect
            self.globalTintColor = UIColor.darkGray
            self.altGlobalTintColor = UIColor.white
        case 0:
            print("")
        default:
            self.blurBG.isHidden = false
            let blurEffect = UIBlurEffect.init(style: UIBlurEffectStyle.extraLight)
            self.blurBG.effect = blurEffect
            self.globalTintColor = UIColor.darkGray
            self.altGlobalTintColor = UIColor.white
        }
        
        switch darkMinimal {
        case 1:
            self.blurBG.isHidden = true
            self.view.backgroundColor = UIColor.black
            self.globalTintColor = UIColor.white
            self.altGlobalTintColor = UIColor.darkGray
        case 2:
            self.blurBG.isHidden = false
            let blurEffect = UIBlurEffect.init(style: UIBlurEffectStyle.extraLight)
            self.blurBG.effect = blurEffect
            self.globalTintColor = UIColor.darkGray
            self.altGlobalTintColor = UIColor.white
        case 0:
            print("")
        default:
            self.blurBG.isHidden = false
            let blurEffect = UIBlurEffect.init(style: UIBlurEffectStyle.extraLight)
            self.blurBG.effect = blurEffect
            self.globalTintColor = UIColor.darkGray
            self.altGlobalTintColor = UIColor.white
        }
        
        self.shiftStatus = 1
        
        pickerViewTo.delegate = self
        pickerViewTo.dataSource = self
        pickerViewTo.isHidden = true
        
        moreDetailLabel.numberOfLines = 0
        
        hideView.isEnabled = false
        clearTranslation.isEnabled = false
        predictionView.isHidden = true
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

        
        // prediction/translate switching gesture
        
        swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.switchView))
        let swipeGestureDirection = UISwipeGestureRecognizerDirection.left
        swipeGesture.direction = swipeGestureDirection
        translateShowView.addGestureRecognizer(swipeGesture)
        // predictionView.addGestureRecognizer(swipeGesture)
        
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
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressHandler(_:)))
        backspaceButton.addGestureRecognizer(longPressRecognizer)
        
        // button ui
        
        for letter in self.allKeys {
            letter.layer.cornerRadius = 5
            letter.backgroundColor = altGlobalTintColor
            letter.setTitleColor(globalTintColor, for: .normal)
            letter.tintColor = globalTintColor
            letter.titleLabel?.font = UIFont.systemFont(ofSize: 22)
            if letter == sendToInput || letter == hideView {
                letter.backgroundColor = UIColor.clear
                letter.layer.cornerRadius = 0
            }
        }
        
        let longKeyHoldRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longKeyHold(_:)))
        
        for letterKey in self.keyPopKeys {
            letterKey.addTarget(self, action: #selector(self.createPopUp(_:bool:)), for: .touchDown)
            letterKey.addTarget(self, action: #selector(self.draggedButton(_:)), for: .touchDragOutside)
            letterKey.addTarget(self, action: #selector(self.draggedButton2(_:)), for: .touchDragInside)
            letterKey.addTarget(self, action: #selector(self.touchUpOutside(_:)), for: .touchUpOutside)
            letterKey.addGestureRecognizer(longKeyHoldRecognizer)
        }
        
        self.moreDetailView.backgroundColor = altGlobalTintColor
        self.moreDetailLabel.textColor = globalTintColor
        
        self.tapSendToInput = UITapGestureRecognizer(target: self, action: #selector(self.showDetailView))
        self.tapSendToInput.numberOfTapsRequired = 1
        self.tapSendToInput.numberOfTouchesRequired = 1
        self.sendToInput.addGestureRecognizer(tapSendToInput)
        self.sendToInput.tag = 1
        self.sendToInput.titleLabel?.lineBreakMode = .byTruncatingTail
        self.sendToInput.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        self.sendToInput.setTitleColor(globalTintColor, for: .normal)
        self.sendToInput.addGestureRecognizer(self.tapSendToInput)
        
        self.hideView.setImage(UIImage(named: "appLogo")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.hideView.setImage(UIImage(named: "appLogo_selected")?.withRenderingMode(.alwaysTemplate), for: .highlighted)
        self.hideView.tintColor = globalTintColor
        
        self.shiftButton.setImage(UIImage(named: "shift0_selected")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.shiftButton.tintColor = globalTintColor
        
        self.backspaceButton.setImage(UIImage(named: "bk")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.backspaceButton.setImage(UIImage(named: "bk_selected")?.withRenderingMode(.alwaysTemplate), for: .highlighted)
        self.backspaceButton.tintColor = globalTintColor
        
        self.backspaceButton2.setImage(UIImage(named: "bk")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.backspaceButton2.setImage(UIImage(named: "bk_selected")?.withRenderingMode(.alwaysTemplate), for: .highlighted)
        self.backspaceButton2.tintColor = globalTintColor
        
        self.nextKeyboardButton.setImage(UIImage(named: "otherBoard")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.nextKeyboardButton.setImage(UIImage(named: "otherBoard")?.withRenderingMode(.alwaysTemplate), for: .highlighted)
        self.nextKeyboardButton.tintColor = globalTintColor
        
        self.symbolsKey.setImage(UIImage(named: "symbols")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.symbolsKey.setImage(UIImage(named: "symbols_selected")?.withRenderingMode(.alwaysTemplate), for: .highlighted)
        self.symbolsKey.tintColor = globalTintColor
        
        self.altBoard.setImage(UIImage(named: "altBoard")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.altBoard.setImage(UIImage(named: "altBoard_selected")?.withRenderingMode(.alwaysTemplate), for: .highlighted)
        self.altBoard.tintColor = globalTintColor
        
        self.returnKey.setImage(UIImage(named: "return")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.returnKey.setImage(UIImage(named: "return_selected")?.withRenderingMode(.alwaysTemplate), for: .highlighted)
        self.returnKey.tintColor = globalTintColor
        
        self.clearTranslation.setImage(UIImage(named: "close")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.clearTranslation.setImage(UIImage(named: "close_selected")?.withRenderingMode(.alwaysTemplate), for: .highlighted)
        self.clearTranslation.tintColor = globalTintColor
        
        self.prediction1.tintColor = globalTintColor
        self.prediction2.tintColor = globalTintColor
        self.prediction3.tintColor = globalTintColor
        
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
            frame = CGRect(x: xLeft / 2, y: -50, width: sender.frame.size.width * 1.3919, height: sender.frame.size.height * 1.1071428571)
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
        
        if sender == row1.subviews[0] as? UIButton {
            frame = CGRect(x: xLeft / 2, y: -50, width: sender.frame.size.width * 1.3919, height: sender.frame.size.height * 1.1071428571)
        }
        
        let popUp = UIView(frame: frame)
        let text = UILabel()
        text.frame = frame1
        text.text = sender.currentTitle!
        text.textColor = altGlobalTintColor
        text.textAlignment = .center
        text.font = UIFont.boldSystemFont(ofSize: 30)
        text.layer.cornerRadius = 5
        text.backgroundColor = globalTintColor
        text.layer.masksToBounds = true
        popUp.backgroundColor = globalTintColor
        popUp.layer.cornerRadius = 5
        popUp.layer.shadowColor = UIColor.gray.cgColor
        popUp.layer.shadowRadius = 2
        popUp.layer.shadowOpacity = 0.1
        popUp.layer.shadowOffset = CGSize(width: 0, height: 4)
        popUp.layer.shouldRasterize = true
        popUp.layer.rasterizationScale = UIScreen.main.scale
        popUp.addSubview(text)
        sender.addSubview(popUp)
        // popUp.removeFromSuperview()
        // popUp.fadeOut(withDuration: 0.3)
        
    }
    
    func createAutoCorrectButton(_ sender: UIButton) {
        
        var frame: CGRect
        let xToUse = (sender.frame.size.width - sender.frame.size.width * 1.3919) / 2
        let xLeft = ((sender.frame.size.width - sender.frame.size.width * 1.3919) / -5)
        let xRight = ((sender.frame.size.width - sender.frame.size.width * 1.3919) * 2)
        frame = CGRect(x: xToUse, y: -50, width: sender.frame.size.width * 1.3919, height: sender.frame.size.height / 3)
        
        
    }
    
    func touchUpOutside(_ sender: UIButton) {
        
        if sender.subviews.count > 1 {
            sender.subviews[2].removeFromSuperview()
            sender.subviews[1].removeFromSuperview()
        }

        
    }
    
    func draggedButton(_ sender: UIButton) {
        
    }
    
    func draggedButton2(_ sender: UIButton) {
                
    }
    
    func switchView() {
        
        if translationViewIsOpen {
            self.translateShowView.isHidden = true
            self.predictionView.isHidden = false
            self.translationViewIsOpen = false
            self.translateShowView.removeGestureRecognizer(swipeGesture)
            self.translateShowView.addGestureRecognizer(swipeGesture)
        } else if translationViewIsOpen == false {
            self.translateShowView.isHidden = false
            self.predictionView.isHidden = true
            self.translationViewIsOpen = true
            self.predictionView.removeGestureRecognizer(swipeGesture)
            self.predictionView.addGestureRecognizer(swipeGesture)
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
    
    func autocorrect() {
        
        let textChecker = UITextChecker()
        /* let missSpelledRange = textChecker.rangeOfMisspelledWord(in: fullString, range: NSMakeRange(0, fullString.utf16.count), startingAt: 0, wrap: false, language: "en_US")
        if missSpelledRange.location != NSNotFound {
            let guesses = textChecker.guesses(forWordRange: missSpelledRange, in: fullString, language: "en_US")
            prediction2.setTitle(guesses?.first, for: .normal)
            let nsText = self.textDocumentProxy.documentContextBeforeInput as NSString?
            self.correctStr = (nsText?.replacingCharacters(in: missSpelledRange, with: (guesses?.first)!))!
            nsText?.replacingCharacters(in: missSpelledRange, with: correctStr)
            
            if guesses?.count == 1 {
                print("ran guessesCount == 1")
                addCorrectionToText(prediction2)
            } else if (guesses?.count)! == 2 {
                predictionArr.append((guesses?[0])!)
                predictionArr.append((guesses?[1])!)
                print(predictionArr)
                prediction1.setTitle((guesses?[1])! as String, for: .normal)
                prediction2.setTitle((guesses?.first)!, for: .normal)
            } else if (guesses?.count)! >= 3 {
                predictionArr.append((guesses?[0])!)
                predictionArr.append((guesses?[1])!)
                predictionArr.append((guesses?[2])!)
                print(predictionArr)
                prediction1.setTitle((guesses?[1])! as String, for: .normal)
                prediction2.setTitle((guesses?.first)!, for: .normal)
                prediction3.setTitle((guesses?[2])! as String, for: .normal)
            }
            
            
        } else {
            print("no guesses")
        } */
        
        let suggestions = textChecker.guesses(forWordRange: NSMakeRange(0, fullString.characters.count ?? 0), in: fullString, language: "en_US")
        let autoCom = textChecker.completions(forPartialWordRange: NSMakeRange(0, fullString.characters.count ?? 0), in: fullString, language: "en_US")
        print("suggestions: ", suggestions)
        if suggestions?.count == 1 {
            self.switchView()
            self.correctStr = (suggestions?.first)!
            prediction2.setTitle(suggestions?.first, for: .normal)
            // addCorrectionToText(prediction2)
        }
        print("autoCom: ", autoCom)
        
    }
    
    /* func checkText(_ text: String, bool: Bool = false) {
        
        let proxy = textDocumentProxy as UITextDocumentProxy
        var wordsBeingTyped = NSString()
        var lastWord: String!
        wordsBeingTyped = proxy.documentContextBeforeInput! as NSString
        let range = NSMakeRange(0, (wordsBeingTyped).length)
        wordsBeingTyped.enumerateSubstrings(in: range, options: NSString.EnumerationOptions.byWords) { (substring, substringRange, enclosingRange, stop) -> () in
            lastWord = substring!
        }
        
        let checkRange = NSMakeRange(0, lastWord!.utf16.count)
        
        let misspelledRange: NSRange = checker.rangeOfMisspelledWord(in: lastWord!, range: checkRange, startingAt: 0, wrap: false, language: "en_US")
        
        if misspelledRange.location != NSNotFound {
            
            let arrGuessed = checker.guesses(forWordRange: misspelledRange, in: lastWord!, language: "en_US")! as [String]
            switch arrGuessed.count {
            case 1:
                let nsText = lastWord! as NSString?
                nsText?.replacingCharacters(in: misspelledRange, with: arrGuessed[0] as String)
                print(nsText!)
                self.prediction1.setTitle("", for: .normal)
                self.prediction3.setTitle("", for: .normal)
                self.prediction2.setTitle(arrGuessed.first, for: .normal)
                self.predictionArr.append(arrGuessed.first!)
            case 2:
                let nsText = lastWord! as NSString?
                nsText?.replacingCharacters(in: misspelledRange, with: arrGuessed[0] as String)
                print(nsText!)
                self.prediction1.setTitle(arrGuessed[1], for: .normal)
                self.prediction3.setTitle("", for: .normal)
                self.prediction2.setTitle(arrGuessed.first, for: .normal)
                self.predictionArr.append(arrGuessed.first!)
                self.predictionArr.append(arrGuessed[1])
            case 3:
                let nsText = lastWord! as NSString?
                nsText?.replacingCharacters(in: misspelledRange, with: arrGuessed[0] as String)
                print(nsText!)
                if arrGuessed.count > 2 {
                    self.prediction1.setTitle(arrGuessed[1], for: .normal)
                    self.prediction2.setTitle(arrGuessed.first, for: .normal)
                    self.prediction3.setTitle(arrGuessed[2], for: .normal)
                    self.predictionArr.append(arrGuessed.first!)
                    self.predictionArr.append(arrGuessed[1])
                    self.predictionArr.append(arrGuessed[2])
                }
            default:
                print("")
            }
            
            /// let nsText = lastWord! as NSString?
            // nsText?.replacingCharacters(in: misspelledRange, with: arrGuessed[0] as String)
            // print(arrGuessed)
            // print(correctStr!)
            /* if bool == true {
                print("bool")
                let nsTextt = textDocumentProxy.documentContextBeforeInput as NSString?
                print(arrGuessed[0])
                print(nsTextt)
                nsTextt?.replacingCharacters(in: misspelledRange, with: arrGuessed[0] as String)
            } else if bool == false {
                print("!bool")
                let correctStr = nsText?.replacingCharacters(in: misspelledRange, with: arrGuessed[0] as String)
                // print(correctStr!)
            } */
            
        } else {
            self.prediction1.setTitle("", for: .normal)
            self.prediction2.setTitle("NOTHING FOUND", for: .normal)
            self.prediction3.setTitle("", for: .normal)
        }
    } */
    
    func addCorrectionToText(_ sender: UIButton) {
        
        if sender == prediction2 {
            // center prediction button
            self.deleteAllText()
            self.textDocumentProxy.insertText(correctStr)
            shouldAutoCap()
        } else if sender == prediction1 {
            // left prediction button
            self.deleteAllText()
            self.textDocumentProxy.insertText(predictionArr[1])
            shouldAutoCap()
        } else if sender == prediction3 {
            self.deleteAllText()
            self.textDocumentProxy.insertText(predictionArr[2])
            shouldAutoCap()
        }
        
        /*
        print("addCorrection Ran")
        self.deleteAllText()
        self.textDocumentProxy.insertText(correctStr)
        shouldAutoCap()
        */
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
    
    func shouldAutoCap() {
        
        let concurrentQueue = DispatchQueue(label: "com.omar.Linguaboard.Translate", attributes: .concurrent)
        concurrentQueue.sync {
            self.fullString = self.fullDocumentContext()
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
    
    func longKeyHold(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
        } else if gesture.state == .ended || gesture.state == .cancelled {
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
        self.hideView.tintColor = globalTintColor
        
        deleteAllText()
        self.textDocumentProxy.insertText(self.sendToInput.currentTitle!)
        self.shouldAutoCap()
        self.sendToInput.setTitle("", for: .normal)
        self.clearTranslation.isEnabled = false
        self.hideView.removeTarget(self, action: #selector(self.addToText), for: .touchUpInside)
        self.hideView.addTarget(self, action: #selector(self.translateCaller), for: .touchUpInside)
        self.hideView.isEnabled = false
        
    }
    
    func translateCaller() {
        
        self.hideView.setImage(UIImage(named: "translateUp")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.hideView.setImage(UIImage(named: "translateUp_selected")?.withRenderingMode(.alwaysTemplate), for: .highlighted)
        
        let inputText = (textDocumentProxy.documentContextBeforeInput ?? "") + (textDocumentProxy.documentContextAfterInput ?? "")
        
        // detectLanguage(inputText)
        googleTranslate(inputText, "en", self.toKey)
        
        if (hideView.actions(forTarget: self, forControlEvent: .touchUpInside)!.contains("addToText")) {
            
            self.hideView.removeTarget(self, action: #selector(self.addToText), for: .touchUpInside)
            
        } else {
            
            self.hideView.removeTarget(self, action: #selector(self.translateCaller), for: .touchUpInside)
            self.hideView.addTarget(self, action: #selector(self.addToText), for: .touchUpInside)
            
        }
        
        self.clearTranslation.isEnabled = true
        
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
                    self.moreDetailLabel.text = text.stringByDecodingHTMLEntities
                    
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
