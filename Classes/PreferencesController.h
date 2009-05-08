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

@class RpmMenu;
@class ApiHandler;

@interface PreferencesController : NSWindowController {
	IBOutlet NSTextField* key;
	IBOutlet NSProgressIndicator* progress;
	IBOutlet NSTextField* verification;
	
	RpmMenu* main_menu;
	NSMutableData* receivedData;
	
	
	/// FDL
	
	IBOutlet NSTableView* apiKeyTable;
	int apiKeyCount;
	int lastKeyIndex;
	
	NSString *apiKeyToAttempt;
	
	NSMutableArray *keyStrings;
	//IBOutlet 
}


@property int apiKeyCount;
@property (nonatomic, retain) NSMutableArray *keyStrings;

-(void)deleteKeyNumber:(int)_keynum;
-(void)initialize;
-(NSString *)nameForApiKeyNumber:(int)_num;
- (IBAction)verify:(id)sender;
-(void)saveSettings;
-(void)updateKeyArrayFromKeychain;

@end
