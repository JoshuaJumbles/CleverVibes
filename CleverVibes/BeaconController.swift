//
//  BeaconController.swift
//  CleverVibes
//
//  Created by Josh Safran on 5/2/17.
//  Copyright © 2017 Josh Safran. All rights reserved.
//

import Foundation
import CoreLocation

class BeaconController:NSObject,CLLocationManagerDelegate{
    static var sharedInstance = BeaconController();
    var manager :CLLocationManager;
    
    var nearbyGalleryNumbers :[Int] = []
    var galleryViewController :GalleryCollectionViewController?
    
    override init(){
        manager = CLLocationManager();
    }
    
    func checkAuthorization(){
        CLLocationManager.authorizationStatus();
        
    }
    
    func registerNewRegionWithMapping(mapping:BeaconGalleryMapping){
        var beaconRegion = CLBeaconRegion(proximityUUID: UUID.init(uuidString:  mapping.uuid)!,
                                          major: CLBeaconMajorValue.init(exactly: mapping.major)!,
                                          minor: CLBeaconMinorValue.init(exactly: mapping.minor)!,
                                          identifier: "\(mapping.galleryNumber)")
        if beaconRegion != nil{
            manager.startMonitoring(for: beaconRegion);
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        var galleryNum = Int(region.identifier);
        if(!nearbyGalleryNumbers.contains(galleryNum!)){
            nearbyGalleryNumbers.append(galleryNum!);
        }
        
        if(galleryViewController != nil){
            galleryViewController?.nearbyGalleriesDidChange()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        var galleryNum = Int(region.identifier);
        if(nearbyGalleryNumbers.contains(galleryNum!)){
            var index = nearbyGalleryNumbers.index(of:(galleryNum!));
            nearbyGalleryNumbers.remove(at: index!);
        }
        
        if(galleryViewController != nil){
            galleryViewController?.nearbyGalleriesDidChange()
        }
    }
    
    
}
