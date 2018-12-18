//
//  BHLoginController.m
//  EmbeddedRobot
//
//  Created by bihu_Mac on 2017/6/23.
//  Copyright © 2017年 initial. All rights reserved.
//
#import "MJExtension.h"
#import "UserData.h"
#import "BHLoginController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"

#import "BHAPIManager.h"
#import <Masonry/Masonry.h>
#import "RootViewController.h"


#define BHWeakSelf(weakSelf) __weak __typeof(&*self)weakSelf = self;
#define BHRGBColor(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

#define BHAlert(title, msg)                   [[[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil] show]
@interface BHLoginController()<UITextFieldDelegate,UIAlertViewDelegate>

@property(nonatomic,strong)UITextField *userTxt;

//@property(nonatomic,strong)UITextField *pwdTxt;

@property(nonatomic,strong)UIButton *loginBtn;


@end

@implementation BHLoginController

-(id)init{
    
    self=[super init];
    if (self) {

    }
    return self;
}

-(void)loadView{
    
    [super loadView];
    [self initView];
}

-(void)viewDidLoad{
    
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
//    [self.view endEditing:YES];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    }

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
}
#pragma mark -
#pragma mark 视图布局约束

-(void)initView{
    
    self.title = @"登陆";
    BHWeakSelf(weakSelf);
    //编辑区*********************
    UIView *userView=[UIView new];
    userView.backgroundColor=[UIColor whiteColor];;
    [self.view addSubview:userView];
    
    [userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.view).offset(100);
        make.height.mas_equalTo(50);
        make.left.and.right.mas_equalTo(weakSelf.view);
    }];
    
    //用户名输入框
    _userTxt=[self structureAccoutView:userView img:@"username"];
    _userTxt.keyboardType=UIKeyboardTypeDefault;
    _userTxt.returnKeyType=UIReturnKeyDefault;
    _userTxt.delegate=self;
    _userTxt.placeholder=@"用户名";
    [_userTxt addTarget:self action:@selector(limitLengths:) forControlEvents:UIControlEventEditingChanged];
    
    //登录按钮
    _loginBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    _loginBtn.backgroundColor=[UIColor redColor];
    _loginBtn.titleLabel.font=[UIFont systemFontOfSize:18];
//    _loginBtn.titleLabel.textColor=[UIColor whiteColor];
    _loginBtn.tintColor=[UIColor whiteColor];
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    _loginBtn.enabled=NO;
    _loginBtn.layer.cornerRadius=5;
    _loginBtn.layer.masksToBounds=YES;
    
    [_loginBtn addTarget:self action:@selector(doLogin:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_loginBtn];
    
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_userTxt.mas_bottom).offset(40);
        make.left.mas_equalTo(weakSelf.view).offset(40);
        make.right.mas_equalTo(weakSelf.view).offset(-40);
        make.height.mas_equalTo(40);
    }];
    
    
   
    
    
    UITapGestureRecognizer *tapGuester=[UITapGestureRecognizer new];
    [tapGuester addTarget:self action:@selector(dismissKeyboard:)];
    [self.view addGestureRecognizer:tapGuester];
    
}




-(void)initLayoutConstraints{

}

#pragma mark 登录事件

-(void)doLogin:(UIButton*)sender{

    NSString *name=_userTxt.text;    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //调用登录接口
    [[BHAPIManager manager] LoginUser:name sucess:^(NSDictionary *dict) {        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        UserInfo * user = [UserInfo mj_objectWithKeyValues:dict];
        UserData * data =[UserData sharedUserData];
        data.user = user;
        [data savedata];
        if ([dict objectForKey:@"token"]) {
            [BHAPIBase setToken:[dict objectForKey:@"token"]];
        }
        RootViewController *rootVC = [[RootViewController alloc] init];
        [self.navigationController pushViewController:rootVC animated:YES];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        BHAlert(@"", [error localizedDescription]);
    }];
    
    
   
}



-(void)dismissKeyboard:(UITapGestureRecognizer*)tapGesture{

    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [self backKeyView];
}

-(void)backKeyView{

    CGRect viewRect=self.view.frame;
    viewRect.origin.y=0;
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame=viewRect;
    }];
}


//

-(void)limitLengths:(UITextField *)sender{
    
    NSString *textStr=[sender text];
    if([textStr length] >= 1 ){
        _loginBtn.enabled=YES;

    }else{
        _loginBtn.enabled=NO;

    }
    
    if([textStr length] <= 1 && sender==_userTxt){
        _loginBtn.enabled=NO;
      
    }
    
    if(sender==_userTxt && [textStr length]>= 1){
        _loginBtn.enabled=YES;
       
    }
}


#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    return YES;
}

//添加键盘伸缩效果
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{


    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{

}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if(textField==_userTxt ){
        
        if (range.location>=20){
            [textField resignFirstResponder];
            return  NO;
        }
    }

    return YES;
}

-(UITextField *)structureAccoutView:(UIView *)view img:(NSString*)imgName{
    
    UIImageView *usrImgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:imgName]];
    usrImgView.contentMode=UIViewContentModeScaleAspectFit;
    [view addSubview:usrImgView];
    
    [usrImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view).offset(20);
        make.left.mas_equalTo(view).offset(40);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    //输入框
    UITextField *txtField=[UITextField new];
    txtField.textColor=BHRGBColor(130, 131, 132);
    txtField.clearButtonMode=UITextFieldViewModeWhileEditing;
    txtField.borderStyle=UITextBorderStyleNone;
    txtField.contentVerticalAlignment=UIControlContentVerticalAlignmentBottom;
    //    txtField.delegate=self;
    
    [view addSubview:txtField];
    
    [txtField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(usrImgView.mas_right).offset(20);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(view).offset(10);
        make.right.mas_equalTo(view).offset(-40);
    }];
    
    //完美的分割线
    UIView *line1= [UIView new];
    line1.layer.borderColor = BHRGBColor(187, 187, 187).CGColor;
    line1.layer.borderWidth = 0.3;
    line1.backgroundColor=[UIColor clearColor];
    [view addSubview:line1];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view.mas_bottom);
        make.left.mas_equalTo(view).offset(40);
        make.right.mas_equalTo(view).offset(-40);
        make.height.mas_equalTo(0.3);
    }];
    return txtField;
}



@end
