//
//  ViewController.swift
//  HWS-project22
//
//  Created by Nikema Prophet on 8/15/16.
//  Copyright © 2016 Nikema Prophet. All rights reserved.
//
import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!

    @IBOutlet weak var distanceReading: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        view.backgroundColor = UIColor.grayColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways {
            if CLLocationManager.isMonitoringAvailableForClass(CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }

    func startScanning() {
        let uuid = NSUUID(UUIDString: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 0, minor: 0, identifier: "MyBeacon")
        
        locationManager.startMonitoringForRegion(beaconRegion)
        locationManager.startRangingBeaconsInRegion(beaconRegion)
    }

    func updateDistance(distance: CLProximity) {
        UIView.animateWithDuration(0.8) { [unowned self] in
            switch distance {
            case .Unknown:
                self.view.backgroundColor = UIColor.grayColor()
                self.distanceReading.text = "UNKNOWN"
                
            case .Far:
                self.view.backgroundColor = UIColor.blueColor()
                self.distanceReading.text = "FAR"
            
            case .Near:
                self.view.backgroundColor = UIColor.orangeColor()
                self.distanceReading.text = "NEAR"
                
            case .Immediate:
                self.view.backgroundColor = UIColor.redColor()
                self.distanceReading.text = "RIGHT HERE"
            
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        if beacons.count > 0 {
            let beacon = beacons[0]
            updateDistance(beacon.proximity)
        } else {
            updateDistance(.Unknown)
        }
    }
}

