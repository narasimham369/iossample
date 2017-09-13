//
//  CLFacebookShare.h
//  TWExperience
//
//  Created by Jay Krish on 17/05/16.
//  Copyright © 2016 AkulaInternational. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FacebookWrapper.h"

@protocol CLFacebookShareDelegate ;

@interface CLFacebookShare : NSObject

@property (nonatomic,strong)id<CLFacebookShareDelegate>CLShareDelegate;

+ (CLFacebookShare *)shareHandler;
- (id)shareToFacebook:(NSDictionary *)dataDictionary withComposerUI:(BOOL)isNeeded inViewController:(UIViewController *)viewController;

@end


@protocol CLFacebookShareDelegate <NSObject>

- (void)CLFacebookShareViewItem:(CLFacebookShare *)facebookShareView isSucces:(BOOL)isSuccess withError:(NSString *)error;

@end
