//
//  ApplicationDelagate.h
//  Athena
//
//  Created by Scott McClaugherty on 2/1/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString *XSAresDataUrl;

@interface ApplicationDelagate : NSObject <NSApplicationDelegate> {

}
- (NSString *)supportDir;
- (void)downloadAresData;
- (void)downloadDidComplete:(NSNotification *)notification;
- (void)openDefaultData;
@end
