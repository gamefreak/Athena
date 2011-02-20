//
//  StringTable.h
//  Athena
//
//  Created by Scott McClaugherty on 2/10/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResCoding.h"

enum {
    STRBriefingTitles = 4000,
    STRPlanetBaseNames = 4100,
    STRPlayerNames = 4200,
    STRRaceNames = 4201,
    STRMajorShipNames = 4300,
    STRPlaceholderStrings  = 4400,
    STRMovieNames = 4500,
    STRScenarioNames = 4600,
    STRBaseObjectNames = 5000,
    STRBaseObjectShortNames = 5001,
    STRBaseObjectNotes = 5002,
    STRBaseObjectStaticNames = 5003,
    STRScenarioStatusesStart = 7000
};
    


@interface StringTable : NSObject <ResCoding> {
    NSMutableArray *strings;
}
- (NSString *)stringAtIndex:(NSUInteger)index;
- (NSMutableArray *)allStrings;
- (NSUInteger)addString:(NSString *)string;
- (NSUInteger)addUniqueString:(NSString *)string;
@end
