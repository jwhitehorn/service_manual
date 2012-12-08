//
//  AppDelegate.m
//  Service Manual
//
//  Created by Jason Whitehorn on 11/27/12.
//  Copyright (c) 2012 Jason Whitehorn. All rights reserved.
//

#import "AppDelegate.h"
#import <Foundation/NSXMLDocument.h>
#import "NSString+JRStringAdditions.h"
#import "MenuItem.h"
#import "WelcomeWindowController.h"

@implementation AppDelegate
@synthesize webView, leftView, outlineView, basePath, userDefaults;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification{
    [[webView preferences] setDefaultFontSize:14];
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *height = [userDefaults valueForKey:@"mainWindowHeight"];
    NSNumber *width = [userDefaults valueForKey:@"mainWindowWidth"];
    if(height && width){
        CGRect newFrame = self.window.frame;
        newFrame.size.width = [width floatValue];
        newFrame.size.height = [height floatValue];
        [self.window setFrame:newFrame display:true];
    }
    
    self.basePath = [userDefaults URLForKey:@"lastDirectory"];
    NSError *error;
    if(!basePath || [basePath checkResourceIsReachableAndReturnError:&error] == false){
        [self presentDirectoryPicker];
    }else{
        [self setupWithDirectory:basePath];
    }
    
    WelcomeWindowController* controller = [[WelcomeWindowController alloc]
                                      initWithWindowNibName:@"WelcomeWindow"];
    [controller showWindow:nil];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender{
    [userDefaults setValue:[NSNumber numberWithFloat:self.window.frame.size.width] forKey:@"mainWindowWidth"];
    [userDefaults setValue:[NSNumber numberWithFloat:self.window.frame.size.height] forKey:@"mainWindowHeight"];
    
    [userDefaults synchronize];
    
    return NSTerminateNow;
}

- (void) presentDirectoryPicker:(id)sender{
    [self presentDirectoryPicker];
}

- (void) presentDirectoryPicker{
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseDirectories:true];
    [panel setCanChooseFiles:false];
    [panel beginWithCompletionHandler:^(NSInteger result){
        if(result == NSFileHandlingPanelOKButton){
            NSURL *path = [[panel URLs] objectAtIndex:0];
            self.basePath = path;
            [userDefaults setURL:basePath forKey:@"lastDirectory"];
            [userDefaults synchronize];
            [self setupWithDirectory:path];
        }
    }];
}

- (void) setupWithDirectory:(NSURL *)baseURI{
    NSURL *menuPath = [NSURL URLWithString:@"./en_US/y2007/jk/si/jk_tree_si.htm" relativeToURL:baseURI];
    
    self.dataSource = [[MenuDataSource alloc] initWithMenuPath:menuPath];
    [outlineView setDataSource:self.dataSource];
    [outlineView reloadData];
    
    [outlineView setDelegate:self];
}

- (void)webView:(WebView *)webView decidePolicyForNavigationAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id < WebPolicyDecisionListener >)listener{
    NSString *path = [[request URL] path];

    if([path containsString:@".xml"]){
        path = [path stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        path = [NSString stringWithFormat:@"file://%@", path];
        [self displayDocument:[NSURL URLWithString:path]];
    }else{
        [listener use];
    }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item{
    bool shouldSelect = [[item children] count] == 0;    //only let selection occur if it has no children
    if(shouldSelect){
        NSString *file = [item filename];
        
        NSURL *path = [NSURL URLWithString:[NSString stringWithFormat:@"./en_US/y2007/jk/si/%@", file] relativeToURL:basePath];
        [self displayDocument:path];
        
        [self.window setTitle:[NSString stringWithFormat:@"Service Manual - %@", [item name]]];
    }
    return shouldSelect;
}

- (void) displayDocument:(NSURL *)docUrl{
    NSError *error;
    NSXMLDocument *doc = [[NSXMLDocument alloc] initWithContentsOfURL:docUrl options:NSXMLDocumentTidyXML error:&error];
    
    NSData *xsltData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"./en_US/y2007/jk/si/xml/twl_formatc.xsl" relativeToURL:basePath]];
    NSXMLDocument *output = [doc objectByApplyingXSLT:xsltData arguments:nil error:&error];
    
    [[webView mainFrame] loadHTMLString:[output XMLString] baseURL:[NSURL URLWithString:@"./en_US/y2007/jk/si/xml/" relativeToURL:basePath]];
}

@end
