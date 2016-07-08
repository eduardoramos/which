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

- (void)updateData {
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
                                           });
                                       }];
            break;
    }
    
    // Create the start date component
    NSDateComponents *fourteenDaysAgoComponents = [[NSDateComponents alloc]init];
    fourteenDaysAgoComponents.day = -14;
    NSDate *fourteenDaysAgo = [cal dateByAddingComponents:fourteenDaysAgoComponents
                                                   toDate:[NSDate date]
                                                  options:0];
    
    //Create the end date component
    NSPredicate *predicate = [self.store predicateForEventsWithStartDate:fourteenDaysAgo endDate:today calendars:nil];
    
    // Fetch all events that match the predicate
    NSArray *events = [self.store eventsMatchingPredicate:predicate];
    NSLog(@"Retrieved %d events from: %@ to %@",events.count,fourteenDaysAgo, today);
    [self setDateText:@"Date..."];
    [self setPayperiodText:@"Pay Period..."];
    for (EKEvent*event in events) {
        NSLog(@"Event %@",event.title);
        if ([event.title containsString:@"PP#"]) {
            NSLog(@"Found %@",event.title);
            [self setPayperiodText:event.title];
            NSUInteger unitFlags = NSCalendarUnitDay;
            NSCalendar *gregorian = [[NSCalendar alloc]
                                     initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDateComponents *components = [gregorian components:unitFlags
                                                        fromDate:event.startDate
                                                          toDate:today options:0];
            NSInteger week;
            if (components.day>7)
                week=2;
            else
                week=1;
            
            NSDateFormatter* day = [[NSDateFormatter alloc] init];
            [day setDateFormat: @"EEEE"];
            NSLog(@"the day is: %@", [day stringFromDate:[NSDate date]]);
            [self setDateText:[NSString stringWithFormat:@"%@ Week %d",
                              [day stringFromDate:[NSDate date]],
                              week]];
            
            NSLog(@"The difference is %i",components.day);
        }
        
    }
}
@end
