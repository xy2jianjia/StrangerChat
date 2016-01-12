//
//  FirstViewController.m
//  StrangerChat
//
//  Created by long on 15/10/17.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "FirstViewController.h"
#import "RegisterViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <QuartzCore/QuartzCore.h>
@interface FirstViewController () <UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

@property (nonatomic,strong) UILabel *headerLabel;// 头像
@property (nonatomic,strong) UIButton *boyButton;// 男
@property (nonatomic,strong) UIButton *girlButton;// 女
@property (nonatomic,strong) UIImageView *headerImageViews;// 头像
@property (nonatomic,strong) UITextField *nameTextField;// 昵称
@property (nonatomic,strong) UITextField *birthTextField;// 出生日期
@property (nonatomic,strong) UILabel *wantLabel;// 我想:
@property (nonatomic,strong) UIButton *marryButton;// 婚恋
@property (nonatomic,strong) UIButton *FriendButton;// 交友
@property (nonatomic,strong) UIButton *AppointButton;// 约会

@property (nonatomic,strong) UIButton *nextButton;// 下一步

@property (nonatomic,strong) UILabel *lineLabel;
@property (nonatomic,strong) UILabel *lineLabel2;
@property (nonatomic,strong) UILabel *lineLabel3;


@property (nonatomic,strong) UIDatePicker *datePicker;// 日期选择器
@property (nonatomic,strong) NSLocale *dateLocale;

@property(nonatomic, strong) NSData *fileData;// 头像文件
@end

@implementation FirstViewController
static NSInteger wantSelectedNum = 0;
static NSInteger headerNum = 0;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:HexRGB(0XFFFFFF),NSForegroundColorAttributeName,nil];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    self.view.backgroundColor = HexRGB(0xFFFEFB);
    self.navigationController.navigationBar.tintColor = HexRGB(0xFFFFFF);
    self.navigationController.navigationBar.barTintColor = HexRGB(0XF04D6D);
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"上一页" style:UIBarButtonItemStylePlain target:self action:nil];
    // 头像
    self.headerImageViews =  [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, got(80), got(80))];
    _headerImageViews.center = CGPointMake(ScreenWidth/2, gotHeight(120));
    _headerImageViews.backgroundColor = [UIColor grayColor];
    _headerImageViews.layer.cornerRadius = got(40);
    _headerImageViews.clipsToBounds = YES;
    _headerImageViews.userInteractionEnabled = YES;
    [self.view addSubview:_headerImageViews];
    
    
    UIImageView *photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(got(180), gotHeight(140), got(20), got(20))];
    photoImageView.userInteractionEnabled = YES;
    photoImageView.image = [UIImage imageNamed:@"btn-picture-h.png"];
    [self.view addSubview:photoImageView];
    
    UITapGestureRecognizer *tapGestureTel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoImageAction:)];
    [photoImageView addGestureRecognizer:tapGestureTel];
    
   
    self.boyButton = [[UIButton alloc] initWithFrame:CGRectMake(got(60), gotHeight(170), got(80), gotHeight(30))];
    [self.boyButton addTarget:self action:@selector(boyAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.boyButton setImage:[UIImage imageNamed:@"bnt-boy2--n.png"] forState:UIControlStateNormal];
    [self.boyButton setImage:[UIImage imageNamed:@"bnt-boy2-s.png"] forState:UIControlStateSelected];
    [self.view addSubview:_boyButton];
    
    self.girlButton = [[UIButton alloc] initWithFrame:CGRectMake(got(180), gotHeight(170), got(80), gotHeight(30))];
    [self.girlButton addTarget:self action:@selector(girlAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.girlButton setImage:[UIImage imageNamed:@"bnt-girl2-n.png"] forState:UIControlStateNormal];
    [self.girlButton setImage:[UIImage imageNamed:@"bnt-girl2-s.png"] forState:UIControlStateSelected];
    [self.view addSubview:_girlButton];
    
    if (self.sexNum == 1) {
        _headerImageViews.image = [UIImage imageNamed:@"icon-boy.png"];
        _boyButton.selected = YES;
    }else if (self.sexNum == 2){
        _headerImageViews.image = [UIImage imageNamed:@"icon-girl-.png"];
        _girlButton.selected = YES;
    }else{
        self.sexNum = 0;
        _headerImageViews.image = [UIImage imageNamed:@"icon-boy.png"];
    }
    
    
    
    // 分割线
    self.lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, gotHeight(220), ScreenWidth,1)];
    _lineLabel.backgroundColor = HexRGB(0Xd0d0d0);
    [self.view addSubview:_lineLabel];
    
    //设置账号密码输入框
    self.nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(got(20), gotHeight(225), got(180), gotHeight(43))];
    _nameTextField.delegate = self;
    _nameTextField.tag = 2001;
    _nameTextField.backgroundColor = [UIColor clearColor];
    //_nameTextField.clearButtonMode = UITextFieldViewModeAlways;//一次性删除
    _nameTextField.placeholder = @"请输入昵称";
    [_nameTextField setValue:HexRGB(0X808080) forKeyPath:@"_placeholderLabel.textColor"];
    _nameTextField.autocorrectionType = UITextAutocorrectionTypeYes;//自动提示
    //_nameTextField.borderStyle = UITextBorderStyleRoundedRect;//输入框样式
    //_nameTextField.keyboardType = UIKeyboardTypeDecimalPad;
    [self.view addSubview:_nameTextField];
    _nameTextField.leftViewMode = UITextFieldViewModeAlways;
    UIView *view5 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, got(50), got(40))];
    
    UIImageView *textView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-user.png"]];
    textView.frame = CGRectMake(got(5), got(5), got(30), got(30));
    [view5 addSubview:textView];
    
    _nameTextField.leftView = view5;
    
    
    
    // 分割线
    self.lineLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(got(70), gotHeight(270), ScreenWidth-got(70),1)];
    _lineLabel2.backgroundColor = HexRGB(0Xd0d0d0);
    [self.view addSubview:_lineLabel2];
    
    
    self.birthTextField = [[UITextField alloc] initWithFrame:CGRectMake(got(20), gotHeight(275), got(180), gotHeight(43))];
    _birthTextField.delegate = self;
    _birthTextField.tag = 2002;
    _birthTextField.backgroundColor = [UIColor clearColor];
    //_birthTextField.clearButtonMode = UITextFieldViewModeAlways;
    _birthTextField.placeholder = @"请输入出生日期";
    [_birthTextField setValue:HexRGB(0X808080) forKeyPath:@"_placeholderLabel.textColor"];
    _birthTextField.autocorrectionType = UITextAutocorrectionTypeYes;
   // _birthTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:_birthTextField];
    
    
    _birthTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *view6 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, got(50), got(40))];
    
    UIImageView *textView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-birthday.png"]];
    textView2.frame = CGRectMake(got(5), got(5), got(30), got(30));
    [view6 addSubview:textView2];
    _birthTextField.leftView = view6;
    
    // 分割线
    self.lineLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(0, gotHeight(320), ScreenWidth,1)];
    _lineLabel3.backgroundColor = HexRGB(0Xd0d0d0);
    [self.view addSubview:_lineLabel3];
    
    // 我想
    self.wantLabel = [[UILabel alloc] initWithFrame:CGRectMake(got(30), gotHeight(335), got(45), gotHeight(20))];
    _wantLabel.text = @"我想:";
    _wantLabel.textColor = HexRGB(0X000000);
    _wantLabel.font = [UIFont systemFontOfSize:got(18)];
    [self.view addSubview:_wantLabel];

    // 婚恋
    self.marryButton = [[UIButton alloc] initWithFrame:CGRectMake(got(80), gotHeight(330), got(60), gotHeight(30))];
    self.marryButton.backgroundColor = [UIColor whiteColor];
    [self.marryButton setTitle:@"婚恋" forState:UIControlStateNormal];
    [self.marryButton setTitleColor:HexRGB(0X808080) forState:UIControlStateNormal];
    self.marryButton.titleLabel.font = [UIFont systemFontOfSize:got(18)];
    //给按钮加一个边框
    self.marryButton.layer.cornerRadius = got(5);
    self.marryButton.clipsToBounds = YES;
    self.marryButton.layer.borderColor = [HexRGB(0Xd0d0d0) CGColor];
    self.marryButton.layer.borderWidth = 1.0f;
    [self.marryButton addTarget:self action:@selector(marryButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.marryButton];
    
    // 交友
    self.FriendButton = [[UIButton alloc] initWithFrame:CGRectMake(got(150), gotHeight(330), got(60), gotHeight(30))];
    self.FriendButton.backgroundColor = [UIColor whiteColor];
    [self.FriendButton setTitle:@"交友" forState:UIControlStateNormal];
    self.FriendButton.titleLabel.font = [UIFont systemFontOfSize:got(18)];
    [self.FriendButton setTitleColor:HexRGB(0X808080) forState:UIControlStateNormal];
    self.FriendButton.layer.borderColor = [HexRGB(0Xd0d0d0) CGColor];
    self.FriendButton.layer.borderWidth = 1.0f;
    self.FriendButton.layer.cornerRadius = got(5);
    self.FriendButton.clipsToBounds = YES;

    [self.FriendButton addTarget:self action:@selector(FriendButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.FriendButton];
    
    // 约
    self.AppointButton = [[UIButton alloc] initWithFrame:CGRectMake(got(220), gotHeight(330), got(60), gotHeight(30))];
    self.AppointButton.backgroundColor = [UIColor whiteColor];
    [self.AppointButton setTitle:@"约" forState:UIControlStateNormal];
    self.AppointButton.titleLabel.font = [UIFont systemFontOfSize:got(18)];
    self.AppointButton.layer.borderColor = [HexRGB(0Xd0d0d0) CGColor];
    self.AppointButton.layer.borderWidth = 1.0f;
    self.AppointButton.layer.cornerRadius = got(5);
    self.AppointButton.clipsToBounds = YES;
    [self.AppointButton setTitleColor:HexRGB(0X808080) forState:UIControlStateNormal];
    [self.AppointButton addTarget:self action:@selector(AppointButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.AppointButton];

    
    //登陆按钮
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeSystem];
    nextButton.backgroundColor = HexRGB(0Xf04d6d);
    nextButton.frame = CGRectMake(got(30), gotHeight(400), got(260), gotHeight(50));
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setTitleColor:HexRGB(0XFFFFFF) forState:UIControlStateNormal];
    nextButton.layer.cornerRadius = got(5);
    nextButton.clipsToBounds = YES;
    [self.view addSubview:nextButton];
    [nextButton addTarget:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // 日期选择
    // 建立 UIDatePicker
    _datePicker = [[UIDatePicker alloc]init];
    _dateLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
    _datePicker.locale = _dateLocale;
    _datePicker.timeZone = [NSTimeZone timeZoneWithName:@"CCD"];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    // 原本跳出键盘的地方 就改成选日期了
    _birthTextField.inputView = _datePicker;
    
    // 建立 UIToolbar
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    // 选取日期完成 并给他一个 selector
    //调整两个item之间的距离.flexible表示距离是动态的,fixed表示是固定的
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(cancelPicker)];
    //  UIToolbar
    toolBar.items = [NSArray arrayWithObjects:flexible,right,nil];
    // 原本应该是键盘上方附带內容的区域 改成一个 UIToolbar
    _birthTextField.inputAccessoryView = toolBar;

    
}


// 男
- (void)boyAction:(UIButton *)sender
{
    if (headerNum == 0) {
        _headerImageViews.image = [UIImage imageNamed:@"icon-boy.png"];
        _boyButton.selected = YES;
        _girlButton.selected = NO;
        self.sexNum = 1;

    }else{
        _boyButton.selected = YES;
        _girlButton.selected = NO;
        self.sexNum = 1;

    }
}

// 女
- (void)girlAction:(UIButton *)sender
{
    if (headerNum == 0) {
        _headerImageViews.image = [UIImage imageNamed:@"icon-girl-.png"];
        _girlButton.selected = YES;
        _boyButton.selected = NO;
        self.sexNum = 2;
    }else{
        _girlButton.selected = YES;
        _boyButton.selected = NO;
        self.sexNum = 2;
    }
    
}



// 设置头像
- (void)photoImageAction:(UITapGestureRecognizer *)tap
{
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择方式" delegate:self cancelButtonTitle:@"取消"destructiveButtonTitle:nil otherButtonTitles:@"照相机",@"本地相册",nil];
    [actionSheet showInView:self.view];

}


// 按下完成的 method
-(void) cancelPicker {
    // endEditing: 是结束编辑 method
    if ([self.view endEditing:NO]) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        _birthTextField.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:_datePicker.date]];
    }
}



// 婚恋
- (void)marryButtonAction:(UIButton *)sender
{
    [self.marryButton setTitleColor:HexRGB(0XF04D6D) forState:UIControlStateNormal];
    self.marryButton.layer.borderColor = [HexRGB(0Xf04d6d) CGColor];
    
    [self.FriendButton setTitleColor:HexRGB(0X808080) forState:UIControlStateNormal];
    self.FriendButton.layer.borderColor = [HexRGB(0Xd0d0d0) CGColor];
    
    [self.AppointButton setTitleColor:HexRGB(0X808080) forState:UIControlStateNormal];
    self.AppointButton.layer.borderColor = [HexRGB(0Xd0d0d0) CGColor];
    wantSelectedNum = 1;
}

// 交友
- (void)FriendButtonAction:(UIButton *)sender
{
    [self.marryButton setTitleColor:HexRGB(0X808080) forState:UIControlStateNormal];
    self.marryButton.layer.borderColor = [HexRGB(0Xd0d0d0) CGColor];
    
    [self.FriendButton setTitleColor:HexRGB(0XF04D6D) forState:UIControlStateNormal];
    self.FriendButton.layer.borderColor = [HexRGB(0Xf04d6d) CGColor];
    
    [self.AppointButton setTitleColor:HexRGB(0X808080) forState:UIControlStateNormal];
    self.AppointButton.layer.borderColor = [HexRGB(0Xd0d0d0) CGColor];
    wantSelectedNum = 2;
}

// 约
- (void)AppointButtonAction:(UIButton *)sender
{
    [self.marryButton setTitleColor:HexRGB(0X808080) forState:UIControlStateNormal];
    self.marryButton.layer.borderColor = [HexRGB(0Xd0d0d0) CGColor];
    
    [self.FriendButton setTitleColor:HexRGB(0X808080) forState:UIControlStateNormal];
    self.FriendButton.layer.borderColor = [HexRGB(0Xd0d0d0) CGColor];
    
    [self.AppointButton setTitleColor:HexRGB(0XF04D6D) forState:UIControlStateNormal];
    self.AppointButton.layer.borderColor = [HexRGB(0Xf04d6d) CGColor];
    wantSelectedNum = 3;
}

// 下一步
- (void)nextButtonAction:(UIButton *)sender
{
    if (headerNum == 0) {
        [NSGetTools showAlert:@"请设置头像"];
    }else if(_sexNum == 0){
        [NSGetTools showAlert:@"请选择性别"];
    }else if (_nameTextField.text == nil || [_nameTextField.text isEqualToString:@""] || _nameTextField.text.length == 0 ){
        [NSGetTools showAlert:@"请输入昵称"];
    }else if (_birthTextField.text == nil || [_birthTextField.text isEqualToString:@""] || _birthTextField.text.length == 0){
        [NSGetTools showAlert:@"请输入出生日期"];
    }else if(wantSelectedNum == 0){
        [NSGetTools showAlert:@"请选择意向"];
    }else{
        RegisterViewController *registerVC = [RegisterViewController new];
        registerVC.title = @"注册";
        registerVC.isSex = self.sexNum;
        registerVC.userName = _nameTextField.text;
        registerVC.birthDay = _birthTextField.text;
        registerVC.wantNum = wantSelectedNum;
        [self.navigationController pushViewController:registerVC animated:YES];
    }
    
}


//空白处点击
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex = [%ld]",buttonIndex);
    switch (buttonIndex) {
        case 0://照相机
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            //            [self presentModalViewController:imagePicker animated:YES];
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
            break;
        case 1://本地相簿
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //            [self presentModalViewController:imagePicker animated:YES];
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}

#pragma UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeImage]) {
        UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
        [self performSelector:@selector(saveImage:)  withObject:img afterDelay:0.5];
    }
    else if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeMovie]) {
        NSString *videoPath = (NSString *)[[info objectForKey:UIImagePickerControllerMediaURL] path];
        self.fileData = [NSData dataWithContentsOfFile:videoPath];
    }
    //    [picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //    [picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)saveImage:(UIImage *)image {
    //    NSLog(@"保存头像！");
    //    [userPhotoButton setImage:image forState:UIControlStateNormal];
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"selfPhoto.jpg"];
    NSLog(@"imageFile->>%@",imageFilePath);
    success = [fileManager fileExistsAtPath:imageFilePath];
    if(success) {
        success = [fileManager removeItemAtPath:imageFilePath error:&error];
    }
    //    UIImage *smallImage=[self scaleFromImage:image toSize:CGSizeMake(80.0f, 80.0f)];//将图片尺寸改为80*80
    UIImage *smallImage = [self thumbnailWithImageWithoutScale:image size:CGSizeMake(93, 93)];
    [UIImageJPEGRepresentation(smallImage, 1.0f) writeToFile:imageFilePath atomically:YES];//写入文件
    UIImage *selfPhoto = [UIImage imageWithContentsOfFile:imageFilePath];//读取图片文件
    //    [userPhotoButton setImage:selfPhoto forState:UIControlStateNormal];
    self.headerImageViews.image = selfPhoto;
    headerNum = 1;
}

// 改变图像的尺寸，方便上传服务器
- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//2.保持原来的长宽比，生成一个缩略图
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
