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
    
    var nearPeripheralArray = [("UUIDString","RSSI","Name")]
    var farPeripheralArray = [("UUIDString","RSSI","Name")]
    
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
        if section == 0 {
            return nearPeripheralArray.count
        } else {
            return farPeripheralArray.count
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier("near", forIndexPath: indexPath) as UITableViewCell
            cell.textLabel?.text = "\(nearPeripheralArray[indexPath.row].2)" + "\(nearPeripheralArray[indexPath.row].1)"
            cell.detailTextLabel?.text = nearPeripheralArray[indexPath.row].0
            
            return cell
            
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("far", forIndexPath: indexPath) as UITableViewCell
            cell.textLabel?.text = "\(farPeripheralArray[indexPath.row].2)" + "\(farPeripheralArray[indexPath.row].1)"
            cell.detailTextLabel?.text = farPeripheralArray[indexPath.row].0
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
    
    
    // Put CentralManager in the main queue
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        myCentralManager = CBCentralManager(delegate: self, queue: dispatch_get_main_queue())
        
    }
    
    
    func centralManagerDidUpdateState(central: CBCentralManager!) {
        
        println("centralManagerDidUpdateState")
        
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

    
    func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
     
        println("Discovered an Peripheral")
        println("Name: \(peripheral.identifier.UUIDString)")
        println("UUID: \(peripheral)")

        println("Services: \(advertisementData)")
        println("RSSI: \(RSSI) \r ")
        
        
        
        if  RSSI.intValue < -80 {
            
//            var UUIDString = peripheral.description[valueFor]
            
            // for each element in the array. check the uuidstring. if so remove that old array entry. place this one in relation to it's rssi
            
            // sort array elment by size of
            
            
            farPeripheralArray.insert(("Name:\(peripheral.name)", "RSSI:\(RSSI)" , "UUIDString: \(peripheral.identifier.UUIDString)"), atIndex: 0)
        } else {
            nearPeripheralArray.insert(("Name:\(peripheral.name)", "RSSI:\(RSSI)", "UUIDString: \(peripheral.identifier.UUIDString)"), atIndex: 0)
        }
        
        tableView.reloadData()
        
    }
    
    
    
    
    //  Mark UI Stuff

        //REFRESH
    @IBAction func refreshed(sender: UIButton) {
        
        refreshArrays()
        tableView.reloadData()
    }
    


    
    
    @IBAction func scanSwitch(sender: UISwitch) {
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
    
    
    
    func printToMyTextView(passedString: String){
        labelStatus.text = passedString
    }
    
    
    func updateStatusLabel(passedString: String){
        labelStatus.text = passedString
    }
    
    
    func updateStatusTitleAndSubTitle(passedString: String){
        formatedForCell.append("added "," Added ")
    }
    

    func refreshArrays(){
        
        nearPeripheralArray.removeAll(keepCapacity: true)
        farPeripheralArray.removeAll(keepCapacity: false)
        
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
