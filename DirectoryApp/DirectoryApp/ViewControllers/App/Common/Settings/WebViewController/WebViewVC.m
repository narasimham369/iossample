//
//  WebViewVC.m
//  DirectoryApp
//
//  Created by Vishnu KM on 03/03/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import "Constants.h"
#import "WebViewVC.h"
#import "MBProgressHUD.h"


@interface WebViewVC ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *customWebView;

@end

@implementation WebViewVC

- (void)initView {
    [super initView];
    [self initialisation];
    
}
-(void)initialisation{
    NSURLRequest *urlrequest=[NSURLRequest requestWithURL:self.url];
    [self.customWebView loadRequest:urlrequest];
    [MBProgressHUD showHUDAddedTo:self.customWebView animated:YES];
    [self showButtonOnLeftWithImageName:@"backImage"];
}

#pragma mark - WebView Delegate methods

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideAllHUDsForView:self.customWebView animated:YES];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self ShowAlert:[NSString stringWithFormat:@"%@",error]];
}

#pragma mark - Button Actions

-(void)backButtonAction:(UIButton *)backButton{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Alert Action

-(void)ShowAlert:(NSString*)alertMessage{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:alertMessage
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
    }];
    [alert addAction:firstAction];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
