//
//  PreferencesController.m
//  rpm_menubar
//
//  Created by David Smith on 2/28/09.
//  Copyright 2009 Cross Forward Consulting, LLC. All rights reserved.
//

#import "PreferencesController.h"
#import "AGKeychain.h"
#import "Constants.h";

@implementation PreferencesController
@synthesize apiKeyCount, keyStrings;



/*
 9dcf486db6a2291ef7b8537447fd3c69e0b8e484
 
 461a28f6aea5260bac47caf2d8eb72cbf0d90eec
 */



- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
	
		if([(NSString *)anObject  isEqualToString:@""])
		{
			NSLog(@"Delete %d", rowIndex);
			[self deleteKeyNumber:rowIndex];
			[self updateKeyArrayFromKeychain];
			[apiKeyTable reloadData];
			[main_menu handleTimer:nil];
		}
		else  
		{
			NSLog(@"Edited %d.  Did not delete.", rowIndex);
		}

}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
	return apiKeyCount;
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
	
	//if(apiKeyCount<=0) return 0;

	return [keyStrings objectAtIndex:rowIndex];

	
}


-(void)deleteKeyNumber:(int)_keynum
{


	

	//Start at deleted key, modify that key to take the value of the next key, repeat.	
	

	
	for(int i=_keynum;i<apiKeyCount-1;i++)
	{
		
		
	
		NSString *keyName=[self nameForApiKeyNumber:i];


		[AGKeychain modifyKeychainItem:keyName withItemKind:keyName forUsername:keyName withNewPassword:(NSString *)[keyStrings objectAtIndex:i+1]];

		
	}
	
	NSString *keyName=[self nameForApiKeyNumber:apiKeyCount-1];

	
	if([AGKeychain checkForExistanceOfKeychainItem:keyName	withItemKind:keyName forUsername:keyName]) 
	{
		[AGKeychain deleteKeychainItem:keyName withItemKind:keyName forUsername:keyName];
		
		//[AGKeychain modifyKeychainItem:keyName withItemKind:keyName forUsername:keyName withNewPassword:[key stringValue]];

	} 
	
	
	
	
	
}


-(void)initialize
{
	//Create array to hold all key stringValues
	keyStrings=[[NSMutableArray alloc]initWithCapacity:1];
	[keyStrings retain];
	[self updateKeyArrayFromKeychain];
	
}

- (void)showWindow:(id)sender
{

	// Auto called on first run.  Also shown from "preferences" in the menu
	main_menu = sender;
	if([self window] == nil)
	{
		[NSBundle loadNibNamed:@"Preferences" owner:self];
		[[self window] center];
	}
	[NSApp activateIgnoringOtherApps:YES];
	[[self window] makeKeyAndOrderFront:self];	

	
	//Populate textfield with something
	//NSString* current_key = [AGKeychain getPasswordFromKeychainItem:@"rpm_key0"	withItemKind:@"rpm_key0" forUsername:@"rpm_key0"];
	
	

	
	//[self updateKeyArrayFromKeychain];
	
	
	[key setStringValue:@"Enter API Key"];
	
	[apiKeyTable reloadData  ];

}

-(void)updateKeyArrayFromKeychain
{
	
	
//	if(apiKeyCount<=0) return;
	
	//Initialize values for looping through existing registerted API keys
	int currentKeyNumber=0;
	NSString *keyName=[self nameForApiKeyNumber:currentKeyNumber];//[[NSMutableString alloc] initWithFormat:@"%@%d", kKeyStringBase, currentKeyNumber];
	NSString *tmpString;
	
	NSLog(@"Looking for registered API keys.");
	
	[keyStrings removeAllObjects];
	
	//Loop through keychain, retrieving existing registered API keys
	while(  [AGKeychain checkForExistanceOfKeychainItem:keyName	withItemKind:keyName forUsername:keyName]) 
	{
		
		keyName=[[NSMutableString alloc] initWithFormat:@"%@%d", kKeyStringBase, currentKeyNumber];
		
		tmpString=[NSString stringWithString:[AGKeychain getPasswordFromKeychainItem:keyName	withItemKind:keyName forUsername:keyName] ];
		
		NSLog(@"Found keyName : %@  key : %@",keyName, tmpString);
		
		[keyStrings addObject:tmpString ];
		[tmpString release];
		currentKeyNumber++;
		
		
	}
	
	[keyStrings retain];
	
	apiKeyCount=currentKeyNumber-1;
	lastKeyIndex=apiKeyCount-1;
	
	NSLog(@"API Keys found: %d", apiKeyCount);
	
	
	
}

-(void)saveSettings {
	//if(apiKeyCount<=0) return;

	
	NSString *newKeyName=[self nameForApiKeyNumber:apiKeyCount];// [[NSMutableString alloc] initWithFormat:@"%@%d", kKeyStringBase, lastKeyIndex+1];
	
	if([AGKeychain checkForExistanceOfKeychainItem:newKeyName	withItemKind:newKeyName forUsername:newKeyName]) 
	{
		[AGKeychain modifyKeychainItem:newKeyName withItemKind:newKeyName forUsername:newKeyName withNewPassword:[key stringValue]];
	} 
	
	else 
	{
		[AGKeychain addKeychainItem:newKeyName	withItemKind:newKeyName forUsername:newKeyName withPassword:[key stringValue]];
	}
	
	[self updateKeyArrayFromKeychain];
}


-(NSString *)nameForApiKeyNumber:(int)_num
{
	if(_num<0) _num=0;
	
	
	return [NSString stringWithFormat: @"%@%d", kKeyStringBase, _num ];
	
}



- (void)windowWillClose:(NSNotification *)notification 
{
	//[self saveSettings];
	//[[[ApiHandler alloc] init] getData:main_menu];

}



- (IBAction)verify:(id)sender 
{
	
	//Method handles presses of "Verify" button

	
	apiKeyToAttempt=[key stringValue];

	NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://rpm.newrelic.com/accounts.xml?include=application_health"]  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0];

    [theRequest addValue:apiKeyToAttempt forHTTPHeaderField:@"x-license-key"];
																		 
	NSURLConnection *theConnection= [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];

	if (theConnection) 
	{
		receivedData=[[NSMutableData data] retain];
	} else 
	{
		// inform the user that the download could not be made
	}
	
	

	 	
}




- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	
//	NSLog([[NSString alloc] initWithData:receivedData encoding:NSASCIIStringEncoding]);	

    [receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSLog([[NSString alloc] initWithData:receivedData encoding:NSASCIIStringEncoding]);	

	if([[[NSString alloc] initWithData:receivedData encoding:NSASCIIStringEncoding] characterAtIndex:0] != '<')
	{
		NSLog(@"Error");
		[verification setStringValue:@"Failed"];
		[verification setTextColor:[NSColor redColor]];
		[progress setHidden:YES];
	}
	

	
	else
	{
		[self saveSettings];
		
		[main_menu handleTimer:nil];
		[progress setHidden:NO];
		[apiKeyTable reloadData];
		[key setStringValue:@""];
		if(apiKeyCount==1)[main_menu beginTimer];
		
		
		
		[verification setStringValue:@"Success"];
		[verification setTextColor:[NSColor greenColor]];
		[progress setHidden:YES];
		[[[ApiHandler alloc] init] getData:main_menu ];
		
		//[keyStrings addObject:key];
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
