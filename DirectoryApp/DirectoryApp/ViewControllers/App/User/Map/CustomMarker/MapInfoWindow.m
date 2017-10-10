
//
//  MapInfoWindow.m
//  DirectoryApp
//
//  Created by Hari R Krishna on 2/28/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import "MapInfoWindow.h"
#import <CLToolKit/ImageCache.h>
#import "UIImageView+WebCache.h"
#import <CLToolKit/UIKitExt.h>

@implementation MapInfoWindow

-(void)awakeFromNib{
    [super awakeFromNib];
    self.logoImageView.layer.cornerRadius=3;
    self.logoImageView.layer.masksToBounds=YES;
    self.imageCarryView.layer.cornerRadius=3;
    self.imageCarryView.layer.masksToBounds=YES;
    self.tipImageView.image = [self.tipImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.tipImageView setTintColor:[UIColor whiteColor]];
}
-(void)setImageUrl:(NSString *)ImageUrl{
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:ImageUrl] placeholderImage:[UIImage imageNamed:@"ProfilePlaceholder"]];
}

@end
