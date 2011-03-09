//
//  FlagMenuPopulator.m
//  Athena
//
//  Created by Scott McClaugherty on 3/8/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "FlagMenuPopulator.h"
#import "FlagBlob.h"
#import "BaseObjectFlags.h"

@implementation FlagMenuPopulator
- (void) dealloc {
    [self clearItems];
    [super dealloc];
}

- (void) setRepresentedClass:(Class)class andPathComponent:(NSString *)component {
    [self clearItems];

    NSArray *names = [class names];
    NSArray *keys = [class keys];
    int max = [names count];
    for (int idx = 0; idx < max; idx++) {
        id name = [names objectAtIndex:idx];
        id key = [keys objectAtIndex:idx];;
        if (key != [NSNull null]) {
            NSMenuItem *item = [[NSMenuItem alloc] init];
            [item setTitle:name];
            [item bind:@"value"
              toObject:controller
           withKeyPath:[NSString stringWithFormat:@"selection.%@.%@", component, key]
               options:nil];
            [menu addItem:item];
            [item release];
        } else {
            [menu addItem:[NSMenuItem separatorItem]];
        }
    }
}

- (void) clearItems {
    int count = [[menu itemArray] count] - 1;
    for (int i = 0; i < count; i++) {
        NSMenuItem *item = [menu itemAtIndex:1];
        if (![item isSeparatorItem]) {
            [item unbind:@"value"];
        }
        [menu removeItem:item];
    }
}
@end
