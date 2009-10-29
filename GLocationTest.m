#import "GHUnit.h"
#import "GHAsyncTestCase.h"
#import "GLocation.h"
#import "GDirection.h"
#import "GDirectionStep.h"
#import "GRoute.h"
#import <CoreLocation/CoreLocation.h>
#import "CLLocation+Vector.h"

@interface GLocationTest : GHAsyncTestCase { }
@end

@implementation GLocationTest

- (void)testResultsForGLocation 
{
	[self prepare];
		
		CLLocationCoordinate2D myHouse;
		myHouse.latitude	= 33.760174;
		myHouse.longitude = -84.332780;
		[GLocation getLocalResultsForLocation:myHouse withQuery:@"Corner Tavern" withDelegate:self];
	
	[self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)locationsLoaded:(NSArray*)locations
{
	GHAssertGreaterThanOrEqual((int)[locations count],1,nil);
	
	for (GLocation* l in locations) {
		GHAssertNotNil(l.name,nil);
		GHAssertNotNil(l.address,nil);
		GHAssertNotNil(l.country,nil);
		GHAssertNotNil(l.city,nil);
		GHAssertNotNil(l.phone,nil);
		GHAssertNotNil(l.region,nil);
	}
	
	[self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testResultsForGLocation)];
}

- (void)testDirections
{
	[self prepare];
		CLLocationCoordinate2D myHouse;
		myHouse.latitude	= 33.760174;
		myHouse.longitude = -84.332780;
		
		CLLocationCoordinate2D cornerTavern;
		cornerTavern.latitude	= 33.679771;
		cornerTavern.longitude = -84.440544;
		
		[GDirection getDirectionsFromLocation:myHouse toLocation:cornerTavern withDelegate:self];
	
	[self waitForStatus:kGHUnitWaitStatusSuccess timeout:20.0];
}

- (void)directionsLoaded:(GDirection*)gd
{
	
	for (GDirectionStep * s in gd.routes) {
		GHAssertNotNil(s.stepDescription,nil);
		GHAssertNotNil(s.distanceInMeters,nil);
		GHAssertNotNil(s.durationInSeconds,nil);
	}
	
	[self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testDirections)];
}

- (void)testRouting 
{
	[self prepare];
	
	CLLocationCoordinate2D myHouse;
	myHouse.latitude	= 33.760174;
	myHouse.longitude = -84.332780;
	
	CLLocationCoordinate2D cornerTavern;
	cornerTavern.latitude	= 33.679771;
	cornerTavern.longitude = -84.440544;
	
	[GRoute getRouteFromLocation:myHouse toLocation:cornerTavern withDelegate:self];
	
	[self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)testShouldBeNorth
{
	CLLocationCoordinate2D northPoint;
	
	northPoint.latitude		= 40.714269;
	northPoint.longitude	= -84.33217;
	
	CLLocation *myHouse = [[CLLocation alloc] initWithLatitude:33.760168 longitude:-84.33217];
	GHAssertEqualStrings([myHouse directionFromCoordinate:northPoint], @"North", [NSString stringWithFormat:@"Should be north, got %@",[myHouse directionFromCoordinate:northPoint]]);
}

- (void)testShouldBeWest
{
	CLLocationCoordinate2D westPoint;
	westPoint.latitude	= 37.77493;
	westPoint.longitude = -122.419415;
	
	CLLocation *myHouse = [[CLLocation alloc] initWithLatitude:33.760168 longitude:-84.33217];
	GHAssertEqualStrings([myHouse directionFromCoordinate:westPoint], @"West", [NSString stringWithFormat:@"Should be west, got %@",[myHouse directionFromCoordinate:westPoint]]);
	
}

@end