//
//  ResEntry.m
//  Athena
//
//  Created by Scott McClaugherty on 2/23/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "ResEntry.h"
#import "ResSegment.h"
#import "ResCoding.h"

@implementation ResEntry
@synthesize ID, type;
@synthesize name, data;

- (id) init {
    self = [super init];
    if (self) {
        ID = 0;
        type = 'null';
        name = @"Untitled";
        data = [[NSData alloc] init];
    }
    return self;
}

- (id) initWithSegment:(ResSegment *)seg {
    self = [super init];
    if (self) {
        ID = seg.index;
        type = [(Class<ResCoding>)[seg dataClass] resType];
        name = [seg.name retain];
        data = [seg.data retain];
    }
    return self;
}

- (id) initWithResType:(ResType)_type
                    atId:(ResID)_ID
                  name:(NSString *)_name
                  data:(NSData *)_data {
    self = [super init];
    if (self) {
        ID = _ID;
        type = _type;
        name = [_name retain];
        data = [_data retain];
    }
    return self;
}

- (void) dealloc {
    [name release];
    [data release];
    [super dealloc];
}

- (void) save {
    Handle hndl = NewHandle([data length]);
    HLock(hndl);
    memcpy(*hndl, [data bytes], [data length]);
    HUnlock(hndl);
    Str255 pname;
    CFStringGetPascalString((CFStringRef)name, pname, 256, kCFStringEncodingMacRoman);
    AddResource(hndl, type, ID, pname);
    ReleaseResource(hndl);
    NSAssert(ResError() == noErr, @"Resource error (%hi)", ResError());
}
@end
