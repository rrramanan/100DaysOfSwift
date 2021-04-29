//
//  ViewController.swift
//  Project22
//
//  Created by R R on 08/02/21.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var distanceReading: UILabel!
    var locationManager: CLLocationManager?
    
    //challenge
    @IBOutlet var circleView: UIView!
    @IBOutlet var titleLabel: UILabel!
    var loadUUID = [String:Bool]()
    var beaconArray = [BeaconList]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .gray
        
        //challenge
        circleView.layer.cornerRadius = 110
        circleView.layer.borderWidth = 3
        circleView.layer.borderColor = UIColor.purple.cgColor
        
        beaconArray.append(BeaconList(UUID: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5", major: 123, minor: 456, identifier: "Beacon One"))
        beaconArray.append(BeaconList(UUID: "5A4BCFCE-174E-4BAC-A814-092E77F6000", major: 12, minor: 45, identifier: "Beacon Two"))
        
        titleLabel.text = "Beacon NA"
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedAlways{
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self){
                if CLLocationManager.isRangingAvailable(){
                    startScanning()
                }
            }
        }
    }
    
    func startScanning(){
        titleLabel.text = "MyBeacon" //challenge
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beaconRegion = CLBeaconRegion(uuid: uuid, major: 123, minor: 456, identifier: "MyBeacon")
        let beaconIdentityConstraint = CLBeaconIdentityConstraint(uuid: uuid, major: 123, minor: 456)
        
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(satisfying: beaconIdentityConstraint)
    }
    
    //challenge
    func startScanning_moreBeacon(){
        
        for beacon in beaconArray{
            if beacon.UUID == "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5"{
                titleLabel.text = beacon.identifier
                let beaconRegion = CLBeaconRegion(uuid: UUID(uuidString: beacon.UUID)!, major: CLBeaconMajorValue(beacon.major), minor: CLBeaconMinorValue(beacon.minor), identifier: beacon.identifier)
                let beaconIdentityConstraint = CLBeaconIdentityConstraint(uuid: UUID(uuidString: beacon.UUID)!, major: CLBeaconMajorValue(beacon.major), minor: CLBeaconMinorValue(beacon.minor))
                locationManager?.startMonitoring(for: beaconRegion)
                locationManager?.startRangingBeacons(satisfying: beaconIdentityConstraint)
            }else{
                titleLabel.text = beacon.identifier
                let beaconRegion = CLBeaconRegion(uuid: UUID(uuidString: beacon.UUID)!, major: CLBeaconMajorValue(beacon.major), minor: CLBeaconMinorValue(beacon.minor), identifier: beacon.identifier)
                let beaconIdentityConstraint = CLBeaconIdentityConstraint(uuid: UUID(uuidString: beacon.UUID)!, major: CLBeaconMajorValue(beacon.major), minor: CLBeaconMinorValue(beacon.minor))
                locationManager?.startMonitoring(for: beaconRegion)
                locationManager?.startRangingBeacons(satisfying: beaconIdentityConstraint)
            }
        }
        
    }
    
    func update(distance:CLProximity){
        UIView.animate(withDuration: 1){
            switch distance{
            case .far:
                self.view.backgroundColor = .blue
                self.distanceReading.text = "FAR"
                self.circleView.transform = CGAffineTransform(scaleX: 0.25, y: 0.25) //challenge
            case .near:
                self.view.backgroundColor = .orange
                self.distanceReading.text = "NEAR"
                self.circleView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5) //challenge
            case .immediate:
                self.view.backgroundColor = .red
                self.distanceReading.text = "IMMEDIATE"
                self.circleView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0) //challenge
            default:
                self.view.backgroundColor = .gray
                self.distanceReading.text = "UNKNOWN"
                self.circleView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001) //challenge
            }
        }
    }
    
  
    
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        
        if let beacon = beacons.first {
            //challenge
            for item in loadUUID{
              if  item.key == beacon.uuid.uuidString && item.value == true{
                 print("old beacon")
              }else{
                alert(uuid: beacon.uuid.uuidString)
              }
            }
            
            update(distance: beacon.proximity)
        }else{
            update(distance: .unknown)
        }
    }


    
    func alert(uuid: String){
        let vc = UIAlertController(title: "Beacon Found", message: "UUID: \(uuid)", preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.loadUUID[uuid] = true
        }))
        present(vc, animated: true)
    }
    
}

