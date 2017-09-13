//
//  BaseTableView.h
//  TWExperience
//
//  Created by Jay Krish on 17/05/16.
//  Copyright © 2016 AkulaInternational. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BaseTableViewDelegate ;

@interface BaseTableView : UITableView <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *tableDataArray;
@property (nonatomic,strong) id<BaseTableViewDelegate>tableViewDelegate;

@end

@protocol BaseTableViewDelegate <NSObject>

@optional
- (void)baseTableViewDelegate:(id)baseTableViewItem clickedItem:(id)item;
- (void)baseTableViewDelegate:(id)baseTableViewItem clickedItem:(id)item atSection:(int)section;

@end