//
//  CalModel.m
//  CalSpy
//
//  Created by Zhang on 09/10/12.
//  Copyright (c) 2012 Zhang. All rights reserved.
//

#import "CalModel.h"
#import <EventKit/EventKit.h>

@interface CalModel(){
    EKEventStore *store;
    NSDateFormatter *formatter;
}
- (NSDate *)getDatePart: (NSDate *)date;
@end

@implementation CalModel

- (id)init
{
    self = [super init];
    store = [[EKEventStore alloc] init];
    if([EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent] ==EKAuthorizationStatusNotDetermined){
        [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            
        }];
    }else{
        
    }
    
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
    }
    
    return self;
}

- (NSArray*)retrieveEventsFrom:(NSDate*)dateBegin To:(NSDate*)dateEnd inCalendars:(NSArray *)calendars
{
    // Create the predicate from the event store's instance method
    NSPredicate *predicate = [store predicateForEventsWithStartDate:dateBegin
                                                            endDate:dateEnd
                                                          calendars:calendars];
    
    // Fetch all events that match the predicate
    NSArray *events = [store eventsMatchingPredicate:predicate];
    
    return events;
}

- (NSArray*)generateSectionsByIteratingEventsArray: (NSArray*)events
{
    NSMutableArray *toReturn = [[NSMutableArray alloc]init];
    NSInteger n = 0;
    NSMutableArray *currentRows = [[NSMutableArray alloc]init];
    NSDate *currentDate;
    for(EKEvent *evt in events){
        NSDate *eventDate = [self getDatePart:evt.startDate];
        if (![eventDate isEqualToDate:currentDate]) {
            [toReturn addObject:[[NSDictionary alloc] initWithObjectsAndKeys:[[NSNumber alloc]initWithInteger:n],@"rowsCount",currentRows, @"rows", [formatter stringFromDate:currentDate], @"sectionLabel", nil]];
            n = 0;
            [currentRows removeAllObjects];
            currentDate = eventDate;
        }
        [currentRows addObject:evt];
        n++;
    }
    if(n!=0){
        [toReturn addObject:[[NSDictionary alloc] initWithObjectsAndKeys:[[NSNumber alloc]initWithInteger:n],@"rowsCount",currentRows, @"rows", [formatter stringFromDate:currentDate], @"sectionLabel", nil]];
    }
    return toReturn;
}

- (NSArray*)retrieveAllCalendars
{
    return [store calendarsForEntityType:EKEntityTypeEvent];
}

- (NSDate *)getDatePart: (NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger comps = (NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit);
    NSDateComponents *dateComponents = [calendar components:comps fromDate: date];
    return [calendar dateFromComponents:dateComponents];
}



@end
