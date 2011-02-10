//
//  ResUnarchiver.m
//  Athena
//
//  Created by Scott McClaugherty on 2/9/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "ResUnarchiver.h"
#import "ResCoding.h"
#import "ResSegment.h"

@implementation ResUnarchiver
- (id) initWithFilePath:(NSString *)path; {
    self = [super init];
    if (self) {
        FSRef file;
        if (!FSPathMakeRef([path UTF8String], &file, NULL)) {
            resFile = FSOpenResFile(&file, fsRdPerm);
            UseResFile(resFile);
        }
        types = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void) registerClass:(Class <Alloc, ResCoding>)class {
    ResType type = [class resType];

    
    if ([class isPacked]) {//data is a concatinated array of structs
        //500 seems to be used for all of ares's packed types
        const ResID packedResourceId = 500u;
        //Pull the data out of resource
        Handle dataH = GetResource(type, packedResourceId);
        HLock(dataH);
        Size size = GetHandleSize(dataH);
        NSData *data = [NSData dataWithBytes:*dataH length:size];
        HUnlock(dataH);
        ReleaseResource(dataH);

        NSUInteger count = size/[class sizeOfResourceItem];
        //Dictionary is used because NSArray doesn't handle sparse arrays
        NSMutableDictionary *table = [NSMutableDictionary dictionaryWithCapacity:count];
        
        char *buffer = malloc(size);
        for (NSUInteger k = 0; k < count; k++) {
            [data getBytes:buffer range:NSMakeRange(size * k, size)];
            ResSegment *seg = [[ResSegment alloc]
                               initWithClass:class
                               data:[NSData dataWithBytes:buffer length:size]];
            
            [table setObject:seg forKey:[[NSNumber numberWithUnsignedInteger:k] stringValue]];
            [seg release];
        }
        free(buffer);
        [types setObject:table forKey:[class typeKey]];
    } else {//Use indexed resources
        ResourceCount count = CountResources(type);
        NSDictionary *table = [NSMutableDictionary dictionaryWithCapacity:count];
        for (ResourceIndex index = 1; index <= count; index++) {
            Handle dataH = GetIndResource(type, index);
            //Pull out the ResId
            ResID rID;
            GetResInfo(dataH, &rID, NULL, NULL);
            HLock(dataH);
            Size size = GetHandleSize(dataH);
            ResSegment *seg = [[ResSegment alloc]
                               initWithClass:class
                               data:[NSData dataWithBytes:*dataH length:size]];
            HUnlock(dataH);
            ReleaseResource(dataH);
            [table setObject:seg forKey:[[NSNumber numberWithShort:rID] stringValue]];
            [seg release];
        }
        [types setObject:table forKey:[class typeKey]];
    }
}

//- (UInt8) decodeUInt8;
//- (SInt8) decodeSInt8;
//- (UInt16) decodeUInt16;
//- (SInt16) decodeSInt16;
//- (UInt32) decodeUInt32;
//- (SInt32) decodeSInt32;
//- (UInt64) decodeUInt64;
//- (SInt64) decodeSInt64;


- (void)dealloc {
    [types release];
    CloseResFile(resFile);
    [super dealloc];
}

@end
