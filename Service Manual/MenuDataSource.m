//
//  DirTreeDataSource.m
//  Service Manual
//
//  Created by Jason Whitehorn on 11/30/12.
//  Copyright (c) 2012 Jason Whitehorn. All rights reserved.
//

#import "MenuDataSource.h"
#import "MenuItem.h"
#import "TFHpple.h"
#import "NSString+JRStringAdditions.h"

@interface MenuDataSource()

@property (strong) NSArray *menuData;
- (NSArray *) parseMenuFrom:(NSURL *)file;
- (MenuItem *) parseNode:(TFHppleElement *)node;

@end

@implementation MenuDataSource
@synthesize menuData;

-(id) initWithMenuPath:(NSURL *)path{
    self = [super init];
    if(self){
        self.menuData = [self parseMenuFrom:path];
    }
    return self;
}

- (NSArray *) parseMenuFrom:(NSURL *)file{
    NSData *data = [NSData dataWithContentsOfURL:file];
    
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:data];
    NSArray *elements = [doc searchWithXPathQuery:@"//ul[@id='ulRoot']/ul/li"];
    
    NSMutableArray *menu = [NSMutableArray new];
    
    for(TFHppleElement *element in elements){
        MenuItem *entry = [self parseNode:element];
        if(entry != nil)
            [menu addObject:entry];
    }
    return menu;
}

- (MenuItem *) parseNode:(TFHppleElement *)node{
    NSArray *links = [node childrenWithTagName:@"a"];
    if([links count] == 0)
        return nil;
    TFHppleElement *element = [links objectAtIndex:0];
    
    NSString *href = [element.attributes objectForKey:@"href"];
    if([href containsString:@"blank.htm"])
        href = @"";
    
    NSMutableArray *children = [NSMutableArray new];
    NSArray *lists = [node childrenWithTagName:@"ul"];
    for(TFHppleElement *list in lists){
        NSArray *listItems = [list childrenWithTagName:@"li"];
        for(TFHppleElement *listItem in listItems){
            MenuItem *child = [self parseNode:listItem];
            [children addObject:child];
        };
    }
    MenuItem *entry = [MenuItem new];
    entry.name = element.text;
    entry.filename = href;
    entry.children = children;
    
    return entry;
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item{
    if(item == nil)
        return [menuData count];
    return [[item children] count];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item{
    return [[item children] count] > 0;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item{
    if(item == nil)
        return [menuData objectAtIndex:index];
    return [[item children] objectAtIndex:index];
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item{
    return [item name];
}

@end
