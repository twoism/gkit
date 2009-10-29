//
//  GDirectionStep.m
//  GKit
//
//  Created by Christopher Burnett on 10/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GDirectionStep.h"


@implementation GDirectionStep

@synthesize distanceInMeters,durationInSeconds,coordinate,stepDescription;

- (void)dealloc
{
	[distanceInMeters release];
	[durationInSeconds release];
	[stepDescription release];
	[super dealloc];
}

- (id)initWithDictionary:(NSDictionary*)dictionary
{
	if(self = [super init]) {
		
		self.stepDescription		= [dictionary valueForKey:@"descriptionHtml"];
		self.distanceInMeters		= [NSNumber numberWithInt:[[[dictionary valueForKey:@"Distance"] valueForKey:@"meters"] intValue]];
		self.durationInSeconds	= [NSNumber numberWithInt:[[[dictionary valueForKey:@"Duration"] valueForKey:@"seconds"] intValue]];
		CLLocationCoordinate2D c;
		c.latitude			= [[[[dictionary valueForKey:@"Point"] valueForKey:@"coordinates"] objectAtIndex:0] floatValue];
		c.longitude			= [[[[dictionary valueForKey:@"Point"] valueForKey:@"coordinates"] objectAtIndex:1] floatValue];
		self.coordinate = c;
	}
	return self;
}

- (NSString*)description
{
	return [NSString stringWithFormat:@"%@ dist: %@ dur: %@ %f,%f",stepDescription,distanceInMeters,durationInSeconds,coordinate.latitude,coordinate.longitude];
}

@end
