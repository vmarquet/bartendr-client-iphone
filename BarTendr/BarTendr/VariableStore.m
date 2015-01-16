//
//  VariableStore.m
//  BarTendr
//
//  Created by ESIEA on 14/01/2015.
//  Copyright (c) 2015 Patouz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VariableStore : NSObject
{
    // Place any "global" variables here
    NSString *numberTable;
}
// message from which our instance is obtained
+ (VariableStore *)sharedInstance;
@end

@implementation VariableStore
+ (VariableStore *)sharedInstance
{
    // the instance of this class is stored here
    static VariableStore *myInstance = nil;
    
    // check to see if an instance already exists
    if (nil == myInstance) {
        myInstance  = [[[self class] alloc] init];
        // initialize variables here
    }
    // return the instance of this class
    return myInstance;
}
@end