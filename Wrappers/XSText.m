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

- (id)copyWithZone:(NSZone *)zone {
    XSText *copy = [[self->isa allocWithZone:zone] init];
    if (copy) {
        copy->name = [name copyWithZone:zone];
        copy->text = [text copyWithZone:zone];
    }
    return copy;
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

- (NSString *) description {
    return [NSString stringWithFormat:@"%@\n%@", name, text];
}
@end
