//
//  AddBankCardTableViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/1.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "AddBankCardTableViewController.h"
#import "NimbusModels.h"
#import "NimbusCore.h"

#import "OCMaskedTextFieldView.h"
typedef enum {
    RadioGroupOption1,
    RadioGroupOption2,
    RadioGroupOption3,
} RadioGroup;
@interface AddBankCardTableViewController ()<NIRadioGroupDelegate,UITextFieldDelegate>
@property (nonatomic, retain) NITableViewModel* model;
@property (nonatomic, retain) NIRadioGroup* radioGroup;
@end

@implementation AddBankCardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"添加银行卡";
    [self setupView];
    self.tableView.rowHeight = 40;
    
    self.tableView.dataSource = _model;
    self.tableView.delegate = [self.radioGroup forwardingTo:self];
    [NSObject setExtraCellLineHidden:self.tableView];
    
    
    UIView* v_footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    UIButton* detailsbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    detailsbtn.backgroundColor = [UIColor grayColor];
    [detailsbtn.layer setMasksToBounds:YES];
    [detailsbtn.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
//    [detailsbtn.layer setBorderWidth:1.0]; //边框
    detailsbtn.frame = CGRectMake(10, 40, SCREEN_WIDTH-20 , 40);
    [detailsbtn setTitle:@"确认添加" forState:UIControlStateNormal];
    [detailsbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [detailsbtn addTarget:self action:@selector(goskipdetails) forControlEvents:UIControlEventTouchUpInside];
    [v_footer addSubview:detailsbtn];

    self.tableView.tableFooterView = v_footer;
}
-(void)goskipdetails
{
    
    DLog(@"确认添加");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupView
{
    
    _radioGroup = [[NIRadioGroup alloc] initWithController:self];
    _radioGroup.delegate = self;
    
    // The title that will be displayed in the radio group cell.
    _radioGroup.cellTitle = @"开户银行";
    
    // The title that will be displayed in the nested radio group controller.
    _radioGroup.controllerTitle = @"开户银行";
    
    [_radioGroup mapObject:[NITitleCellObject objectWithTitle:@"工商银行"] toIdentifier:RadioGroupOption1];
    [_radioGroup mapObject:[NITitleCellObject objectWithTitle:@"中国银行"] toIdentifier:RadioGroupOption2];
    [_radioGroup mapObject:[NITitleCellObject objectWithTitle:@"交通银行"] toIdentifier:RadioGroupOption3];
    
    NICellDrawRectBlock cardholderBlock = ^CGFloat(CGRect rect, id object, UITableViewCell *cell) {
        // If the cell is tapped or selected we want to draw the text on top of the selection
        // background. This requires that the content's background be clear.
        if (cell.isHighlighted || cell.isSelected) {
            [[UIColor clearColor] set];
        } else {
            [[UIColor whiteColor] set];
        }
        
        // Fill in the content rect.
        UIRectFill(rect);
        
        
        cell.textLabel.text = object;
        UITextField* textField = [[UITextField alloc] initWithFrame:CGRectMake(90, 0, SCREEN_WIDTH-100 , 40)];
//        [textField setBorderStyle:UITextBorderStyleRoundedRect]; //外框类型
        
        textField.placeholder = @"姓名"; //默认显示的字
        
        
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.returnKeyType = UIReturnKeyDone;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
        
        textField.delegate = self;
        [cell.contentView addSubview:textField];
        return 0;
    };
    NICellDrawRectBlock BankCardBlock = ^CGFloat(CGRect rect, id object, UITableViewCell *cell) {
        // If the cell is tapped or selected we want to draw the text on top of the selection
        // background. This requires that the content's background be clear.
        if (cell.isHighlighted || cell.isSelected) {
            [[UIColor clearColor] set];
        } else {
            [[UIColor whiteColor] set];
        }
        
        // Fill in the content rect.
        UIRectFill(rect);
        
        
        cell.textLabel.text = object;
        OCMaskedTextFieldView *textField = [[OCMaskedTextFieldView alloc]
                                            initWithFrame:CGRectMake(90, 0, SCREEN_WIDTH-100 , 40)
                                            andMask:@"#### #### #### #### "
                                            showMask:YES];
        [[textField maskedTextField] setBorderStyle:UITextBorderStyleNone];
        [[textField maskedTextField] setFont:FONT(15)];
        [[textField maskedTextField] setTintColor:COLOR(0, 0, 0, 1)];
        [[textField maskedTextField] setKeyboardAppearance:UIKeyboardAppearanceDark];
        
        /*
         New Method to programatically assign input to a masked field
         excess text will be ignored.
         
         setting 1234123412341234123412341234 to an IBAN field works as follows:
         mask  : TR - #### #### #### #### #### ####
         
         [textField setRawInput:@"1234123412341234123412341234"];
         
         output: TR - 1234 1234 1234 1234 1234 1234
         */
//        [textField setRawInput:@"1234123412341234"];
        
        
//        [self setupTextField:[textField maskedTextField]];
        [cell.contentView addSubview:textField];
        return 0;
    };
    NSMutableArray* tableContents = [NSMutableArray array];
    
    [tableContents addObject:
     [NIDrawRectBlockCellObject objectWithBlock:cardholderBlock object:@"持卡人"]];
    [tableContents addObject:
     [NIDrawRectBlockCellObject objectWithBlock:BankCardBlock object:@"银行卡号"]];
    [tableContents addObject:_radioGroup];
    _radioGroup.selectedIdentifier = RadioGroupOption2;
    _model = [[NITableViewModel alloc] initWithListArray:tableContents
                                                delegate:(id)[NICellFactory class]];
}

#pragma mark - NIRadioGroupDelegate

- (void)radioGroup:(NIRadioGroup *)radioGroup didSelectIdentifier:(NSInteger)identifier {
    // When the radio group selection changes, this method will be called with the new identifier.
    NSLog(@"Did select radio group option %zd", identifier);
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSString *)radioGroup:(NIRadioGroup *)radioGroup textForIdentifier:(NSInteger)identifier {
    switch (identifier) {
        case RadioGroupOption1:
            return @"工商银行";
        case RadioGroupOption2:
            return @"中国银行";
        case RadioGroupOption3:
            return @"交通银行";
    }
    return nil;
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
