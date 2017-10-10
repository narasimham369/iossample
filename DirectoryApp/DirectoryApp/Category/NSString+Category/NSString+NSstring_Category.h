//
//  NSString+NSstring_Category.h
//  Ribbn
//
//  Created by Bibin Mathew on 1/21/17.
//  Copyright © 2017 codelynks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSstring_Category)
-(NSString *)convertDateWithInitialFormat:(NSString *)initialFormat ToDateWithFormat:(NSString *)dateFormat;
- (NSString *) capitalizeFirstLetter;
@end
