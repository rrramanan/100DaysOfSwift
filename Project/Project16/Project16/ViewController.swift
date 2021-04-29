//
//  ViewController.swift
//  Project16
//
//  Created by R R on 20/01/21.
//
import MapKit
import UIKit

class ViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics.")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 59.95), info: "Founded over a thousand years ago.")
        let paris =  Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.")
        let rome  = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 41.9), info: "Has a whole country inside it.")
        let washington = Capital(title: "Washington", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")
        
        mapView.addAnnotations([london,oslo,paris,rome,washington])
        
       
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Map Mode", style: .plain, target: self, action: #selector(chooseMap))
        
    }
    
    @objc func chooseMap(){
        let ac = UIAlertController(title: "Map View", message: "Choose the map type", preferredStyle: .actionSheet)
        
        ac.addAction(UIAlertAction(title: "Standard", style: .default, handler: { [weak self] action in
            self?.mapView.mapType = .standard
        }))
        
        ac.addAction(UIAlertAction(title: "Satellite", style: .default, handler: { [weak self] action in
            self?.mapView.mapType = .satellite
        }))
        
        ac.addAction(UIAlertAction(title: "Satellite Flyover", style: .default, handler: { [weak self] action in
            self?.mapView.mapType = .satelliteFlyover
        }))
        
        ac.addAction(UIAlertAction(title: "hybrid", style: .default, handler: { [weak self] action in
            self?.mapView.mapType = .hybrid
        }))
        
        ac.addAction(UIAlertAction(title: "Hybrid Flyover", style: .default, handler: { [weak self] action in
            self?.mapView.mapType = .hybridFlyover
        }))
        
        present(ac, animated: true)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        guard annotation is Capital else { return nil }
        
        let identifier = "Capital"

        //challenge
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView

        if annotationView == nil{
           
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            //challenge
            annotationView?.pinTintColor = .blue
            
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn

        }else{
            annotationView?.annotation = annotation
        }

        return annotationView
    }

    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    
        guard let capital = view.annotation as? Capital else { return }
        
        let placeName = capital.title
       // let placeInfo = capital.info
        
//        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "OK", style: .default))
//        present(ac, animated: true)
        
        
    //challenge
        let vc = DetailVC()
        vc.getcapitalString = placeName
        navigationController?.pushViewController(vc, animated: true)
        
    }
    

}

