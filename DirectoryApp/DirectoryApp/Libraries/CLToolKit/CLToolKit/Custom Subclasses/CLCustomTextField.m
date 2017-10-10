//
//  CLTextField.m
//  Colgate
//
//  Created by Vishakh Krishnan on 9/12/13.
//  Copyright (c) 2013 Codelynks. All rights reserved.
//

#import "CLCustomTextField.h"


#define iPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define iPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define xValue iPhone?5:10
#define yValue iPhone?2:7
#define widthValue iPhone?75:75 
#define heightValue iPhone?0:0

@interface CLCustomTextField ()

@property (nonatomic) CGRect palceHolderRect;
@property (nonatomic) BOOL isPlaceHolderShifted;

@end

@implementation CLCustomTextField

// arrange text some space from origin
- (CGRect)textRectForBounds:(CGRect)bounds {
    if(self.preventEdgeInsetLayouting)
        [super textRectForBounds:bounds];

    return CGRectMake(bounds.origin.x + (xValue), bounds.origin.y +(yValue),
                      bounds.size.width - (widthValue), bounds.size.height - (yValue));
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
//    return CGRectMake(bounds.origin.x + xValue, bounds.origin.y + yValue,
//                      bounds.size.width - widthValue, bounds.size.height - heightValue);
    return CGRectMake(bounds.origin.x+ (xValue), bounds.origin.y+ (yValue), bounds.size.width - (widthValue), bounds.size.height);
}
- (void)setPlaceHolderFrame:(CGRect ) placeHolderFrame{
}

- (void) drawPlaceholderInRect:(CGRect)rect {
    UIColor *placeholderColor = [UIColor colorWithRed:0.439 green:0.4 blue:0.4 alpha:1];
    CGSize size = [self.placeholder sizeWithFont:self.font];
    CGRect placeholderRect = CGRectMake(rect.origin.x, (rect.size.height - size.height)/2, rect.size.width, size.height);
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineBreakMode = NSLineBreakByTruncatingTail;
        style.alignment = self.textAlignment;
        NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:style,NSParagraphStyleAttributeName, self.font, NSFontAttributeName, placeholderColor, NSForegroundColorAttributeName, nil];
      [self.placeholder drawInRect:placeholderRect withAttributes:attr];
    }
    else {
        [placeholderColor setFill];
        [self.placeholder drawInRect:placeholderRect
                            withFont:self.font
                       lineBreakMode:NSLineBreakByTruncatingTail
                           alignment:self.textAlignment];
    }
//    
//    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
//        NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName: self.font};
//        CGRect boundingRect = [self.placeholder boundingRectWithSize:rect.size options:0 attributes:attributes context:nil];
//        [self.placeholder drawAtPoint:CGPointMake(0, (rect.size.height/2)/*-boundingRect.size.height/2*/) withAttributes:attributes];
//    }
//    else{
//        [[UIColor whiteColor] setFill];
//        [[self placeholder] drawInRect:CGRectMake(0, rect.origin.y+yValue, rect.size.width, rect.size.height) withFont:[UIFont systemFontOfSize:20]];
//    }
}
@end
