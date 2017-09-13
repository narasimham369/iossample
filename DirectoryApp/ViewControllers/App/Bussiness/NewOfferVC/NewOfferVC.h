//
//  NewOfferVC.h
//  DirectoryApp
//
//  Created by Bibin Mathew on 2/21/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import "BaseViewController.h"

@protocol NewOfferVCDelegate;
@interface NewOfferVC : BaseViewController
@property (nonatomic, assign) BOOL isFromSpecialCouponOffer;
@property (nonatomic, assign) BOOL isFromEdit;
@property (nonatomic, strong) id offerDetails;
@property (nonatomic, assign) id <NewOfferVCDelegate>offerVCDelegate;
@end

@protocol NewOfferVCDelegate <NSObject>
-(void)sendButtonActionDelegateWithOfferID:(NSNumber *)offerId;
@end

