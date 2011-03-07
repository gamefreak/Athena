//
//  WeaponViewController.h
//  Athena
//
//  Created by Scott McClaugherty on 3/6/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class BaseObject;
@class Weapon;

@interface WeaponViewController : NSViewController {
    NSString *weaponTitle;//i.e. pulse,beam,special
    Weapon *weapon;//IB supplied
    IBOutlet NSView *targetView;
}
@property (readwrite, retain) NSString *weaponTitle;

- (IBAction) openObjectPicker:(id)sender;
@end
