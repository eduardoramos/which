//
//  ViewController.m
//  which
//
//  Created by Eduardo Ramos on 5/29/16.
//  Copyright © 2016 Eduardo Ramos. All rights reserved.
//

#import "ViewController.h"

#import "DataRetriever.h"

@interface ViewController ()

@property (retain, nonatomic) DataRetriever *retriever;

@end

@implementation ViewController

- (DataRetriever*)retriever {
    if (!_retriever) {
        _retriever = [[DataRetriever alloc] init];
    }
    return _retriever;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.retriever updateData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
