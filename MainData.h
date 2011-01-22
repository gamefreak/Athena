//
//  MainData.h
//  Athena
//
//  Created by Scott McClaugherty on 1/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MainData : NSObject <NSCoding> {
    NSMutableArray *objects;
    NSMutableArray *races;
    NSMutableArray *briefings;
}

@end
