//
//  ImageEditor.h
//  Athena
//
//  Created by Scott McClaugherty on 10/4/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MainData, XSImageView;

@interface ImageEditor : NSWindowController {
    MainData *data;
    NSMutableArray *images;
    IBOutlet XSImageView *imageView;
    IBOutlet NSArrayController *arrayController;
}
@property (readonly) MainData *data;
@property (readwrite, retain) NSMutableArray *images;
- (id)initWithMainData:(MainData *)data;
@end
