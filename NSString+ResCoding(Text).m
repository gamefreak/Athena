//
//  NSString+ResCoding(Text).m
//  Athena
//
//  Created by Scott McClaugherty on 2/11/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "NSString+ResCoding(Text).h"
#import "ResUnarchiver.h"

@implementation NSString (NSString_ResCoding_Text)
- (id) initWithResArchiver:(ResUnarchiver *)coder {
    self = [self initWithData:[coder rawData] encoding:NSMacOSRomanStringEncoding];
    return self;
}

//- (void)encodeResWithCoder:(ResArchiver *)coder {}

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
