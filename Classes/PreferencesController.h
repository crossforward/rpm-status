//
//  PreferencesController.h
//  rpm_menubar
//
//  Created by David Smith on 2/28/09.
//  Copyright 2009 Cross Forward Consulting, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ApiHandler.h"
#import "RpmMenu.h"

@interface PreferencesController : NSWindowController {
	IBOutlet NSTextField* key;
	IBOutlet NSProgressIndicator* progress;
	IBOutlet NSTextField* verification;
	
	RpmMenu* main_menu;
	NSMutableData* receivedData;
}

- (IBAction)verify:(id)sender;
-(void)saveSettings;

@end
