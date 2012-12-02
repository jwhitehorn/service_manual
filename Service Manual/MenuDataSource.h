//
//  DirTreeDataSource.h
//  Service Manual
//
//  Created by Jason Whitehorn on 11/30/12.
//  Copyright (c) 2012 Jason Whitehorn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuDataSource : NSObject<NSOutlineViewDataSource>

-(id) initWithMenuPath:(NSURL *)path;

@end
