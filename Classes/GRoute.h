//
//  GRoute.h
//  GKit
//
//  Created by Christopher Burnett on 10/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#include <HTTPRiot/HTTPRiot.h>

@interface GRoute : HRRestModel {
	NSMutableArray *steps;
}
@property(nonatomic,retain) NSMutableArray *steps;

+ (id)getRouteFromLocation:(CLLocationCoordinate2D)from
								toLocation:(CLLocationCoordinate2D)to
							withDelegate:(id)delegate;

- (id)initWithArray:(NSArray*)ar;

@end
