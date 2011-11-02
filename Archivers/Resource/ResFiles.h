//
//  ResFiles.h
//  Athena
//
//  Created by Scott McClaugherty on 11/2/11.
//  Copyright (c) 2011 Scott McClaugherty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ResFile <NSObject>
- (id)initWithFileName:(NSString *)fileName;
- (NSDictionary *)allEntriesOfClass:(Class)class;
@end

@interface ResourceFile : NSObject <ResFile> {
    ResFileRefNum fileNumber;
}
@end

@interface ZipFile : NSObject <ResFile> {
    NSString *directoryName;
}
- (NSString *)getMetadataForKey:(NSString *)key;
@end
