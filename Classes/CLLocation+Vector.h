//
//  CLLocation+Vector.h
//  GKit
//
//  Created by Christopher Burnett on 10/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CLLocation(Vectors) 
- (float)angleBetween:(CLLocationCoordinate2D)coord;
- (NSString*)directionFromCoordinate:(CLLocationCoordinate2D)coord;
@end
