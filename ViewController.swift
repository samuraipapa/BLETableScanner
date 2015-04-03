//
//  ViewController.swift
//  BLETableScanner
//
//  Created by GrownYoda on 4/3/15.
//  Copyright (c) 2015 yuryg. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    var myPeripheralArray = ["Peripherial 1","Peripherial 2", "Peripherial 3"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 2
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return myPeripheralArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier("near", forIndexPath: indexPath) as UITableViewCell
            cell.textLabel?.text = myPeripheralArray[indexPath.row]
            return cell
            
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("far", forIndexPath: indexPath) as UITableViewCell
            cell.textLabel?.text = myPeripheralArray[indexPath.row]
            return cell
            
        }


        // Configure the cell...
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Close By"
        }else{
            return "Far Away"
        }
    }
    


    @IBOutlet weak var refresh: UIButton!
    
    @IBAction func refreshed(sender: UIButton) {
        
        myPeripheralArray.append("Hay Hay Hay")
        tableView.reloadData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    
    
    
    
    
}
