//
//  GlanceController.m
//  which WatchKit Extension
//
//  Created by Eduardo Ramos on 5/29/16.
//  Copyright © 2016 Eduardo Ramos. All rights reserved.
//

#import "GlanceController.h"
#import "DataRetriever.h"

@interface GlanceController()
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *cardGroup;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *cardLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *payperiodLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *dateLabel;

@property (retain, nonatomic) DataRetriever *retriever;
@end


@implementation GlanceController

- (DataRetriever*)retriever {
    if (!_retriever) {
        _retriever = [[DataRetriever alloc] init];
    }
    return _retriever;
}

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    // Configure interface objects here.
    [self.cardLabel setText:@"N/A"];
    [self.payperiodLabel setText:@"N/A"];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user

    [self.retriever updateData];
    
    [self.cardGroup setBackgroundColor:self.retriever.backgroundColor];
    [self.cardLabel setTextColor:self.retriever.textColor];
    [self.cardLabel setText:self.retriever.cardText];
    
    [self.payperiodLabel setText:self.retriever.payperiodText];
    [self.dateLabel setText:self.retriever.dateText];

    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end


