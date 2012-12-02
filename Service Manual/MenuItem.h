//
//  MenuItem.h
//  Service Manual
//
//  Created by Jason Whitehorn on 11/30/12.
//  Copyright (c) 2012 Jason Whitehorn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuItem : NSObject

@property (strong) NSString *name;
@property (strong) NSArray *children;
@property (strong) NSString *filename;

@end
