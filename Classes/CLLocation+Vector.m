//
//  CLLocation+Vector.m
//  GKit
//
//  Created by Christopher Burnett on 10/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CLLocation+Vector.h"

#define CARDINAL_DIRECTIONS [NSArray arrayWithObjects:@"North",@"NorthEast",@"East",@"SouthEast",@"South",@"SouthWest",@"West",@"NorthWest",nil]

@implementation CLLocation(Vectors)

- (float)angleBetween:(CLLocationCoordinate2D)coord
{
	
	float lat1 = self.coordinate.latitude * M_PI / 180.0;
	float lat2 = coord.latitude * M_PI / 180.0;
	float lon1 = self.coordinate.longitude * M_PI / 180.0;
	float lon2 = coord.longitude * M_PI / 180.0;
	
	float b = atan2f(sinf(lon2-lon1)*cosf(lat2), cosf(lat1)*sinf(lat2)-sinf(lat1)*cosf(lat2)*cosf(lon2-lon1));
	float a = (2*M_PI);
	float c = b - (floor(b/a) * a);
	return (c * (180/ M_PI));
}

- (NSString*)directionFromCoordinate:(CLLocationCoordinate2D)coord
{
	float degrees = [self angleBetween:coord];
	return [CARDINAL_DIRECTIONS objectAtIndex:((int)floor((fabs(degrees) + 22.5)/45) )];
}

@end
