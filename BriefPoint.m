//
//  BriefPoint.m
//  Athena
//
//  Created by Scott McClaugherty on 1/22/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "BriefPoint.h"
#import "Archivers.h"
#import "XSPoint.h"

@implementation BriefPoint
@synthesize title, type, objectId;
@synthesize isVisible, range, content;

- (id) init {
    self = [super init];
    title = @"Untitled";
    type = BriefTypeNoPoint;
    content = @"";
    objectId = -1;
    isVisible = YES;
    range = [[XSPoint alloc] init];
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [self init];
    [title release];
    title = [[coder decodeStringForKey:@"title"] retain];
    
    NSString *typeName = [coder decodeStringForKey:@"kind"];
    if ([typeName isEqual:@"no point"]) {
        type = BriefTypeNoPoint;
    } else if ([typeName isEqual:@"object"]) {
        type = BriefTypeObject;
        objectId = [coder decodeIntegerForKey:@"objectId"];
        isVisible = [coder decodeBoolForKey:@"visible"];
    } else if ([typeName isEqual:@"absolute"]) {
        type = BriefTypeAbsolute;;
    } else if ([typeName isEqual:@"freestanding"]) {
        type = BriefTypeFreestanding;
    } else {
        @throw @"Invalid Briefing Type";
    }
    
    [range release];
    range = [[coder decodePointForKey:@"range"] retain];

    [content release];
    content = [coder decodeStringForKey:@"content"];
    [content retain];
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [coder encodeString:title forKey:@"title"];
    switch (type) {
        case BriefTypeNoPoint:
            [coder encodeString:@"no point" forKey:@"kind"];
            break;
        case BriefTypeObject:
            [coder encodeString:@"object" forKey:@"kind"];
            [coder encodeInteger:objectId forKey:@"objectId"];
            [coder encodeBool:isVisible forKey:@"visible"];
            break;
        case BriefTypeAbsolute:
            [coder encodeString:@"absolute" forKey:@"kind"];
            break;
        case BriefTypeFreestanding:
            [coder encodeString:@"freestanding" forKey:@"kind"];
            break;
        default:
            @throw @"Invalid Briefing Type";
            break;
    }
    [coder encodePoint:range forKey:@"range"];
    [coder encodeString:content forKey:@"content"];
}

- (void) dealloc {
    [title release];
    [range release];
    [content retain];
    [super dealloc];
}

+ (BOOL) isComposite {
    return YES;
}

+ (Class) classForLuaCoder:(LuaUnarchiver *)coder {
    return self;
}
@end
