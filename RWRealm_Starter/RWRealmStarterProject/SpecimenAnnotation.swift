//
//  Entry.swift
//  RWRealmStarterProject
//
//  Created by Bill Kastanakis on 8/6/14.
//  Copyright (c) 2014 Bill Kastanakis. All rights reserved.
//

import UIKit
import MapKit

class SpecimenAnnotation: NSObject, MKAnnotation {
  
  var coordinate: CLLocationCoordinate2D
  var title: String
  var subtitle: String
  
  init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
    self.coordinate = coordinate
    self.title = title
    self.subtitle = subtitle
  }
  
}
