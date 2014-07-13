//
//  DownloadWindow.h
//  Athena
//
//  Created by Scott McClaugherty on 8/29/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ProgressWindow.h"

extern NSString *XSDownloadComplete;

@interface DownloadWindow : ProgressWindow <NSURLDownloadDelegate> {
    NSString *displayText;
    NSURLResponse *response;
    NSUInteger bytesDownloaded;
    NSString *destination;
}
@property (retain) NSString *displayText;
@property (retain) NSURLResponse *response;
@property (retain) NSString *destination;
@end
