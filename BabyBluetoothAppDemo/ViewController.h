//
//  ViewController.h
//  BabyBluetoothAppDemo
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BabyBluetooth.h"
//#import "PeripheralViewController.h"

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

