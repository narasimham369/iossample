//
//  NSArray+Custom.m
//  Colgate
//
//  Created by Rajesh R on 05/11/12.
//  Copyright (c) 2012 Colgate. All rights reserved.
//

#import "NSArray+Custom.h"

@implementation NSArray (Custom)
- (void)makeObjectsPerformSelector:(SEL)aSelector withObject:(id)arg0 withObject:(id)arg1 {
	for(id obj in self) {
		NSMethodSignature *signature = [obj methodSignatureForSelector:aSelector];
		NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
		[invocation setSelector:aSelector];
		[invocation setArgument:(__bridge void *)(arg0) atIndex:0];
		[invocation setArgument:(__bridge void *)(arg1) atIndex:1];
		[invocation setTarget:obj];
		[invocation invoke];
	}
}
@end
