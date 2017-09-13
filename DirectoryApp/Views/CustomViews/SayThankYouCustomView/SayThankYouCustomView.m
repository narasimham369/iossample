//
//  SayThankYouCustomView.m
//  DirectoryApp
//
//  Created by Vishnu KM on 02/03/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import "Constants.h"
#import "SayThankYouCustomView.h"
@interface SayThankYouCustomView()<UITextViewDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *thankYouSubView;
@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;
@property (weak, nonatomic) IBOutlet UITextView *messageTextview;
@end
@implementation SayThankYouCustomView
- (void)awakeFromNib {
    [super awakeFromNib];
    self.messageTextview.delegate = self;
    self.tapGesture.delegate = self;
    self.messageTextview.layer.cornerRadius = 3;
    self.thankYouSubView.layer.cornerRadius = 5;
}

#pragma mark- Tap Action

- (IBAction)tapAction:(id)sender {
    if (IS_IPHONE_5){
        [UIView animateWithDuration:0.3 animations:^{
            [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y+55, self.frame.size.width, self.frame.size.height)];
        }];
    }
    else{
        [UIView animateWithDuration:0.3 animations:^{
            [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y+20, self.frame.size.width, self.frame.size.height)];
        }];
    }
    [self endEditing:YES];
}

#pragma mark UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:self.thankYouSubView]) {
        
        return NO;
    }
    
    return YES;
}

#pragma mark- TextField Delegates

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if(textView==self.messageTextview){
        if (IS_IPHONE_5) {
            [UIView animateWithDuration:0.3 animations:^{
                [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y-55, self.frame.size.width, self.frame.size.height)];
            }];
        }
        else{
            [UIView animateWithDuration:0.3 animations:^{
                [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y-20, self.frame.size.width, self.frame.size.height)];
            }];
        }
    }
    
}

#pragma mark- Button Action

- (IBAction)cancelButton:(id)sender {
    [self endEditing:YES];
    if(self.thankUViewDelegate && [self.thankUViewDelegate respondsToSelector:@selector(DissmissView:)]){
        [self.thankUViewDelegate DissmissView:self];
    }
}
- (IBAction)sendButtonAction:(id)sender {
    [self endEditing:YES];
    if(self.thankUViewDelegate && [self.thankUViewDelegate respondsToSelector:@selector(sendButtonActionFromView:DelegateWithMessageContent:)]){
        [self.thankUViewDelegate sendButtonActionFromView:self DelegateWithMessageContent:self.messageTextview.text];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
