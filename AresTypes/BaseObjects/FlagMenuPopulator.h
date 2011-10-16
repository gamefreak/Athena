//
//  FlagMenuPopulator.h
//  Athena
//
//  Created by Scott McClaugherty on 3/8/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FlagMenuPopulator : NSObject {
    IBOutlet NSMenu *menu;
    IBOutlet NSObjectController *controller;
}
- (void) setRepresentedClass:(Class)class andPathComponent:(NSString *)component;
- (void) clearItems;
@end
