//
//  UniquePairKeyFormatter.h
//  Athena
//
//  Created by Scott McClaugherty on 9/29/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UniquePairKeyFormatter : NSFormatter {
//    NSArrayController *array;
    NSNumberFormatter *numberChecker;
}
@property (readwrite, retain) IBOutlet NSArrayController *array;
@end
