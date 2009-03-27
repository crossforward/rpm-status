//
//  ApiHandler.h
//  rpm_menu
//
//  Created by David Smith on 2/26/09.
//  Copyright 2009 Cross Forward Consulting, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RpmMenu.h"

@interface ApiHandler : NSObject {

	NSMutableData *receivedData;
	RpmMenu* mainMenu;
}

-(void)getData:(RpmMenu*)target;

@end
