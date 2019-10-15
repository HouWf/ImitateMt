//
//  BFCMacro.h
//  BFCompetition
//
//  Created by hzhy001 on 2018/10/19.
//  Copyright © 2018年 hzhy001. All rights reserved.
//

#ifndef BFCMacro_h
#define BFCMacro_h

/****************** 尺寸 ****************/
//不同屏幕尺寸字体适配（320，568是因为效果图为IPHONE5 如果不是则根据实际情况修改）
#define kScreenWidthRatio  (Main_Screen_Width / 375.0)
#define kScreenHeightRatio (Main_Screen_Height / 667.0)
#define AdaptedWidth(x)  (x * kScreenWidthRatio) // 向上取整 ceilf
#define AdaptedHeight(x) (x * kScreenHeightRatio)// 向上取整

// MainScreen Height&Width
#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width

//获取View的属性
#define GetViewWidth(view)  view.frame.size.width
#define GetViewHeight(view) view.frame.size.height
#define GetViewX(view)      view.frame.origin.x
#define GetViewY(view)      view.frame.origin.y

/****************** 字体 ****************/
// 字体大小(常规/粗体)
#define BOLDSYSTEMFONT(FONTSIZE)[UIFont boldSystemFontOfSize:FONTSIZE]
#define SYSTEMFONT(FONTSIZE)    [UIFont systemFontOfSize:FONTSIZE]
#define FONT(NAME, FONTSIZE)    [UIFont fontWithName:(NAME) size:(FONTSIZE)]
#define DEFAULTFONT(FONTSIZE)    FONT(@"PingFangSC-Regular", FONTSIZE)
#define DEFAULTFONT_BOLD(FONTSIZE)   FONT(@"PingFangSC-Medium", FONTSIZE)
#define DEFAULTFONT_HN(FONTSIZE)    FONT(@"HelveticaNeue", FONTSIZE)
#define DEFAULTFONT_HN_BOLD(FONTSIZE)    FONT(@"HelveticaNeue-Bold", FONTSIZE)

#define FONT_SC(FONTSIZE)  DEFAULTFONT(FONTSIZE)

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define rgba(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

// 红背景
#define BFRedColor rgba(230, 69, 69, 1)
// 浅红色
#define BFLightRedColor rgba(255, 232, 230, 1)
// 灰背景
#define BFGrayColor RGB(245, 245, 245)
// 字体颜色
#define BFTextGrayColor RGB(153, 153, 153)
// 字体黑色
#define BFBlackColor rgba(51, 51, 51, 1)
// line颜色
#define LineColor rgba(229, 229, 229, 1)
//线条颜色
#define BFLineColor RGB(229, 229, 229)
// 绿色
#define GreenColor rgba(82, 204, 163, 1)

//获取图片资源
#define GetImage(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]

#define BLOCK_EXEC(block, ...) if (block) { block(__VA_ARGS__); };
#define WEAK  @weakify(self);
#define STRONG  @strongify(self);

#endif /* BFCMacro_h */
