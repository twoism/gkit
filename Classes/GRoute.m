//
//  GRoute.m
//  GKit
//
//  Created by Christopher Burnett on 10/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GRoute.h"

@implementation GRoute

@synthesize steps;

- (void)dealloc
{
	[steps release];
	[super dealloc];
}

// http://maps.google.com/maps?saddr=Atlanta,GA&daddr=Birmingham,AL&output=xml

+ (void)initialize {
	[self setDelegate:self];
	[self setBaseURL:[NSURL URLWithString:@"http://maps.google.com"]];
	[self setDefaultParams:[NSDictionary dictionaryWithObjectsAndKeys:
													@"kml",@"output",
													nil]];
	[self setFormat:HRDataFormatXML];
	/* Spoofing for Access */
	[self setHeaders:[NSDictionary dictionaryWithObject:@"http://iphone.local" forKey:@"Referer"]];
}

+ (id)getRouteFromLocation:(CLLocationCoordinate2D)from
								toLocation:(CLLocationCoordinate2D)to
							withDelegate:(id)delegate 
{
	NSString *toStr				= [NSString stringWithFormat:@"%f,%f",from.latitude,from.longitude];
	NSString *fromStr			= [NSString stringWithFormat:@"%f,%f",to.latitude,to.longitude];
	NSDictionary *d			= [NSDictionary dictionaryWithObjectsAndKeys:fromStr,@"saddr",toStr,@"daddr",nil];
	NSDictionary *opts	= [NSDictionary dictionaryWithObject:d forKey:@"params"];
	[self getPath:@"/maps" withOptions:opts object:delegate];
	return self;
}

#pragma mark - HRRequestOperation Delegates
+ (void)restConnection:(NSURLConnection *)connection 
			didFailWithError:(NSError *)error 
								object:(id)object 
{
	NSLog(@"%@",[error localizedDescription]);
}

+ (void)restConnection:(NSURLConnection *)connection 
			 didReceiveError:(NSError *)error 
							response:(NSHTTPURLResponse *)response 
								object:(id)object 
{
	NSLog(@"%@",[error localizedDescription]);
}

+ (void)restConnection:(NSURLConnection *)connection 
	didReceiveParseError:(NSError *)error 
					responseBody:(NSString *)string 
{
	NSLog(@"%@",[error localizedDescription]);
}

+ (void)restConnection:(NSURLConnection *)connection 
		 didReturnResource:(id)resource 
								object:(id)object 
{
	NSString *coordinatesString = [[[resource valueForKeyPath:@"kml.Document.Placemark"] lastObject] valueForKeyPath:@"GeometryCollection.LineString.coordinates"];
	GRoute *route = [[GRoute alloc] initWithArray:[coordinatesString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]]]
	NSLog(@"%@",coordinatesString);
}

- (id)initWithArray:(NSArray*)ar
{
	if(self = [super init]) {
		for (id item in ar) {
			CLLocation *c;
			c.coordinate.latitude	= [[item objectAtIndex:0] floatValue];
			c.coordinate.longitude = [[item objectAtIndex:1] floatValue];
			//[self.steps addObject:c];
		}
		
	}
	return self;
}



@end
