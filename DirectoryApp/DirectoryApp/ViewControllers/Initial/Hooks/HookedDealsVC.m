//
//  HookedDealsVC.m
//  DirectoryApp
//
//  Created by smacardev on 09/10/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import "HookedDealsVC.h"
#import "FacebookLoginVC.h"
@interface HookedDealsVC ()

@end

@implementation HookedDealsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if(IS_IPHONE_5){
        
        self.topPosition_btn.constant=110;
    }else if(IS_IPHONE_6_PlUS_Or_Later){
        self.topPosition_btn.constant=160;
    }else if(IS_IPHONE4){
         self.topPosition_btn.constant=90;
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)GotItTouch:(id)sender {
    FacebookLoginVC *fbLogin =[[FacebookLoginVC alloc]initWithNibName:@"FacebookLoginVC" bundle:nil];
    UINavigationController *fabLogNav = [[UINavigationController alloc] initWithRootViewController:fbLogin];
    fbLogin.userName=self.userName;
    fbLogin.password=self.password;
    [self presentViewController:fabLogNav animated:YES completion:nil];
}


-(void)emailConfirm{
    FacebookLoginVC *fbLogin =[[FacebookLoginVC alloc]initWithNibName:@"FacebookLoginVC" bundle:nil];
    UINavigationController *fabLogNav = [[UINavigationController alloc] initWithRootViewController:fbLogin];
    fbLogin.userName=self.userName;
    fbLogin.password=self.password;
    [self presentViewController:fabLogNav animated:YES completion:nil];
}
@end
