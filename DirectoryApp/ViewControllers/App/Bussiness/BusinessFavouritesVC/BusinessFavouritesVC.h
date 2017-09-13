//
//  BusinessFavouritesVC.h
//  DirectoryApp
//
//  Created by Vishnu KM on 16/02/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface BusinessFavouritesVC : BaseViewController
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) BOOL isBusinessFavourites;
@property (weak, nonatomic) IBOutlet UIView *moreButtonView;
@end
