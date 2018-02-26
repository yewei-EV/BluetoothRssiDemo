#import "ViewController.h"
#import "SVProgressHUD.h"
#import "TriangulationAlgorithm.h"

//screen width and height
#define width [UIScreen mainScreen].bounds.size.width
#define height [UIScreen mainScreen].bounds.size.height

@interface ViewController (){
    NSMutableArray *peripheralDataArray;
    BabyBluetooth *baby;
    TriangulationCalculator * triangulationCalculator;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVProgressHUD showInfoWithStatus:@"Ready to open device"];
    NSLog(@"viewDidLoad");
    peripheralDataArray = [[NSMutableArray alloc]init];
    
    //Initialize BabyBluetooth wrap
    baby = [BabyBluetooth shareBabyBluetooth];
    //Set bluetooth Delegate
    [self babyDelegate];
    
    //initialize triangulation calculator
    triangulationCalculator = [[TriangulationCalculator alloc]init];
}


-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"viewDidAppear");
    //Stop preivous connectiong
    [baby cancelAllPeripheralsConnection];
    //directly use without waiting for CBCentralManagerStatePoweredOn
    baby.scanForPeripherals().begin();
    //baby.scanForPeripherals().begin().stop(10);
}

-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"viewWillDisappear");
}


#pragma mark -Bluetooth config and control

//Bluetooth Delegate setting
-(void)babyDelegate{
    
    __weak typeof(self) weakSelf = self;
    [baby setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        if (central.state == CBCentralManagerStatePoweredOn) {
            [SVProgressHUD showInfoWithStatus:@"Device open, start scaning"];
        }
    }];
    
    //Store previous two rssi value
    static int prev_rssi1 = 0;
    static int prevprev_rssi1 = 0;
    static int prev_rssi2 = 0;
    static int prevprev_rssi2 = 0;
    static int prev_rssi3 = 0;
    static int prevprev_rssi3 = 0;
    static int avag_rssi_one = 0;
    static int avag_rssi_two = 0;
    static int avag_rssi_three = 0;
    static float distance_one = 0;
    static float distance_two = 0;
    static float distance_three = 0;

    //Handle Delegate
    [baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        if ([peripheral.name isEqual:@"BrtBeacon01"]) {

            if (prev_rssi1 == 0) {
                prev_rssi1 = [RSSI intValue];
            }
            if (prevprev_rssi1 == 0) {
                prevprev_rssi1 = [RSSI intValue];
            }
            avag_rssi_one = ([RSSI intValue] + prev_rssi1 + prevprev_rssi1)/3;
            //NSLog(@"%@ has RSSI: %@ and %@",peripheral.name, RSSI, avag_rssi);
        
            //Translate RSSI value into distance
            double txPower = -65;
            if (avag_rssi_one == 0) {
                distance_one = -1.0;
            }
            double ratio = avag_rssi_one*1.0/txPower;
            if (ratio < 1.0) {
                distance_one = pow(ratio,10);
            }
            else {
                distance_one = (0.89976)*pow(ratio,7.7095) + 0.111;
            }
            NSLog(@"%@ has RSSI: %@ average: %d and %.1f meters", peripheral.name, RSSI, avag_rssi_one, distance_one);
            prevprev_rssi1 = prev_rssi1;
            prev_rssi1 = avag_rssi_one;
        }
        if ([peripheral.name isEqual:@"BrtBeacon02"]) {
            
            if (prev_rssi2 == 0) {
                prev_rssi2 = [RSSI intValue];
            }
            if (prevprev_rssi2 == 0) {
                prevprev_rssi2 = [RSSI intValue];
            }
            avag_rssi_two = ([RSSI intValue] + prev_rssi2 + prevprev_rssi2)/3;
            //NSLog(@"%@ has RSSI: %@ and %@",peripheral.name, RSSI, avag_rssi);
            
            //Translate RSSI value into distance
            double txPower = -65;
            if (avag_rssi_two == 0) {
                distance_two = -1.0;
            }
            double ratio = avag_rssi_two*1.0/txPower;
            if (ratio < 1.0) {
                distance_two = pow(ratio,10);
            }
            else {
                distance_two = (0.89976)*pow(ratio,7.7095) + 0.111;
            }
            NSLog(@"%@ has RSSI: %@ average: %d and %.1f meters", peripheral.name, RSSI, avag_rssi_two, distance_two);
            prevprev_rssi2 = prev_rssi2;
            prev_rssi2 = avag_rssi_two;
        }
        if ([peripheral.name isEqual:@"BrtBeacon03"]) {
      
            if (prev_rssi3 == 0) {
                prev_rssi3 = [RSSI intValue];
            }
            if (prevprev_rssi3 == 0) {
                prevprev_rssi3 = [RSSI intValue];
            }
            avag_rssi_three = ([RSSI intValue] + prev_rssi3 + prevprev_rssi3)/3;
            //NSLog(@"%@ has RSSI: %@ and %@",peripheral.name, RSSI, avag_rssi);
            
            //Translate RSSI value into distance
            double txPower = -65;
            if (avag_rssi_three == 0) {
                distance_three = -1.0;
            }
            double ratio = avag_rssi_three*1.0/txPower;
            if (ratio < 1.0) {
                distance_three = pow(ratio,10);
            }
            else {
                distance_three = (0.89976)*pow(ratio,7.7095) + 0.111;
            }
            NSLog(@"%@ has RSSI: %@ average: %d and %.1f meters", peripheral.name, RSSI, avag_rssi_three, distance_three);
            prevprev_rssi3 = prev_rssi3;
            prev_rssi3 = avag_rssi_three;
        }
        
        if (distance_one != 0 && distance_two != 0 && distance_three != 0) {
            CGPoint position = [triangulationCalculator calculatePosition:1 beaconId2:2 beaconId3:3 beaconDis1:distance_one*100 beaconDis2:distance_two*100 beaconDis3:distance_three*100];
        }
        
        [weakSelf insertTableView:peripheral advertisementData:advertisementData RSSI:RSSI];
    }];
    
    
    //Set searching filter
    [baby setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        //Only search device with this prefix
        if ([peripheralName hasPrefix:@"BrtBeacon"] ) {
            return YES;
        }
        return NO;
    }];

    [baby setBlockOnCancelAllPeripheralsConnectionBlock:^(CBCentralManager *centralManager) {
        NSLog(@"setBlockOnCancelAllPeripheralsConnectionBlock");
    }];
       
    [baby setBlockOnCancelScanBlock:^(CBCentralManager *centralManager) {
        NSLog(@"setBlockOnCancelScanBlock");
    }];
    
    
    //Ignore same Peripherals found
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    //connect device->
    [baby setBabyOptionsWithScanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:nil scanForPeripheralsWithServices:nil discoverWithServices:nil discoverWithCharacteristics:nil];

}

#pragma mark -UIViewController method
//insert table data
-(void)insertTableView:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    NSArray *peripherals = [peripheralDataArray valueForKey:@"peripheral"];
    if(![peripherals containsObject:peripheral]) {
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:peripherals.count inSection:0];
        [indexPaths addObject:indexPath];
        
        NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
        [item setValue:peripheral forKey:@"peripheral"];
        [item setValue:RSSI forKey:@"RSSI"];
        [item setValue:advertisementData forKey:@"advertisementData"];
        [peripheralDataArray addObject:item];
        
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark -table delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     return peripheralDataArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSDictionary *item = [peripheralDataArray objectAtIndex:indexPath.row];
    CBPeripheral *peripheral = [item objectForKey:@"peripheral"];
    NSDictionary *advertisementData = [item objectForKey:@"advertisementData"];
    NSNumber *RSSI = [item objectForKey:@"RSSI"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //peripheral's displayed name, use definition of kCBAdvDataLocalName，if missing, then use peripheral name
    NSString *peripheralName;
    if ([advertisementData objectForKey:@"kCBAdvDataLocalName"]) {
        peripheralName = [NSString stringWithFormat:@"%@",[advertisementData objectForKey:@"kCBAdvDataLocalName"]];
    }else if(!([peripheral.name isEqualToString:@""] || peripheral.name == nil)){
        peripheralName = peripheral.name;
    }else{
        peripheralName = [peripheral.identifier UUIDString];
    }
    
    cell.textLabel.text = peripheralName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"RSSI: %@",RSSI];
    
    
    return cell;
}


@end
