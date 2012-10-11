//
//  CalModel.h
//  CalSpy
//
//  Created by Zhang on 09/10/12.
//  Copyright (c) 2012 Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalModel : NSObject

- (NSArray*)retrieveEventsFrom:(NSDate*)dateBegin To:(NSDate*)dateEnd inCalendars:(NSArray *)calendars;
- (NSArray*)generateSectionsByIteratingEventsArray: (NSArray*)events;
- (NSArray*)retrieveAllCalendars;

@end
