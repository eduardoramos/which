//
//  DataRetriever.m
//  which
//
//  Created by Eduardo Ramos on 6/25/16.
//  Copyright © 2016 Eduardo Ramos. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <EventKit/EventKit.h>

#import "DataRetriever.h"

@implementation DataRetriever

static DataRetriever* _sharedDataRetriever = nil;

+(DataRetriever*)sharedDataRetrieverSingleton
{
    @synchronized([DataRetriever class])
    {
        if(_sharedDataRetriever == nil)
            _sharedDataRetriever = [[super allocWithZone:NULL] init];
    }
    return _sharedDataRetriever;
}

- (EKEventStore*)store {
    if (!_store) {
        _store = [[EKEventStore alloc] init];
    }
    return _store;
}

-(void) accessToCalendarGrantedWithCalendar:(NSCalendar*)cal {
    NSDate *today = [NSDate dateWithTimeIntervalSinceNow:0];
    // Create the start date component
    NSDateComponents *fourteenDaysFromTodayComponents = [[NSDateComponents alloc]init];
    fourteenDaysFromTodayComponents.day = 14;
    NSDate *fourteenDaysFromToday = [cal dateByAddingComponents:fourteenDaysFromTodayComponents
                                                   toDate:[NSDate date]
                                                  options:0];
    
    //Create the end date component
    NSPredicate *predicate = [self.store predicateForEventsWithStartDate:today endDate:fourteenDaysFromToday calendars:nil];
    
    // Fetch all events that match the predicate
    NSArray *events = [self.store eventsMatchingPredicate:predicate];
    NSLog(@"Retrieved %lu events: %@ to %@",(unsigned long)events.count,fourteenDaysFromToday, today);
    
    for (EKEvent*event in events) {
        NSLog(@"Event %@",event.title);
        if ([event.title containsString:@"PP#"]) {
            NSLog(@"Found %@",event.title);
            [self setPayperiodText:event.title];
            NSUInteger unitFlags = NSCalendarUnitDay;
            NSCalendar *gregorian = [[NSCalendar alloc]
                                     initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDateComponents *components = [gregorian components:unitFlags
                                                        fromDate:today
                                                          toDate:event.startDate options:0];
            NSInteger week;
            if (components.day<7)
                week=2;
            else
                week=1;
            
            NSDateFormatter* day = [[NSDateFormatter alloc] init];
            [day setDateFormat: @"EEEE"];
            NSLog(@"the day is: %@", [day stringFromDate:[NSDate date]]);
            [self setDateText:[NSString stringWithFormat:@"%@ Week %ld",
                               [day stringFromDate:[NSDate date]],
                               (long)week]];
            
            NSLog(@"The difference is %li",(long)components.day);
            
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EventsUpdated" object:self];
}

- (void)updateData {
    NSLog(@"updateData called");
    // This method is called when watch view controller is about to be visible to user
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSDate *today = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSDateComponents *components = [cal components:NSCalendarUnitDay fromDate:today];
    NSInteger day = [components day];
    
    NSString * myString;
    
    if ((day>10) && (day<=26))
    {
        myString = @"Gold\n(11-26th)";
        [self setBackgroundColor:[UIColor yellowColor]];
        [self setTextColor:[UIColor blackColor]];
        
    }
    else
    {
        myString = @"Blue\n(27-10th)";
        [self setBackgroundColor:[UIColor blueColor]];
        [self setTextColor:[UIColor whiteColor]];
        
    }
    
    myString = [NSString stringWithFormat:@"%@",myString];
    
    [self setCardText:myString];

    [self.store reset];
    
    if (!self.isAccessToEventStoreGranted)
    {
        [self setPayperiodText:@"GSA Calendar"];
        [self setDateText:@"Retrieving Events..."];
    }
    
    EKAuthorizationStatus authorizationStatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];

    switch (authorizationStatus) {
        case EKAuthorizationStatusDenied:
        case EKAuthorizationStatusRestricted:
            self.isAccessToEventStoreGranted=NO;
            NSLog(@"Not authorized");
        case EKAuthorizationStatusAuthorized:
            self.isAccessToEventStoreGranted=YES;
            
            NSLog(@"Authorized!");
        case EKAuthorizationStatusNotDetermined:
            NSLog(@"Not determined");
            __weak DataRetriever *weakSelf = self;
            [self.store requestAccessToEntityType:EKEntityTypeEvent
                                       completion:^(BOOL granted, NSError *error) {
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               weakSelf.isAccessToEventStoreGranted = granted;
                                               NSLog(@"Granted  = %d",weakSelf.isAccessToEventStoreGranted);
                                               if (granted==NO){
                                                   NSLog(@"%@",error);
                                                   [self setPayperiodText:@"Grant access\nto calendars"];
                                                   [self setDateText:@"In the iOS Privacy Settings"];
                                               } else
                                               {
                                                   [self accessToCalendarGrantedWithCalendar:cal];
                                               }
                                           });

                                       }];
    }
}

@end
