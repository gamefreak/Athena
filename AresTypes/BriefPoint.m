//
//  BriefPoint.m
//  Athena
//
//  Created by Scott McClaugherty on 1/22/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "BriefPoint.h"
#import "StringTable.h"
#import "Archivers.h"
#import "XSPoint.h"
#import "XSText.h"

@implementation BriefPoint
@synthesize title, type, objectId;
@synthesize isVisible, range, content;
@dynamic typeObj, doesntHaveObject;

- (id) init {
    self = [super init];
    if (self) {
        title = @"Untitled";
        type = BriefTypeNoPoint;
        content = [[XSText alloc] init];
        objectId = -1;
        isVisible = YES;
        range = [[XSIPoint alloc] init];
    }
    return self;
}

- (void) dealloc {
    [title release];
    [range release];
    [content retain];
    [super dealloc];
}

//MARK: Lua Coding

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [self init];
    if (self) {
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

        range.point = [coder decodePointForKey:@"range"].point;

        content.text = [coder decodeStringForKey:@"content"];
        return self;
    }
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
    [coder encodeString:content.text forKey:@"content"];
}

+ (BOOL) isComposite {
    return YES;
}

+ (Class) classForLuaCoder:(LuaUnarchiver *)coder {
    return self;
}

//MARK: Res Coding

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [self init];
    if (self) {
        type = [coder decodeSInt8];
        [coder skip:1u];
        if (type == BriefTypeObject) {
            objectId = [coder decodeSInt32];
            isVisible = (BOOL)[coder decodeSInt8];
            [coder skip:3u];
        } else {
            [coder skip:8u];
        }

        range.y = [coder decodeSInt32];
        range.x = [coder decodeSInt32];
        short stringGroup = [coder decodeSInt16];
        short stringId = [coder decodeSInt16];
        [title release];
        title = [[[coder decodeObjectOfClass:[StringTable class] atIndex:stringGroup] stringAtIndex:stringId - 1] retain];
        short contentId = [coder decodeSInt16];
        [content release];
        content = [[coder decodeObjectOfClass:[XSText class] atIndex:contentId] retain];
    }
    return self;
}

- (void)encodeResWithCoder:(ResArchiver *)coder {
    [coder encodeSInt8:type];
    [coder skip:1u];
    if (type == BriefTypeObject) {
        [coder encodeSInt32:objectId];
        [coder encodeSInt8:(isVisible?1:0)];
        [coder skip:3u];
    } else {
        [coder skip:8u];
    }
    [coder encodeSInt32:range.y];
    [coder encodeSInt32:range.x];
    [coder encodeSInt16:STRBriefingTitles];
    [coder encodeSInt16:[coder addString:title toStringTable:STRBriefingTitles]];
    [coder encodeSInt16:[coder encodeObject:content]];
}

+ (ResType)resType {
    return 'snbf';
}

+ (NSString *)typeKey {
    return @"snbf";
}

+ (BOOL)isPacked {
    return YES;
}

+ (size_t)sizeOfResourceItem {
    return 24;
}

- (NSNumber *)typeObj {
    return [NSNumber numberWithInt:type];
}

- (void)setTypeObj:(NSNumber *)typeObj {
    type = [typeObj intValue];
}

- (BOOL)doesntHaveObject {
    return type != BriefTypeObject;
}

static NSSet *typeKeyPath;
+ (NSSet *) keyPathsForValuesAffectingDoesntHaveObject {
    if (typeKeyPath == nil) {
        typeKeyPath = [[NSSet alloc] initWithObjects:@"type", nil];
    }
    return typeKeyPath;
}
@end
