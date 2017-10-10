//
//  CustomContactView.h
//  DirectoryApp
//
//  Created by Vishnu KM on 08/03/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SendContactViewDelegate;
@interface CustomContactView : UIView
@property (nonatomic, strong) id storeContacts;
@property (nonatomic, assign) NSInteger checkTag;
@property (nonatomic, assign) id<SendContactViewDelegate>delegateButton;
@end

@protocol SendContactViewDelegate <NSObject>

- (void)sendContactViewValidation:(CustomContactView *)button;
- (void)sendContactViewItem:(CustomContactView *)button buttonClickWithIndex:(NSString *)index;

@end
