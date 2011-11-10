//
//  VersionFormatter.m
//  Athena
//
//  Created by Scott McClaugherty on 10/29/11.
//  Copyright (c) 2011 Scott McClaugherty. All rights reserved.
//

#import "VersionFormatter.h"

typedef union {
    int raw;
    struct {
        int major:8;
        int minor:8;
        int bugfix:8;
        int edit:8;
    };
} AresVersion;

@implementation VersionFormatter
- (NSString *)stringForObjectValue:(id)obj {
    AresVersion version;
    version.raw = [obj unsignedIntValue];
    if (version.edit != 0) {
        return [NSString stringWithFormat:@"%hhu.%hhu.%hhu.%hhu", version.major, version.minor, version.bugfix, version.edit];
    } else if (version.bugfix != 0) {
        return [NSString stringWithFormat:@"%hhu.%hhu.%hu", version.major, version.minor, version.bugfix];
    } else if (version.minor != 0) {
        return [NSString stringWithFormat:@"%hhu.%hhu", version.major, version.minor];
    }
    return [NSString stringWithFormat:@"%hhu", version.major];
}

- (BOOL)getObjectValue:(id *)obj forString:(NSString *)string errorDescription:(NSString **)error {
    NSScanner *scanner = [NSScanner scannerWithString:string];
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"."]];
    int major = 0, minor = 0, bugfix = 0, edit = 0;
    if (![scanner scanInt:&major]) major = 0; else 
    if (![scanner scanInt:&minor]) minor = 0; else
    if (![scanner scanInt:&bugfix]) bugfix = 0; else
    if (![scanner scanInt:&edit]) edit = 0;
     AresVersion version = {.major = major, .minor = minor, .bugfix = bugfix, .edit = edit};
    *obj = [NSNumber numberWithUnsignedInt:version.raw];
    return YES;
}
@end
