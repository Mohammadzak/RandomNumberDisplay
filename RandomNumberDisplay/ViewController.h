//
//  ViewController.h
//  RandomNumberDisplay
//
//  Created by Apple on 26/03/18.
//  Copyright © 2018 sampleTest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "detailsTableViewCell.h"
@import SocketIO;
@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    
}

@property (weak, nonatomic) IBOutlet UILabel *lblRandomNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrentTimeDisplay;
@property (weak, nonatomic) IBOutlet UIButton *btnclksplinechart;
- (IBAction)touchupbtnsplinechartclk:(id)sender;
- (IBAction)touchupbtnnotificationListclk:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *notificationbtnlist;
@property (weak, nonatomic) IBOutlet UITableView *tableList;

@property (strong , nonatomic) SocketManager *manager;
@property (strong , nonatomic) SocketIOClient *socket;
@end

