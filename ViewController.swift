//
//  ViewController.swift
//  BLETableScanner
//
//  Created by GrownYoda on 4/3/15.
//  Copyright (c) 2015 yuryg. All rights reserved.
//

import UIKit
import CoreBluetooth


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CBCentralManagerDelegate, CBPeripheralDelegate {

    // BLE Stuff
    let myCentralManager = CBCentralManager()
    var peripheralArray = [CBPeripheral]() // create now empty array.

    var myPeripheralArray = ["Peripherial 1","Peripherial 2", "Peripherial 3"]
    
    var formatedForCell = [("Title","SubTitle")]
    

    // UI Stuff
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelStatus: UILabel!
 
    
    
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
    


    
    // Mark   CBCentralManager Methods
    
    func centralManagerDidUpdateState(central: CBCentralManager!) {
        
        updateStatusLabel("centralManagerDidUpdateState")
        
        /*
        typedef enum {
        CBCentralManagerStateUnknown  = 0,
        CBCentralManagerStateResetting ,
        CBCentralManagerStateUnsupported ,
        CBCentralManagerStateUnauthorized ,
        CBCentralManagerStatePoweredOff ,
        CBCentralManagerStatePoweredOn ,
        } CBCentralManagerState;
        */
        switch central.state{
        case .PoweredOn:
            updateStatusLabel("poweredOn")
            
            
        case .PoweredOff:
            updateStatusLabel("Central State PoweredOFF")
            
        case .Resetting:
            updateStatusLabel("Central State Resetting")
            
        case .Unauthorized:
            updateStatusLabel("Central State Unauthorized")
            
        case .Unknown:
            updateStatusLabel("Central State Unknown")
            
        case .Unsupported:
            updateStatusLabel("Central State Unsupported")
            
        default:
            updateStatusLabel("Central State None Of The Above")
            
        }
        }

    
    
    
    
    
    
    //  Mark UI Stuff

        //REFRESH
    @IBAction func refreshed(sender: UIButton) {
        
        myPeripheralArray.append("Hay Hay Hay")
        tableView.reloadData()
    }
    
        // SCAN
    @IBAction func scanButton(sender: UISwitch) {
        if sender.on{
            
            myCentralManager.scanForPeripheralsWithServices(nil, options: nil )   // call to scan for services
            printToMyTextView("Scanning for Peripherals")
            
        }else{
            myCentralManager.stopScan()   // stop scanning to save power
            printToMyTextView("Stop Scanning")
            
            if (peripheralArray.count > 0 ) {
                myCentralManager.cancelPeripheralConnection(peripheralArray[0])
            }
        }

        
        
    }

    
    
    @IBAction func scanSwitch(sender: UISwitch) {
        if sender.on{
            
            myCentralManager.scanForPeripheralsWithServices(nil, options: nil )   // call to scan for services
            printToMyTextView("\r scanning for Peripherals")
            
        }else{
            myCentralManager.stopScan()   // stop scanning to save power
            printToMyTextView("stop scanning")
            
            if (peripheralArray.count > 0 ) {
                myCentralManager.cancelPeripheralConnection(peripheralArray[0])
            }
        }
    }
    
    
    
    func printToMyTextView(passedString: String){
        labelStatus.text = passedString
    }
    
    
    func updateStatusLabel(passedString: String){
        labelStatus.text = passedString
    }
    
    
    func updateStatusTitleAndSubTitle(passedString: String){
        formatedForCell.append("added "," Added ")
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
