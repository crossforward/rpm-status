//
//  ApiHandler.m
//  rpm_menu
//
//  Created by David Smith on 2/26/09.
//  Copyright 2009 Cross Forward Consulting, LLC. All rights reserved.
//

#import "ApiHandler.h"
#import "ApplicationStatus.h"
#import "AGKeychain.h"

@implementation ApiHandler
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	[mainMenu setErrorStatus];
}

-(void)getData:(RpmMenu*)target
{
	NSString* key = [AGKeychain getPasswordFromKeychainItem:@"rpm_key"
													withItemKind:@"rpm_key"
													 forUsername:@"rpm_key"];
	
	mainMenu = target;
	NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://rpm.newrelic.com/accounts.xml?include=application_health"]];	
	NSLog(key);
	[theRequest addValue:key forHTTPHeaderField:@"x-license-key"];
	NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if (theConnection) {
		receivedData=[[NSMutableData data] retain];
	} else {
		// inform the user that the download could not be made
	}
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	 [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[connection release];
    [receivedData release];
	[mainMenu setErrorStatus];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection

{
	NSLog([[NSString alloc] initWithData:receivedData encoding:NSASCIIStringEncoding]);	
	NSError *error;
	NSXMLDocument* doc = [[NSXMLDocument alloc] initWithData:receivedData options:0 error:&error];
    if (!doc) {
		[mainMenu setErrorStatus];
		return;
    }    

	NSMutableArray* applications = [[NSMutableArray alloc] init];
    NSArray *itemNodes = [[doc nodesForXPath:@"//application" error:&error] retain];
	for(int i = 0 ; i < [itemNodes count]; i++ ) {
		ApplicationStatus* current = [[ApplicationStatus alloc] init];
		NSXMLElement* currentNode = [itemNodes objectAtIndex:i];
		for(int j = 0; j < [[currentNode children] count]; j++) {
			NSXMLElement* attribute = [[currentNode children] objectAtIndex:j];
			if ([@"id" compare:[attribute name] options:NSCaseInsensitiveSearch] == NSOrderedSame) {
				current.application_id = [[attribute stringValue] integerValue];
			} else if ([@"name" compare:[attribute name] options:NSCaseInsensitiveSearch] == NSOrderedSame) {
				current.name = [attribute stringValue];
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
	}	
	
	// release the connection, and the data object
	
	[connection release];
	
	[receivedData release];
	[mainMenu updateStatus:applications];
}
		  
@end
