//
//  CBViewController.m
//  CoinbaseClient
//
//  Created by Josh Beal on 12/10/13.
//  Copyright (c) 2013 CoinbaseClient. All rights reserved.
//

#import "CBViewController.h"
#import "CBTransaction.h"
#import <NSHash/NSString+NSHash.h>
#import <NSDate+TimeAgo/NSDate+TimeAgo.h>
#import <SAMCategories.h>
#import <UIImageView+WebCache.h>
#import <Coinbase/Coinbase.h>
#import <Coinbase/CBExchange.h>

@interface CBViewController ()
@property UIView *headerView;
@property UILabel *headerLabel;
@property UIButton *authButton;
@property UIButton *rightButton;
@property NSMutableArray *transactions;
@property UILabel *nameLabel;
@property UILabel *balanceLabel;
@property UILabel *balanceTitleLabel;
@property UIImageView *photo;

@property CBAccount *account;
@end

#define PHOTO_TAG 1

@implementation CBViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    BOOL ios7 = ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0);
    
    if (ios7) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 70+100+35, 320, self.view.frame.size.height-70-100-35)];
    } else {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50+100+35, 320, self.view.frame.size.height-50-100-35)];
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    self.transactions = [[NSMutableArray alloc] init];
    
    int headerHeight;
    if (ios7) {
        headerHeight = 70;
    } else {
        headerHeight = 50;
    }
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, headerHeight)];
    [self.headerView setBackgroundColor:[UIColor colorWithRed:52/255.0f green:152/255.0f blue:219/255.0f alpha:1.0]];
    self.headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, headerHeight - 50 + 14, 200, 22)];
    [self.headerLabel setText:@"Coinbase Example"];
    [self.headerLabel setTextAlignment:NSTextAlignmentCenter];
    [self.headerLabel setBackgroundColor:[UIColor clearColor]];
    [self.headerLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    self.headerLabel.textColor = [UIColor whiteColor];
    [self.headerView addSubview:self.headerLabel];

    int buttonY;
    if (ios7) {
        buttonY = 20;
    } else {
        buttonY = 0;
    }
    
    self.authButton = [[UIButton alloc] initWithFrame:CGRectMake(0, buttonY, 70, 50)];
    [self.authButton setTitle:@"Login" forState:UIControlStateNormal];
    self.authButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    [self.authButton addTarget:self action:@selector(auth) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:self.authButton];
    
    self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(320-70, buttonY, 70, 50)];
    [self.rightButton setTitle:@"Test" forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    [self.rightButton addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:self.rightButton];
    
    [self.view addSubview:self.headerView];
    
    int photoY;
    if (ios7) {
        photoY = 60 + 20;
    } else {
        photoY = 60;
    }
    
    self.photo = [[UIImageView alloc] initWithFrame:CGRectMake(20, photoY, 80, 80)];
    [self.photo.layer setCornerRadius:self.photo.frame.size.width/2];
    [self.photo setClipsToBounds:YES];
    [self.view addSubview:self.photo];
    
    self.balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, photoY+20, 280, 40)];
    [self.view addSubview:self.balanceLabel];
    
    UILabel *historyLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, photoY+90, 280, 35)];
    [historyLabel setText:@"Transaction History"];
    [self.view addSubview:historyLabel];
    
    UILabel *historyLabelTop = [[UILabel alloc]init];
    historyLabelTop.backgroundColor = [UIColor colorWithRed:206/255.0f green:206/255.0f blue:206/255.0f alpha:1.0];
    historyLabelTop.frame = CGRectMake(0, photoY+90, 320, 1);
    [self.view addSubview:historyLabelTop];
    
    UILabel *historyLabelBottom = [[UILabel alloc]init];
    historyLabelBottom.backgroundColor = [UIColor colorWithRed:206/255.0f green:206/255.0f blue:206/255.0f alpha:1.0];
    historyLabelBottom.frame = CGRectMake(0, photoY+125, 320, 1);
    [self.view addSubview:historyLabelBottom];
}

- (void)viewDidAppear:(BOOL)animated
{
}

- (void)test {
    if ([Coinbase isAuthenticated]) {
//        [self.account getAccountChanges:^(NSDictionary *result, NSError *error) {
//            NSLog(@"%@", result);
//        }];
//        
//        [self.account getCurrentBalance:^(NSString *balance, NSError *error) {
//            NSLog(@"%@", balance);
//        }];
//        
//        [self.account getReceiveAddress:^(NSString *address, NSError *error) {
//            NSLog(@"%@", address);
//        }];
//        
//        [self.account getAddresses:^(NSDictionary *result, NSError *error) {
//            NSLog(@"%@", result);
//        }];
//        
//        [self.account getContacts:^(NSDictionary *result, NSError *error) {
//            NSLog(@"%@", result);
//        }];
//        
//        [CBExchange getTransfers:^(NSDictionary *result, NSError *error) {
//            NSLog(@"%@", result);
//        }];

//        [CBTransaction request:@0.01 from:@"jbeal24@live.com" withNotes:@"CC" withHandler:^(CBTransaction *transaction, NSError *error) {
//            __block NSString *tid = transaction.transactionId;
//            [CBTransaction resend:tid withHandler:^(BOOL success, NSError *error) {
//
//                [CBTransaction cancel:tid withHandler:^(BOOL success, NSError *error) {
//                    
//                }];
//            }];
//        }];
        
//        [CBExchange buyBitcoin:@0.01 withHandler:^(NSDictionary *result, NSError *error) {
//            NSLog(@"%@", result);
//        }];
    }
    
//    [CBExchange getBuyPriceForQty:@1 withHandler:^(NSString *price) {
//        NSLog(@"%@", price);
//    }];
//    
//    [CBExchange getSellPriceForQty:@1 withHandler:^(NSString *price) {
//        NSLog(@"%@", price);
//    }];
//    
//    [CBExchange getSpotRateForCurrency:@"USD" withHandler:^(NSString *price) {
//        NSLog(@"%@", price);
//    }];
    
    [CBExchange getSupportedCurrencies:^(NSDictionary *result, NSError *error) {
        NSLog(@"%@", result);
    }];
}

- (void)auth
{
    if (![Coinbase isAuthenticated]) {
        [Coinbase login:^(NSError *error) {
            if (error) {
                NSLog(@"%@", error);
            } else {
                [Coinbase getAccount:^(CBAccount *account, NSError *error) {
                    self.account = account;
                    [self.headerLabel setText:self.account.name];
                    [CBExchange getExchangeRates:^(NSDictionary *entries, NSError *error) {
                        [self.balanceLabel setText:[NSString stringWithFormat:@"Ƀ%.4f ≈ $%.2f", [self.account.balance floatValue], [self.account.balance floatValue] * [[entries objectForKey:@"btc_to_usd"] floatValue]]];
                    }];
                    [self.photo setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.gravatar.com/avatar/%@?s=200", [self.account.email MD5]]] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
                    [self.account getTransactions:^(NSArray *transactions, NSError *error) {
                        self.transactions = [transactions mutableCopy];
                        [self.tableView reloadData];
                    }];
                }];
                [self.authButton setTitle:@"Logout" forState:UIControlStateNormal];
            }
        }];
    } else {
        [self.authButton setTitle:@"Login" forState:UIControlStateNormal];
        [self.headerLabel setText:@"Coinbase Example"];
        self.account = nil;
        [self.photo setImage:[UIImage imageNamed:@"placeholder.jpg"]];
        [self.transactions removeAllObjects];
        [self.tableView reloadData];
        [Coinbase logout];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.transactions count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UIImageView *photo;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.numberOfLines = 0;
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
        cell.indentationLevel = 4;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        photo = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 30, 30)];
        photo.tag = PHOTO_TAG;
        [photo.layer setCornerRadius:photo.frame.size.width/2];
        [photo setClipsToBounds:YES];
        [cell.contentView addSubview:photo];
    } else {
        photo = (UIImageView *)[cell.contentView viewWithTag:PHOTO_TAG];
    }
    
    [[photo subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CBTransaction *transaction = [self.transactions objectAtIndex:indexPath.row];
    
    UIColor *red = [UIColor colorWithRed:192/255.0f green:57/255.0f blue:43/255.0f alpha:1.0];
    UIColor *green = [UIColor colorWithRed:39/255.0f green:174/255.0f blue:96/255.0f alpha:1.0];
    
    NSString *amount;
    if (![[transaction.amount substringToIndex:1] isEqualToString:@"-"]) {
        amount = [NSString stringWithFormat:@"+ Ƀ%@", transaction.amount];
    } else {
        amount = [NSString stringWithFormat:@"- Ƀ%@", [transaction.amount substringFromIndex:1]];
    }
    
    UIColor *textColor = ([[amount substringToIndex:1] isEqualToString:@"+"]) ? green : red;
    
    // Create the attributes
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           [UIColor blackColor], NSForegroundColorAttributeName, nil];
    NSDictionary *subAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                              textColor, NSForegroundColorAttributeName, nil];
    
    NSString *description;
    
    if ([transaction.name length] >= 34) {
        transaction.name = [NSString stringWithFormat:@"%@...", [transaction.name substringToIndex:12]];
    }
    
    if ([transaction.email isEqualToString:@"transfers@coinbase.com"]) {
        if (transaction.sender) {
            description = @"You sold bitcoin\n";
            [photo setImage:[UIImage imageNamed:@"bitcoin.png"]];
        } else {
            description = @"You purchased bitcoin\n";
            [photo setImage:[UIImage imageNamed:@"bitcoin.png"]];
        }
    } else if (transaction.sender) {
        if (transaction.request) {
            description = [NSString stringWithFormat:@"%@ requested bitcoin\n", transaction.name];
            
            [photo setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.gravatar.com/avatar/%@?s=200", [transaction.email MD5]]] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
        } else {
            description = [NSString stringWithFormat:@"You sent bitcoin to %@\n", transaction.name];
            
            [photo setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.gravatar.com/avatar/%@?s=200", [self.account.email MD5]]] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
        }
    } else {
        if (transaction.request) {
            description = [NSString stringWithFormat:@"You requested bitcoin from %@\n", transaction.name];
            
            [photo setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.gravatar.com/avatar/%@?s=200", [self.account.email MD5]]] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
        } else {
            description = [NSString stringWithFormat:@"%@ sent you bitcoin\n", transaction.name];
            
            [photo setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.gravatar.com/avatar/%@?s=200", [transaction.email MD5]]] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
        }
    }
    NSDate *date = [NSDate sam_dateFromISO8601String:transaction.timestamp];
    NSString *timestamp = [NSString stringWithFormat:@" | %@", [date timeAgo]];
    const NSRange range = NSMakeRange(description.length,amount.length);
    
    // Create the attributed string (text + attributes)
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", description, amount, timestamp] attributes:attrs];
    [attributedText setAttributes:subAttrs range:range];
    
    [cell.textLabel setAttributedText:attributedText];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CBTransaction *transaction = [self.transactions objectAtIndex:indexPath.row];
    if (transaction.hash) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://coinbase.com/network/transactions/%@.json", transaction.hash]]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
