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
    
    // Chat Array
    var fullChatArray = [("","", "", "")]
    var chatDictionary:[String:(String, String, String, String)] = ["UUIDString":("UUIDString","RSSI", "Name","myPeripheralDictionary Services1")]
    var cleanAndSortedChatArray = [("","", "","")]
    
    // BLE Peripheral Arrays
    var fullPeripheralArray = [("UUIDString","RSSI", "Name", "full Services1")]
    var myPeripheralDictionary:[String:(String, String, String, String)] = ["UUIDString":("UUIDString","RSSI", "Name","myPeripheralDictionary Services1")]
    var cleanAndSortedArray = [("UUIDString","RSSI", "Name","clean Services1")]
    

    // UI Stuff
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelStatus: UILabel!
    
    @IBOutlet weak var scanSwitchProp: UISwitch!
    
    //  Table Cell That is formatted for info  (Future Implimenation)
    var formatedForCell = [("Title","SubTitle")]
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshArrays()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //  Mark UI Stuff
    
    //Refresh Button
    @IBAction func refreshed(sender: UIButton) {
        
        myCentralManager.stopScan()   // stop scanning to save power
        myPeripheralDictionary.removeAll(keepCapacity: false)

        tableView.reloadData()
        
        if scanSwitchProp.on{
            
            
            myCentralManager.scanForPeripheralsWithServices(nil, options: nil )   // call to scan for services
            updateStatusLabel("Refreshing. ")
            
        }else{
            myCentralManager.stopScan()   // stop scanning to save power
            updateStatusLabel("Stop Scanning")
            
            if (peripheralArray.count > 0 ) {
                myCentralManager.cancelPeripheralConnection(peripheralArray[0])
            }
        }


        
    
    }
    
    
    
    
    @IBAction func scanSwitch(sender: UISwitch) {
        if sender.on{
            
            myCentralManager.scanForPeripheralsWithServices(nil, options: nil )   // call to scan for services
            updateStatusLabel("Scanning for Peripherals")
            
        }else{
            myPeripheralDictionary.removeAll(keepCapacity: false)
            myCentralManager.stopScan()   // stop scanning to save power
            updateStatusLabel("Stop Scanning")
            
            if (peripheralArray.count > 0 ) {
                myCentralManager.cancelPeripheralConnection(peripheralArray[0])
            }
        }
    }
    
    
    
    
    
    func updateStatusLabel(passedString: String){
        labelStatus.text = passedString 
    }
    
    
    
    
    func refreshArrays(){
        
        fullPeripheralArray.removeAll(keepCapacity: false)
        cleanAndSortedArray.removeAll(keepCapacity: false)
        myPeripheralDictionary.removeAll(keepCapacity: false)
        
        cleanAndSortedChatArray.removeAll(keepCapacity: false)
        fullChatArray.removeAll(keepCapacity: false)
        chatDictionary.removeAll(keepCapacity: false)
        
    }
    

    
    
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 2
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 0 {
            return cleanAndSortedChatArray.count
        }else{
            return cleanAndSortedArray.count
        }

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       

        
        if (indexPath.section == 0) {
            // Configure the cell...
            let cell = tableView.dequeueReusableCellWithIdentifier("chatCell", forIndexPath: indexPath) as UITableViewCell
            cell.textLabel?.text = "\(cleanAndSortedChatArray[indexPath.row].1)" + "  \(cleanAndSortedChatArray[indexPath.row].2)"
            cell.detailTextLabel?.text = cleanAndSortedChatArray[indexPath.row].3
            
            return cell

        } else {
            
        // Configure the cell...
        let cell = tableView.dequeueReusableCellWithIdentifier("backgroundCell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = "\(cleanAndSortedArray[indexPath.row].1)" + "  \(cleanAndSortedArray[indexPath.row].2)"
        cell.detailTextLabel?.text = cleanAndSortedArray[indexPath.row].3
        
            return cell}

    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Chat Activity"
        }else if section == 1{
            return "BackGround Devices"
        } else {
            return "Misc"
        }
    }
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        //  future build out
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // 
        println("selected: \(indexPath.row)")
        updateStatusLabel("selected: \(cleanAndSortedArray[indexPath.row].3)")
        
        
        
    }


    
    // Mark   CBCentralManager Methods
    
    // Put CentralManager in the main queue
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        myCentralManager = CBCentralManager(delegate: self, queue: dispatch_get_main_queue())
        
    }
    
    //Did Update State
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
    
    // Did Discover Peripherals
    func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
        
        
        
        // Refresh Entry or Make an New Entry into Dictionary
        let myUUIDString = peripheral.identifier.UUIDString
        let myRSSIString = String(RSSI.intValue)
        var myNameString: String!
        var myMessageString: String!
        

        //myMessageString = advertisementData[CBAdvertisementDataManufacturerDataKey] as String

        
        let prefixString = "GC"
     //   let localNameKey = advertisementData[CBAdvertisementDataLocalNameKey]
        
        if let localNameKey: AnyObject = advertisementData[CBAdvertisementDataLocalNameKey]  {
  
            myNameString = localNameKey as String
            var myTuple = (myUUIDString, myRSSIString, "\(myNameString)", "\(myMessageString)" )
            
            if myNameString!.hasPrefix("GC:"){
                myTuple.2 = "Chat: " + myTuple.2
                chatDictionary[myTuple.0] = myTuple
                
                // Clean Array
                fullChatArray.removeAll(keepCapacity: false)
                
                // Tranfer Dictionary to Array
                for eachItem in chatDictionary{
                    fullChatArray.append(eachItem.1)
                }
                
                // Sort Array by RSSI
                //from http://www.andrewcbancroft.com/2014/08/16/sort-yourself-out-sorting-an-array-in-swift/
                cleanAndSortedChatArray = sorted(fullChatArray,{
                    (str1: (String,String,String,String) , str2: (String,String,String,String) ) -> Bool in
                    return str1.1.toInt() > str2.1.toInt()
                })
                
                return  

            } else {
                
//                
//                myTuple.2 = "localNameKey: " + myTuple.2
//                chatDictionary[myTuple.0] = myTuple
//                
//                // Clean Array
//                fullChatArray.removeAll(keepCapacity: false)
//                
//                // Tranfer Dictionary to Array
//                for eachItem in chatDictionary{
//                    fullChatArray.append(eachItem.1)
//                }
//                
//                // Sort Array by RSSI
//                //from http://www.andrewcbancroft.com/2014/08/16/sort-yourself-out-sorting-an-array-in-swift/
//                cleanAndSortedChatArray = sorted(fullChatArray,{
//                    (str1: (String,String,String,String) , str2: (String,String,String,String) ) -> Bool in
//                    return str1.1.toInt() > str2.1.toInt()
//                })
                
                
            
            }
        }
        
            
            
            myNameString = peripheral.name

            let myTuple = (myUUIDString, myRSSIString, "Backgroud: \(myNameString)", "\(myMessageString)" )
            myPeripheralDictionary[myTuple.0] = myTuple
            
            // Clean Array
            fullPeripheralArray.removeAll(keepCapacity: false)
            
            // Tranfer Dictionary to Array
            for eachItem in myPeripheralDictionary{
                fullPeripheralArray.append(eachItem.1)
            }
            
            // Sort Array by RSSI
            //from http://www.andrewcbancroft.com/2014/08/16/sort-yourself-out-sorting-an-array-in-swift/
            cleanAndSortedArray = sorted(fullPeripheralArray,{
                (str1: (String,String,String,String) , str2: (String,String,String,String) ) -> Bool in
                return str1.1.toInt() > str2.1.toInt()
            })
     
        tableView.reloadData()
        
    }
            
  //          }
        
//        if (advertisementData[CBAdvertisementDataManufacturerDataKey]  != nil){
//
//                myMessageString = advertisementData[CBAdvertisementDataManufacturerDataKey] as String
//
//        } else{
//            myMessageString = "No Manufactor Data"
//        }
        
        
        
        
   //     var myAdvertisedServices = peripheral.services
   //     var myArray = advertisementData
   //     var advertString = "\(advertisementData)"

        
        
//        if RSSI.intValue < 0 && myNameString != nil {
//        
//    //
//        
//        }
    



    
    // Notes
    func attribution(){
    
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
