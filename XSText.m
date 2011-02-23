//
//  XSText.m
//  Athena
//
//  Created by Scott McClaugherty on 2/23/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "XSText.h"
#import "Archivers.h"

@implementation XSText
@synthesize name, text;

- (id) init {
    self = [super init];
    if (self) {
        name = @"Untitled";
        text = @"";
    }
    return self;
}

- (void) dealloc {
    [name release];
    [text release];
    [super dealloc];
}

- (id) initWithResArchiver:(ResUnarchiver *)coder {
    self = [super init];
    if (self) {
        name = [[coder currentName] retain];
        text = [[NSString alloc] initWithData:[coder rawData] encoding:NSMacOSRomanStringEncoding];
    }
    return self;
}

- (void)encodeResWithCoder:(ResArchiver *)coder {
    [coder setName:name];
    [coder writeBytes:(void *)[text cStringUsingEncoding:NSMacOSRomanStringEncoding]
               length:[text lengthOfBytesUsingEncoding:NSMacOSRomanStringEncoding]];
}

+ (ResType)resType {
    return 'TEXT';
}

+ (NSString *)typeKey {
    return @"TEXT";
}

+ (BOOL)isPacked {
    return NO;
}
@end
