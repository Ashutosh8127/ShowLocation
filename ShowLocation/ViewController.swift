//
//  ViewController.swift
//  ShowLocation
//
//  Created by Ashutosh Singh on 11/08/17.
//  Copyright © 2017 AshutoshSingh. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController,UISearchBarDelegate {

    @IBOutlet weak var myMap: MKMapView!
    
    @IBAction func searchButton(_ sender: Any)
    {
       let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
       present(searchController, animated: true, completion: nil)
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
        
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        activeSearch.start { (response, error) in
            
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            
            
            if response == nil
            {
                print("ERROR")
            }
            else
            {
           let annotations = self.myMap.annotations
                self.myMap.removeAnnotations(annotations)
                
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                
                let annotation = MKPointAnnotation()
                annotation.title = searchBar.text
                annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                self.myMap.addAnnotation(annotation)
                
                
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                let span = MKCoordinateSpanMake(0.1, 0.1)
                let region = MKCoordinateRegionMake(coordinate, span)
                self.myMap.setRegion(region, animated: true)
                
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

