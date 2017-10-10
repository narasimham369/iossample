//
//  MapInfoWindow.h
//  DirectoryApp
//
//  Created by Hari R Krishna on 2/28/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapInfoWindow : UIView
@property (weak, nonatomic) IBOutlet UIImageView *tipImageView;
@property (weak, nonatomic) IBOutlet UIView *imageCarryView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (strong, nonatomic)  NSString *ImageUrl;

@end
