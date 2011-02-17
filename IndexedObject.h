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
@property (readwrite, assign) NSUInteger objectIndex;
@property (readwrite, retain) Index *indexRef;
- (id) initWithIndex:(NSUInteger)index;
- (void) objectsAddedAtIndexes:(NSIndexSet *)indexes;
- (void) objectsRemovedAtIndexes:(NSIndexSet *)indexes;
@end

@interface Index : NSObject {
    NSUInteger index;
}
@property (readwrite, assign) NSUInteger index;
- (id) initWithIndex:(NSUInteger)index;
@end