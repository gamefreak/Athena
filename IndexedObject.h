//
//  IndexedObject.h
//  Athena
//
//  Created by Scott McClaugherty on 2/16/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Index;
//This is to preserce indexs when adding removing or deleting packed objects.
//Otherwise we would be losing references left and right.
@interface IndexedObject : NSObject {
    Index *index;
}
@property (readwrite, assign) unsigned short objectIndex;
@property (readwrite, retain) Index *indexRef;
- (id) initWithIndex:(unsigned short)index;
- (void) objectsAddedAtIndexes:(NSIndexSet *)indexes;
- (void) objectsRemovedAtIndexes:(NSIndexSet *)indexes;
@end

@interface Index : NSObject {
    unsigned short index;
    id object;//do not release/retain
}
@property (readwrite, assign) unsigned short index;
@property (readonly) NSInteger orNull;
@property (readwrite, assign) id object;
- (id) initWithIndex:(unsigned short)index;
+ (id) index;
@end
