//
//  AppDelegate.h
//  Service Manual
//
//  Created by Jason Whitehorn on 11/27/12.
//  Copyright (c) 2012 Jason Whitehorn. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "MenuDataSource.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSOutlineViewDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet WebView *webView;
@property (assign) IBOutlet NSView *leftView;
@property (strong) IBOutlet NSOutlineView *outlineView;

@property (strong) MenuDataSource *dataSource;
@property (strong) NSURL *basePath;
@property (strong) NSUserDefaults *userDefaults;

- (IBAction) presentDirectoryPicker:(id)sender;

@end
