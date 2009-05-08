//
//  ApiHandler.m
//  rpm_menu
//
//  Created by David Smith on 2/26/09.
//  Copyright 2009 Cross Forward Consulting, LLC. All rights reserved.
//

#import "ApiHandler.h"
#import "AGKeychain.h"
#import "Constants.h"

@implementation ApiHandler
@synthesize prefs;

-(id)init
{
	if(self=[super init])
	{
		currentApiKeyIndex=0;
		//[super init];
	}
	return self;
	
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	[mainMenu setErrorStatus];
}


-(void)getData:(RpmMenu*)target 
{
	
	apiKeyCount=[prefs apiKeyCount];
	
	if(apiKeyCount<=0) return;
	//NSLog(@"ApiKeyCount : %d", apiKeyCount);
	currentApiKeyIndex=0;
	applications = [[NSMutableArray alloc] init];
	[self getSingleData:target];
	
	mainMenu = target;
	
}



-(void)getSingleData:(RpmMenu*)target 

{
	
	//loop through api keys here

	receivedData=nil;
	
	
	NSLog(@"ApiKeyCount : %d, currentApiIndex : %d", apiKeyCount, currentApiKeyIndex);
	
	/*
	
	NSString *keyName=[self nameForApiKeyNumber:currentApiKeyIndex];
	NSLog(@"keyName : %@", keyName);
	
	*/
	
	
	//NSString* key = [AGKeychain getPasswordFromKeychainItem:keyName withItemKind:keyName forUsername:keyName];
	NSString *key=[NSString stringWithString:(NSString* )[[prefs keyStrings] objectAtIndex:currentApiKeyIndex]];
	NSLog(@"key : %@", key);
	
	
	
//	NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:filename] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0 ];//cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0

	
	NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://rpm.newrelic.com/accounts.xml?include=application_health"]  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0];
	//NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://rpm.newrelic.com/accounts.xml?include=application_health"]];	
	[theRequest addValue:key forHTTPHeaderField:@"x-license-key"];

	
	receivedData=[[NSMutableData alloc] initWithLength:0];
	
	theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	
	if (theConnection) 
	{
		
		//receivedData=nil;
		//receivedData=[[NSMutableData data] retain];
		//[receivedData setLength:0];
		

	} 
	else 
	{
		
	}
	[theRequest release];	


}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"Yes there is a connection. Iteration %d", currentApiKeyIndex);

	 [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
 	NSLog([[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);	
	[receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[connection release];
    [receivedData release];
	[mainMenu setErrorStatus];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection

{
	[connection cancel];
	[connection release];
	
	NSLog(@"XML Data Found.  Iteration %d", currentApiKeyIndex);
//	NSLog([[NSString alloc] initWithData:receivedData encoding:NSASCIIStringEncoding]);	
	NSError *error;
	NSXMLDocument* doc = [[NSXMLDocument alloc] initWithData:receivedData options:0 error:&error];
    
	if (!doc) 
	{
		[mainMenu setErrorStatus];
		return;
    }    

	

    NSArray *itemNodes = [[doc nodesForXPath:@"//application" error:&error] retain];
	for(int i = 0 ; i < [itemNodes count]; i++ ) {
		current = [[ApplicationStatus alloc] init];
		NSXMLElement* currentNode  = [itemNodes objectAtIndex:i];
		for(int j = 0; j < [[currentNode children] count]; j++) {
			NSXMLElement* attribute = [[currentNode children] objectAtIndex:j];
			if ([@"id" compare:[attribute name] options:NSCaseInsensitiveSearch] == NSOrderedSame) {
				current.application_id = [[attribute stringValue] integerValue];
			} else if ([@"name" compare:[attribute name] options:NSCaseInsensitiveSearch] == NSOrderedSame) {
				current.name = [attribute stringValue];
				NSLog(@"////////// Project found : %@ /////////////", current.name);
			} else if ([@"overview-url" compare:[attribute name] options:NSCaseInsensitiveSearch] == NSOrderedSame) {
				current.overview_url = [attribute stringValue];
			} else if ([@"threshold-values" compare:[attribute name] options:NSCaseInsensitiveSearch] == NSOrderedSame) {
				for(int k = 0; k < [[attribute children] count]; k++) {
					NSXMLElement* values = [[attribute children] objectAtIndex:k];
					if( [@"CPU" compare:[[values attributeForName:@"name"] stringValue] options:NSCaseInsensitiveSearch] == NSOrderedSame) {
						current.cpu_status = [[[values attributeForName:@"threshold_value"] stringValue] integerValue];
						current.cpu = [[values attributeForName:@"formatted_metric_value"] stringValue];
					}
					if( [@"Memory" compare:[[values attributeForName:@"name"] stringValue] options:NSCaseInsensitiveSearch] == NSOrderedSame) {
						current.memory_status = [[[values attributeForName:@"threshold_value"] stringValue] integerValue];
						current.memory = [[values attributeForName:@"formatted_metric_value"] stringValue];
					}
					if( [@"Response Time" compare:[[values attributeForName:@"name"] stringValue] options:NSCaseInsensitiveSearch] == NSOrderedSame) {
						current.response_time_status = [[[values attributeForName:@"threshold_value"] stringValue] integerValue];
						current.response_time = [[values attributeForName:@"formatted_metric_value"] stringValue];
					}
					if( [@"Throughput" compare:[[values attributeForName:@"name"] stringValue] options:NSCaseInsensitiveSearch] == NSOrderedSame) {
						current.throughput_status = [[[values attributeForName:@"threshold_value"] stringValue] integerValue];
						current.throughput = [[values attributeForName:@"formatted_metric_value"] stringValue];
					}
					if( [@"DB" compare:[[values attributeForName:@"name"] stringValue] options:NSCaseInsensitiveSearch] == NSOrderedSame) {
						current.db_status = [[[values attributeForName:@"threshold_value"] stringValue] integerValue];
						current.db = [[values attributeForName:@"formatted_metric_value"] stringValue];
					}
					
				}	
			}
		}
		[applications addObject:current];
		[current release];
		
	}	
	
	
	[doc release];
	connection=nil;
	// release the connection, and the data object
	[receivedData setLength:0];

	[receivedData release];
	[current release];
	
	NSLog(@"XML Data Loaded.");


	if(currentApiKeyIndex<apiKeyCount-1)
	{
		currentApiKeyIndex++;
		[self getSingleData:mainMenu];
	}
	else
	{
		currentApiKeyIndex=0;
		[mainMenu updateStatus:applications];
		[applications removeAllObjects];	
		[receivedData release];
	}

}
		  
@end
