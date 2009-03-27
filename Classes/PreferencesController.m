//
//  PreferencesController.m
//  rpm_menubar
//
//  Created by David Smith on 2/28/09.
//  Copyright 2009 Cross Forward Consulting, LLC. All rights reserved.
//

#import "PreferencesController.h"
#import "AGKeychain.h"


@implementation PreferencesController

- (void)showWindow:(id)sender
{
	main_menu = sender;
	if([self window] == nil)
	{
		[NSBundle loadNibNamed:@"Preferences" owner:self];
		[[self window] center];
	}
	[NSApp activateIgnoringOtherApps:YES];
	[[self window] makeKeyAndOrderFront:self];	

	
	
	NSString* current_key = [AGKeychain getPasswordFromKeychainItem:@"rpm_key"
													withItemKind:@"rpm_key"
													 forUsername:@"rpm_key"];
	
	
	[key setStringValue:current_key];
}

-(void)saveSettings {
	if([AGKeychain checkForExistanceOfKeychainItem:@"rpm_key"	withItemKind:@"rpm_key" forUsername:@"rpm_key"]) {
		[AGKeychain modifyKeychainItem:@"rpm_key" withItemKind:@"rpm_key" forUsername:@"rpm_key" withNewPassword:[key stringValue]];
	} else {
		[AGKeychain addKeychainItem:@"rpm_key"	withItemKind:@"rpm_key" forUsername:@"rpm_key" withPassword:[key stringValue]];
	}
}
- (void)windowWillClose:(NSNotification *)notification {
	[self saveSettings];
	[[[ApiHandler alloc] init] getData:main_menu];

}
- (IBAction)verify:(id)sender {

	[self saveSettings];
	
	NSString* current_key = [AGKeychain getPasswordFromKeychainItem:@"rpm_key"
											   withItemKind:@"rpm_key"
												forUsername:@"rpm_key"];
	
	NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://rpm.newrelic.com/accounts.xml?include=application_health"]];	
    [theRequest addValue:current_key forHTTPHeaderField:@"x-license-key"];
																		 
	NSURLConnection *theConnection= [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	
	if (theConnection) {
		receivedData=[[NSMutableData data] retain];
	} else {
		// inform the user that the download could not be made
	}
	
	[progress setHidden:NO];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	if([[[NSString alloc] initWithData:receivedData encoding:NSASCIIStringEncoding] characterAtIndex:0] != '<')
	{
		NSLog(@"Error");
		[verification setStringValue:@"Failed"];
		[verification setTextColor:[NSColor redColor]];
		[progress setHidden:YES];
	}else
	{
		[verification setStringValue:@"Success"];
		[verification setTextColor:[NSColor greenColor]];
		[progress setHidden:YES];
		[[[ApiHandler alloc] init] getData:main_menu];
	}
		
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	NSLog(@"Authentication Challenge %d", [challenge previousFailureCount]);
	[verification setStringValue:@"Failed"];
	[verification setTextColor:[NSColor redColor]];
	[progress setHidden:YES];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	NSLog(@"Error");
	[verification setStringValue:@"Failed"];
	[verification setTextColor:[NSColor redColor]];
	[progress setHidden:YES];
}


@end
