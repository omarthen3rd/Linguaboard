//
//  LinguaboardTableViewController.swift
//  Linguaboard
//
//  Created by Omar Abbasi on 2017-02-13.
//  Copyright © 2017 Omar Abbasi. All rights reserved.
//

import UIKit

class LinguaboardTableViewController: UITableViewController {

    // 0 == nil
    // 1 == true
    // 2 == false
    
    @IBOutlet var darkModeSwitch: UISwitch!
    @IBOutlet var whiteMinimalMode: UISwitch!
    @IBOutlet var darkMinimalMode: UISwitch!
    @IBAction func darkModeAction(_ sender: Any) {
        
        if darkModeSwitch.isOn && darkModeSwitch.isEnabled {
            
            whiteMinimalMode.isEnabled = false
            // whiteMinimalBool.set("nil", forKey: "whiteMinimalBool")
            whiteMinimalBool.set(0, forKey: "whiteMinimalBool")
            whiteMinimalBool.synchronize()
            
            darkMinimalMode.isEnabled = false
            // darkMinimalModeBool.set("nil", forKey: "darkMinimalBool")
            darkMinimalModeBool.set(0, forKey: "darkMinimalBool")
            darkMinimalModeBool.synchronize()
            
            // darkModeBool.set("true", forKey: "darkBool")
            darkModeBool.set(1, forKey: "darkBool")
            darkModeBool.synchronize()
            
        } else if !(darkModeSwitch.isOn) && darkModeSwitch.isEnabled {
            
            whiteMinimalMode.isEnabled = true
            // whiteMinimalBool.set("nil", forKey: "whiteMinimalBool")
            whiteMinimalBool.set(0, forKey: "whiteMinimalBool")
            whiteMinimalBool.synchronize()
            
            darkMinimalMode.isEnabled = true
            // darkMinimalModeBool.set("nil", forKey: "darkMinimalBool")
            darkMinimalModeBool.set(0, forKey: "darkMinimalBool")
            darkMinimalModeBool.synchronize()
            
            // darkModeBool.set("false", forKey: "darkBool")
            darkModeBool.set(2, forKey: "darkBool")
            darkModeBool.synchronize()
            
        }
        
    }
    
    var darkModeBool: UserDefaults = UserDefaults(suiteName: "group.Linguaboard")!
    var whiteMinimalBool: UserDefaults = UserDefaults(suiteName: "group.Linguaboard")!
    var darkMinimalModeBool: UserDefaults = UserDefaults(suiteName: "group.Linguaboard")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.darkMinimalMode.addTarget(self, action: #selector(self.minimalMode(_:)), for: .touchUpInside)
        self.whiteMinimalMode.addTarget(self, action: #selector(self.minimalMode(_:)), for: .touchUpInside)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func minimalMode(_ sender: UISwitch) {
        
        if sender == whiteMinimalMode {
            
            if sender.isOn && sender.isEnabled {
                
                print("ran white on")
                
                darkMinimalMode.isEnabled = false
                // darkMinimalModeBool.set("nil", forKey: "darkMinimalBool")
                darkMinimalModeBool.set(0, forKey: "darkMinimalBool")
                darkMinimalModeBool.synchronize()
                
                darkModeSwitch.isEnabled = false
                // darkModeBool.set("nil", forKey: "darkBool")
                darkModeBool.set(0, forKey: "darkBool")
                darkModeBool.synchronize()
                
                // whiteMinimalBool.set("true", forKey: "whiteMinimalBool")
                whiteMinimalBool.set(1, forKey: "whiteMinimalBool")
                whiteMinimalBool.synchronize()
                
                
            } else if !(sender.isOn) && sender.isEnabled {
                
                print("ran white off")
                
                darkMinimalMode.isEnabled = true
                // darkMinimalModeBool.set("nil", forKey: "darkMinimalBool")
                darkMinimalModeBool.set(0, forKey: "darkMinimalBool")
                darkMinimalModeBool.synchronize()
                
                darkModeSwitch.isEnabled = true
                // darkModeBool.set("nil", forKey: "darkBool")
                darkModeBool.set(0, forKey: "darkBool")
                darkModeBool.synchronize()
                
                // whiteMinimalBool.set("false", forKey: "whiteMinimalBool")
                whiteMinimalBool.set(2, forKey: "whiteMinimalBool")
                whiteMinimalBool.synchronize()
                
                
            }
            
            
        } else if sender == darkMinimalMode {
            
            if sender.isOn && sender.isEnabled {
                
                print("ran dark on")
                
                whiteMinimalMode.isEnabled = false
                // whiteMinimalBool.set("nil", forKey: "whiteMinimalBool")
                whiteMinimalBool.set(0, forKey: "whiteMinimalBool")
                whiteMinimalBool.synchronize()
                
                darkModeSwitch.isEnabled = false
                // darkModeBool.set("nil", forKey: "darkBool")
                darkModeBool.set(0, forKey: "darkBool")
                darkModeBool.synchronize()
                
                // darkMinimalModeBool.set("true", forKey: "darkMinimalBool")
                darkMinimalModeBool.set(1, forKey: "darkMinimalBool")
                darkMinimalModeBool.synchronize()
                
            } else if !(sender.isOn) && sender.isEnabled {
                
                print("ran dark off")
                
                whiteMinimalMode.isEnabled = true
                // whiteMinimalBool.set("nil", forKey: "whiteMinimalBool")
                whiteMinimalBool.set(0, forKey: "whiteMinimalBool")
                whiteMinimalBool.synchronize()
                
                darkModeSwitch.isEnabled = true
                // darkModeBool.set("nil", forKey: "darkBool")
                darkModeBool.set(0, forKey: "darkBool")
                darkModeBool.synchronize()
                
                // darkMinimalModeBool.set("false", forKey: "darkMinimalBool")
                darkMinimalModeBool.set(2, forKey: "darkMinimalBool")
                darkMinimalModeBool.synchronize()
                
            }
            
        }
        
    }

}
