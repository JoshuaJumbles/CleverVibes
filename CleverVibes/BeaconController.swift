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
        
        super.init();
        
        manager.delegate = self;
    
        
        
        
    }
    
    func registerNewRegionWithMapping(mapping:BeaconGalleryMapping){
        var beaconRegion = CLBeaconRegion(proximityUUID: UUID.init(uuidString:  mapping.uuid)!,
                                          major: CLBeaconMajorValue.init(exactly: mapping.major)!,
                                          minor: CLBeaconMinorValue.init(exactly: mapping.minor)!,
                                          identifier: "\(mapping.galleryNumber)")
        beaconRegion.notifyOnEntry = true;
        beaconRegion.notifyOnExit = true;
        
        let auth  = CLLocationManager.authorizationStatus();
        if(auth != CLAuthorizationStatus.authorizedWhenInUse){
            manager.requestWhenInUseAuthorization()
        }
        CLLocationManager.locationServicesEnabled()
        print(auth)
        
        
        
//        beaconRegion.
        if beaconRegion != nil{
            manager.startMonitoring(for: beaconRegion);
            manager.startRangingBeacons(in: beaconRegion);
            
           
//            manager.start
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        var galleryNum = Int(region.identifier);
        addNearbyGallery(galleryNum: galleryNum!)
        
        if(galleryViewController != nil){
            galleryViewController?.nearbyGalleriesDidChange()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        var galleryNum = Int(region.identifier);
        removeNearbyGallery(galleryNum: galleryNum!);
        
        if(galleryViewController != nil){
            galleryViewController?.nearbyGalleriesDidChange()
        }
    }
    
    func addNearbyGallery(galleryNum:Int) -> Bool{
        if(!nearbyGalleryNumbers.contains(galleryNum)){
            nearbyGalleryNumbers.append(galleryNum);
            return true;
        }
        return false
    }
    
    func removeNearbyGallery(galleryNum:Int) -> Bool{
        if(nearbyGalleryNumbers.contains(galleryNum)){
            var index = nearbyGalleryNumbers.index(of:(galleryNum));
            nearbyGalleryNumbers.remove(at: index!);
            return true;
        }
        return false
    }
    
//    - (void)locationManager:(CLLocationManager *)manager
//    didRangeBeacons:(NSArray *)beacons
//    inRegion:(CLBeaconRegion *)region {
//    
//    if ([beacons count] > 0) {
//    CLBeacon *nearestExhibit = [beacons firstObject];
//    
//    // Present the exhibit-specific UI only when
//    // the user is relatively close to the exhibit.
//    if (CLProximityNear == nearestExhibit.proximity) {
//    [self presentExhibitInfoWithMajorValue:nearestExhibit.major.integerValue];
//    } else {
//    [self dismissExhibitInfo];
//    }
//    }
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        var didChange = false;
        var isClose = false;
        if(beacons.count > 0){
            for beacon in beacons{
                if(beacon.proximity == CLProximity.far){
                    isClose = true
                }
            }
        }
        
        if(isClose){
            didChange = addNearbyGallery(galleryNum: Int(region.identifier)!)
        }
        
        if(didChange){
            if(galleryViewController != nil){
                galleryViewController?.nearbyGalleriesDidChange()
            }
        }
    }
    
}
