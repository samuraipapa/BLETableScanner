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

    var fullPeripheralArray = [("UUIDString","RSSI","Name")]
    
    
    var myPeripheralArray = ["Peripherial 1","Peripherial 2", "Peripherial 3"]
    
    var nearPeripheralArray = [("UUIDString","RSSI","Name")]
    var farPeripheralArray = [("UUIDString","RSSI","Name")]
    var miscPeripheralArray = [("UUIDString","RSSI","Name")]

    
    var cleanAndSortedNearArray = [("UUIDString","RSSI","Name")]
    var cleanAndSortedFarArray = [("UUIDString","RSSI","Name")]
    var cleanAndSortedMiscArray = [("UUIDString","RSSI","Name")]
    
    var formatedForCell = [("Title","SubTitle")]
    

    // UI Stuff
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelStatus: UILabel!
 
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshArrays()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 3
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if section == 0 {
            return nearPeripheralArray.count
        } else if section == 1 {
            return farPeripheralArray.count
        } else {
            return miscPeripheralArray.count
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("near", forIndexPath: indexPath) as UITableViewCell
            cell.textLabel?.text = "\(cleanAndSortedNearArray[indexPath.row].1)" + "  \(cleanAndSortedNearArray[indexPath.row].0)"
            cell.detailTextLabel?.text = cleanAndSortedNearArray[indexPath.row].2
            
            return cell
            
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("far", forIndexPath: indexPath) as UITableViewCell
            cell.textLabel?.text = "\(cleanAndSortedFarArray[indexPath.row].1)" + "  \(cleanAndSortedFarArray[indexPath.row].0)"
            cell.detailTextLabel?.text = cleanAndSortedFarArray[indexPath.row].2
            return cell
            
        }    else  {
            let cell = tableView.dequeueReusableCellWithIdentifier("far", forIndexPath: indexPath) as UITableViewCell
            cell.textLabel?.text = "\(cleanAndSortedMiscArray[indexPath.row].1)" + "  \(cleanAndSortedMiscArray[indexPath.row].0)"
            cell.detailTextLabel?.text = cleanAndSortedMiscArray[indexPath.row].2
            return cell
            
        }



        // Configure the cell...
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Close By"
        }else if section == 1{
            return "Far Away"
        } else {
            return "Misc"
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
     
        updateStatusLabel("Discovered: \(peripheral.name)")
        println("Discovered Name: \(peripheral.name)")
        println("UUIDString: \(peripheral.identifier.UUIDString)")
        println("peripheral: \(peripheral)")

        println("AdvertisementData: \(advertisementData)")
        println("RSSI: \(RSSI) \r ")
        

        
        if  RSSI.intValue < -80 {
            
            // for each element in the array. check the uuidstring. if so remove that old array entry. place this one in relation to it's rssi
            
            for (myIndex, checkUUID) in enumerate(farPeripheralArray){
            
                if (checkUUID.0 == peripheral.identifier.UUIDString) {
                    let myTuple = ("\(peripheral.name)", "\(RSSI)", "\(peripheral.identifier.UUIDString)")
                    farPeripheralArray.insert(myTuple, atIndex: myIndex)
                  }
                }
            }
        
        
        if ( RSSI.intValue < -80 ){
            farPeripheralArray.append("\(peripheral.name)", "\(RSSI)", "\(peripheral.identifier.UUIDString)")
            // sort array elment by size of RSSI
            cleanAndSortedFarArray = sorted(farPeripheralArray,{
                (str1: (String,String,String) , str2: (String,String,String) ) -> Bool in
                return str1.1.toInt() > str2.1.toInt()
            })

            

        
              } else if (RSSI.intValue > -79 && RSSI.intValue < 1)  {
          
            nearPeripheralArray.append("\(peripheral.name)", "\(RSSI)", "\(peripheral.identifier.UUIDString)")
            cleanAndSortedNearArray = sorted(nearPeripheralArray,{
                (str1: (String,String,String) , str2: (String,String,String) ) -> Bool in
                return str1.1.toInt() > str2.1.toInt()
            })
            ////  from http://www.andrewcbancroft.com/2014/08/16/sort-yourself-out-sorting-an-array-in-swift/

        } else {
            
            miscPeripheralArray.append("\(peripheral.name)", "\(RSSI)", "\(peripheral.identifier.UUIDString)")
            cleanAndSortedMiscArray = sorted(miscPeripheralArray,{
                (str1: (String,String,String) , str2: (String,String,String) ) -> Bool in
                return str1.1.toInt() > str2.1.toInt()
            })
            
        }
        
        tableView.reloadData()
        
    
    }
    
    
    
    
    //  Mark UI Stuff

        //REFRESH
    @IBAction func refreshed(sender: UIButton) {
        
        refreshArrays()
        tableView.reloadData()
    }
    
    
    
//    
//     func sortArray(arrayToSort: Array ) -> Array {
//        
//        //  from http://www.andrewcbancroft.com/2014/08/16/sort-yourself-out-sorting-an-array-in-swift/
//        
//        let arrayOfIntsAsStrings = [("UUID","3", "Name"),("UUID","2","Name"),("UUID","1","Name"),("UUID","50","Name"),("UUID","53","Name"),("UUID","98","Name")]
//        
//        let sortedArray = sorted(arrayOfIntsAsStrings,{
//            (str1: (String,String,String) , str2: (String,String,String) ) -> Bool in
//            return str1.1.toInt() < str2.1.toInt()
//        })
//        
//        return sortedArray
//        
//    }
    


    
    
    @IBAction func scanSwitch(sender: UISwitch) {
        if sender.on{
            
            myCentralManager.scanForPeripheralsWithServices(nil, options: nil )   // call to scan for services
            updateStatusLabel("Scanning for Peripherals")
            
        }else{
            myCentralManager.stopScan()   // stop scanning to save power
            updateStatusLabel("Stop Scanning")
            
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
        miscPeripheralArray.removeAll(keepCapacity: false)
        
        
        cleanAndSortedNearArray.removeAll(keepCapacity: true)
        cleanAndSortedFarArray.removeAll(keepCapacity: false)
        cleanAndSortedMiscArray.removeAll(keepCapacity: false)
        
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
