//
//  NSString+Extension.h
//  PlatformMobile
//
//  Created by Jayahari V on 16/01/12.
//  Copyright (c) 2012 <company name>. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

- (BOOL)empty;
- (BOOL)validEmail;

- (BOOL)validName;
- (BOOL)validNameWithSpace;
- (BOOL)validFacebookName;
- (BOOL)validateUrl;
- (BOOL)validateMobile :(NSString *)strNumber;
- (BOOL)ValidatePhoneWithString:(NSString *)phoneNumber;
- (BOOL)validatePhoneRegister:(NSString *)phoneNumber;
- (int) noOfUpperCaseCharacters;
- (int) noOfLowerCaseCharacters;
- (int) noOfDigits;
- (int) noOfSpecialCharacters;

@end
