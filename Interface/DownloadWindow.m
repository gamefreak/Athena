//
//  DownloadWindow.m
//  Athena
//
//  Created by Scott McClaugherty on 8/29/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "DownloadWindow.h"

NSString *XSDownloadComplete = @"XSDownloadComplete";

@implementation DownloadWindow
@synthesize displayText, response, destination;

- (id)initWithWindow:(NSWindow *)window {
    self = [super initWithWindow:window];
    if (self) {
        [self setDisplayText:@"PLACEHOLDER"];
        bytesDownloaded = 0;
    }
    
    return self;
}

- (void)dealloc {
    [displayText release];
    [response release];
    [destination release];
    [super dealloc];
}

- (void)download:(NSURLDownload *)download didReceiveResponse:(NSURLResponse *)newResponse {
    [self setResponse:newResponse];
}

- (void)download:(NSURLDownload *)download didReceiveDataOfLength:(NSUInteger)length {
    NSInteger downloadSize = [response expectedContentLength];
    bytesDownloaded += length;
    [self setPercentage:100.0f*(float)bytesDownloaded/downloadSize];
}

- (void)download:(NSURLDownload *)download didFailWithError:(NSError *)error {
    NSLog(@"Download failed %@", error);
}

- (void)downloadDidFinish:(NSURLDownload *)download {
    [[NSNotificationCenter defaultCenter] postNotificationName:XSDownloadComplete object:self];
}

- (void)download:(NSURLDownload *)download decideDestinationWithSuggestedFilename:(NSString *)filename {
    NSString *path = [destination stringByAppendingPathComponent:filename];
    NSLog(@"DEST: %@", path);
    [download setDestination:filename allowOverwrite:YES];
}

