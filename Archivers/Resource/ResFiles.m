//
//  ResFiles.m
//  Athena
//
//  Created by Scott McClaugherty on 11/2/11.
//  Copyright (c) 2011 Scott McClaugherty. All rights reserved.
//

#import "ResFiles.h"
#import "ResCoding.h"
#import "ResSegment.h"
#import <objc/runtime.h>
#import <sys/stat.h>

@implementation ResourceFile

- (id)initWithFileName:(NSString *)fileName {
    self = [super init];
    if (self) {
        FSRef file;
        OSStatus status = FSPathMakeRef((UInt8 *)[fileName cStringUsingEncoding:NSMacOSRomanStringEncoding], &file, NULL);
        if (status == noErr) {
            fileNumber = FSOpenResFile(&file, fsRdPerm);
        } else {
            [self release];
            return nil;
        }
    }
    return self;
}
- (void)dealloc {
    CloseResFile(fileNumber);
    [super dealloc];
}

- (NSDictionary *)allEntriesOfClass:(Class)class {
    UseResFile(fileNumber);
    ResType type = [class resType];

    NSMutableDictionary *table = [NSMutableDictionary dictionary];
    if ([class isPacked]) {//data is a concatenated array of structs
        //500 seems to be used for all of ares's packed types
        const ResID packedResourceId = 500u;
        //Pull the data out of resource
        Handle dataH = Get1Resource(type, packedResourceId);
        if (dataH == NULL) {
            ReleaseResource(dataH);
            return [[table copy] autorelease];
        }
        HLock(dataH);
        Size size = GetHandleSize(dataH);
        NSData *data = [NSData dataWithBytes:*dataH length:size];
        HUnlock(dataH);
        ReleaseResource(dataH);
        size_t recSize = [class sizeOfResourceItem];
        NSUInteger count = size/recSize;
        //        //Dictionary is used because NSArray doesn't handle sparse arrays
        //        NSMutableDictionary *table = [NSMutableDictionary dictionaryWithCapacity:count];
        for (NSUInteger k = 0; k < count; k++) {
            ResSegment *seg = [[ResSegment alloc]
                               initWithClass:class
                               data:[data subdataWithRange:NSMakeRange(recSize * k, recSize)]
                               index:k
                               name:@""
                               origin:DataBasisAres];
            if (class_conformsToProtocol(class, @protocol(ResIndexOverriding))) {
                seg.index = [(id<ResIndexOverriding>)class peekAtIndexWithData:[seg data]];
            }

            [table setObject:seg forKey:[[NSNumber numberWithUnsignedInteger:seg.index] stringValue]];
            [seg release];
        }
    } else {//Use indexed resources
        ResourceCount count = Count1Resources(type);
        for (ResourceIndex index = 1; index <= count; index++) {
            Handle dataH = Get1IndResource(type, index);
            //Pull out the ResId
            ResID rID;
            Str255 name;
            GetResInfo(dataH, &rID, NULL, name);
            NSString *str = [[NSString alloc] initWithBytes:&name[1] length:*name encoding:NSMacOSRomanStringEncoding];
            HLock(dataH);
            Size size = GetHandleSize(dataH);
            ResSegment *seg = [[ResSegment alloc]
                               initWithClass:class
                               data:[NSData dataWithBytes:*dataH length:size]
                               index:rID
                               name:str
                               origin:DataBasisAres];
            [str release];
            [table setObject:seg forKey:[[NSNumber numberWithUnsignedShort:rID] stringValue]];
            [seg release];
            HUnlock(dataH);
            ReleaseResource(dataH);
        }
        OSErr err = ResError();
        if (err != 0) {
            @throw [NSString stringWithFormat:@"Resource error: %d", err];
        }
    }
    return [[table copy] autorelease];
}
@end

@implementation ZipFile
- (id)initWithFileName:(NSString *)fileName {
    if (self) {
        const char *tempDirTemplate = [[NSTemporaryDirectory() stringByAppendingPathComponent:@"TEMP.XXXXXX"] fileSystemRepresentation];
        char *tempDir = malloc(strlen(tempDirTemplate) + 1);
        strcpy(tempDir, tempDirTemplate);
        mkdtemp(tempDir);
        NSString *workDir = [NSString stringWithUTF8String:tempDir];
        free(tempDir);

        mkdir([workDir UTF8String], 0777);

        NSTask *unzipTask = [[NSTask alloc] init];
        [unzipTask setLaunchPath:@"/usr/bin/unzip"];
        [unzipTask setCurrentDirectoryPath:workDir];
        [unzipTask setArguments:[NSArray arrayWithObjects:@"-q", fileName, @"-d", workDir, nil]];
        [unzipTask launch];
        [unzipTask waitUntilExit];
        [unzipTask release];
        directoryName = [workDir retain];
    }
    return self;
}
- (void)dealloc {
    NSTask *rmTask = [[NSTask alloc] init];
    [rmTask setLaunchPath:@"/bin/rm"];
    [rmTask setArguments:[NSArray arrayWithObjects:@"-r", directoryName, nil]];
    [rmTask setCurrentDirectoryPath:[directoryName stringByDeletingLastPathComponent]];
    [rmTask launch];
    [rmTask waitUntilExit];
    assert([rmTask terminationStatus] == 0);
    [rmTask release];
    [directoryName release];
    [super dealloc];
}

- (NSDictionary *)allEntriesOfClass:(Class)class {
    NSMutableDictionary *table = [NSMutableDictionary dictionary];
    NSString *dir = [[directoryName stringByAppendingPathComponent:@"data"] stringByAppendingPathComponent:[class typeKey]];
    NSError *error = nil;
    NSArray *subPaths = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:dir error:&error];
    NSAssert(error == nil, @"ERROR %@", error);
    for (NSString *file in subPaths) {
        NSScanner *scanner = [NSScanner scannerWithString:[file stringByDeletingPathExtension]];
        int idx = 0xDEADBEEF;
        BOOL ok = YES;
        ok = [scanner scanInt:&idx];
        assert(ok);
        assert(idx != 0xDEADBEEF);
        if ([class isPacked] && idx != 500) {//only read packed data from index 500
            continue;
        }
        NSString *name = nil;
        ok = [scanner scanUpToString:@"\0" intoString:&name];
        assert(ok);
        if ([class isPacked]) {
            NSData *data = [NSData dataWithContentsOfFile:[dir stringByAppendingPathComponent:file]];
            size_t recSize = [class sizeOfResourceItem];
            NSUInteger count = [data length]/recSize;
            for (int k = 0; k < count; k++) {
                ResSegment *seg = [[ResSegment alloc] initWithClass:class data:[data subdataWithRange:NSMakeRange(recSize * k, recSize)] index:k name:@"" origin:DataBasisAntares];
                if (class_conformsToProtocol(class, @protocol(ResIndexOverriding))) {
                    seg.index = [(id<ResIndexOverriding>)class peekAtIndexWithData:[seg data]];
                }
                [table setObject:seg forKey:[[NSNumber numberWithUnsignedInt:seg.index] stringValue]];
                [seg release];
            }
        } else {
            ResSegment *seg = [[ResSegment alloc] initWithClass:class data:[NSData dataWithContentsOfFile:[dir stringByAppendingPathComponent:file]] index:idx name:name origin:DataBasisAntares];
            [table setObject:seg forKey:[[NSNumber numberWithInt:idx] stringValue]];
            [seg release];
        }
    }
    return [[table copy] autorelease];
}

- (NSString *)getMetadataForKey:(NSString *)key {
    NSString *dir = [directoryName stringByAppendingPathComponent:@"data"];
    NSString *file = [dir stringByAppendingPathComponent:key];
    NSError *error = nil;
    NSString *value = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:&error];
    NSAssert(error == nil, @"ERROR: %@", error);
    return value;
}
@end