package dataCenter
{
	import com.greensock.TweenLite;
	import com.sina.microblog.MicroBlog;
	import com.sina.microblog.data.MicroBlogUser;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.utils.Timer;
	
	import localManager.LocalizationPhase;
	
	import modules.AlertTip;
	import modules.BugsSubmit;
	import modules.CommentInput;
	import modules.CommentList;
	import modules.CommentListWindow;
	import modules.ConfirmPanel;
	import modules.EmotionsWindow;
	import modules.ImageFrame;
	import modules.MainPanel;
	import modules.MewFuncList;
	import modules.MicroBlogPublish;
	import modules.MiniCat;
	import modules.OperationProgressBar;
	import modules.RepostPanel;
	import modules.SuggestionSubmit;
	import modules.SystemSetting;
	import modules.TabsView;
	import modules.ToolTip;
	import modules.UilityWin;
	import modules.UpdateDescriptor;
	import modules.UserDescription;
	import modules.UserOperation;
	import modules.UserProgressBar;
	
	import remoteManager.MewUpdater;
	
	import resource.ResCenter;

	public class DataCenter
	{
		public static var mainPanel:MainPanel = null;
		public static var microAPI:MicroBlog;
		public static var user:MicroBlogUser;
		public static var curUserId:String;
		public static var curUserName:String;
//		public static var operPB:UserProgressBar;
		public static var sendPanel:MicroBlogPublish;
		public static var alertTip:AlertTip;
		public static var updateDescriptor:UpdateDescriptor;
		public static var mewUpdater:MewUpdater;
		public static var userOper:OperationProgressBar;
		public static var aAndD:UserOperation;
		public static var userDes:UserDescription;
		public static var bugsSubmit:BugsSubmit;
		public static var suggestionSubmit:SuggestionSubmit;
		public static var mewList:MewFuncList;
		public static var toolTip:ToolTip;
		public static var tabsViewer:TabsView;
		public static var newMB:UilityWin;
		public static var systemSetter:SystemSetting;
		public static var commentListWindow:CommentListWindow;
		public static var emotionWindow:EmotionsWindow;
//		public static var windowList:Array;
		public static var confirmPanel:ConfirmPanel;
		public static var dataPreloader:DataPreloader;
		public static var floatAvatar:MiniCat;
		
		public static var loginType:String = "basic";
		
//		public static var lidList:XML;
		public static var appKey:String = "2150876607";
		public static var appSecret:String = "04c79316aa35ff6949b886546da32245";
		public static var topSearchURL:String = "http://api.t.sina.com.cn/statuses/search.xml";
		public static var userSearchURL:String = "http://api.t.sina.com.cn/users/search.xml";
		public static var randomStatusURL:String = "http://api.t.sina.com.cn/statuses/public_timeline.xml";
		public static var suggestionURL:String = "http://api.t.sina.com.cn/users/suggestions.xml";
		public static var fansNum:int;
		
		public static var count:int;            // 每页显示的微博条数
		public static var refreshDelay:int;  // 40秒
		public static var commentCount:uint;      // 每页显示的评论条数
		public static var isNotice:Boolean;   // 是否浮动提示
		public static var isVoice:Boolean;   // 是否声音提示
		public static var notClose:Boolean;   // 点击关闭按钮隐藏
		public static var autoRun:Boolean;   // 开机自动运行
		public static var alwaysInfront:Boolean;  // 始终位于最前面
		public static var showSystemTrayIcon:Boolean; // 显示系统托盘图标
		public static var autoHideByEdge:Boolean;     // 桌面边缘自动隐藏
		public static var hideNotClose:Boolean;
		public static var miniNotHide:Boolean;
		public static var updateDelay:uint;
		
		public static var weiboNotice:Boolean;     // 新微博提示
		public static var commentNotice:Boolean;   // 新评论提示
		public static var atNotice:Boolean;        // 新@提示
		public static var fansNotice:Boolean;      // 新粉丝提示
		public static var personalNotice:Boolean;  // 新私信提示
		
		public static var windowWidth:int = 420;          // 默认窗口宽度
		public static var windowHeight:int = 740;         // 默认窗口高度
		
		public static var FriendTimelinePhase:String;          // * 关注微博列表预加载是否完成 1
		public static var UserTimelinePhase:String;            // 用户微博列表预加载是否完成 2
		public static var AtDataPhase:String;                  // * @列表预加载是否完成 3
		public static var CommentDataPhase:String;             // * 评论列表预加载是否完成 4
		public static var PersonalReceiveDataPhase:String;     // * 私信接收列表预加载是否完成 5
		public static var FansDataPhase:String;                // * 粉丝列表预加载是否完成 6
		public static var FollowDataPhase:String;              // 关注列表预加载是否完成 7
		public static var PersonalSendDataPhase:String;        // 私信已发送列表预加载是否完成 8
		public static var CollectionDataPhase:String;          // 微博收藏列表预加载是否完成 9
		
		public static var FriendLastId:String;   // 关注微博列表最新一条的id
		public static var FansLastId:String;     // 粉丝列表最新一位的id
		public static var PersonalLastId:String; // 私信接收列表最新一条的id
		public static var AtLastId:String;       // @列表最新一条的id
		public static var CommentLastId:String;  // 评论最新一条的id
		
		//刷新时比对
		public static var UserTimeLineLastId:String;
		public static var FollowInfoLastId:String;
		public static var PersonalSendLastId:String;
		public static var CollectionLastId:String;
		
		public static var FansListFileName:String;
		public static var FollowListFileName:String;
		public static var FriendTimeLineFileName:String;
		public static var UserTimeLineFileName:String;
		public static var PersonalSendFileName:String;
		public static var PersonalReceiveFileName:String;
		public static var AtDataFileName:String;
		public static var CommentFileName:String;
		public static var CollectionFileName:String;
		
		public static var CurrentSystem:String = "";
		
		public static var SoundPath:String = "resource/sound.mp3";
		
		public static var loginTimes:uint;
		
		public function DataCenter()
		{
		}
		public static function init():void{
			
			alertTip = new AlertTip();
			userOper = new OperationProgressBar();
			//tabsViewer = new TabsView();
			aAndD = new UserOperation();
			dataPreloader = new DataPreloader();
			fansNum = 20;
			count = 20;
			refreshDelay = 40;
			commentCount = 10;
			updateDelay = 1;
			isNotice = true;
			isVoice = true;
			notClose = true;
			autoRun = false;
			alwaysInfront = false;
			showSystemTrayIcon = true;
			autoHideByEdge = true;
			weiboNotice = true;
			commentNotice = true;
			atNotice = true;
			fansNotice = true;
			personalNotice = true;
			hideNotClose = true;
			miniNotHide = true;
			FriendTimelinePhase = LocalizationPhase.IS_LOADING;
			UserTimelinePhase = LocalizationPhase.IS_LOADING;
			AtDataPhase = LocalizationPhase.IS_LOADING;
			CommentDataPhase = LocalizationPhase.IS_LOADING;
			PersonalReceiveDataPhase = LocalizationPhase.IS_LOADING;
			FansDataPhase = LocalizationPhase.IS_LOADING;
			FollowDataPhase = LocalizationPhase.IS_LOADING;
			PersonalSendDataPhase = LocalizationPhase.IS_LOADING;
			CollectionDataPhase = LocalizationPhase.IS_LOADING;
			FansListFileName = "fans";
			FollowListFileName = "follow";
			FriendTimeLineFileName = "public";
			UserTimeLineFileName = "usertimeline";
			PersonalSendFileName = "personalS";
			PersonalReceiveFileName = "personalR";
			AtDataFileName = "at";
			CommentFileName = "comment";
			CollectionFileName = "collection";
			loginTimes = 0;
			
		}
	}
}