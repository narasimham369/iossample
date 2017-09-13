/**************************************************************************************
//  File Name      : SwipeController.h
//  Project Name   : <Generic Class>
//  Description    : N/A
//  Version        : 1.0
//  Created by     :   
//  Created on     : 12/04/2011
//  Copyright (C) 2011   . All Rights Reserved.
***************************************************************************************/

#import <UIKit/UIKit.h>


@interface CLSwipeController : UIViewController {
    
    int initialPageToShow;
    int m_totalPages;
    
    float imageHorizontalSpacing;
    float imageVerticalSpacing;
    
    @private
    //for sliding 
    int m_iCurrentPageIndex; 
	BOOL m_bRotationInProgress;
    NSMutableArray *m_pageViews;
	UIScrollView *m_scrollView;
    
}

@property (nonatomic, retain) UIScrollView *scrollView;

@property (nonatomic, assign) int initialPageToShow;
@property (nonatomic, assign) int totalPages; 

@property (nonatomic, assign) float imageHorizontalSpacing;
@property (nonatomic, assign) float imageVerticalSpacing;

- (void)loadScrollView; 

- (CGSize)pageSize;
- (BOOL)isPageLoaded:(int)pageIndex;

- (void)layoutPages;
- (CGRect)alignView:(UIView *)view forPage:(int)pageIndex;

- (UIView *)viewForPage:(int)pageIndex;

-(void)willChangeToPageIndex:(int)pageIndex;
-(void)didChangePageIndex:(int)pageIndex;

-(void)gotoPageAtIndex:(int)pageIndex;
-(void)reloadCurrentPageView;
- (void)unloadPageViews;
- (void)reloadPageViews;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (UIView *)loadedViewForPage:(int)pageIndex;

@end
