//
//  MapViewController.h
//  DirectoryApp
//
//  Created by Hari R Krishna on 2/16/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface MapViewController : BaseViewController
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (nonatomic, assign) NSInteger checkTag;
@property (nonatomic) BOOL isFromBussinessUser;
@end
