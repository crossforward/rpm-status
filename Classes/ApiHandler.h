//
//  ApiHandler.h
//  rpm_menu
//
//  Created by David Smith on 2/26/09.
//  Copyright 2009 Cross Forward Consulting, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RpmMenu.h"
#import "ApplicationStatus.h"

@class RpmMenu;
@class PreferencesController;

@interface ApiHandler : NSObject {

	NSMutableData *receivedData;
	RpmMenu* mainMenu;
	
	
	//FDL
	
	PreferencesController *prefs;
	int apiKeyCount;
	int currentApiKeyIndex;
	NSMutableArray* applications;
	ApplicationStatus* current;
	NSURLConnection *theConnection;

}

@property (nonatomic, retain) PreferencesController *prefs;

-(void)getData:(RpmMenu*)target ;
-(id)init;
-(void)getSingleData:(RpmMenu*)target;



@end
