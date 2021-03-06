//
//  SubActions.m
//  Athena
//
//  Created by Scott McClaugherty on 1/27/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "SubActions.h"
#import "Archivers.h"
#import "IndexedObject.h"

#import "BaseObject.h"
#import "Scenario.h"

#import "XSText.h"

@implementation NoAction
- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [super initWithResArchiver:coder];
    if (self) {
        [coder skip:24u];
    }
    return self;
}

- (void) encodeResWithCoder:(ResArchiver *)coder {
    [super encodeResWithCoder:coder];
    [coder skip:24u];
}

- (NSString *)description {
    return @"No Action";
}
@end

@implementation CreateObjectAction
@synthesize baseType, min, range;
@synthesize velocityRelative, directionRelative, distanceRange;

- (id) init {
    self = [super init];
    if (self) {
        baseType = [[Index alloc] init];
        min = 1;
        range = 0;
        velocityRelative = YES;//???
        directionRelative = YES;//???
        distanceRange = 0;
    }
    return self;
}

- (void) dealloc {
    [baseType release];
    [super dealloc];
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    if (self) {
        [baseType release];
        baseType = [[coder getIndexRefWithIndex:[coder decodeIntegerForKey:@"baseType"]
                                       forClass:[BaseObject class]] retain];
        min = [coder decodeIntegerForKey:@"min"];
        range = [coder decodeIntegerForKey:@"range"];
        velocityRelative = [coder decodeBoolForKey:@"velocityRelative"];
        directionRelative = [coder decodeBoolForKey:@"directionRelative"];
        distanceRange = [coder decodeIntegerForKey:@"distanceRange"];
    }
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeInteger:baseType.index forKey:@"baseType"];
    [coder encodeInteger:min forKey:@"min"];
    [coder encodeInteger:range forKey:@"range"];
    [coder encodeBool:velocityRelative forKey:@"velocityRelative"];
    [coder encodeBool:directionRelative forKey:@"directionRelative"];
    [coder encodeInteger:distanceRange forKey:@"distanceRange"];
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [super initWithResArchiver:coder];
    if (self) {
        baseType = [[coder getIndexRefWithIndex:[coder decodeSInt32]
                                       forClass:[BaseObject class]] retain];
        min = [coder decodeSInt32];
        range = [coder decodeSInt32];
        velocityRelative = (BOOL)[coder decodeSInt8];
        directionRelative = (BOOL)[coder decodeSInt8];
        distanceRange = [coder decodeSInt32];
        [coder skip:6u];
    }
    return self;
}

- (void) encodeResWithCoder:(ResArchiver *)coder {
    [super encodeResWithCoder:coder];
    [coder encodeSInt32:baseType.index];
    [coder encodeSInt32:min];
    [coder encodeSInt32:range];
    [coder encodeSInt8:velocityRelative];
    [coder encodeSInt8:directionRelative];
    [coder encodeSInt32:distanceRange];
    [coder skip:6u];
}

- (void)addObserver:(NSObject *)observer {
    [super addObserver:observer];
    [self addObserver:observer forKeyPath:@"baseType" options:NSKeyValueObservingOptionOld context:NULL];
    [self addObserver:observer forKeyPath:@"min" options:NSKeyValueObservingOptionOld context:NULL];
    [self addObserver:observer forKeyPath:@"range" options:NSKeyValueObservingOptionOld context:NULL];
    [self addObserver:observer forKeyPath:@"velocityRelative" options:NSKeyValueObservingOptionOld context:NULL];
    [self addObserver:observer forKeyPath:@"directionRelative" options:NSKeyValueObservingOptionOld context:NULL];
    [self addObserver:observer forKeyPath:@"distanceRange" options:NSKeyValueObservingOptionOld context:NULL];
}

- (void)removeObserver:(NSObject *)observer {
    [super removeObserver:observer];
    [self removeObserver:observer forKeyPath:@"baseType"];
    [self removeObserver:observer forKeyPath:@"min"];
    [self removeObserver:observer forKeyPath:@"range"];
    [self removeObserver:observer forKeyPath:@"velocityRelative"];
    [self removeObserver:observer forKeyPath:@"directionRelative"];
    [self removeObserver:observer forKeyPath:@"distanceRange"];
}

- (NSString *)nibName {
    return @"CreateObject";
}

- (NSString *)description {
    if (range > 0) {
        return [NSString stringWithFormat:@"Create %li to %li of %@", (long)min, min + range, [[baseType object] name]];
    } else {
        return [NSString stringWithFormat:@"Create %li of %@", (long)min, [[baseType object] name]];
    }
}

- (NSString *)pickerLabel {
    return [NSString stringWithFormat:@"%i %@", [baseType index], [[baseType object] shortName]];
}

+ (NSSet *)keyPathsForValuesAffectingDescription {
    return [NSSet setWithObjects:@"baseType", @"min", @"range", nil];
}

+ (NSSet *)keyPathsForValuesAffectingPickerLabel {
    return [NSSet setWithObjects:@"index", nil];
}
@end

@implementation PlaySoundAction
@synthesize priority, persistence, isAbsolute;
@synthesize volume, volumeRange;
@synthesize soundId, soundIdRange;

- (id) init {
    self = [super init];
    if (self) {
        priority = 1;//???
        persistence = 1;///???
        isAbsolute = YES;//???
        volume = 1;//???
        volumeRange = 0;
        soundId = -1;//???
        soundIdRange = 0;
    }
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    if (self) {
        priority = [coder decodeIntegerForKey:@"priority"];
        persistence = [coder decodeIntegerForKey:@"persistence"];
        isAbsolute = [coder decodeBoolForKey:@"isAbsolute"];
        volume = [coder decodeIntegerForKey:@"volume"];
        volumeRange = [coder decodeIntegerForKey:@"volumeRange"];
        soundId = [coder decodeIntegerForKey:@"soundId"];
        soundIdRange = [coder decodeIntegerForKey:@"soundIdRange"];
    }
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeInteger:priority forKey:@"priority"];
    [coder encodeInteger:persistence forKey:@"persistence"];
    [coder encodeBool:isAbsolute forKey:@"isAbsolute"];
    [coder encodeInteger:volume forKey:@"volume"];
    [coder encodeInteger:volumeRange forKey:@"volumeRange"];
    [coder encodeInteger:soundId forKey:@"soundId"];
    [coder encodeInteger:soundIdRange forKey:@"soundIdRange"];
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [super initWithResArchiver:coder];
    if (self) {
        priority = [coder decodeUInt8];
        [coder skip:1u];
        persistence = [coder decodeSInt32];
        isAbsolute = (BOOL)[coder decodeSInt8];
        [coder skip:1u];
        volume = [coder decodeSInt32];
        volumeRange = [coder decodeSInt32];
        soundId = [coder decodeSInt32];
        soundIdRange = [coder decodeSInt32];
    }
    return self;
}

- (void) encodeResWithCoder:(ResArchiver *)coder {
    [super encodeResWithCoder:coder];
    [coder encodeUInt8:priority];
    [coder skip:1u];
    [coder encodeSInt32:persistence];
    [coder encodeSInt8:isAbsolute];
    [coder skip:1u];
    [coder encodeSInt32:volume];
    [coder encodeSInt32:volumeRange];
    [coder encodeSInt32:soundId];
    [coder encodeSInt32:soundIdRange];
}

- (void)addObserver:(NSObject *)observer {
    [super addObserver:observer];
    [self addObserver:observer forKeyPath:@"priority" options:NSKeyValueObservingOptionOld context:NULL];
    [self addObserver:observer forKeyPath:@"persistence" options:NSKeyValueObservingOptionOld context:NULL];
    [self addObserver:observer forKeyPath:@"isAbsolute" options:NSKeyValueObservingOptionOld context:NULL];
    [self addObserver:observer forKeyPath:@"volume" options:NSKeyValueObservingOptionOld context:NULL];
    [self addObserver:observer forKeyPath:@"volumeRange" options:NSKeyValueObservingOptionOld context:NULL];
    [self addObserver:observer forKeyPath:@"soundId" options:NSKeyValueObservingOptionOld context:NULL];
    [self addObserver:observer forKeyPath:@"soundIdRange" options:NSKeyValueObservingOptionOld context:NULL];
}

- (void)removeObserver:(NSObject *)observer {
    [super removeObserver:observer];
    [self removeObserver:observer forKeyPath:@"priority"];
    [self removeObserver:observer forKeyPath:@"persistence"];
    [self removeObserver:observer forKeyPath:@"isAbsolute"];
    [self removeObserver:observer forKeyPath:@"volume"];
    [self removeObserver:observer forKeyPath:@"volumeRange"];
    [self removeObserver:observer forKeyPath:@"soundId"];
    [self removeObserver:observer forKeyPath:@"soundIdRange"];
}

- (NSString *)nibName {
    return @"PlaySound";
}

- (NSString *)description {
    if (soundIdRange == 0) {
        return [NSString stringWithFormat:@"Play sound %li", (long)soundId];
    } else {
        return [NSString stringWithFormat:@"Play sound in range %li - %li", (long)soundId, soundId + soundIdRange];
    }
}

+ (NSSet *)keyPathsForValuesAffectingDescription {
    return [NSSet setWithObjects:@"soundId", @"soundIdRange", nil];
}
@end

@implementation MakeSparksAction
@synthesize count, velocity, velocityRange, color;

- (id) init {
    self = [super init];
    if (self) {
        count = 1;//???
        velocity = 1;//???
        velocityRange = 0;
        color = 0;//???
    }
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    if (self) {
        count = [coder decodeIntegerForKey:@"count"];
        velocity = [coder decodeIntegerForKey:@"velocity"];
        velocityRange = [coder decodeIntegerForKey:@"velocityRange"];
        color = [coder decodeIntegerForKey:@"color"];
    }
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeInteger:count forKey:@"count"];
    [coder encodeInteger:velocity forKey:@"velocity"];
    [coder encodeInteger:velocityRange forKey:@"velocityRange"];
    [coder encodeInteger:color forKey:@"color"];
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    if (self) {
        count = [coder decodeSInt32];
        velocity = [coder decodeSInt32];
        velocityRange = [coder decodeSInt32];
        color = [coder decodeUInt8];
        [coder skip:11u];
    }
    return self;
}

- (void) encodeResWithCoder:(ResArchiver *)coder {
    [super encodeResWithCoder:coder];
    [coder encodeSInt32:count];
    [coder encodeSInt32:velocity];
    [coder encodeSInt32:velocityRange];
    [coder encodeUInt8:color];
    [coder skip:11u];
}

- (void)addObserver:(NSObject *)observer {
    [super addObserver:observer];
    [self addObserver:observer forKeyPath:@"count" options:NSKeyValueObservingOptionOld context:NULL];
    [self addObserver:observer forKeyPath:@"velocity" options:NSKeyValueObservingOptionOld context:NULL];

    [self addObserver:observer forKeyPath:@"velocityRange" options:NSKeyValueObservingOptionOld context:NULL];

    [self addObserver:observer forKeyPath:@"color" options:NSKeyValueObservingOptionOld context:NULL];

}

- (void)removeObserver:(NSObject *)observer {
    [super removeObserver:observer];
    [self removeObserver:observer forKeyPath:@"count"];
    [self removeObserver:observer forKeyPath:@"velocity"];
    [self removeObserver:observer forKeyPath:@"velocityRange"];
    [self removeObserver:observer forKeyPath:@"color"];
}

- (NSString *)description {
    if (count == 1) {
        return [NSString stringWithFormat:@"Make 1 %li-colored spark", (long)color];
    } else {
        return [NSString stringWithFormat:@"Make %li %li-colored sparks", (long)count, (long)color];
    }
}

+ (NSSet *)keyPathsForValuesAffectingDescription {
    return [NSSet setWithObjects:@"color", @"count", nil];
}

- (NSString *)nibName {
    return @"CreateSparks";
}
@end

@implementation ReleaseEnergyAction
@synthesize percent;

- (id) init {
    self = [super init];
    if (self) {
        percent = 100.0f;//???
    }
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    if (self) {
        percent = [coder decodeFloatForKey:@"percent"];
    }
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeFloat:percent forKey:@"percent"];
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [super initWithResArchiver:coder];
    if (self) {
        percent = [coder decodeFixed];
        [coder skip:20u];
    }
    return self;
}

- (void) encodeResWithCoder:(ResArchiver *)coder {
    [super encodeResWithCoder:coder];
    [coder encodeFixed:percent];
    [coder skip:20u];
}

- (void)addObserver:(NSObject *)observer {
    [super addObserver:observer];
    [self addObserver:observer forKeyPath:@"percent" options:NSKeyValueObservingOptionOld context:NULL];
}

- (void)removeObserver:(NSObject *)observer {
    [super removeObserver:observer];
    [self removeObserver:observer forKeyPath:@"percent"];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Release %g%% of object's energy.", percent];
}

+ (NSSet *)keyPathsForValuesAffectingDescription {
    return [NSSet setWithObjects:@"percent", nil];
}

- (NSString *)nibName {
    return @"ReleaseEnergy";
}
@end

@implementation LandAtAction
@synthesize speed;

- (id) init {
    self = [super init];
    if (self) {
        speed = 1;//???
    }
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    if (self) {
        speed = [coder decodeIntegerForKey:@"speed"];
    }
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeInteger:speed forKey:@"speed"];
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [super initWithResArchiver:coder];
    if (self) {
        speed = [coder decodeSInt32];
        [coder skip:20u];
    }
    return self;
}

- (void) encodeResWithCoder:(ResArchiver *)coder {
    [super encodeResWithCoder:coder];
    [coder encodeSInt32:speed];
    [coder skip:20u];
}

- (void)addObserver:(NSObject *)observer {
    [super addObserver:observer];
    [self addObserver:observer forKeyPath:@"speed" options:NSKeyValueObservingOptionOld context:NULL];
}

- (void)removeObserver:(NSObject *)observer {
    [super removeObserver:observer];
    [self removeObserver:observer forKeyPath:@"speed"];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Land at destination at speed %li", (long)speed];
}

+ (NSSet *)keyPathsForValuesAffectingDescription {
    return [NSSet setWithObjects:@"speed", nil];
}

- (NSString *)nibName {
    return @"LandAt";
}
@end

@implementation EnterWarpAction
@synthesize warpSpeed;

- (id) init {
    self = [super init];
    if (self) {
        warpSpeed = 1;//???
    }
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    if (self) {
        warpSpeed = [coder decodeIntegerForKey:@"warpSpeed"];
    }
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeInteger:warpSpeed forKey:@"warpSpeed"];
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [super initWithResArchiver:coder];
    if (self) {
        //should this be interpreted as fixed instead?
        warpSpeed = [coder decodeSInt32];
        [coder skip:20u];
    }
    return self;
}

- (void) encodeResWithCoder:(ResArchiver *)coder {
    [super encodeResWithCoder:coder];
    [coder encodeSInt32:warpSpeed];
    [coder skip:20u];
}

- (void)addObserver:(NSObject *)observer {
    [super addObserver:observer];
    [self addObserver:observer forKeyPath:@"warpSpeed" options:NSKeyValueObservingOptionOld context:NULL];
}

- (void)removeObserver:(NSObject *)observer {
    [super removeObserver:observer];
    [self removeObserver:observer forKeyPath:@"warpSpeed"];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Begin warping at %li u/s", (long)warpSpeed];
}
@end

@implementation DisplayMessageAction
@synthesize pages;

- (id) init {
    self = [super init];
    if (self) {
        pages = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    [pages release];
    [super dealloc];
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    if (self) {
        [pages setArray:[coder decodeArrayOfClass:[XSText class] forKey:@"pages" zeroIndexed:NO]];
    }
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeArray:pages forKey:@"pages" zeroIndexed:NO];
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [super initWithResArchiver:coder];
    if (self) {
        short ID = [coder decodeSInt16];
        short pageCount = [coder decodeSInt16];
        for (int page = 0; page < pageCount; page++) {
            XSText *pageText = nil;
            @try {
                pageText = [coder decodeObjectOfClass:[XSText class] atIndex:ID + page];
            }
            @catch (NSString *exc) {
                NSLog(@"ACTION[%lu]: IS MISSING MESSAGE[%i][%i]", [coder currentIndex], ID, page);
                pageText = [[[XSText alloc] init] autorelease];
                [pageText setName:@"<MISSING>"];
                [pageText setText:@"MISSING"];
            }
            @finally {
                [pages addObject:pageText];
            }
        }
        [coder skip:20u];
    }
    return self;
}

- (void) encodeResWithCoder:(ResArchiver *)coder {
    [super encodeResWithCoder:coder];
    NSUInteger idx = [coder currentIndex];
    if ([pages count] == 0) {//Special case for no pages
        XSText *text = [[XSText alloc] init];
        [text setName:[NSString stringWithFormat:@"Empty message %lu", (unsigned long)idx]];
        [text setText:@"EMPTY"];
        [coder encodeSInt16:[coder encodeObject:text]];
        [text release];
        [coder encodeSInt16:1];
    } else {
        NSEnumerator *enumerator = [pages objectEnumerator];
        int pageNumber = 1;
        //Special case the first page so we can have it's ID
        XSText *page = [enumerator nextObject];
        if ([[page name] length] == 0) {
            page = [[page copy] autorelease];
            [page setName:[NSString stringWithFormat:@"Message %lu page %i", (unsigned long)idx, pageNumber++]];
        }
        [coder encodeSInt16:[coder encodeObject:page]];
        for (XSText *page in enumerator) {
            if ([[page name] length] == 0) {
                page = [[page copy] autorelease];
                [page setName:[NSString stringWithFormat:@"Message %lu page %i", (unsigned long)idx, pageNumber++]];
            }
            [coder encodeObject:page];
        }
        [coder encodeSInt16:[pages count]];
    }
    [coder skip:20u];
}

- (void)addObserver:(NSObject *)observer {
    [super addObserver:observer];
    [self addObserver:observer forKeyPath:@"pages" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)removeObserver:(NSObject *)observer {
    [super removeObserver:observer];
    [self removeObserver:observer forKeyPath:@"pages"];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Display a %lu pages of a message", (unsigned long)[pages count]];
}

+ (NSSet *)keyPathsForValuesAffectingDescription {
    return [NSSet setWithObjects:@"pages", nil];
}

- (NSString *)nibName {
    return @"DisplayMessage";
}
@end

@implementation ChangeScoreAction
@synthesize player, score, amount;

- (id) init {
    self = [super init];
    if (self) {
        player = 0;//???
        score = 0;//???
        amount = 0;
    }
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    if (self) {
        player = [coder decodeIntegerForKey:@"player"];
        score = [coder decodeIntegerForKey:@"score"];
        amount = [coder decodeIntegerForKey:@"amount"];
    }
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeInteger:player forKey:@"player"];
    [coder encodeInteger:score forKey:@"score"];
    [coder encodeInteger:amount forKey:@"amount"];
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [super initWithResArchiver:coder];
    if (self) {
        player = [coder decodeSInt32];
        score = [coder decodeSInt32];
        amount = [coder decodeSInt32];
        [coder skip:12u];
    }
    return self;
}

- (void) encodeResWithCoder:(ResArchiver *)coder {
    [super encodeResWithCoder:coder];
    [coder encodeSInt32:player];
    [coder encodeSInt32:score];
    [coder encodeSInt32:amount];
    [coder skip:12u];
}

- (void)addObserver:(NSObject *)observer {
    [super addObserver:observer];
    [self addObserver:observer forKeyPath:@"player" options:NSKeyValueObservingOptionOld context:NULL];
    [self addObserver:observer forKeyPath:@"score" options:NSKeyValueObservingOptionOld context:NULL];
    [self addObserver:observer forKeyPath:@"amount" options:NSKeyValueObservingOptionOld context:NULL];
}

- (void)removeObserver:(NSObject *)observer {
    [super removeObserver:observer];
    [self removeObserver:observer forKeyPath:@"player"];
    [self removeObserver:observer forKeyPath:@"score"];
    [self removeObserver:observer forKeyPath:@"amount"];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Add %li to score %li of player %li.", (long)amount, (long)score, (long)player];
}

+ (NSSet *)keyPathsForValuesAffectingDescription {
    return [NSSet setWithObjects:@"player", @"score", @"amount", nil];
}

- (NSString *)nibName {
    return @"ChangeScore";
}
@end

@implementation DeclareWinnerAction
@synthesize player, nextLevel, text;

- (id) init {
    self = [super init];
    if (self) {
        player = 0;
        nextLevel = [[Index alloc] init];
        text = [[XSText alloc] init];
    }
    return self;
}

- (void) dealloc {
    [nextLevel release];
    [text release];
    [super dealloc];
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    if (self) {
        player = [coder decodeIntegerForKey:@"player"];
        [nextLevel release];
        nextLevel = [[coder getIndexRefWithIndex:[coder decodeIntegerForKey:@"nextLevel"]-1
                                        forClass:[Scenario class]] retain];
        [text setText:[coder decodeStringForKey:@"text"]];
    }

    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeInteger:player forKey:@"player"];
    [coder encodeInteger:nextLevel.index forKey:@"nextLevel"];
    [coder encodeString:text.text forKey:@"text"];
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [super initWithResArchiver:coder];
    if (self) {
        player = [coder decodeSInt32];
        [nextLevel release];
        nextLevel = [[coder getIndexRefWithIndex:[coder decodeSInt32]
                                        forClass:[Scenario class]] retain];
        text = [[coder decodeObjectOfClass:[XSText class] atIndex:[coder decodeSInt32]] retain];
        [coder skip:12u];
    }
    return self;
}

- (void) encodeResWithCoder:(ResArchiver *)coder {
    [super encodeResWithCoder:coder];
    [coder encodeSInt32:player];
    [coder encodeSInt32:nextLevel.index];
    [coder encodeSInt32:[coder encodeObject:text]];
    [coder skip:12u];
}

- (void)addObserver:(NSObject *)observer {
    [super addObserver:observer];
    [self addObserver:observer forKeyPath:@"player" options:NSKeyValueObservingOptionOld context:NULL];
    [self addObserver:observer forKeyPath:@"nextLevel" options:NSKeyValueObservingOptionOld context:NULL];
    [self addObserver:observer forKeyPath:@"text.name" options:NSKeyValueObservingOptionOld context:NULL];
    [self addObserver:observer forKeyPath:@"text.text" options:NSKeyValueObservingOptionOld context:NULL];
}

- (void)removeObserver:(NSObject *)observer {
    [super removeObserver:observer];
    [self removeObserver:observer forKeyPath:@"player"];
    [self removeObserver:observer forKeyPath:@"nextLevel"];
    [self removeObserver:observer forKeyPath:@"text.name"];
    [self removeObserver:observer forKeyPath:@"text.text"];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Declare player %li winner and go to level %i.", (long)player, nextLevel.index];
}

+ (NSSet *)keyPathsForValuesAffectingDescription {
    return [NSSet setWithObjects:@"player", @"nextLevel.index", nil];
}

- (NSString *)nibName {
    return @"DeclareWinner";
}
@end

@implementation DieAction
@synthesize how;

- (id) init {
    self = [super init];
    if (self) {
        how = DieActionNormal;
    }
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    if (self) {
        NSString *howStr = [coder decodeStringForKey:@"how"];
        if ([howStr isEqual:@"plain"]) {
            how = DieActionNormal;
        } else if ([howStr isEqual:@"expire"]) {
            how = DieActionExpire;
        } else if ([howStr isEqual:@"destroy"]){
            how = DieActionDestroy;
        } else if ([howStr isEqual:@""]) {//Glitch? set to Normal
            how = DieActionNormal;
        } else {
            @throw [NSString stringWithFormat:@"Invalid die action type: %@", howStr];
        }
    }
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    switch (how) {
        case DieActionNormal:
            [coder encodeString:@"plain" forKey:@"how"];
            break;
        case DieActionExpire:
            [coder encodeString:@"expire" forKey:@"how"];
            break;
        case DieActionDestroy:
            [coder encodeString:@"destroy" forKey:@"how"];
            break;
        default:
            @throw [NSString stringWithFormat:@"Invalid die action type: %d", how];
            break;
    }
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [super initWithResArchiver:coder];
    if (self) {
        how = [coder decodeSInt8];
        switch (how) {
            case DieActionNormal:
            case DieActionExpire:
            case DieActionDestroy:
                //bypass
                break;
            default:
                how = DieActionNormal;
                break;
        }
        [coder skip:23u];
    }
    return self;
}

- (void) encodeResWithCoder:(ResArchiver *)coder {
    [super encodeResWithCoder:coder];
    [coder encodeSInt8:how];
    [coder skip:23u];
}

- (void)addObserver:(NSObject *)observer {
    [super addObserver:observer];
    [self addObserver:observer forKeyPath:@"how" options:NSKeyValueObservingOptionOld context:NULL];
}

- (void)removeObserver:(NSObject *)observer {
    [super removeObserver:observer];
    [self removeObserver:observer forKeyPath:@"how"];
}

- (NSString *)description {
    switch (how) {
        case DieActionNormal:
            return @"Die normally.";
            break;
        case DieActionExpire:
            return @"Die by expiring.";
            break;
        case DieActionDestroy:
            return @"Die by destruction.";
            break;
        default:
            return @"Die action is invalid!";
            break;
    }
    return @"Die action is invalid!";    
}

+ (NSSet *)keyPathsForValuesAffectingDescription {
    return [NSSet setWithObjects:@"how", nil];
}

- (NSString *)nibName {
    return @"Die";
}
@end

@implementation SetDestinationAction
- (NSString *)description {
    return [NSString stringWithFormat:@"Set destination to %li", (long)directOverride];
}

+ (NSSet *)keyPathsForValuesAffectingDestination {
    return [NSSet setWithObjects:@"directOverride", nil];
}
@end

@implementation ActivateSpecialAction
- (NSString *)description {
    return @"Activate special weapon.";
}
@end

@implementation ActivatePulseAction
- (NSString *)description {
    return @"Activate pulse weapon.";
}
@end

@implementation ActivateBeamAction
- (NSString *)description {
    return @"Activate beam weapon.";
}
@end

@implementation ColorFlashAction
@synthesize duration, color, shade;

- (id) init {
    self = [super init];
    if (self) {
        duration = 1;//???
        color = 0;//??? grey
        shade = 0;//???
    }
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    if (self) {
        duration = [coder decodeIntegerForKey:@"duration"];
        color = [coder decodeIntegerForKey:@"color"];
        shade = [coder decodeIntegerForKey:@"shade"];
    }
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeInteger:duration forKey:@"duration"];
    [coder encodeInteger:color forKey:@"color"];
    [coder encodeInteger:shade forKey:@"shade"];
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [super initWithResArchiver:coder];
    if (self) {
        duration = [coder decodeSInt32];
        color = [coder decodeUInt8];
        shade = [coder decodeUInt8];
        [coder skip:18u];
    }
    return self;
}

- (void) encodeResWithCoder:(ResArchiver *)coder {
    [super encodeResWithCoder:coder];
    [coder encodeSInt32:duration];
    [coder encodeUInt8:color];
    [coder encodeUInt8:shade];
    [coder skip:18u];
}

- (void)addObserver:(NSObject *)observer {
    [super addObserver:observer];
    [self addObserver:observer forKeyPath:@"duration" options:NSKeyValueObservingOptionOld context:NULL];
    [self addObserver:observer forKeyPath:@"color" options:NSKeyValueObservingOptionOld context:NULL];
    [self addObserver:observer forKeyPath:@"shade" options:NSKeyValueObservingOptionOld context:NULL];
}

- (void)removeObserver:(NSObject *)observer {
    [super removeObserver:observer];
    [self removeObserver:observer forKeyPath:@"duration"];
    [self removeObserver:observer forKeyPath:@"color"];
    [self removeObserver:observer forKeyPath:@"shade"];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%li tick flash of color %li:%li.", (long)duration, (long)color, (long)shade];
}

+ (NSSet *)keyPathsForValuesAffectingDescription {
    return [NSSet setWithObjects:@"duration", @"color", @"shade", nil];
}

- (NSString *)nibName {
    return @"ColorFlash";
}
@end

@implementation CreateObjectSetDestinationAction
- (NSString *)description {
    if (range > 0) {
        return [NSString stringWithFormat:@"Create %li to %li of %@ with parent's destination.", (long)min, min + range, [[baseType object] name]];
    } else {
        return [NSString stringWithFormat:@"Create %li of %@ with parent's destination.", (long)min, [[baseType object] name]];
    }
}
@end

@implementation NilTargetAction
- (NSString *)description {
    return @"Clear target";
}
@end

@implementation DisableKeysAction
@synthesize keyMask;
@dynamic hexValue;

- (id) init {
    self = [super init];
    keyMask = 0x00000000;//???
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    keyMask = [coder decodeIntegerForKey:@"keyMask"];
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeInteger:keyMask forKey:@"keyMask"];
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    keyMask = [coder decodeUInt32];
    [coder skip:20u];
    return self;
}

- (void) encodeResWithCoder:(ResArchiver *)coder {
    [super encodeResWithCoder:coder];
    [coder encodeUInt32:keyMask];
    [coder skip:20u];
}

- (void)addObserver:(NSObject *)observer {
    [super addObserver:observer];
    [self addObserver:observer forKeyPath:@"keyMask" options:NSKeyValueObservingOptionOld context:NULL];
}

- (void)removeObserver:(NSObject *)observer {
    [super removeObserver:observer];
    [self removeObserver:observer forKeyPath:@"keyMask"];
}

+ (NSSet *)keyPathsForValuesAffectingKeyMask {
    return [NSSet setWithObjects:@"hexValue", nil];
}

- (NSString *)hexValue {
    return [NSString stringWithFormat:@"%x", keyMask];
}

- (void)setHexValue:(NSString *)hexValue {
    NSScanner *scanner = [NSScanner scannerWithString:hexValue];
    [scanner scanHexInt:&keyMask];
}

+ (NSSet *)keyPathsForValuesAffectingHexValue {
    return [NSSet setWithObjects:@"keyMask", nil];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Disable keys with mask 0x08%x.", keyMask];
}

+ (NSSet *)keyPathsForValuesAffectingDescription {
    return [NSSet setWithObjects:@"keyMask", @"hexValue", nil];
}

- (NSString *)nibName {
    return @"DisableKeys";
}
@end

@implementation EnableKeysAction
- (NSString *)description {
    return [NSString stringWithFormat:@"Enable keys with mask 0x%08x.", keyMask];
}
@end

@implementation SetZoomLevelAction
@synthesize zoomLevel;

- (id) init {
    self = [super init];
    if (self) {
        zoomLevel = ZoomLevelActualSize;//???
    }
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    if (self) {
        zoomLevel = [coder decodeIntegerForKey:@"zoomLevel"];
    }
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeInteger:zoomLevel forKey:@"value"];
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [super initWithResArchiver:coder];
    if (self) {
        zoomLevel = [coder decodeUInt32];
        if (!(ZoomLevelDoubleSize <= zoomLevel && zoomLevel <= ZoomLevelAll)) {
            NSLog(@"Bad zoom level [%i]", zoomLevel);
            zoomLevel = ZoomLevelActualSize;
        }
        [coder skip:20u];
    }
    return self;
}

- (void) encodeResWithCoder:(ResArchiver *)coder {
    [super encodeResWithCoder:coder];
    [coder encodeUInt32:zoomLevel];
    [coder skip:20u];
}

- (void)addObserver:(NSObject *)observer {
    [super addObserver:observer];
    [self addObserver:observer forKeyPath:@"zoomLevel" options:NSKeyValueObservingOptionOld context:NULL];
}

- (void)removeObserver:(NSObject *)observer {
    [super removeObserver:observer];
    [self removeObserver:observer forKeyPath:@"zoomLevel"];
}

- (NSString *) zoomString {
    switch (zoomLevel) {
        case ZoomLevelDoubleSize:
            return @"2:1";
            break;
        case ZoomLevelActualSize:
            return @"1:1";
            break;
        case ZoomLevelHalfSize:
            return @"1:2";
            break;
        case ZoomLevelQuarterSize:
            return @"1:4";
            break;
        case ZoomLevelSixteenthSize:
            return @"1:16";
            break;
        case ZoomLevelNearestFoe:
            return @"nearest hostile";
            break;
        case ZoomLevelNearestObject:
            return @"nearest object";
            break;
        case ZoomLevelAll:
            return @"all";
            break;
        default:
            return @"<invalid zoom level>";
            break;
    }
    NSAssert(0, @"Unreachable");
}

+ (NSSet *)keyPathsForValuesAffectingZoomString {
    return [NSSet setWithObjects:@"zoomLevel", nil];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Set zoom level to %@.", [self zoomString]];
}

+ (NSSet *)keyPathsForValuesAffectingDescription {
    return [NSSet setWithObjects:@"zoomLevel", @"zoomString", nil];
}

- (NSString *)nibName {
    return @"SetZoomLevel";
}
@end

@implementation ComputerSelectAction
@synthesize screen, line;

- (id) init {
    self = [super init];
    if (self) {
        screen = 1;//???
        line = 1;//???
    }
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    if (self) {
        screen = [coder decodeIntegerForKey:@"screen"];
        line = [coder decodeIntegerForKey:@"line"];
    }
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeInteger:screen forKey:@"screen"];
    [coder encodeInteger:line forKey:@"line"];
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [super initWithResArchiver:coder];
    if (self) {
        screen = [coder decodeSInt32];
        line = [coder decodeSInt32];
        [coder skip:16u];
    }
    return self;
}

- (void) encodeResWithCoder:(ResArchiver *)coder {
    [super encodeResWithCoder:coder];
    [coder encodeSInt32:screen];
    [coder encodeSInt32:line];
    [coder skip:16u];
}

- (void)addObserver:(NSObject *)observer {
    [super addObserver:observer];
    [self addObserver:observer forKeyPath:@"screen" options:NSKeyValueObservingOptionOld context:NULL];
    [self addObserver:observer forKeyPath:@"line" options:NSKeyValueObservingOptionOld context:NULL];
}

- (void)removeObserver:(NSObject *)observer {
    [super removeObserver:observer];
    [self removeObserver:observer forKeyPath:@"screen"];
    [self removeObserver:observer forKeyPath:@"line"];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Select line %li of screen %li in minicomputer.", (long)line, (long)screen];
}

+ (NSSet *)keyPathsForValuesAffectingDescription {
    return [NSSet setWithObjects:@"screen", @"line", nil];
}

- (NSString *)nibName {
    return @"ComputerSelect";
}
@end

@implementation AssumeInitialObjectAction
@synthesize ID;

- (id) init {
    self = [super init];
    if (self) {
        ID = -1;//???
    }
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    if (self) {
        ID = [coder decodeIntegerForKey:@"id"];
    }
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeInteger:ID forKey:@"id"];
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [super initWithResArchiver:coder];
    if (self) {
        ID = [coder decodeUInt32];
        [coder skip:20u];
    }
    return self;
}

- (void) encodeResWithCoder:(ResArchiver *)coder {
    [super encodeResWithCoder:coder];
    [coder encodeUInt32:ID];
    [coder skip:20u];
}

- (void)addObserver:(NSObject *)observer {
    [super addObserver:observer];
    [self addObserver:observer forKeyPath:@"ID" options:NSKeyValueObservingOptionOld context:NULL];
}

- (void)removeObserver:(NSObject *)observer {
    [super removeObserver:observer];
    [self removeObserver:observer forKeyPath:@"ID"];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Become initial object with id %li", (long)ID];
}

+ (NSSet *)keyPathsForValuesAffectingDescription {
    return [NSSet setWithObjects:@"ID", nil];
}

- (NSString *)nibName {
    return @"AssumeInitial";
}
@end
