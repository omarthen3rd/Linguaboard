//
//  LinguaboardTableViewController.swift
//  Linguaboard
//
//  Created by Omar Abbasi on 2017-02-13.
//  Copyright © 2017 Omar Abbasi. All rights reserved.
//

import UIKit

class LinguaboardTableViewController: UITableViewController {

    @IBOutlet var darkModeSwitch: UISwitch!
    @IBOutlet var whiteMinimalMode: UISwitch!
    @IBOutlet var darkMinimalMode: UISwitch!
    @IBAction func darkModeAction(_ sender: Any) {
        
        if darkModeSwitch.isOn && darkModeSwitch.isEnabled {
            
            whiteMinimalMode.isEnabled = false
            darkMinimalMode.isEnabled = false
            
            darkModeBool.set(true, forKey: "darkBool")
            darkModeBool.synchronize()
            
        } else if !(darkModeSwitch.isOn) && darkModeSwitch.isEnabled {
            
            whiteMinimalMode.isEnabled = true
            darkMinimalMode.isEnabled = true
            
            darkModeBool.set(false, forKey: "darkBool")
            darkModeBool.synchronize()
            
        }
        
    }
    
    var darkModeBool: UserDefaults = UserDefaults(suiteName: "group.Linguaboard")!
    var whiteMinimalModeBool: UserDefaults = UserDefaults(suiteName: "group.Linguaboard")!
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
                darkModeSwitch.isEnabled = false
                
                whiteMinimalModeBool.set(true, forKey: "whiteMinimalBool")
                whiteMinimalModeBool.synchronize()
                
            } else if !(sender.isOn) && sender.isEnabled {
                
                print("ran white off")
                
                darkMinimalMode.isEnabled = true
                darkModeSwitch.isEnabled = true
                
                whiteMinimalModeBool.set(false, forKey: "whiteMinimalBool")
                whiteMinimalModeBool.synchronize()
                
            }
            
        } else if sender == darkMinimalMode {
            
            if sender.isOn && sender.isEnabled {
                
                print("ran dark on")
                
                whiteMinimalMode.isEnabled = false
                darkModeSwitch.isEnabled = false
                
                darkMinimalModeBool.set(true, forKey: "darkMinimalBool")
                darkMinimalModeBool.synchronize()
                
            } else if !(sender.isOn) && sender.isEnabled {
                
                print("ran dark off")
                
                whiteMinimalMode.isEnabled = true
                darkModeSwitch.isEnabled = true
                
                darkMinimalModeBool.set(false, forKey: "darkMinimalBool")
                darkMinimalModeBool.synchronize()
                
            }
            
        }
        
    }
    
    // MARK: - Table view data source

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
