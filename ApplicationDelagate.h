//
//  ApplicationDelagate.h
//  Athena
//
//  Created by Scott McClaugherty on 2/1/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString *XSAresDataUrl;
extern NSString *XSHasAskedForData;
extern NSString *XSHasAresData;

extern NSString *HeraHelpURL;

@interface ApplicationDelagate : NSObject <NSApplicationDelegate> {

}
+ (NSString *)supportDir;
+ (void)ensureDirectoryExists:(NSString *)directory;
- (void)downloadAresData;
- (void)downloadDidComplete:(NSNotification *)notification;
- (void)openDefaultData;
- (IBAction)redownloadData:(id)sender;
- (IBAction)openOrignalData:(id)sender;//Action version
- (IBAction)showHeraHelp:(id)sender;
@end
