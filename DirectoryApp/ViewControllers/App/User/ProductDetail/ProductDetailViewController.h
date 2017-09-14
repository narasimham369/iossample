//
//  ProductDetailViewController.h
//  DirectoryApp
//
//  Created by Hari R Krishna on 2/16/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <GoogleMaps/GoogleMaps.h>

typedef NS_ENUM(NSInteger, IDTYPE ){
    BUSINESSIDTYPE1 = 1,
    BUSINESSIDTYPE2 = 2,
};

@interface ProductDetailViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *emptyDataLabel;
@property (strong, nonatomic) id bussinessDummyDetails;
@property (strong, nonatomic) id bussinessDetails;
@property (assign, nonatomic) BOOL isFromFavouriteSpots;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *TableActivityIndicator;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;

@end
