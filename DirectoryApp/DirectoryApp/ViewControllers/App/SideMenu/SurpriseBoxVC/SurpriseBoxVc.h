//
//  SurpriseBoxVc.h
//  DirectoryApp
//
//  Created by Bibin Mathew on 2/21/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import "BaseViewController.h"

@interface SurpriseBoxVc : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *surpriseBoxTableView;
@property (nonatomic)  BOOL isFromPush;
-(void)getMyRecommendationsApi;
@end
