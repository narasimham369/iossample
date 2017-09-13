/**************************************************************************************
//  File Name      : SwipeController.m
//  Project Name   : <Generic Class>
//  Description    : Class contain methods to swipe through views
//  Version        : 1.0
//  Created by     :   
//  Created on     : 12/04/2011
//  Copyright (C) 2011   . Ltd. All Rights Reserved.
***************************************************************************************/

#import "CLSwipeController.h"

@interface CLSwipeController () <UIScrollViewDelegate>

@property (nonatomic, retain) NSMutableArray *pageViews;

@property (nonatomic, assign) int currentPageIndex;

- (void)currentPageIndexDidChange;

@end

#pragma mark -

@implementation CLSwipeController

//private
@synthesize pageViews = m_pageViews;
@synthesize scrollView = m_scrollView;
@synthesize currentPageIndex = m_iCurrentPageIndex;

//public
@synthesize initialPageToShow;
@synthesize totalPages = m_totalPages;
@synthesize imageHorizontalSpacing;
@synthesize imageVerticalSpacing;

#pragma mark -
#pragma mark Override setter methods
//to avoid setting values out of index
- (void)setCurrentPageIndex:(int)currentPageIndex {
    if (currentPageIndex < 0) {
        m_iCurrentPageIndex = 0;
    }
    else if(currentPageIndex >= self.totalPages)   {
        m_iCurrentPageIndex = (self.totalPages - 1);
    }
    else    {
        m_iCurrentPageIndex = currentPageIndex;
    }
}

-(void)setTotalPages:(int)totalPages    {
    
    if (totalPages > 0) {
        m_totalPages = totalPages;
        
        if ([self.pageViews count] < totalPages) {
            //to correct the pageview count
            int pageViewCount = [self.pageViews count];
            for (int i = pageViewCount; i < m_totalPages; ++i)
                [self.pageViews addObject:[NSNull null]];
        }
    }
}
 

#pragma mark -
#pragma mark View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //to set initial page to show
    self.currentPageIndex = initialPageToShow;
    
    //to initialize Scrollview 
	[self loadScrollView];
    
    self.pageViews = [NSMutableArray array];
	// to save time and memory, we won't load the page views immediately
	for (int i = 0; i < self.totalPages; ++i)
		[self.pageViews addObject:[NSNull null]];	
}

- (void)viewWillAppear:(BOOL)animated {
	
	if(self.totalPages !=0)	{
		
        //to load page views
        [self currentPageIndexDidChange];
        [self layoutPages];
		self.scrollView.contentOffset = CGPointMake(self.currentPageIndex * [self pageSize].width, 0);
	}
}

#pragma mark -
#pragma mark Orientation handles

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	
	m_bRotationInProgress = YES;

	[self unloadPageViews];
	
    //to clear all page views
	[[self.scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
#if !__has_feature(objc_arc) 
	[[self.scrollView subviews] makeObjectsPerformSelector:@selector(release)];
#endif
	[self.pageViews removeAllObjects];
	
	for (int i = 0; i < self.totalPages; ++i)
		[self.pageViews addObject:[NSNull null]];
	
	//to load page views
	[self currentPageIndexDidChange];
	
	// hide other page views because they may overlap the current page during animation
	for (int pageIndex = 0; pageIndex < self.totalPages; ++pageIndex)
		if ([self isPageLoaded:pageIndex])
			[self viewForPage:pageIndex].hidden = YES; //(pageIndex != self.currentPageIndex);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	// resize and reposition the page view, but use the current contentOffset as page origin
	// (note that the scrollview has already been resized by the time this method is called)
	UIView *pageView = [self viewForPage:self.currentPageIndex];
	[self viewForPage:self.currentPageIndex].frame = [self alignView:pageView forPage:self.currentPageIndex];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	
	// adjust frames according to the new page size - this does not cause any visible changes
	[self layoutPages];
	//self.scrollView.contentMode=UIViewContentModeScaleAspectFit;
	self.scrollView.contentMode=UIViewContentModeScaleAspectFill;
    self.scrollView.contentSize=CGSizeMake((self.totalPages*([self pageSize].width+ (2*imageHorizontalSpacing))), [self pageSize].height);
	self.scrollView.contentOffset = CGPointMake((self.currentPageIndex * ((2*imageHorizontalSpacing)+[self pageSize].width)),0);
	
	// unhide
	for (int pageIndex = 0; pageIndex < self.totalPages; ++pageIndex)
		if ([self isPageLoaded:pageIndex])
			[self viewForPage:pageIndex].hidden = NO;
	
	m_bRotationInProgress = NO;
}

#pragma mark -
#pragma mark Controller initialization

- (void)loadScrollView {
	
	self.scrollView = [[UIScrollView alloc] init];
	self.scrollView.delegate = self;
	self.scrollView.pagingEnabled = YES;
	self.scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
	self.scrollView.showsHorizontalScrollIndicator = NO;
	self.scrollView.showsVerticalScrollIndicator = NO;
	self.scrollView.bounces = NO;
	self.scrollView.frame = self.view.frame;
	self.scrollView.contentMode = UIViewContentModeScaleAspectFill;
    self.scrollView.backgroundColor = [UIColor clearColor];
	[self.view addSubview:self.scrollView];
	[self.view sendSubviewToBack:self.scrollView];
#if !__has_feature(objc_arc) 
    [self.scrollView autorelease];
#endif
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self																					   action:@selector(pinch:)];
    [self.scrollView addGestureRecognizer:pinchGesture];
    pinchGesture = nil;
}

#pragma mark -
#pragma mark Controller methods
#pragma mark -

- (CGSize)pageSize {
	
	return  self.view.frame.size;
}

- (BOOL)isPageLoaded:(int)pageIndex {
    if ([self.pageViews count] > pageIndex) {
        return ([self.pageViews objectAtIndex:pageIndex] != [NSNull null]);
    }
    else {
        return NO;
    }
}

#pragma mark -

- (UIView *)loadViewForPage:(int)pageIndex {
	UIView *controller;
    @try {
        
        controller=[[UIView alloc] init];
        //for random colors
        CGFloat red =  (CGFloat)random()/(CGFloat)RAND_MAX;
        CGFloat blue = (CGFloat)random()/(CGFloat)RAND_MAX;
        CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX;
        
        controller.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception on loadViewForPage at Index %d : %@",pageIndex,[exception description]);
    }
	
	return controller;
}

- (UIView *)viewForPage:(int)pageIndex {
	if(pageIndex < 0){
        NSLog(@"Exception on viewForPage for Index %d ",pageIndex);
		return nil;
	}
	else if(pageIndex >= self.totalPages){
        NSLog(@"Exception on viewForPage for Index %d ",pageIndex);
		return nil;
	}
	
	UIView *pageView = nil;
	@try{
        
		if (![self isPageLoaded:pageIndex]) {
            
			pageView = [self loadViewForPage:pageIndex];
			[self.pageViews replaceObjectAtIndex:pageIndex withObject:pageView];
			[self.scrollView addSubview:pageView];
#if !__has_feature(objc_arc) 
			[pageView release];
#endif
			pageView=nil;
			
			pageView = [self.pageViews objectAtIndex:pageIndex];
		} else {
            
			pageView = [self.pageViews objectAtIndex:pageIndex];
		}
	}
	@catch (NSException *exception) {
		NSLog(@"Exception on viewForPage for Index %d : %@",pageIndex,[exception description]);
	}
	
	return pageView;
}

- (UIView *)loadedViewForPage:(int)pageIndex {
    UIView *pageView = nil;
    @try {
        if ([self isPageLoaded:pageIndex]) {
            pageView = [self.pageViews objectAtIndex:pageIndex]; 
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception on loadedViewForPage at Index %d : %@",pageIndex,[exception description]);
    }
    return pageView;
}

#pragma mark -

- (CGRect)alignView:(UIView *)view forPage:(int)pageIndex {
	CGSize pageSize = [self pageSize];
    
    CGRect scrollViewRect;
    scrollViewRect.origin.x     = 0;
    scrollViewRect.origin.y     = 0;
    scrollViewRect.size.width   = ((2*imageHorizontalSpacing) + pageSize.width);
    scrollViewRect.size.height  = (pageSize.height + imageVerticalSpacing);
    
	[self.scrollView setFrame:scrollViewRect];
    
    CGSize scrollContentSize;
    scrollContentSize.width     = (self.totalPages*(pageSize.width+ (2*imageHorizontalSpacing)));
    scrollContentSize.height    = (pageSize.height + imageVerticalSpacing);
	[self.scrollView setContentSize:scrollContentSize];
    
    CGRect pageRect;
    pageRect.origin.x   = imageHorizontalSpacing +(pageIndex *  ((2*imageHorizontalSpacing) + pageSize.width));
    pageRect.origin.y   = imageVerticalSpacing;
    pageRect.size.width = pageSize.width;
    pageRect.size.height= pageSize.height;
    NSLog(@"pageView frame %@ vertical %f",NSStringFromCGRect(pageRect),imageVerticalSpacing);

	return pageRect;
}

- (void)layoutPage:(int)pageIndex {
	@try {
        
		UIView *pageView = [self viewForPage:pageIndex];
		if(pageView && (NSNull *)pageView != [NSNull null])	{
			pageView.contentMode=UIViewContentModeScaleAspectFill;
			pageView.frame = [self alignView:pageView forPage:pageIndex]; 
		}
	}
	@catch (NSException *exception) {
		NSLog(@"Exception on layoutPage at Index %d : %@",pageIndex,[exception description]);
	}
}

- (void)layoutPages { 
	@try {
		CGSize pageSize = [self pageSize];	
		// move all visible pages to their places, because otherwise they may overlap
		for (int pageIndex = 0; pageIndex < self.totalPages; ++pageIndex)
			if ([self isPageLoaded:pageIndex])  {
				[self layoutPage:pageIndex];
            }
        
		self.scrollView.contentMode=UIViewContentModeScaleAspectFill;
		self.scrollView.contentSize = CGSizeMake(self.totalPages * pageSize.width, pageSize.height);
	}
	@catch (NSException *exception) {
		NSLog(@"Exception on layoutPages : %@",[exception description]);
	}
}

#pragma mark -

- (void)currentPageIndexDidChange { 
	@try{
        
        [self willChangeToPageIndex:self.currentPageIndex];
		
		[self layoutPage:self.currentPageIndex];
		if (self.currentPageIndex+1 < self.totalPages)
			[self layoutPage:self.currentPageIndex+1];
		if (self.currentPageIndex > 0)
			[self layoutPage:self.currentPageIndex-1];
		
		[self unloadPageViews];
        
        [self didChangePageIndex:self.currentPageIndex];
        
		//self.navigationItem.title = [NSString stringWithFormat:@"Article %d of %d", 1+self.currentPageIndex, self.totalPages];
	}
	@catch (NSException *exception) {
		NSLog(@"Exception on currentPageIndexDidChange : %@",[exception description]);
	}
}

-(void)willChangeToPageIndex:(int)pageIndex    {
    //a method for overriding....
}

-(void)didChangePageIndex:(int)pageIndex    {
    //a method for overriding....
    if ([self isPageLoaded:pageIndex]) {
        UIView *pageView = [self.pageViews objectAtIndex:pageIndex];
        [self.scrollView bringSubviewToFront:pageView];
    }
}

#pragma mark -
#pragma mark UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	@try {
        //CGSize pageSize = [self pageSize];
        if(scrollView == self.scrollView)   {
            
            if (m_bRotationInProgress)
                return; // UIScrollView layoutSubviews code adjusts contentOffset, breaking our logic
            
            int pageWidth = scrollView.frame.size.width;
            
            int newPageIndex = (self.scrollView.contentOffset.x + pageWidth / 2) / pageWidth;
            if (newPageIndex == self.currentPageIndex) return;
            
            // could happen when scrolling fast
            if (newPageIndex < 0)
                newPageIndex = 0;
            else if (newPageIndex >= self.totalPages)
                newPageIndex = self.totalPages - 1;
            
            self.currentPageIndex = newPageIndex;
            [self currentPageIndexDidChange];
        }
        
	}
	@catch (NSException *exception) {
		NSLog(@"Exception on unloadPageViews : %@",[exception description]);
	}
}

#pragma mark -

- (void)gotoPageAtIndex:(int)pageIndex	{
	if (pageIndex < 0) {
		pageIndex = 0;
	}
	else if(pageIndex >= self.totalPages){
		pageIndex=(self.totalPages - 1);
	}
	
	float fScroll;
	self.currentPageIndex = pageIndex;
    
	[[self.scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
	[self.pageViews removeAllObjects];
    
    self.pageViews = nil;
    self.pageViews = [NSMutableArray array];
    
	for (NSUInteger i = 0; i < self.totalPages; ++i)
		[self.pageViews addObject:[NSNull null]];
	

	[self currentPageIndexDidChange];
    
	fScroll=self.scrollView.frame.size.width*pageIndex;
	[self.scrollView setContentOffset:CGPointMake(fScroll,0)];
}


- (void)unloadPageViews	{
	@try {
		if (self.pageViews) {
			
			// unload non-visible pages in case the memory is scarse
			for (int pageIndex = 0; pageIndex < self.totalPages; ++pageIndex)	{
				if (pageIndex < self.currentPageIndex-1 || pageIndex > self.currentPageIndex+1)
					if ([self isPageLoaded:pageIndex]) {
						if(pageIndex==0 && self.currentPageIndex <=1)
							continue;
						
						UIView *pageView = [self.pageViews objectAtIndex:pageIndex];
						[[pageView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
						[pageView removeFromSuperview];
						if(pageView)	{
							pageView=nil;
						}
						[self.pageViews replaceObjectAtIndex:pageIndex withObject:[NSNull null]];
					}	
			}
		}
        
	}
	@catch (NSException *exception) {
		NSLog(@"Exception on unloadPages : %@",[exception description]);
	}
	@finally {
		
	}
}

- (void)reloadPageViews	{
    @try {
        if (self.totalPages > 0) {
         
            // unload all pages in case the memory is scarse
            for (int pageIndex = 0; pageIndex < self.totalPages; ++pageIndex)	{
                
                if ([self isPageLoaded:pageIndex]) {
                    
                    UIView *pageView = [self.pageViews objectAtIndex:pageIndex];
                    [[pageView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
#if !__has_feature(objc_arc)
                    [[pageView subviews] makeObjectsPerformSelector:@selector(release)];
#endif
                    [pageView removeFromSuperview];
                    if(pageView)
                        pageView=nil;
                    [self.pageViews replaceObjectAtIndex:pageIndex withObject:[NSNull null]];
                }
            }	
            
            [self currentPageIndexDidChange];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception on reloadPageViews : %@",[exception description]);
    }
    @finally {
        
    }
}

- (void)reloadCurrentPageView	{
    @try {
        if (self.totalPages > 0) {
            if ([self isPageLoaded:self.currentPageIndex]) {
                
                UIView *pageView = [self.pageViews objectAtIndex:self.currentPageIndex];
                [[pageView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
#if !__has_feature(objc_arc)
                [[pageView subviews] makeObjectsPerformSelector:@selector(release)];
#endif
                [pageView removeFromSuperview];
                if(pageView)
                    pageView=nil;
                [self.pageViews replaceObjectAtIndex:self.currentPageIndex withObject:[NSNull null]];
            }	
            
            [self currentPageIndexDidChange];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception on reloadCurrentPageView : %@",[exception description]);
    }
    @finally {
        
    }
}

#pragma mark - Zoom handles

-(void)pinch:(UIPinchGestureRecognizer *)recognizer	{
    
}

#pragma mark -
#pragma mark Memory management

- (void)viewDidUnload   {
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    if (self.scrollView) {
		[[self.scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
		[self.scrollView removeFromSuperview];
		self.scrollView=nil;
	}
    
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    [self reloadPageViews];
}

- (void)dealloc {
    
    if (self.pageViews) {
		[self.pageViews removeAllObjects];
		self.pageViews=nil;	
	}
    
    if (self.scrollView) {
		[[self.scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
		[self.scrollView removeFromSuperview];
		self.scrollView=nil;
	}
#if !__has_feature(objc_arc) 
    [super dealloc];
#endif
}

@end
