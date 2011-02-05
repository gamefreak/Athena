//
//  TextEditor.h
//  Athena
//
//  Created by Scott McClaugherty on 2/5/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface TextEditor : NSWindowController {
    NSString *title;
    NSString *text;
}
- (id) initWithTitle:(NSString *)title text:(NSString *)text;
@end
