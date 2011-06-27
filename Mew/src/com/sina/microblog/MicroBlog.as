package com.sina.microblog
{
	import com.adobe.crypto.HMAC;
	import com.adobe.crypto.SHA1;
	import com.dynamicflash.util.Base64;
	import com.sina.microblog.data.MicroBlogComment;
	import com.sina.microblog.data.MicroBlogCount;
	import com.sina.microblog.data.MicroBlogDirectMessage;
	import com.sina.microblog.data.MicroBlogProfileUpdateParams;
	import com.sina.microblog.data.MicroBlogRateLimit;
	import com.sina.microblog.data.MicroBlogStatus;
	import com.sina.microblog.data.MicroBlogUnread;
	import com.sina.microblog.data.MicroBlogUser;
	import com.sina.microblog.data.MicroBlogUsersRelationship;
	import com.sina.microblog.events.MicroBlogErrorEvent;
	import com.sina.microblog.events.MicroBlogEvent;
	import com.sina.microblog.utils.GUID;
	import com.sina.microblog.utils.StringEncoders;
	import com.ut.nm_test_internal;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.getClassByAlias;
	import flash.net.navigateToURL;
	import flash.system.ApplicationDomain;
	import flash.system.Capabilities;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	import flash.utils.getDefinitionByName;

	use namespace nm_test_internal;
	
	/**
	 *  当OAuth过程发生错误时触发该事件.
	 *
	 *  <p>当consumerKey和consumerSecret不为空时，使用OAuth方式进行认证</p>
	 *
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="oauthCertifcateError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当加载公共微博消息成功时触发该事件.
	 *
	 *  <p>调用loadPublicTimeLine成功时，事件的<code>result</code>属性为一个<code>MicroBlogStatus</code>
	 *  对象数组.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadPublicTimeLineResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当加载公共微博消息失败时触发该事件.
	 *
	 *  <p>调用loadPublicTimeLine失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadPublicTimeLineError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当加载用户所有关注的用户最新的n条微博消息成功时触发该事件.
	 *
	 *  <p>调用loadFriendsTimeLine成功时，事件的<code>result</code>属性为一个<code>MicroBlogStatus</code>
	 *  对象数组.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadFriendsTimeLineResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当加载用户所有关注的用户最新的n条微博消息失败时触发该事件.
	 *
	 *  <p>调用loadFriendsTimeLine失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadFriendsTimeLineError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当加载指定用户的微博消息成功时触发该事件.
	 *
	 *  <p>调用loadUserTimeLine成功时，事件的<code>result</code>属性为一个<code>MicroBlogStatus</code>
	 *  对象数组.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadUserTimeLineResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当加载指定用户的微博消息失败时触发该事件.
	 *
	 *  <p>调用loadUserTimeLine失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadUserTimeLineError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当加载提及博主的微博消息成功时触发该事件.
	 *
	 *  <p>调用loadMensions成功时，事件的<code>result</code>属性为一个<code>MicroBlogStatus</code>
	 *  对象数组.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadMensionsResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当加载指定用户的微博消息失败时触发该事件.
	 *
	 *  <p>调用loadMensions失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadMensionsError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当加载对博主所发微博消息的评论成功时触发该事件.
	 *
	 *  <p>调用loadCommentsTimeline成功时，事件的<code>result</code>属性为一个<code>MicroBlogComment</code>
	 *  对象数组.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadCommentsTimelineResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当加载指定用户的微博消息失败时触发该事件.
	 *
	 *  <p>调用loadMensions失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadCommentsTimelineError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当加载博主所发表评论成功时触发该事件.
	 *
	 *  <p>调用loadMyComments成功时，事件的<code>result</code>属性为一个<code>MicroBlogComment</code>
	 *  对象数组.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadMyCommentsResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当加载博主所发表评论失败时触发该事件.
	 *
	 *  <p>调用loadMyComments失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadMyCommentsError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当加载对微博消息的评论成功时触发该事件.
	 *
	 *  <p>调用loadComments成功时，事件的<code>result</code>属性为一个<code>MicroBlogComment</code>
	 *  对象数组.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadCommentsResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当加载对微博消息的评论失败时触发该事件.
	 *
	 *  <p>调用loadComments失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadCommentsError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当加载微博消息相关统计数据成功时触发该事件.
	 *
	 *  <p>调用loadStatusCounts成功时，事件的<code>result</code>属性为一个<code>MicroBlogCount</code>
	 *  对象数组.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadStatusCountsResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当加载微博消息相关统计数据失败时触发该事件.
	 *
	 *  <p>调用loadStatusCounts失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadStatusCountsError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当发布微博消息成功时触发该事件.
	 *
	 *  <p>调用updateStatus成功时，事件的<code>result</code>属性为刚发布的<code>MicroBlogStatus</code>
	 *  对象.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="updateStatusResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当发布微博消息失败时触发该事件.
	 *
	 *  <p>调用updateStatus失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="updateStatusError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当删除微博消息成功时触发该事件.
	 *
	 *  <p>调用deleteStatus成功时，事件的<code>result</code>属性为被删除的<code>MicroBlogStatus</code>
	 *  对象.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="deleteStatusResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当删除微博消息失败时触发该事件.
	 *
	 *  <p>调用deleteStatus失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="deleteStatusError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当加载某个微博消息成功时触发该事件.
	 *
	 *  <p>调用loadStatusInfo成功时，事件的<code>result</code>属性为<code>MicroBlogStatus</code>
	 *  对象.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadStatusInfoResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当加载某个微博消息失败时触发该事件.
	 *
	 *  <p>调用loadStatusInfo失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadStatusInfoError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当删除某个微博消息评论成功时触发该事件.
	 *
	 *  <p>调用deleteComment成功时，事件的<code>result</code>属性为<code>MicroBlogComment</code>
	 *  对象.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="deleteCommentResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当删除某个微博消息评论失败时触发该事件.
	 *
	 *  <p>调用deleteComment失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="deleteCommentError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当评论某个微博消息成功时触发该事件.
	 *
	 *  <p>调用commentStatus成功时，事件的<code>result</code>属性为<code>MicroBlogComment</code>
	 *  对象.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="commentStatusResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当评论某个微博消息失败时触发该事件.
	 *
	 *  <p>调用commentStatus失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="commentStatusError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当转发某个微博消息成功时触发该事件.
	 *
	 *  <p>调用repostStatus成功时，事件的<code>result</code>属性为<code>MicroBlogStatus</code>
	 *  对象.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="repostStatusResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当转发某个微博消息失败时触发该事件.
	 *
	 *  <p>调用repostStatus失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="repostStatusError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当回复某个微博评论成功时触发该事件.
	 *
	 *  <p>调用replyStatus成功时，事件的<code>result</code>属性为<code>MicroBlogStatus</code>
	 *  对象.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="replyStatusResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当回复某个微博评论失败时触发该事件.
	 *
	 *  <p>调用replyStatus失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="replyStatusError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当加载接收到的私信列表成功时触发该事件.
	 *
	 *  <p>调用loadDirectMessagesReceived成功时，事件的<code>result</code>属性为<code>MicroBlogDirectMessage</code>
	 *  对象数组.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadDirectMessagesReceivedResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当加载接收到的私信列表失败时触发该事件.
	 *
	 *  <p>调用loadDirectMessagesReceived失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadDirectMessagesReceivedError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当加载发出的私信列表成功时触发该事件.
	 *
	 *  <p>调用loadDirectMessagesSent成功时，事件的<code>result</code>属性为<code>MicroBlogDirectMessage</code>
	 *  对象数组.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadDicrectMessagesSentResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当加载发出的私信列表失败时触发该事件.
	 *
	 *  <p>调用loadDirectMessagesSent失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadDicrectMessagesSentError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当删除私信成功时触发该事件.
	 *
	 *  <p>调用deleteDirectMessage成功时，事件的<code>result</code>属性为被删除的<code>MicroBlogDirectMessage</code>
	 *  对象.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="deleteDirectMessageResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当删除私信失败时触发该事件.
	 *
	 *  <p>调用deleteDirectMessage失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="deleteDirectMessageError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当发送私信成功时触发该事件.
	 *
	 *  <p>调用sendDirectMessage成功时，事件的<code>result</code>属性<code>MicroBlogDirectMessage</code>
	 *  对象.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="sendDirectMessageResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当发送私信失败时触发该事件.
	 *
	 *  <p>调用deleteDirectMessage失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="sendDirectMessageSentError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当加载指定用户信息成功时触发该事件.
	 *
	 *  <p>调用loadUserInfo成功时，事件的<code>result</code>属性<code>MicroBlogUser</code>
	 *  对象.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadUserInfoResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当加载指定用户信息失败时触发该事件.
	 *
	 *  <p>调用loadUserInfo失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadUserInfoError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当加载用户关注的博主列表成功时触发该事件.
	 *
	 *  <p>调用loadFriendsInfo成功时，事件的<code>result</code>属性<code>MicroBlogUser</code>
	 *  对象数组.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadFriendsInfoResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当加载用户关注的博主列表失败时触发该事件.
	 *
	 *  <p>调用loadFriendsInfo失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadFriendsInfoError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当加载关注用户的博主列表成功时触发该事件.
	 *
	 *  <p>调用loadFollowersInfo成功时，事件的<code>result</code>属性<code>MicroBlogUser</code>
	 *  对象数组.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadFollowersInfoResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当加载关注用户的博主列表失败时触发该事件.
	 *
	 *  <p>调用loadFollowersInfo失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadFollowersInfoError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当关注某博主成功时触发该事件.
	 *
	 *  <p>调用follow成功时，事件的<code>result</code>属性<code>MicroBlogUser</code>
	 *  对象.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="followResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当关注某博主失败时触发该事件.
	 *
	 *  <p>调用follow失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="followError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当取消关注某博主成功时触发该事件.
	 *
	 *  <p>调用cancelFollowing成功时，事件的<code>result</code>属性<code>MicroBlogUser</code>
	 *  对象.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="cancelFollowingResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当取消关注某博主失败时触发该事件.
	 *
	 *  <p>调用cancelFollowing失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="cancelFollowingError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当查询两个微博用户关系成功返回时触发该事件.
	 *
	 *  <p>调用checkIsFollowing成功时，事件的<code>result</code>属性<code>MicroBlogRelationship</code>
	 *  对象.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="checkIsFollowingResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当查询两个微博用户关系失败时触发该事件.
	 *
	 *  <p>调用checkIsFollowing失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="checkIsFollowingError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当加载博主关注的用户id列表成功时触发该事件.
	 *
	 *  <p>调用loadFriendsIDList成功时，事件的<code>result</code>属性<code>uint</code>
	 *  数组.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadFriendsIDListResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当加载博主关注的用户id列表失败时触发该事件.
	 *
	 *  <p>调用loadFriendsIDList失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadFriendsIDListError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当加关注载博主的用户id列表成功时触发该事件.
	 *
	 *  <p>调用loadFollowersIDList成功时，事件的<code>result</code>属性<code>uint</code>
	 *  数组.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadFollowersIDListResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当加载关注博主的用户id列表失败时触发该事件.
	 *
	 *  <p>调用loadFollowersIDList失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadFollowersIDListError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当验证用户信息成功和登陆成功时触发该事件.
	 *
	 *  <p>调用verifyCrendentials成功时，事件的<code>result</code>属性<code>MicroBlogUser</code>
	 *  对象.</p>
	 *  <p>注意：当使用Basic方式验证的时候调用login成功时也会触发该事件</p>
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="verifyCredentialsResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当验证用户信息失败时触发该事件.
	 *
	 *  <p>调用verifyCrendentials失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="verifyCredentialsError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当获取调用速率限制信息成功时触发该事件.
	 *
	 *  <p>调用getRateLimitStatus成功时，事件的<code>result</code>属性<code>MicroBlogUser</code>
	 *  数组.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="getRateLimitStatusResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当获取调用速率限制信息失败时触发该事件.
	 *
	 *  <p>调用getRateLimitStatus失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="getRateLimitStatusError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当用户成功注销时触发该事件.
	 *
	 *  <p>调用logout成功时，事件的<code>result</code>属性<code>MicroBlogRateLimit</code>
	 *  数组.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="logoutResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当用户注销失败时触发该事件.
	 *
	 *  <p>调用logout失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="logoutError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当更新用户信息成功时触发该事件.
	 *
	 *  <p>调用updateProfile成功时，事件的<code>result</code>属性<code>MicroBlogUser</code>
	 *  对象.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="updateProfileResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当更新用户信息失败时触发该事件.
	 *
	 *  <p>调用updateProfile失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="updateProfileError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当更新用户头像成功时触发该事件.
	 *
	 *  <p>调用updateProfileImage成功时，事件的<code>result</code>属性<code>MicroBlogUser</code>
	 *  对象.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="updateProfileImageResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当更新用户头像失败时触发该事件.
	 *
	 *  <p>调用updateProfileImage失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="updateProfileImageError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	
	/**
	 *  当加载用户收藏列表成功时触发该事件.
	 *
	 *  <p>调用loadFavoriteList成功时，事件的<code>result</code>属性<code>MicroBlogStatus</code>
	 *  对象数组.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadFavoriteListResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当加载用户收藏列表失败时触发该事件.
	 *
	 *  <p>调用loadFavoriteList失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadFavoriteListError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当收藏微博消息成功时触发该事件.
	 *
	 *  <p>调用addToFavorites成功时，事件的<code>result</code>属性<code>MicroBlogStatus</code>
	 *  对象.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="addToFavoritesResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当收藏微博消息失败时触发该事件.
	 *
	 *  <p>调用addToFavorites失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="addToFavoritesError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当将微博消息移出收藏列表成功时触发该事件.
	 *
	 *  <p>调用removeFromFavorites成功时，事件的<code>result</code>属性<code>MicroBlogStatus</code>
	 *  对象.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="removeFromFavoritesResult", type="com.sina.microblog.events.MicroBlogEvent")]	
	/**
	 *  当将微博消息移出收藏列表失败时触发该事件.
	 *
	 *  <p>调用addToFavorites失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="removeFromFavoritesError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当允许/不允许某用户通知成功时触发该事件.
	 *
	 *  <p>调用enableNotification成功时，事件的<code>result</code>属性<code>MicroBlogUser</code>
	 *  对象.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="enableNotificationResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当允许/不允许某用户通知失败时触发该事件.
	 *
	 *  <p>调用enableNotification失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="enableNotificationError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当请求省份，城市与id对应列表成功时触发该事件.
	 *
	 *  <p>调用loadProvinceCityIDList成功时，事件的<code>result</code>属性<code>XML</code>
	 *  对象.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadProvinceCityIdListResult", type="flash.events.MicroBlogEvent")]
	/**
	 *  当请求省份，城市与id对应列表失败时触发该事件.
	 *
	 *  <p>调用loadProvinceCityIDList失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadProvinceCityIdListError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当请求未被验证，服务器调用产生安全错误时触发该事件.
	 *
	 *  @see flash.events.SecurityErrorEvent
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="securityError", type="flash.events.SecurityErrorEvent")]
	
	/**
	 * MicroBlog是新浪微博AS3 API的核心类.
	 *
	 * <p>其主要功能包括：</br>
	 * <ul>
	 * <li>封装核心的平台API</li>
	 * <li>封装了两种用户认证方式：用户名/密码和OAuth方式</li>
	 * <li>使用事件来返回API调用结果</li>
	 * <li>对API调用的结果(XML)进行强类型的封装</li>
	 * </ul>
	 * 一般情况下，当一个API调用成功时，将会抛出一个<b>MicroBlogEvent</b>事件，而调用失败将会抛出<b>MicroBlogErrorEvent</b>事件。</br>
	 * 具体事件类型请参照函数说明文档。
	 * </p>
	 * <p>
	 * <b>例1 使用用户名密码进行用户认证</b>
	 * <pre><br/>
	 * private var mb:MicroBlog = new MicroBlog();
	 * public function init():void 
	 * {
	 * 		mb.login(username, password);
	 * }</pre>
	 * </p>
	 * <p>
	 * <b>例2 使用OAuth进行认证</b>
	 * <pre><br/>
	 * private var mb:MicroBlog = new MicroBlog();
	 * public function init():void
	 * {
	 * 		mb.consumerKey = xxxxxx;
	 * 		mb.consumerSecret = xxxxxx;
	 * 		if ( accessTokenKey &#38;&#38; accessTokenSecret )
	 * 		//如果保存了用户认证过的Token，则不需要登陆，也不需要pin_onClick的调用过程
	 * 		{
	 * 			mb.accessTokenKey = accessTokenKey;
	 * 			mb.accessTokenSecret = accessTokenSecret;
	 * 		} else
	 * 		{
	 * 			mb.login();
	 * 		}
	 * }
	 * //当用户在网页上认证了该请求以后
	 * private function pin_onClick():void
	 * {
	 * 		mb.pin = xxxxx;//如果不使用pin码，将pin置为空即可mb.pin="";
	 * }
	 * //然后就可以访问微博数据了
	 * </pre>
	 * </p>
	 * <p>
	 * <b>例3 一个典型的服务器调用过程，包括调用api，监听事件</b>
	 * <pre><br/>
	 * private var mb:MicroBlog = new MicroBlog();
	 * private function initListeners():void
	 * {
	 * 		mb.addEventListener(MicroBlogEvent.LOAD_PUBLIC_TIMELINE_RESULT, mb_onPublicTimeline, false, 0, true);
	 * 		mb.addEventListener(MicroBlogErrorEvent.LOAD_PUBLIC_TIMELINE_ERROR, mb_onError, false, 0, true);
	 * }
	 * public function loadPublicTimeline():void
	 * {
	 * 		mb.loadPublicTimeline();
	 * }
	 * private function mb_onPublicTimeline(event:MicroBlogEvent):void
	 * {
	 * 		//处理成功返回的数据
	 * 		var data:Array = event.result;
	 * 		xxxxxx
	 * }
	 * private function mb_onError(event:MicroBlogErrorEvent):void
	 * {
	 * 		var msg:String = event.message;
	 * 		xxxxxxx
	 * }
	 * </pre>
	 * </p>
	 *
	 */
	public class MicroBlog extends EventDispatcher
	{

		private static const API_BASE_URL:String="http://api.t.sina.com.cn/";

		private static const OAUTH_REQUEST_TOKEN_REQUEST_URL:String=API_BASE_URL + "oauth/request_token";
		//private static const OAUTH_REQUEST_TOKEN_REQUEST_URL:String="http://twitter.com/oauth/request_token";
		private static const OAUTH_AUTHORIZE_REQUEST_URL:String=API_BASE_URL + "oauth/authorize";
		private static const OAUTH_ACCESS_TOKEN_REQUEST_URL:String=API_BASE_URL + "oauth/access_token";

		private static const PUBLIC_TIMELINE_REQUEST_URL:String=API_BASE_URL + "statuses/public_timeline.xml";
		private static const FRIENDS_TIMELINE_REQUEST_URL:String=API_BASE_URL + "statuses/friends_timeline.xml";
		private static const USER_TIMELINE_REQUEST_URL:String=API_BASE_URL + "statuses/user_timeline$user.xml";
		private static const MENTIONS_REQUEST_URL:String=API_BASE_URL + "statuses/mentions.xml";
		private static const COMMENTS_TIMELINE_REQUEST_URL:String=API_BASE_URL + "statuses/comments_timeline.xml";
		private static const COMMENTS_BY_ME_REQUEST_URL:String=API_BASE_URL + "statuses/comments_by_me.xml";
		private static const COMMENTS_REQUEST_URL:String=API_BASE_URL + "statuses/comments.xml";
		private static const STATUS_COUNTS_REQUEST_URL:String=API_BASE_URL + "statuses/counts.xml";

		private static const UPDATE_STATUS_REQUEST_URL:String=API_BASE_URL + "statuses/update.xml";
		private static const UPDATE_STATUS_WITH_IMAGE_REQUEST_URL:String=API_BASE_URL + "statuses/upload.xml";
		private static const SHOW_STATUS_REQUEST_URL:String=API_BASE_URL + "statuses/show/$id.xml";
		private static const DELETE_STATUS_REQUEST_URL:String=API_BASE_URL + "statuses/destroy/$id.xml";
		private static const COMMENT_STATUS_REQUEST_URL:String=API_BASE_URL + "statuses/comment.xml";
		private static const DELETE_COMMENT_REQUEST_URL:String=API_BASE_URL + "statuses/comment_destroy/$id.xml";
		private static const REPOST_STATUS_REQUEST_URL:String=API_BASE_URL + "statuses/repost.xml";
		private static const REPLY_STATUS_REQUEST_URL:String=API_BASE_URL + "statuses/reply.xml";

		private static const LOAD_DIRECT_MESSAGES_RECEIVED_REQUEST_URL:String=API_BASE_URL + "direct_messages.xml";
		private static const LOAD_DIRECT_MESSAGES_SENT_REQUEST_URL:String=API_BASE_URL + "direct_messages/sent.xml";
		private static const SEND_DIRECT_MESSAGE_REQUEST_URL:String=API_BASE_URL + "direct_messages/new.xml";
		private static const DELETE_DIRECT_MESSAGE_REQUEST_URL:String=API_BASE_URL + "direct_messages/destroy/$id.xml";

		private static const LOAD_USER_INFO_REQUEST_URL:String=API_BASE_URL + "users/show$user.xml";
		private static const LOAD_FRIENDS_INFO_REQUEST_URL:String=API_BASE_URL + "statuses/friends$user.xml";
		private static const LOAD_FOLLOWERS_INFO_REQUEST_URL:String=API_BASE_URL + "statuses/followers$user.xml";

		private static const FOLLOW_REQUEST_URL:String=API_BASE_URL + "friendships/create$user.xml";
		private static const CANCEL_FOLLOWING_REQUEST_URL:String=API_BASE_URL + "friendships/destroy$user.xml";
		private static const CHECK_IS_FOLLOWING_REQUEST_URL:String=API_BASE_URL + "friendships/show.xml";

		private static const LOAD_FRIENDS_ID_LIST_REQUEST_URL:String=API_BASE_URL + "friends/ids$user.xml";
		private static const LOAD_FOLLOWERS_ID_LIST_REQUEST_URL:String=API_BASE_URL + "followers/ids$user.xml";
		
		private static const VERIFY_CREDENTIALS_REQUEST_URL:String=API_BASE_URL + "account/verify_credentials.xml";
		private static const GET_RATE_LIMIT_STATUS_REQUEST_URL:String=API_BASE_URL + "account/rate_limit_status.xml";
		private static const LOGOUT_REQUEST_URL:String=API_BASE_URL + "account/end_session.xml";
		private static const UPDATE_PROFILE_IMAGE_REQUEST_URL:String=API_BASE_URL + "account/update_profile_image.xml";
		private static const UPDATE_PROFILE_REQUEST_URL:String=API_BASE_URL + "account/update_profile.xml";

		private static const LOAD_FAVORITE_LIST_REQUEST_URL:String=API_BASE_URL + "favorites.xml";
		private static const ADD_TO_FAVORITES_REQUEST_URL:String=API_BASE_URL + "favorites/create.xml";
		private static const REMOVE_FROM_FAVORITES_REQUEST_URL:String=API_BASE_URL + "favorites/destroy/$id.xml";

		private static const ENABLE_NOTIFICATION_REQUEST_URL:String=API_BASE_URL + "notifications/$enabled$user.xml";
	
		private static const LOAD_PROVINCE_CITY_ID_LIST:String=API_BASE_URL + "provinces.xml";
//		private static const VERIFY_CREDENTIALS:String = "1";
//		private static const LOGOUT:String = "2";

		private static const USER_ID:String="user_id";
		private static const SCREEN_NAME:String="screen_name";
		private static const SINCE_ID:String="since_id";
		private static const MAX_ID:String="max_id";
		private static const COUNT:String="count";
		private static const PAGE:String="page";
		private static const ROLE:String="role";
		private static const ID:String="id";
		private static const CURSOR:String="cursor";
		private static const FOLLOW:String="follow";
		private static const SOURCE_ID:String="source_id";
		private static const SOURCE_SCREEN_NAME:String="source_screen_name";
		private static const TARGET_ID:String="target_id";
		private static const TARGET_SCREEN_NAME:String="target_screen_name";

		private static const MULTIPART_FORMDATA:String="multipart/form-data; boundary=";
		private static const CONTENT_DISPOSITION_BASIC:String='Content-Disposition: form-data; name="$name"';

		private static const CONTENT_TYPE_JPEG:String="Content-Type: image/pjpeg";
		private static const CONTENT_TRANSFER_ENCODING:String="Content-Transfer-Encoding: binary";
		
		private static const SOURCE_ADOBE_AIR_CLIENT:String = "Adobe Air Client";
		private var _consumerKey:String="";
		private var _consumerSecret:String="";
		private var _accessTokenKey:String="";
		private var _accessTokenSecret:String="";
		private var _pin:String="";
		private var _source:String = SOURCE_ADOBE_AIR_CLIENT;
		private var authHeader:URLRequestHeader;

		private var serviceLoader:Dictionary=new Dictionary();
		private var loaderMap:Dictionary=new Dictionary();

		private var oauthLoader:URLLoader;
		
		/**
		 * @private Used for test purpose.
		 */
		nm_test_internal var lastLoader:URLLoader;
		nm_test_internal var lastRequest:URLRequest;
		
		public function MicroBlog()
		{

		}

		/**
		 * consumerKey是一个只写属性，用于验证客户端的合法性，
		 * 必须在调用login之前将其设置为合适值.
		 */
		public function set consumerKey(value:String):void
		{
			if ( value )
			{
				_consumerKey=value;
			} else
			{
				_consumerKey = "";
			}
		}

		/**
		 * consumerSecret是一个只写属性，用于和consumerKey一起验证客户端的合法性，
		 * 必须在调用login之前将其设置为合适值.
		 */
		public function set consumerSecret(value:String):void
		{
			if ( value )
			{
				_consumerSecret=value;
			} else
			{
				_consumerSecret = "";
			}
		}
		/**
		 * pin是用于OAuth认证用的属性，由登陆页面生成.仅在登陆时使用.
		 * 
		 */
		public function set pin(value:String):void
		{
			_pin=value;
			//Case that the saved user come back. 
			//The oauthLoader will not created before login
			//Actually, the application could save last token and
			//reset after the application restarted.
			if ( oauthLoader )
			{
				var url:String=OAUTH_ACCESS_TOKEN_REQUEST_URL;
				var req:URLRequest=signRequest(URLRequestMethod.GET, url, null);
				oauthLoader.load(req);
				_pin = ""; // Just use once.
			}
		}
		
		/**
		 * accessTokenKey是用于OAuth认证的访问资源的token，由用户授权.
		 * 
		 */
		public function set accessTokenKey(value:String):void
		{
			if (null != value)
			{
				_accessTokenKey=value;
			} else
			{
				_accessTokenKey = "";
			}
		}

		public function get accessTokenKey():String
		{
			return _accessTokenKey;
		}
		/**
		 * accessTokenSecret是用于OAuth认证的访问资源的token的密钥.
		 * 
		 */
		public function get accessTokenSecrect():String
		{
			return _accessTokenSecret;
		}
		public function set accessTokenSecrect(value:String):void
		{
			if (null != value)
			{
				_accessTokenSecret=value;
			} else
			{
				_accessTokenSecret = "";
			}
		}
		/**
		 * source是标识客户端来源.必须设置为新浪认证的应用程序id
		 * 
		 */
		public function set source(value:String):void
		{
			_source = StringEncoders.urlEncodeUtf8String(value);
		}
		public function get source():String
		{
			return _source;
		}
		/**
		 * login函数封装了OAuth所要求的验证的三个步骤，
		 * 调用者只需要将新浪微博的用户名和密码
		 * （之前输入的consumerKey和consumerSecret）
		 * 传入函数即可.
		 *
		 * @param userName 是合法的新浪微博用户名.
		 * @param password 是与用户名对应的密码.
		 *
		 * login函数没有返回值，验证结果将采用消息的方式通知api调用者.
		 * @see com.sina.microblog.events.MicroBlogEvent#LOGIN_RESULT
		 *
		 */
		public function login(userName:String=null, password:String=null):void
		{
			if (_accessTokenKey.length > 0 && _accessTokenSecret.length > 0)
			{
				return;
			}

			if (_consumerKey.length > 0 && _consumerSecret.length > 0)
			{
				if (null == oauthLoader)
				{
					oauthLoader=new URLLoader();
					oauthLoader.addEventListener(Event.COMPLETE, oauthLoader_onComplete, false, 0, true);
					oauthLoader.addEventListener(IOErrorEvent.IO_ERROR, oauthLoader_onError, false, 0, true);
					oauthLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, oauthLoader_onSecurityError, false, 0, true);
				}
				var req:URLRequest=signRequest(URLRequestMethod.GET, OAUTH_REQUEST_TOKEN_REQUEST_URL, null);
				oauthLoader.load(req);
			}
			else if (userName != null && password != null)
			{
				var creds:String=userName + ":" + password;
				var encodedCredentials:String=Base64.encode(creds);
				authHeader=new URLRequestHeader("Authorization", "Basic " + encodedCredentials);
				verifyCredentials();
			}

		}

		/**
		 * 返回最新更新的20条公共微博消息.
		 *
		 * <b>有请求数限制</b>
		 * 
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件<br/>
		 * type为<b>MicroBlogEvent.STATUS_PUBLIC_TIMELINE_RESULT</b><br/>
		 * success为<b>true</b>如果该属性为false，则表示该次操作失败<br/>
		 * result为一个MicroBlogStatus数组，该数组包含了最新的20条微博消息.</p>
		 *
		 * <p>如果该函数调用失败，将会抛出MicroBlogErrorEvent事件，该事件<br/>
		 * type为<b>MicroErrorEvent.STATUS_PUBLIC_TIMELINE_ERROR</b></p>
		 *
		 */
		public function loadPublicTimeline():void
		{
			addProcessor(PUBLIC_TIMELINE_REQUEST_URL, processStatusArray, MicroBlogEvent.LOAD_PUBLIC_TIMELINE_RESULT, MicroBlogErrorEvent.LOAD_PUBLIC_TIMELINE_ERROR);
			executeRequest(PUBLIC_TIMELINE_REQUEST_URL, getMicroBlogRequest(PUBLIC_TIMELINE_REQUEST_URL, null, URLRequestMethod.GET));
		}

		/**
		 * 返回用户所有关注的用户最新的n条微博消息.
		 *
		 * <b>有请求数限制</b>
		 * 
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.STATUS_FRIENDS_TIMELINE_RESULT</b><br/>
		 * result为一个MicroBlogStatus数组，该数组包含了所请求的微博消息.</p>
		 *
		 * <p>如果该函数调用失败，将会抛出MicroBlogErrorEvent事件，该事件<br/>
		 * type为<b>MicroErrorEvent.STATUS_FRIENDS_TIMELINE_ERROR</b><br/></p>
		 *
		 * @param sinceID 请求大于该id的所有消息更新，默认值为0，表示不限制.
		 * @param maxID 请求小于该id的所有消息更新，默认为0，表示不限制.
		 * @param count 请求的页大小，即一页包含多少条记录；默认值0，表示使用服务器默认分页大小.
		 * @param page 请求的页序号，默认值0，返回第一页.
		 *
		 */
		public function loadFriendsTimeline(sinceID:String=null, maxID:String=null, count:uint=0, page:uint=0):void
		{
			addProcessor(FRIENDS_TIMELINE_REQUEST_URL, processStatusArray, MicroBlogEvent.LOAD_FRIENDS_TIMELINE_RESULT, MicroBlogErrorEvent.LOAD_FRIENDS_TIMELINE_ERROR);
			var url:String=FRIENDS_TIMELINE_REQUEST_URL;
			var params:Object=new Object();
			makeQueryCombinatory(params, sinceID, maxID, count, page);
			executeRequest(FRIENDS_TIMELINE_REQUEST_URL, getMicroBlogRequest(url, params, URLRequestMethod.GET));
		}

		/**
		 * 返回用户发布的最新的n条微博消息.
		 *
		 * <b>有请求数限制</b>
		 * 
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.STATUS_USER_TIMELINE_RESULT</b><br/>
		 * result为一个MicroBlogStatus数组，该数组包含了所请求的微博消息.
		 * 由于分页限制，最多只能返回用户最新的300条微博信息</p>
		 *
		 * <p>如果该函数调用失败，将会抛出MicroBlogErrorEvent事件，该事件<br/>
		 * type为<b>MicroErrorEvent.STATUS_USER_TIMELINE_ERROR</b></p>
		 *
		 * @param id 可选参数. 根据指定用户UID或用户帐号来返回微博信息.
		 * @param userID 可选参数. 指定用户UID来返回微博信息，主要是用来区分用户UID跟用户账号一样，产生歧义的时候，特别是在用户账号为数字导致和用户Uid发生歧义.
		 * @param screenName 可选参数，指定用户的微博昵称，主要是用来区分用户UID跟用户账号一样，产生歧义的时候。
		 * @param sinceID 请求大于该id的所有消息更新，默认值为0，表示不限制.
		 * @param maxID 请求小于该id的所有消息更新，默认为0，表示不限制.
		 * @param count 请求的页大小，即一页包含多少条记录；默认值0，表示使用服务器默认分页大小.
		 * @param page 请求的页序号，默认值0，返回第一页.
		 *
		 *
		 */
		public function loadUserTimeline(id:*=null, userID:String=null, screenName:String=null, sinceID:String=null, maxID:String=null, count:uint=0, page:uint=0):void
		{
			//TO-DO: if the parameter equals to zero, don't include this parameter when build request url.
			addProcessor(USER_TIMELINE_REQUEST_URL, processStatusArray, MicroBlogEvent.LOAD_USER_TIMELINE_RESULT, MicroBlogErrorEvent.LOAD_USER_TIMELINE_ERROR);
			var user:String;
			if (id)
			{
				user="/" + String(id);
			}
			else
			{
				user="";
			}
			var url:String=USER_TIMELINE_REQUEST_URL.replace("$user", user);
			var params:Object=new Object();
			makeUserParams(params, userID, screenName, -1);
			makeQueryCombinatory(params, sinceID, maxID, count, page);

			executeRequest(USER_TIMELINE_REQUEST_URL, getMicroBlogRequest(url, params, URLRequestMethod.GET));
		}

		/**
		 * 返回最近n条提及我的微博消息.
		 *
		 * <b>有请求数限制</b>
		 * 
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.STATUS_MENTIONS_RESULT</b><br/>
		 * result为一个MicroBlogStatus数组，该数组包含了所请求的微博消息.</p>
		 *
		 * <p>如果该函数调用失败，将会抛出MicroBlogErrorEvent事件，该事件<br/>
		 * type为<b>MicroErrorEvent.STATUS_MENTIONS_ERROR</b></p>
		 *
		 * @param sinceID 请求大于该id的所有消息更新，默认值为0，表示不限制.
		 * @param maxID 请求小于该id的所有消息更新，默认为0，表示不限制.
		 * @param count 请求的页大小，即一页包含多少条记录；默认值0，表示使用服务器默认分页大小.
		 * @param page 请求的页序号，默认值0，返回第一页.
		 *
		 */
		public function loadMentions(sinceID:String=null, maxID:String=null, count:uint=0, page:uint=0):void
		{
			//TO-DO: if the parameter equals to zero, don't include this parameter when build request url.
			addProcessor(MENTIONS_REQUEST_URL, processStatusArray, MicroBlogEvent.LOAD_MENSIONS_RESULT, MicroBlogErrorEvent.LOAD_MENSIONS_ERROR);
			var url:String=MENTIONS_REQUEST_URL;
			var params:Object=new Object();
			makeQueryCombinatory(params, sinceID, maxID, count, page);
			executeRequest(MENTIONS_REQUEST_URL, getMicroBlogRequest(url, params, URLRequestMethod.GET));
		}

		/**
		 * 返回最近n条评论.
		 * 
		 * <b>有请求数限制</b>
		 * 
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.STATUS_COMMENTS_TIMELINE_RESULT</b><br/>
		 * result为一个MicroBlogStatus数组，该数组包含了所请求的微博消息.</p>
		 *
		 * <p>如果该函数调用失败，将会抛出MicroBlogErrorEvent事件，该事件<br/>
		 * type为<b>MicroErrorEvent.STATUS_COMMENTS_TIMELINE_ERROR</b></p>
		 *
		 * @param sinceID 请求大于该id的所有消息更新，默认值为0，表示不限制.
		 * @param maxID 请求小于该id的所有消息更新，默认为0，表示不限制.
		 * @param count 请求的页大小，即一页包含多少条记录；默认值0，表示使用服务器默认分页大小.
		 * @param page 请求的页序号，默认值0，返回第一页.
		 *
		 */
		public function loadCommentsTimeline(sinceID:String=null, maxID:String=null, count:uint=0, page:uint=0):void
		{
			addProcessor(COMMENTS_TIMELINE_REQUEST_URL, processCommentArray, MicroBlogEvent.LOAD_COMMENTS_TIMELINE_RESULT, MicroBlogErrorEvent.LOAD_COMMENTS_TIMELINE_ERROR);
			var url:String=COMMENTS_TIMELINE_REQUEST_URL;
			var params:Object=new Object();
			makeQueryCombinatory(params, sinceID, maxID, count, page);
			executeRequest(COMMENTS_TIMELINE_REQUEST_URL, getMicroBlogRequest(url, params, URLRequestMethod.GET));
		}

		/**
		 * 返回我发表的评论.
		 *
		 * <b>有请求数限制</b>
		 * 
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.STATUS_COMMENTS_BY_ME_RESULT</b><br/>
		 * result为一个MicroBlogStatus数组，该数组包含了所请求的微博消息.</p>
		 *
		 * <p>如果该函数调用失败，将会抛出MicroBlogErrorEvent事件，该事件<br/>
		 * type为<b>MicroErrorEvent.STATUS_COMMENTS_TIMELINE_ERROR</b></p>
		 *
		 * @param sinceID 请求大于该id的所有消息更新，默认值为0，表示不限制.
		 * @param maxID 请求小于该id的所有消息更新，默认为0，表示不限制.
		 * @param count 请求的页大小，即一页包含多少条记录；默认值0，表示使用服务器默认分页大小.
		 * @param page 请求的页序号，默认值0，返回第一页.
		 *
		 */
		public function loadMyComments(sinceID:String=null, maxID:String=null, count:uint=0, page:uint=0):void
		{
			addProcessor(COMMENTS_BY_ME_REQUEST_URL, processCommentArray, MicroBlogEvent.LOAD_MY_COMMENTS_RESULT, MicroBlogErrorEvent.LOAD_MY_COMMENTS_ERROR);
			var url:String=COMMENTS_BY_ME_REQUEST_URL;
			var params:Object=new Object();
			makeQueryCombinatory(params, sinceID, maxID, count, page);
			executeRequest(COMMENTS_BY_ME_REQUEST_URL, getMicroBlogRequest(url, params, URLRequestMethod.GET));
		}

		/**
		 * 返回指定微博的最新n条评论.
		 *
		 * <b>有请求数限制</b>
		 * 
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.STATUS_COMMENTS_RESULT</b><br/>
		 * result为一个MicroBlogStatus数组，该数组包含了所请求的微博消息.</p>
		 *
		 * @param id 必选参数，指定微博ID.
		 * @param count 请求的页大小，即一页包含多少条记录；默认值0，表示使用服务器默认分页大小.
		 * @param page 请求的页序号，默认值0，返回第一页.
		 */
		public function loadCommentList(id:String, count:uint=0, page:uint=0):void
		{
			addProcessor(COMMENTS_REQUEST_URL, processCommentArray, MicroBlogEvent.LOAD_COMMENTS_RESULT, MicroBlogErrorEvent.LOAD_COMMENTS_ERROR);
			var url:String=COMMENTS_REQUEST_URL;
			var params:Object=new Object();
			params[ID]=id;
			makeQueryCombinatory(params, "", "", count, page);
			executeRequest(COMMENTS_REQUEST_URL, getMicroBlogRequest(url, params, URLRequestMethod.GET));
		}

		/**
		 * 批量统计微薄的评论数，转发数.单次最多获取100个.
		 *
		 * <b>有请求数限制</b>
		 * 
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.STATUS_COUNTS_RESULT</b><br/>
		 * result为一个MicroBlogCounts实例.</p>
		 *
		 * @param ids 必选参数，指定微博ID数组.
		 *
		 */
		public function loadStatusCounts(ids:Array):void
		{
			addProcessor(STATUS_COUNTS_REQUEST_URL, processCounts, MicroBlogEvent.LOAD_STATUS_COUNTS_RESULT, MicroBlogErrorEvent.LOAD_STATUS_COUNTS_ERROR);
			var idsParam:String="";
			
			if (null == ids || ids.length == 0)
			{
				return;
			}
			var len:int=ids.length - 1;
			for (var i:int=0; i < len; ++i)
			{
				idsParam+=ids[i].toString() + ",";
			}
			idsParam+=ids[len].toString();
			var params:Object=new Object();
			params["ids"]=idsParam;
			var url:String=STATUS_COUNTS_REQUEST_URL;
			executeRequest(STATUS_COUNTS_REQUEST_URL, getMicroBlogRequest(url, params, URLRequestMethod.GET));
		}

		/**
		 * 获取单条ID的微博信息，作者信息将同时返回.
		 *
		 * <b>有请求数限制</b>
		 * 
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.SHOW_STATUS_RESULT</b><br/>
		 * result为一个MicroBlogStatus实例.</p>
		 *
		 * @param id 必选参数，指定微博消息ID.
		 *
		 */
		public function loadStatusInfo(id:String):void
		{
			addProcessor(SHOW_STATUS_REQUEST_URL, processStatus, MicroBlogEvent.LOAD_STATUS_INFO_RESULT, MicroBlogErrorEvent.LOAD_STATUS_INFO_ERROR);
			var url:String=SHOW_STATUS_REQUEST_URL.replace("$id", id);
			executeRequest(SHOW_STATUS_REQUEST_URL, getMicroBlogRequest(url, null, URLRequestMethod.GET));
		}

		/**
		 * 发布一条微博信息.为防止重复，发布的信息与当前最新信息一样话，将会被忽略.
		 *
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.UPDATE_STATUS_RESULT</b><br/>
		 * result为一个MicroBlogStatus实例.</p>
		 *
		 * @param status 必选参数，要更新的微博信息,信息内容部超过140个汉字.
		 * @param filename 可选参数，上传的jpeg文件名.
		 * @param imgData 可选参数，为需要上传的jpeg文件数据，为空则不上传图片.
		 *
		 * 如果没有登录或超过发布上限，将返回错误
		 * 系统将忽略重复发布的信息.每次发布将比较最后一条发布消息，如果一样将被忽略.因此用户不能连续提交相同信息.
		 */
		public function updateStatus(status:String, filename:String=null, imgData:ByteArray=null):void
		{
			addProcessor(UPDATE_STATUS_REQUEST_URL, processStatus, MicroBlogEvent.UPDATE_STATUS_RESULT, MicroBlogErrorEvent.UPDATE_STATUS_ERROR);
			var req:URLRequest;
			var params:URLVariables=new URLVariables();
			
			if ( status )
			{
				params.status= encodeMsg(status);
			} else
			{
				if ( imgData == null )
				{
					return;
				}
			}
			
			var url:String;

			if (imgData)
			{
				url=UPDATE_STATUS_WITH_IMAGE_REQUEST_URL;
				req=getMicroBlogRequest(url, params, URLRequestMethod.POST);
				var boundary:String=makeBoundary();
				req.contentType=MULTIPART_FORMDATA + boundary;
				req.data=makeMultipartPostData(boundary, "pic", filename, imgData, params);
			}
			else
			{
				
				url=UPDATE_STATUS_REQUEST_URL;
				req=getMicroBlogRequest(url, params, URLRequestMethod.POST);
				req.data=params;
			}
			executeRequest(UPDATE_STATUS_REQUEST_URL, req);

		}

		/**
		 * 返回发布一条带图片的微博信息的<code>URLRequest对象</code>.
		 *
		 * 
		 * <p>如果消息成功发送，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.UPDATE_STATUS_RESULT</b><br/>
		 * result为一个MicroBlogStatus实例.</p>
		 *
		 *
		 * @return <code>URLRequest</code>对象，用于在flash中用File对象上传图片，在调用File对象的upload时uploadDataFieldName必须为pic。
		 *
		 * 如果没有登录或超过发布上限，将返回错误
		 * 系统将忽略重复发布的信息.每次发布将比较最后一条发布消息，如果一样将被忽略.因此用户不能连续提交相同信息.
		 *
		 * @see #updateStatus()
		 */
		public function getUploadImageRequest(status:String):URLRequest
		{
			var req:URLRequest;
			
			var url:String=UPDATE_STATUS_WITH_IMAGE_REQUEST_URL;
			var data:URLVariables=new URLVariables();
			data.status=encodeMsg(status);
			req=getMicroBlogRequest(url, data, URLRequestMethod.POST);
			req.data=data;
			return req;
		}

		/**
		 * 删除微博信息.注意：只能删除自己发布的信息.
		 * 
		 * <p> 如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.DELETE_STATUS_RESULT</b><br/>
		 * result为一个MicroBlogStatus实例.</p>
		 *
		 * @param id 必填参数，要删除的微博信息ID.
		 *
		 */
		public function deleteStatus(id:String):void
		{
			addProcessor(DELETE_STATUS_REQUEST_URL, processStatus, MicroBlogEvent.DELETE_STATUS_RESULT, MicroBlogErrorEvent.DELETE_STATUS_ERROR);
			var url:String=DELETE_STATUS_REQUEST_URL.replace("$id", id);
			var postData:URLVariables = new URLVariables();
			var req:URLRequest = getMicroBlogRequest(url, postData, URLRequestMethod.POST);
			req.data = postData;
			executeRequest(DELETE_STATUS_REQUEST_URL, req);
			
		}

		/**
		 * 转发一条微博信息.为防止重复，发布的信息与当前最新信息一样话，将会被忽略.
		 *
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.REPOST_STATUS_RESULT</b><br/>
		 * result为一个MicroBlogStatus实例.</p>
		 *
		 * @param id 必填参数，转发的微博ID.
		 * @param status 可选参数，要更新的微博信息,信息内容部超过140个汉字.
		 * 
		 * <p>如果没有登录或超过发布上限，将返回错误
		 * 系统将忽略重复发布的信息.每次发布将比较最后一条发布消息，如果一样将被忽略.因此用户不能连续提交相同信息.
		 * </p>
		 */
		public function repostStatus(id:String, status:String=null):void
		{
			addProcessor(REPOST_STATUS_REQUEST_URL, processStatus, MicroBlogEvent.REPOST_STATUS_RESULT, MicroBlogErrorEvent.REPOST_STATUS_ERROR);

			var variable:URLVariables=new URLVariables();
			variable.id=id;
			if (status && status.length > 0)
			{
				variable.status=encodeMsg(status);
			}
			var req:URLRequest=getMicroBlogRequest(REPOST_STATUS_REQUEST_URL, variable, URLRequestMethod.POST);
			req.data=variable;
			executeRequest(REPOST_STATUS_REQUEST_URL, req);
		}

		/**
		 * 对一条微博信息进行评论.为防止重复，发布的信息与当前最新信息一样话，将会被忽略.
		 *
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件
		 * type为<b>MicroBlogEvent.COMMENT_STATUS_RESULT</b><br/>
		 * result为一个MicroBlogComment实例.</p>
		 *
		 * <p>如果没有登录或超过发布上限，将返回错误<br/>
		 * 系统将忽略重复发布的信息.每次发布将比较最后一条发布消息，如果一样将被忽略.因此用户不能连续提交相同信息.</p>
		 *
		 * @param id 必填参数， 要评论的微博ID.
		 * @param comment 必选参数，要更新的微博信息,信息内容部超过140个汉字.
		 * @param cid 选填参数，要评论的评论ID.
		 *
		 */
		public function commentStatus(id:String, comment:String, cid:String=null):void
		{
			addProcessor(COMMENT_STATUS_REQUEST_URL, processComment, MicroBlogEvent.COMMENT_STATUS_RESULT, MicroBlogErrorEvent.COMMENT_STATUS_ERROR);

			var variable:URLVariables=new URLVariables();
			variable.id=id;
			if (comment)
			{
				variable.comment=encodeMsg(comment);
			}
			if (cid && cid.length > 0)
			{
				variable.cid=cid;
			}
			var req:URLRequest=getMicroBlogRequest(COMMENT_STATUS_REQUEST_URL, variable, URLRequestMethod.POST);
			req.data=variable;
			executeRequest(COMMENT_STATUS_REQUEST_URL, req);
		}

		/**
		 * 删除评论.注意：只能删除自己发布的信息.
		 *
		 * <p> 如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.DELETE_STATUS_COMMENT_RESULT</b><br/>
		 * result为一个MicroBlogComment实例.</p>
		 *
		 * @param id 必填参数，要删除的微博评论信息ID.
		 *
		 */
		public function deleteComment(id:String):void
		{
			addProcessor(DELETE_COMMENT_REQUEST_URL, processComment, MicroBlogEvent.DELETE_COMMENT_RESULT, MicroBlogErrorEvent.DELETE_COMMENT_ERROR);
			var url:String=DELETE_COMMENT_REQUEST_URL.replace("$id", id);
			var postData:URLVariables = new URLVariables();
			var req:URLRequest = getMicroBlogRequest(url, postData, URLRequestMethod.POST);
			req.data = postData;
			executeRequest(DELETE_COMMENT_REQUEST_URL, req);
		}

		/**
		 * 对一条微博评论信息进行回复.为防止重复，发布的信息与当前最新信息一样话，将会被忽略.
		 *
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.REPLY_STATUS_RESULT</b><br/>
		 * result为一个MicroBlogStatus实例.</p>
		 *
		 * @param id 必填参数， 要评论的微博消息ID.
		 * @param comment 必选参数，要更新的微博信息,信息内容部超过140个汉字.
		 * @param cid 必选参数，要评论的评论ID.
		 * 
		 * <p>如果没有登录或超过发布上限，将返回错误
		 * 系统将忽略重复发布的信息.每次发布将比较最后一条发布消息，如果一样将被忽略.因此用户不能连续提交相同信息.
		 * </p>
		 */
		public function replyStatus(id:String, comment:String, cid:String):void
		{
			addProcessor(REPLY_STATUS_REQUEST_URL, processComment, MicroBlogEvent.REPLY_STATUS_RESULT, MicroBlogErrorEvent.REPLY_STATUS_ERROR);
			var variable:URLVariables=new URLVariables();
			variable.id=id;
			if ( comment )
			{
				variable.comment=encodeMsg(comment);
			}
			variable.cid=cid;
			var req:URLRequest=getMicroBlogRequest(REPLY_STATUS_REQUEST_URL, variable, URLRequestMethod.POST);
			req.data=variable;
			executeRequest(REPLY_STATUS_REQUEST_URL, req);
		}

		/**
		 * 按用户UID或昵称返回用户资料，同时也将返回用户的最新发布的微博.
		 *
		 * <b>有请求数限制</b>
		 * 
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.SHOW_USERS_RESULT</b><br/>
		 * result为一个MicroBlogUser实例.</p>
		 *
		 * @param user 用户UID或用户帐号.
		 * @param userID 指定用户UID,主要是用来区分用户UID跟用户账号一样，产生歧义的时候，特别是在用户账号为数字导致和用户Uid发生歧义.
		 * @param screenName 指定微博昵称，主要是用来区分用户UID跟用户账号一样，产生歧义的时候.
		 *
		 * <br/>
		 * <b>以上三个参数必须至少给一个</b>
		 * 为了保护用户隐私，只有用户设置了公开或对粉丝设置了公开的数据才会返回.
		 */
		public function loadUserInfo(user:String=null, userID:String=null, screenName:String=null):void
		{
			addProcessor(LOAD_USER_INFO_REQUEST_URL, processUser, MicroBlogEvent.LOAD_USER_INFO_RESULT, MicroBlogErrorEvent.LOAD_USER_INFO_ERROR);
			if (user && user.length > 0)
			{
				user="/" + user;
			}
			else
			{
				user="";
			}
			var url:String=LOAD_USER_INFO_REQUEST_URL.replace("$user", user);
			var params:Object=new Object();
			makeUserParams(params, userID, screenName, -1);
			executeRequest(LOAD_USER_INFO_REQUEST_URL, getMicroBlogRequest(url, params, URLRequestMethod.GET));

		}

		/**
		 * 返回用户关注实例列表，并返回最新微博文章.按关注人的关注时间倒序返回，
		 * 每次返回100个,通过cursor参数来取得多于100的关注人.
		 * 也可以通过ID,nickname,user_id参数来获取其他人的关注人列表.
		 *
		 * <b>有请求数限制</b>
		 * 
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.FRIENDS_RESULT</b><br/>
		 * result为一个MicroBlogUser数组.</p>
		 *
		 * @param user 用户UID或用户帐号.
		 * @param userID 指定用户UID,主要是用来区分用户UID跟用户账号一样，产生歧义的时候，特别是在用户账号为数字导致和用户Uid发生歧义.
		 * @param screenName 指定微博昵称，主要是用来区分用户UID跟用户账号一样，产生歧义的时候.
		 * @param cursor 选填参数. 单页只能包含100个关注列表，为了获取更多则cursor默认从-1开始，通过增加或减少cursor来获取更多的关注列表.
		 *
		 * <p>为了保护用户隐私，只有用户设置了公开或对粉丝设置了公开的数据才会返回.</p>
		 */
		public function loadFriendsInfo(user:String=null, userID:String=null, screenName:String=null, cursor:Number=-1):void
		{
			addProcessor(LOAD_FRIENDS_INFO_REQUEST_URL, processUserArray, MicroBlogEvent.LOAD_FRIENDS_INFO_RESULT, MicroBlogErrorEvent.LOAD_FRIENDS_INFO_ERROR);
			if (user && user.length > 0)
			{
				user="/" + user;
			}
			else
			{
				user="";
			}
			var url:String=LOAD_FRIENDS_INFO_REQUEST_URL.replace("$user", user);
			var params:Object=new Object();
			makeUserParams(params, userID, screenName, cursor);
			executeRequest(LOAD_FRIENDS_INFO_REQUEST_URL, getMicroBlogRequest(url, params, URLRequestMethod.GET));
		}

		/**
		 * 返回用户的粉丝列表，并返回粉丝的最新微博.按粉丝的关注时间倒序返回，
		 * 每次返回100个,通过cursor参数来取得多于100的粉丝.
		 *
		 * <b>有请求数限制</b>
		 * 
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.FOLLOWERS_RESULT</b><br/>
		 * result为一个MicroBlogUser数组.</p>
		 *
		 * @param user 用户UID或用户帐号.
		 * @param userID 指定用户UID,主要是用来区分用户UID跟用户账号一样，产生歧义的时候，特别是在用户账号为数字导致和用户Uid发生歧义.
		 * @param screenName 指定微博昵称，主要是用来区分用户UID跟用户账号一样，产生歧义的时候.
		 * @param cursor 选填参数. 单页只能包含100个关注列表，为了获取更多则cursor默认从-1开始，通过增加或减少cursor来获取更多的关注列表.
		 *
		 * <p>为了保护用户隐私，只有用户设置了公开或对粉丝设置了公开的数据才会返回.</p>
		 */
		public function loadFollowersInfo(user:String=null, userID:String=null, screenName:String=null, cursor:int=-1):void
		{
			addProcessor(LOAD_FOLLOWERS_INFO_REQUEST_URL, processUserArray, MicroBlogEvent.LOAD_FOLLOWERS_INFO_RESULT, MicroBlogErrorEvent.LOAD_FOLLOWERS_INFO_ERROR);
			if (user && user.length > 0)
			{
				user="/" + user;
			}
			else
			{
				user="";
			}
			var url:String=LOAD_FOLLOWERS_INFO_REQUEST_URL.replace("$user", user);
			var params:Object=new Object();
			makeUserParams(params, userID, screenName, cursor);
			executeRequest(LOAD_FOLLOWERS_INFO_REQUEST_URL, getMicroBlogRequest(url, params, URLRequestMethod.GET));
		}

		/**
		 * 返回用户的最新n条私信.
		 *
		 * <b>有请求数限制</b>
		 * 
		 * <p> 如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.DIRECT_MESSAGES_RESULT</b><br/>
		 * result为一个MicroBlogDirectMessage数组.</p>
		 *
		 * @param sinceID 请求大于该id的所有消息更新，默认值为0，表示不限制.
		 * @param maxID 请求小于该id的所有消息更新，默认为0，表示不限制.
		 * @param count 请求的页大小，即一页包含多少条记录；默认值0，表示使用服务器默认分页大小.
		 * @param page 请求的页序号，默认值0，返回第一页.
		 *
		 * <p>为了保护用户隐私，只有用户设置了公开或对粉丝设置了公开的数据才会返回.</p>
		 */
		public function loadDirectMessagesReceived(sinceID:String=null, maxID:String=null, count:uint=0, page:uint=0):void
		{
			addProcessor(LOAD_DIRECT_MESSAGES_RECEIVED_REQUEST_URL, processDirectMessageArray, MicroBlogEvent.LOAD_DIRECT_MESSAGES_RECEIVED_RESULT, MicroBlogErrorEvent.LOAD_DIRECT_MESSAGES_RECEIVED_ERROR);
			var url:String=LOAD_DIRECT_MESSAGES_RECEIVED_REQUEST_URL;
			var params:Object=new Object();
			makeQueryCombinatory(params, sinceID, maxID, count, page);
			executeRequest(LOAD_DIRECT_MESSAGES_RECEIVED_REQUEST_URL, getMicroBlogRequest(url, params, URLRequestMethod.GET));
		}

		/**
		 * 返回登录用户已发送最新n条私信.
		 *
		 * <b>有请求数限制</b>
		 * 
		 * <p> 如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.SENT_DIRECT_MESSAGES_RESULT</b><br/>
		 * result为一个MicroBlogDirectMessage数组.</p>
		 *
		 * @param sinceID 请求大于该id的所有消息更新，默认值为0，表示不限制.
		 * @param maxID 请求小于该id的所有消息更新，默认为0，表示不限制.
		 * @param count 请求的页大小，即一页包含多少条记录；默认值0，表示使用服务器默认分页大小.
		 * @param page 请求的页序号，默认值0，返回第一页.
		 *
		 * <p>为了保护用户隐私，只有用户设置了公开或对粉丝设置了公开的数据才会返回.</p>
		 */
		public function loadDirectMessagesSent(sinceID:String=null, maxID:String=null, count:uint=0, page:uint=0):void
		{
			addProcessor(LOAD_DIRECT_MESSAGES_SENT_REQUEST_URL, processDirectMessageArray, MicroBlogEvent.LOAD_DIRECT_MESSAGES_SENT_RESULT, MicroBlogErrorEvent.LOAD_DIRECT_MESSAGES_SENT_ERROR);
			var url:String=LOAD_DIRECT_MESSAGES_SENT_REQUEST_URL;
			var params:Object=new Object();
			makeQueryCombinatory(params, sinceID, maxID, count, page);
			
			executeRequest(LOAD_DIRECT_MESSAGES_SENT_REQUEST_URL, getMicroBlogRequest(url, params, URLRequestMethod.GET));
		}

		/**
		 * 返发送一条私信.必须包含参数user和message,
		 * userID和screenName必须选一个.
		 *
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.NEW_DIRECT_MESSAGES_RESULT</b><br/>
		 * result为一个MicroBlogDirectMessage实例.</p>
		 *
		 * @param user 用户UID或用户帐号.
		 * @param message 必须参数. 要发生的消息内容，文本大小必须小于140个汉字.
		 * @param userID 指定用户UID,主要是用来区分用户UID跟用户账号一样，产生歧义的时候，特别是在用户账号为数字导致和用户Uid发生歧义.
		 * @param screenName 指定微博昵称，主要是用来区分用户UID跟用户账号一样，产生歧义的时候.
		 *
		 */
		public function sendDirectMessage(user:String, message:String, userID:String=null, screenName:String=null):void
		{
			//curl -u user:password -d "text=all your bases are belong to us&user=user_2" http://api.t.sina.com.cn/direct_messages/new.xml
			addProcessor(SEND_DIRECT_MESSAGE_REQUEST_URL, processDirectMessage, MicroBlogEvent.SEND_DIRECT_MESSAGE_RESULT, MicroBlogErrorEvent.SEND_DIRECT_MESSAGE_ERROR);
			if ((!userID || userID.length <= 0) && screenName == null)
			{
				var e:MicroBlogErrorEvent=new MicroBlogErrorEvent(MicroBlogErrorEvent.SEND_DIRECT_MESSAGE_ERROR);
				e.message="参数错误";
				dispatchEvent(e);
			}

			var data:URLVariables=new URLVariables();
			if (userID && userID.length > 0)
			{
				data.user_id=userID;
			}
			if (screenName)
			{
				data.screen_name=screenName;
			}
			data.id = user;
			data.text = encodeMsg(message);
			var req:URLRequest=getMicroBlogRequest(SEND_DIRECT_MESSAGE_REQUEST_URL, data, URLRequestMethod.POST);
			req.data=data;
			executeRequest(SEND_DIRECT_MESSAGE_REQUEST_URL, req);
		}

		/**
		 * 按ID删除私信.操作用户必须为私信的接收人.
		 *
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.DELETE_DIRECT_MESSAGES_RESULT</b><br/>
		 * result为一个MicroBlogDirectMessage实例.</p>
		 *
		 * @param id 必填参数，要删除的私信主键ID.
		 *
		 */
		public function deleteDirectMessage(id:String):void
		{
			//curl -u user:password --http-request DELETE http://api.t.sina.com.cn/direct_messages/destroy/88619848.xml
			addProcessor(DELETE_DIRECT_MESSAGE_REQUEST_URL, processDirectMessage, MicroBlogEvent.DELETE_DIRECT_MESSAGE_RESULT, MicroBlogErrorEvent.DELETE_DIRECT_MESSAGE_ERROR);
			var url:String=DELETE_DIRECT_MESSAGE_REQUEST_URL.replace("$id", id);
			var postData:URLVariables = new URLVariables();
			var req:URLRequest = getMicroBlogRequest(url, postData, URLRequestMethod.POST);
			req.data = postData;
			executeRequest(DELETE_DIRECT_MESSAGE_REQUEST_URL, req);
		}

		/**
		 * 关注一个用户.成功则返回关注人的资料，
		 * 失败则返回一条字符串的说明.
		 *
		 * <p> 如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.CREATE_FRIENDSHIPS_RESULT</b><br/>
		 * result为一个MicroBlogUser实例.</p>
		 *
		 * @param user 用户UID或用户帐号.
		 * @param userID 主要是用来区分用户UID跟用户账号一样，产生歧义的时候，特别是在用户账号为数字导致和用户Uid发生歧义.
		 * @param screenName 指定微博昵称，主要是用来区分用户UID跟用户账号一样，产生歧义的时候.
		 * @param isFollow 可选参数.将是自己粉丝的用户加为关注.
		 *
		 */
		public function follow(user:String, userID:String, screenName:String=null, isFollow:Boolean=true):void
		{
			//TO-DO: if the parameter equals to zero, don't include this parameter when build request url.
			addProcessor(FOLLOW_REQUEST_URL, processUser, MicroBlogEvent.FOLLOW_RESULT, MicroBlogErrorEvent.FOLLOW_ERROR);
			if (user && user.length > 0)
			{
				user="/" + user;
			} else
			{
				user="";
			}
			var url:String=FOLLOW_REQUEST_URL.replace("$user", user);
			var params:URLVariables=new URLVariables();
			if ( userID && userID.length > 0 )
			{
				params.user_id = userID;
			}
			if ( screenName && screenName.length > 0 )
			{
				params.screen_name = screenName;
			}
			params.follow = isFollow;
			
			var req:URLRequest=getMicroBlogRequest(url, params, URLRequestMethod.POST);
			req.data = params;
			executeRequest(FOLLOW_REQUEST_URL, req);
		}

		/**
		 * 取消关注某用户.成功则返回被取消关注人的资料，
		 * 失败则返回一条字符串的说明.
		 *
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.DESTROY_FRIENDSHIPS_RESULT</b><br/>
		 * result为一个MicroBlogUser实例.</p>
		 *
		 * @param user 用户UID或用户帐号.
		 * @param userID 主要是用来区分用户UID跟用户账号一样，产生歧义的时候，特别是在用户账号为数字导致和用户Uid发生歧义.
		 * @param screenName 指定微博昵称，主要是用来区分用户UID跟用户账号一样，产生歧义的时候.
		 *
		 */
		public function cancelFollowing(user:String, userID:String, screenName:String=null):void
		{
			//TO-DO: if the parameter equals to zero, don't include this parameter when build request url.
			addProcessor(CANCEL_FOLLOWING_REQUEST_URL, processUser, MicroBlogEvent.CANCEL_FOLLOWING_RESULT, MicroBlogErrorEvent.CANCEL_FOLLOWING_ERROR);
			if (user && user.length > 0)
			{
				user="/" + user;
			} else
			{
				user="";
			}
			var url:String=CANCEL_FOLLOWING_REQUEST_URL.replace("$user", user);
			var params:URLVariables=new URLVariables();
			if ( userID && userID.length > 0 )
			{
				params.user_id = userID;
			}
			if ( screenName && screenName.length > 0 )
			{
				params.screen_name = screenName;
			}
			
			var req:URLRequest=getMicroBlogRequest(url, params, URLRequestMethod.POST);
			req.data = params;
			executeRequest(CANCEL_FOLLOWING_REQUEST_URL, req);
		}

		/**
		 * 返回两个用户关系的详细情况.
		 *
		 * <b>有请求数限制</b>
		 * 
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.CHECK_FRIENDSHIPS_RESULT</b><br/>
		 * result为<code>MicroBlogUsersRelationship</code>值.</p>
		 *
		 * @param targetID 选填参数，要判断的目标用户的uid.
		 * @param targetScreenName  选填参数，要判断的目标用户的昵称.targetID和targetScreenName两个参数必须填一个.
		 * @param sourceID 选填参数，要判断的源用户的uid
		 * @param sourceScreenName 选填参数，要判断的源用户的昵称.如果sourceID和sourceScreenName均未填，则以当前用户为源用户
		 *
		 */
		public function checkIsFollowing(targetID:String=null, targetScreenName:String=null, sourceID:String=null, sourceScreenName:String=null):void
		{
			addProcessor(CHECK_IS_FOLLOWING_REQUEST_URL, processRelationship, MicroBlogEvent.CHECK_IS_FOLLOWING_RESULT, MicroBlogErrorEvent.CHECK_IS_FOLLOWING_ERROR);
			var params:Object=new Object();
			var needExecute:Boolean=false;
			if (targetID && targetID.length > 0)
			{
				params[TARGET_ID]=targetID;
				needExecute=true;
			}
			if (targetScreenName && targetScreenName.length > 0)
			{
				params[TARGET_SCREEN_NAME]=StringEncoders.urlEncodeUtf8String(targetScreenName);
				needExecute=true;
			}
			if (!needExecute)
			{
				return;
			}
			if (sourceID && sourceID.length > 0)
			{
				params[SOURCE_ID]=sourceID;
			}
			if (sourceScreenName && sourceScreenName.length > 0)
			{
				params[SOURCE_SCREEN_NAME]=StringEncoders.urlEncodeUtf8String(sourceScreenName);
			}
			var url:String=CHECK_IS_FOLLOWING_REQUEST_URL;
			executeRequest(CHECK_IS_FOLLOWING_REQUEST_URL,getMicroBlogRequest(url, params, URLRequestMethod.GET));
		}

		/**
		 * 返回用户关注对象的user_id列表.
		 *
		 * <b>有请求数限制</b>
		 * 
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.LOAD_FRIENDS_ID_LIST_RESULT</b><br/>
		 * result为<code>uint数组</code>实例.</p>
		 *
		 * <p>如果该函数调用失败，将会抛出MicroBlogErrorEvent事件，该事件<br/>
		 * type为<b>MicroErrorEvent.LOAD_FRIENDS_ID_LIST_ERROR</b><br/>
		 * message为错误描述.</p>
		 *
		 * @param user 用户UID或用户帐号.
		 * @param userID 主要是用来区分用户UID跟用户账号一样，产生歧义的时候，特别是在用户账号为数字导致和用户Uid发生歧义.
		 * @param screenName 指定微博昵称，主要是用来区分用户UID跟用户账号一样，产生歧义的时候.
		 * @param cursor 选填参数. 单页只能包含5000个id，为了获取更多则cursor默认从-1开始，通过增加或减少cursor来获取更多的关注列表.
		 * @param count 可选参数. 每次返回的最大记录数（即页面大小），不大于5000。
		 */
		public function loadFriendsIDList(user:String, userID:String=null, screenName:String=null, cursor:Number=-1, count:uint=5000):void
		{
			addProcessor(LOAD_FRIENDS_ID_LIST_REQUEST_URL, processIDSArray, MicroBlogEvent.LOAD_FRIENDS_ID_LIST_RESULT, MicroBlogErrorEvent.LOAD_FRIENDS_ID_LIST_ERROR);
			if (user && user.length > 0)
			{
				user="/" + user;
			}
			else
			{
				user="";
			}
			var url:String=LOAD_FRIENDS_ID_LIST_REQUEST_URL.replace("$user", user);
			var params:Object=new Object();
			makeUserParams(params, userID, screenName, cursor);
			params["count"] = count;
			executeRequest(LOAD_FRIENDS_ID_LIST_REQUEST_URL, getMicroBlogRequest(url, params, URLRequestMethod.GET));
		}

		/**
		 * 返回用户粉丝的user_id列表.
		 *
		 * <b>有请求数限制</b>
		 * 
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.LOAD_FOLLOWERS_ID_LIST_RESULT</b><br/>
		 * result为<code>uint数组</code>实例.</p>
		 *
		 * <p>如果该函数调用失败，将会抛出MicroBlogErrorEvent事件，该事件<br/>
		 * type为<b>MicroErrorEvent.LOAD_FOLLOWERS_ID_LIST_ERROR</b><br/>
		 * message为错误描述.</p>
		 *
		 * @param user 用户UID或用户帐号.
		 * @param userID 主要是用来区分用户UID跟用户账号一样，产生歧义的时候，特别是在用户账号为数字导致和用户Uid发生歧义.
		 * @param screenName 指定微博昵称，主要是用来区分用户UID跟用户账号一样，产生歧义的时候.
		 * @param cursor 选填参数. 单页只能包含5000个id，为了获取更多则cursor默认从-1开始，通过增加或减少cursor来获取更多的关注列表.
		 * @param count 可选参数. 每次返回的最大记录数（即页面大小），不大于5000。
		 */
		public function loadFollowersIDList(user:String, userID:String=null, screenName:String=null, cursor:Number=-1, count:uint=5000):void
		{
			addProcessor(LOAD_FOLLOWERS_ID_LIST_REQUEST_URL, processIDSArray, MicroBlogEvent.LOAD_FOLLOWERS_ID_LIST_RESULT, MicroBlogErrorEvent.LOAD_FOLLOWERS_ID_LIST_ERROR);
			if (user && user.length>0)
			{
				user="/" + user;
			}
			else
			{
				user="";
			}
			var url:String=LOAD_FOLLOWERS_ID_LIST_REQUEST_URL.replace("$user", user);
			var params:Object=new Object();
			makeUserParams(params, userID, screenName, cursor);
			params["count"]=count;
			executeRequest(LOAD_FOLLOWERS_ID_LIST_REQUEST_URL, getMicroBlogRequest(url, params, URLRequestMethod.GET));
		}

		/**
		 * 判断用户身份是否合法.
		 *
		 * <b>有请求数限制</b>
		 * 
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.VERIFY_CREDENTIALS_RESULT</b><br/>
		 * result为<code>MicroBlogUser</code>实例.</p>
		 *
		 * <p>如果该函数调用失败，将会抛出MicroBlogErrorEvent事件，该事件<br/>
		 * type为<b>MicroErrorEvent.VERIFY_CREDENTIALS_ERROR</b><br/>
		 * message为错误描述.</p>
		 *
		 */
		public function verifyCredentials():void
		{
			//TO-DO: if the parameter equals to zero, don't include this parameter when build request url.
			//curl -u user:password http://api.t.sina.com.cn/account/verify_credentials.xml
			addProcessor(VERIFY_CREDENTIALS_REQUEST_URL, processUser, MicroBlogEvent.VERIFY_CREDENTIALS_RESULT, MicroBlogErrorEvent.VERIFY_CREDENTIALS_ERROR);
			executeRequest(VERIFY_CREDENTIALS_REQUEST_URL, getMicroBlogRequest(VERIFY_CREDENTIALS_REQUEST_URL, null));
		}

		/**
		 * 获取当前的API调用次数限制.
		 *
		 * <b>有请求数限制</b>
		 * 
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.RATE_LIMIT_INFO_RESULT</b><br/>
		 * result为<code>MicroBlogRateInfo</code>实例.</p>
		 *
		 * <p>如果该函数调用失败，将会抛出MicroBlogErrorEvent事件，该事件<br/>
		 * type为<b>MicroErrorEvent.RATE_LIMIT_INFO_ERROR</b><br/>
		 * message为错误描述.</p>
		 *
		 */
		public function getRateLimitInfo():void
		{
			//curl -u user:password http://api.t.sina.com.cn/account/rate_limit_status.xml
			addProcessor(GET_RATE_LIMIT_STATUS_REQUEST_URL, processRateLimit, MicroBlogEvent.GET_RATE_LIMIT_STATUS_RESULT, MicroBlogErrorEvent.GET_RATE_LIMIT_STATUS_ERROR);
			executeRequest(GET_RATE_LIMIT_STATUS_REQUEST_URL, getMicroBlogRequest(GET_RATE_LIMIT_STATUS_REQUEST_URL, null) );
		}

		/**
		 * 登陆用户退出.
		 *
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.LOGOUT_RESULT</b><br/></p>
		 *
		 * <p>如果该函数调用失败，将会抛出MicroBlogErrorEvent事件，该事件<br/>
		 * type为<b>MicroErrorEvent.LOGOUT_ERROR</b><br/>
		 * message为错误描述.</p>
		 *
		 */
		public function logout():void
		{
			//curl -u user:password -d "" http://api.t.sina.com.cn/account/end_session.xml
			addProcessor(LOGOUT_REQUEST_URL, processLogout, MicroBlogEvent.LOGOUT_RESULT, MicroBlogErrorEvent.LOGOUT_ERROR);
			var postData:URLVariables = new URLVariables();
			postData.source = "air client";
			var req:URLRequest = getMicroBlogRequest(LOGOUT_REQUEST_URL, postData, URLRequestMethod.POST);
			req.data = postData;
			executeRequest(LOGOUT_REQUEST_URL, req );
		}


		/**
		 * 用户可以通过此接口来更新头像.
		 *
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.UPDATE_PROFILE_IMAGE_RESULT</b><br/>
		 * result为一个MicroBlogUser实例.</p>
		 *
		 * <p>如果该函数调用失败，将会抛出MicroBlogErrorEvent事件，该事件<br/>
		 * type为<b>MicroErrorEvent.UPDATE_PROFILE_IMAGE_ERROR</b><br/>
		 * message为错误描述.</p>
		 *
		 * @param imgData  必须为小于700K的有效的GIF, JPG, 或 PNG 图片. 如果图片大于500像素将按比例缩放
		 *
		 */
		public function updateProfileImage(imgData:ByteArray, filename:String):void
		{
			//TO-DO: Need to be verified.
			addProcessor(UPDATE_PROFILE_IMAGE_REQUEST_URL, processUser, MicroBlogEvent.UPDATE_PROFILE_IMAGE_RESULT, MicroBlogErrorEvent.UPDATE_PROFILE_IMAGE_ERROR);
			var boundary:String=makeBoundary();
			var postData:Object = {image:imgData};
			var req:URLRequest=getMicroBlogRequest(UPDATE_PROFILE_IMAGE_REQUEST_URL, postData, URLRequestMethod.POST);
			delete postData["image"];
			req.contentType=MULTIPART_FORMDATA + boundary;
			req.data=makeMultipartPostData(boundary, "image", filename, imgData, postData);
			executeRequest(UPDATE_PROFILE_IMAGE_REQUEST_URL, req);
		}

		/**
		 * 用户可以通过此接口来更改微博信息的来源.用于无法传递ByteArray为参数的情况.
		 *
		 * <p>如果图片上传成功，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.UPDATE_DELIVERY_DEVICE_RESULT</b><br/>
		 * result为一个MicroBlogUser实例.</p>
		 *
		 * <p>如果图片上传失败，将会抛出MicroBlogErrorEvent事件，该事件<br/>
		 * type为<b>MicroErrorEvent.UPDATE_DELIVERY_DEVICE_ERROR</b><br/>
		 * message为错误描述.</p>
		 *
		 * @return 返回用于上传图片的URLRequest.用于在flash中用File对象上传图片，在调用File对象的upload时uploadDataFieldName必须为image
		 *
		 */
		public function getUpdateProfileImageRequest():URLRequest
		{
			addProcessor(UPDATE_PROFILE_IMAGE_REQUEST_URL, processUser, MicroBlogEvent.UPDATE_PROFILE_IMAGE_RESULT, MicroBlogErrorEvent.UPDATE_PROFILE_IMAGE_ERROR);
			var postData:URLVariables = new URLVariables();
			var req:URLRequest=getMicroBlogRequest(UPDATE_PROFILE_IMAGE_REQUEST_URL, postData, URLRequestMethod.POST);
			req.data=postData;
			return req;
		}

		/**
		 * 用户可以通过此接口来更新微博页面参数.
		 *
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.UPDATE_PROFILE_RESULT</b><br/>
		 * result为一个MicroBlogUser实例.</p>
		 *
		 * <p>如果该函数调用失败，将会抛出MicroBlogErrorEvent事件，该事件<br/>
		 * type为<b>MicroErrorEvent.UPDATE_PROFILE_ERROR</b><br/>
		 * message为错误描述.</p>
		 *
		 * @param params MicroBlogProfileUpdateParams对象，用于更新个人设置@see com.sina.microblog.data.MicroBlogProfileUpdateParams.
		 *
		 *
		 */
		public function updateProfile(params:MicroBlogProfileUpdateParams):void
		{
			//curl -u user:password -d "update_delivery_device=none" http://api.t.sina.com.cn/account/update_profile_colors.xml
			addProcessor(UPDATE_PROFILE_REQUEST_URL, processUser, MicroBlogEvent.UPDATE_PROFILE_RESULT, MicroBlogErrorEvent.UPDATE_PROFILE_ERROR);
			if (null==params || params.isEmpty)
			{
				return;
			}
			var postData:URLVariables = params.postData;
			var req:URLRequest=getMicroBlogRequest(UPDATE_PROFILE_REQUEST_URL, postData, URLRequestMethod.POST);
			req.data=postData;
			executeRequest(UPDATE_PROFILE_REQUEST_URL, req);
		}

		/**
		 * 返回用户的最近20条收藏信息，和用户收藏页面返回内容是一致的.
		 *
		 * <b>有请求数限制</b>
		 * 
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.LOAD_FAVORIT_LIST_RESULT</b><br/>
		 * result为一个MicroBlogStatus对象数组.</p>
		 *
		 * <p>如果该函数调用失败，将会抛出MicroBlogErrorEvent事件，该事件<br/>
		 * type为<b>MicroErrorEvent.LOAD_FAVORIT_LIST_ERROR</b><br/>
		 * message为错误描述.</p>
		 *
		 * @param page  可选参数. 返回结果的页序号。注意：有分页限制.
		 *
		 *
		 */
		public function loadFavoriteList(page:uint=0):void
		{
			addProcessor(LOAD_FAVORITE_LIST_REQUEST_URL, processStatusArray, MicroBlogEvent.LOAD_FAVORITE_LIST_RESULT, MicroBlogErrorEvent.LOAD_FAVORITE_LIST_ERROR);
	
			var url:String=LOAD_FAVORITE_LIST_REQUEST_URL;
			var params:Object=new Object();
			if ( page > 0 )
			{
				params["page"]=page.toString();
			}
			executeRequest(LOAD_FAVORITE_LIST_REQUEST_URL, getMicroBlogRequest(url, params, URLRequestMethod.GET));
		}

		/**
		 * 收藏一条微博信息.
		 *
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.ADD_TO_FAVORITES_RESULT</b><br/>
		 * result为一个MicroBlogStatus对象.</p>
		 *
		 * <p>如果该函数调用失败，将会抛出MicroBlogErrorEvent事件，该事件<br/>
		 * type为<b>MicroErrorEvent.ADD_TO_FAVORITES_ERROR</b><br/>
		 * message为错误描述.</p>
		 *
		 * @param statusID 必填参数， 要收藏的微博id.
		 *
		 */
		public function addToFavorites(statusID:String):void
		{
			if ( statusID.length <= 0 )
			{
				return;
			}
			addProcessor(ADD_TO_FAVORITES_REQUEST_URL, processStatus, MicroBlogEvent.ADD_TO_FAVORITES_RESULT, MicroBlogErrorEvent.ADD_TO_FAVORITES_ERROR);

			var postData:URLVariables=new URLVariables();
			postData.id=statusID.toString();
			var req:URLRequest=getMicroBlogRequest(ADD_TO_FAVORITES_REQUEST_URL, postData, URLRequestMethod.POST);
			req.data=postData;
			executeRequest(ADD_TO_FAVORITES_REQUEST_URL, req);
		}

		/**
		 * 从收藏列表里删除一条微博信息.
		 *
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.ADD_TO_FAVORITES_RESULT</b><br/>
		 * result为一个MicroBlogStatus对象.</p>
		 *
		 * <p>如果该函数调用失败，将会抛出MicroBlogErrorEvent事件，该事件<br/>
		 * type为<b>MicroErrorEvent.ADD_TO_FAVORITES_ERROR</b><br/>
		 * message为错误描述.</p>
		 *
		 * @param statusID 必填参数， 要收藏的微博id.
		 *
		 */
		public function removeFromFavorites(statusID:String):void
		{
			if ( !statusID || statusID.length <= 0)
			{
				return;
			}
			addProcessor(REMOVE_FROM_FAVORITES_REQUEST_URL, processStatus, MicroBlogEvent.REMOVE_FROM_FAVORITES_RESULT, MicroBlogErrorEvent.REMOVE_FROM_FAVORITES_ERROR);
			var postData:URLVariables = new URLVariables();
			var req:URLRequest=getMicroBlogRequest(REMOVE_FROM_FAVORITES_REQUEST_URL.replace("$id", statusID), postData, URLRequestMethod.POST);
			req.data = postData;
			executeRequest(REMOVE_FROM_FAVORITES_REQUEST_URL, req);
		}

//		/**
//		 * 允许/禁止通知更新给指定用户.
//		 *
//		 * <b>有请求数限制</b>
//		 * 
//		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
//		 * type为<b>MicroBlogEvent.FOLLOW_NOTIFICATION_RESULT</b><br/>
//		 * result为一个MicroBlogUser对象.</p>
//		 *
//		 * <p>如果该函数调用失败，将会抛出MicroBlogErrorEvent事件，该事件<br/>
//		 * type为<b>MicroErrorEvent.FOLLOW_NOTIFICATION_ERROR</b><br/>
//		 * message为错误描述.</p>
//		 *
//		 * @param isEnable 必选参数
//		 * @param user 指定的用户ID或用户帐号.
//		 * @param page  指定的用户UID.
//		 * @param screenName 指定的用户帐号
//		 *
//		 * 以上三个可选参数必须设置一个
//		 *
//		 */
//		public function enableNotification(isEnable:Boolean, user:String=null, userID:uint=0, screenName:String=null):void
//		{
//			addProcessor(ENABLE_NOTIFICATION_REQUEST_URL, processUser, MicroBlogEvent.ENABLE_NOTIFICATION_RESULT, MicroBlogErrorEvent.ENABLE_NOTIFICATION_ERROR);
//			var hasParam:Boolean=false;
//			if (user && user.length > 0)
//			{
//				user="/" + user;
//				hasParam=true;
//			}
//			else
//			{
//				user="";
//			}
//			var url:String;
//			if (isEnable)
//			{
//				url=ENABLE_NOTIFICATION_REQUEST_URL.replace("$enabled", "follow");
//			}
//			else
//			{
//				url=ENABLE_NOTIFICATION_REQUEST_URL.replace("$enabled", "leave");
//			}
//			url=url.replace("$user", user);
//			var postData:URLVariables=new URLVariables();
//			if (userID > 0)
//			{
//				postData.user_id=userID;
//				hasParam=true;
//			}
//			if (screenName && screenName.length > 0)
//			{
//				postData.screen_name=StringEncoders.urlEncodeUtf8String(screenName);
//				hasParam=true;
//			}
//			if (!hasParam)
//			{
//				return;
//			}
//			var req:URLRequest=getMicroBlogRequest(url, postData, URLRequestMethod.POST);
//			req.data=postData;
//			executeRequest(ENABLE_NOTIFICATION_REQUEST_URL, req);
//		}
//		
		/**
		 * 返回省份，城市的名字对应id的列表，为xml格式.
		 *
		 * <b>有请求数限制</b>
		 * 
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.LOAD_PROVINCE_CITY_ID_LIST_RESULT</b><br/>
		 * result为一个XML对象.</p>
		 *
		 * <p>如果该函数调用失败，将会抛出MicroBlogErrorEvent事件，该事件<br/>
		 * type为<b>MicroErrorEvent.LOAD_PROVINCE_CITY_ID_LIST_ERROR</b><br/>
		 * message为错误描述.</p>
		 *
		 * <p>返回的xml数据格式请参看新浪微博开放平台 http://open.t.sina.com.cn
		 * </p>
		 * 
		 * <p>要想获取省份id为11，城市id为1的地址信息可以参考以下方法<br/>
		 * <pre>
		 * var prov:XML = provinces.province.(&#64;id == "11")[0];
		 * province = prov.&#64;name;
		 * city = prov.city.(&#64;id == "1")[0].&#64;name;
		 * </pre>
		 * 通过名字得到id可以参考如下方法<br/>
		 * <pre>
		 * var prov:XML = provinces.province.(&#64;name == "北京")[0];
		 * provinceID = prov.&#64;id;
		 * cityID = prov.city.(&#64;name == "东城区")[0].&#64;id;
		 * </pre>
		 * </p>
		 */
		public function loadProvinceCityIDList():void
		{
			addProcessor(LOAD_PROVINCE_CITY_ID_LIST, processProvincesXML, MicroBlogEvent.LOAD_PROVINCE_CITY_ID_LIST_RESULT, MicroBlogErrorEvent.LOAD_PROVINCE_CITY_ID_LIST_ERROR);
			executeRequest(LOAD_PROVINCE_CITY_ID_LIST, getMicroBlogRequest(LOAD_PROVINCE_CITY_ID_LIST, null) );
		}
		//Event handler

		private function addProcessor(name:String, dataProcess:Function, resultEventType:String, errorEventType:String):void
		{
			if (null == serviceLoader[name])
			{
				var loader:URLLoader=new URLLoader();
				loader.addEventListener(Event.COMPLETE, loader_onComplete);
				loader.addEventListener(IOErrorEvent.IO_ERROR, loader_onError);
				loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_onSecurityError);
				serviceLoader[name]=loader;
				loaderMap[loader]={dataFunc: dataProcess, resultEvent: resultEventType, errorEvent: errorEventType};
			}
		}
		
		private function executeRequest(name:String, req:URLRequest):void
		{
			var urlLoader:URLLoader = serviceLoader[name] as URLLoader;
			lastLoader = urlLoader;
			lastRequest = req;
			urlLoader.load(req);
		}

		private function loader_onComplete(event:Event):void
		{
			var loader:URLLoader=event.target as URLLoader;
			var processor:Object=loaderMap[loader];
			var dataStr:String = loader.data as String;
			if ( dataStr.length  <= 0 )
			{
				var ioError:MicroBlogErrorEvent = new MicroBlogErrorEvent(MicroBlogErrorEvent.NET_WORK_ERROR);
				ioError.message = "The network error";
				dispatchEvent(ioError);
				return;
			}
			var result:XML=new XML(loader.data);
			
			if (result.child("error").length() > 0)
			{
				var error:MicroBlogErrorEvent=new MicroBlogErrorEvent(processor.errorEvent);
				error.message="Error " + result.error_code + " : " + result.error;
				dispatchEvent(error);
			}
			else
			{
				var e:MicroBlogEvent=new MicroBlogEvent(processor.resultEvent);
				e.result=processor.dataFunc(result);
				e.nextCursor=Number(result.next_cursor);
				e.previousCursor=Number(result.previous_cursor);
				dispatchEvent(e);
			}
			//trace(loader.data);
		}

		private function loader_onError(event:IOErrorEvent):void
		{
			var loader:URLLoader=event.target as URLLoader;
			var processor:Object=loaderMap[loader];
			var error:MicroBlogErrorEvent=new MicroBlogErrorEvent(processor.errorEvent);
			error.message=event.text;
			dispatchEvent(error);
		}

		private function loader_onSecurityError(event:SecurityErrorEvent):void
		{
			dispatchEvent(event);
		}

		private function getMicroBlogRequest(url:String, params:Object, requestMethod:String="GET"):URLRequest
		{
			var req:URLRequest;
			
			if ( null == params )
			{
				params = new Object();
			}
			params["source"] = source;
			if ( accessTokenKey.length > 0)
			{
				req=signRequest(requestMethod, url, params, false);
			}
			else
			{
				if (requestMethod == URLRequestMethod.GET)
				{
					url+=makeGETParamString(params);
				}
				req=new URLRequest(url);
				if ( authHeader )
				{
					req.requestHeaders.push(authHeader);
				}
			}
			req.method=requestMethod;
			return req;
		}

		private function processStatusArray(statuses:XML):Array
		{
			var microBlogStatus:MicroBlogStatus;
			var statusArray:Array=[];
			for each (var status:XML in statuses.status)
			{
				microBlogStatus=new MicroBlogStatus();
				microBlogStatus.serialization(status);
				statusArray.push(microBlogStatus);
			}
			return statusArray;
		}

		private function processStatus(status:XML):MicroBlogStatus
		{
			var microBlogStatus:MicroBlogStatus = new MicroBlogStatus();
			microBlogStatus.serialization(status);
			return microBlogStatus;
		}

		private function processCommentArray(comments:XML):Array
		{
			var microBlogComment:MicroBlogComment;
			var commentArray:Array=[];
			for each (var comment:XML in comments.comment)
			{
				microBlogComment=new MicroBlogComment();
				microBlogComment.serialization(comment);
				commentArray.push(microBlogComment);
			}
			return commentArray;
		}

		private function processComment(comment:XML):MicroBlogComment
		{
			var microBlogComment:MicroBlogComment = new MicroBlogComment();
			microBlogComment.serialization(comment);
			return microBlogComment;
		}

		private function processCounts(counts:XML):Array
		{
			var countArray:Array=[];
			var count:MicroBlogCount;
			for each (var countValue:XML in counts.children())
			{
				count=new MicroBlogCount(countValue);
				countArray.push(count);
			}
			return countArray;
		}

		private function processUser(user:XML):MicroBlogUser
		{
			var microBlogUser:MicroBlogUser = new MicroBlogUser();
			microBlogUser.serialization(user);
			return microBlogUser;
		}

		private function processUserArray(users:XML):Array
		{
			var userArray:Array=[];
			var mbUser:MicroBlogUser;
			for each (var userValue:XML in users.user)
			{
				mbUser=new MicroBlogUser();
				mbUser.serialization(userValue);
				userArray.push(mbUser);
			}
			return userArray;
		}

		private function processDirectMessageArray(messages:XML):Array
		{
			var messageArray:Array=[];
			var mbMessage:MicroBlogDirectMessage;
			for each (var messageValue:XML in messages.direct_message)
			{
				mbMessage=new MicroBlogDirectMessage();
				mbMessage.serialization(messageValue);
				messageArray.push(mbMessage);
			}
			return messageArray;
		}

		private function processDirectMessage(message:XML):MicroBlogDirectMessage
		{
			var mbd:MicroBlogDirectMessage = new MicroBlogDirectMessage();
			mbd.serialization(message);
			return mbd;
		}

//		private function processBoolean(message:XML):Boolean
//		{
//			return message.toString() == "true";
//		}

		private function processRelationship(message:XML):MicroBlogUsersRelationship
		{
			return new MicroBlogUsersRelationship(message);
		}

		private function processIDSArray(message:XML):Array
		{
			var ar:Array=[];
			for each (var id:XML in message.ids[0].children())
			{
				ar.push(uint(id.toString()));
			}
			return ar;
		}
		private function processRateLimit(message:XML):MicroBlogRateLimit
		{
			return new MicroBlogRateLimit(message);
		}
		private function processLogout(user:XML):MicroBlogUser
		{
			_accessTokenKey = "";
			_accessTokenSecret = "";
			authHeader = null;
			var microBlogUser:MicroBlogUser = new MicroBlogUser();
			microBlogUser.serialization(user);
			return microBlogUser;
		}
		private function processProvincesXML(result:XML):XML
		{
			return result;
		}
		private function makeGETParamString(parameters:Object):String
		{
			var paramStr:String=makeParamsToUrlString(parameters);
			if (paramStr.length > 0)
			{
				paramStr="?" + paramStr;
			}
			return paramStr;
		}

		private function makeQueryCombinatory(params:Object, sinceID:String, maxID:String, count:uint, page:uint):void
		{

			if (sinceID && sinceID.length > 0)
			{
				params[SINCE_ID]=sinceID;

			}
			if (maxID && maxID.length > 0)
			{
				params[MAX_ID]=maxID;

			}
			if (count > 0)
			{
				params[COUNT]=count;

			}
			if (page > 0)
			{
				params[PAGE]=page;
			}

		}

		private function makeUserParams(params:Object, userID:String, screenName:String, cursor:Number):void
		{

			if (userID && userID.length > 0)
			{
				params[USER_ID]=userID;

			}
			if (screenName)
			{
				params[SCREEN_NAME]=screenName;

			}
			if (cursor >= 0)
			{
				params[CURSOR]=cursor;

			}

		}

		private function makeBoundary():String
		{
			var boundary:String="";

			for (var i:int=0; i < 13; i++)
			{
				boundary+=String.fromCharCode(int(97 + Math.random() * 25));
			}
			boundary="---------------------------" + boundary;

			return boundary;
		}

		private function encodeMsg(status:String):String
		{
			return StringEncoders.urlEncodeSpecial(status);
		}

		private function makeMultipartPostData(boundary:String, imgFieldName:String, filename:String, imgData:ByteArray, params:Object):Object
		{
			var req:URLRequest=new URLRequest();
			var postData:ByteArray=new ByteArray();
			postData.endian=Endian.BIG_ENDIAN;
			var value:String;

			//add params to the post data.
			if (params)
			{
				for (var name:String in params)
				{
					boundaryPostData(postData, boundary);
					addLineBreak(postData);
					//writeStringToByteArray(postData, CONTENT_DISPOSITION_BASIC.replace("$name", name));
					postData.writeUTFBytes(CONTENT_DISPOSITION_BASIC.replace("$name", name));
					addLineBreak(postData);
					addLineBreak(postData);
					postData.writeUTFBytes(params[name]);
					addLineBreak(postData);
				}
			}
			//add image;
//			--BbC04y
//			Content-Disposition: file; filename="file2.jpg"
//			Content-Type: image/jpeg
//			Content-Transfer-Encoding: binary
//			
//			...contents of file2.jpg...
//			--BbC04y--

			boundaryPostData(postData, boundary);
			addLineBreak(postData);
			//writeStringToByteArray(postData, CONTENT_DISPOSITION_BASIC.replace("$name", "files") + '; filename="'+filename + '"');
			postData.writeUTFBytes(CONTENT_DISPOSITION_BASIC.replace("$name", imgFieldName) + '; filename="' + filename + '"');
			addLineBreak(postData);
			//writeStringToByteArray(postData, CONTENT_TYPE_JPEG);
			postData.writeUTFBytes(CONTENT_TYPE_JPEG);
			addLineBreak(postData);
			//writeStringToByteArray(postData,CONTENT_TRANSFER_ENCODING);
			//postData.writeUTFBytes(CONTENT_TRANSFER_ENCODING);
			//addLineBreak(postData);
			addLineBreak(postData);
			postData.writeBytes(imgData, 0, imgData.length);
			addLineBreak(postData);

			boundaryPostData(postData, boundary);
			addDoubleDash(postData);

			trace(postData.toString());
			postData.position=0;
			return postData;
		}

		private function boundaryPostData(data:ByteArray, boundary:String):void
		{
			var len:int=boundary.length;
			addDoubleDash(data);
			for (var i:int=0; i < len; ++i)
			{
				data.writeByte(boundary.charCodeAt(i));
			}
		}

		private function addDoubleDash(data:ByteArray):void
		{
			data.writeShort(0x2d2d);
		}

		private function addLineBreak(data:ByteArray):void
		{
			data.writeShort(0x0d0a);
		}


		private function signRequest(requestMethod:String, url:String, requestParams:Object, useHead:Boolean=false):URLRequest
		{
			var method:String=requestMethod.toUpperCase();
			var oauthParams:Object=getOAuthParams();
			var params:Object=new Object;
			for (var key:String in oauthParams)
			{
				params[key]=oauthParams[key];
			}
			for (var key1:String in requestParams)
			{
				params[key1]=requestParams[key1];
			}

			var req:URLRequest=new URLRequest();
			req.method=method;
			req.url=url;
			var paramsStr:String=makeSignableParamStr(params);
			var msgStr:String=StringEncoders.urlEncodeUtf8String(requestMethod.toUpperCase()) + "&";
			msgStr+=StringEncoders.urlEncodeUtf8String(url);
			msgStr+="&";
			msgStr+=StringEncoders.urlEncodeUtf8String(paramsStr);
			
			var secrectStr:String=_consumerSecret + "&";
			if (_accessTokenSecret.length > 0 && _accessTokenKey.length > 0)
			{
				secrectStr+=_accessTokenSecret;
			}
			var sig:String=Base64.encode(HMAC.hash(secrectStr, msgStr, SHA1));
			// The matchers are specified in OAuth only.
			sig = sig.replace(/\+/g, "%2B");
			
			oauthParams["oauth_signature"]=sig;
			trace("BaseString:::::", msgStr);
			trace("signature::::", sig);
			
			if (method == URLRequestMethod.GET)
			{
				if (useHead)
				{
					req.url+=("?" + makeSignableParamStr(requestParams));
					req.requestHeaders.push(makeOauthHeaderFromArray(oauthParams));
				}
				else
				{
					req.url+=("?" + paramsStr + '&oauth_signature=' + sig);
				}
			}
			else if (requestMethod == URLRequestMethod.POST)
			{
				req.requestHeaders.push(makeOauthHeaderFromArray(oauthParams));
			}
			return req;
		}

		private function makeSignableParamStr(params:Object):String
		{
			var retParams:Array=[];

			for (var param:String in params)
			{
				if (param != "oauth_signature")
				{
					retParams.push(param + "=" + StringEncoders.urlEncodeUtf8String(params[param].toString()));
					//retParams.push(param + "=" +params[param].toString());
				}	
				
			}

			retParams.sort();

			return retParams.join("&");
		}

		private function makeParamsToUrlString(params:Object):String
		{
			var retParams:Array=[];

			for (var param:String in params)
			{
				retParams.push(param + "=" + params[param].toString());
			}

			retParams.sort();

			return retParams.join("&");
		}

		private function makeOauthHeaderFromArray(params:Object):URLRequestHeader
		{
			var oauthHeaderValue:String='OAuth realm="' + API_BASE_URL + '",';
			var parseParams:Array=[];
			for (var key:String in params)
			{
				parseParams.push(key + '="' + params[key] + '"');
			}
			oauthHeaderValue+=parseParams.join(",");

			var reqHeader:URLRequestHeader=new URLRequestHeader("Authorization", oauthHeaderValue);
			return reqHeader;
		}

		private function getOAuthParams():Object
		{
			var params:Object=new Object;
			var now:Date=new Date();

			params["oauth_consumer_key"]=_consumerKey;
			if (_accessTokenKey.length > 0)
			{
				params["oauth_token"]=_accessTokenKey;
			}
			if ( _pin && _pin.length > 0 )
			{
				params["oauth_verifier"] = _pin;
			}
			params["oauth_signature_method"]="HMAC-SHA1";
			params["oauth_timestamp"]=now.time.toString().substr(0, 10);
			params["oauth_nonce"]=GUID.createGUID();
			params["oauth_version"]="1.0";
			params["oauth_callback"]="oob";
			return params;
		}

		private function oauthLoader_onComplete(event:Event):void
		{
			trace(oauthLoader.data);
			var needRequestAuthorize:Boolean=_accessTokenKey.length == 0;
			var result:String=oauthLoader.data as String;

			if (result.length > 0)
			{
				var urlVar:URLVariables=new URLVariables(oauthLoader.data);
				_accessTokenKey=urlVar.oauth_token;
				_accessTokenSecret=urlVar.oauth_token_secret;
				if (needRequestAuthorize)
				{
					requestAuthorize();
					needRequestAuthorize=false;
				}
				else
				{
					var e:MicroBlogEvent=new MicroBlogEvent(MicroBlogEvent.OAUTH_CERTIFICATE_RESULT);
					e.result={oauthTokenKey: _accessTokenKey, oauthTokenSecrect: _accessTokenSecret};
					dispatchEvent(e);
					verifyCredentials();
				}
			}

		}

		private function oauthLoader_onError(event:IOErrorEvent):void
		{
			//var urlData:URLVariables = new URLVariables(oauthLoader.data);
			var e:MicroBlogErrorEvent = new MicroBlogErrorEvent(MicroBlogErrorEvent.OAUTH_CERTIFICATE_ERROR);
			e.message = oauthLoader.data;
			dispatchEvent(e);
		}

		private function oauthLoader_onSecurityError(event:SecurityErrorEvent):void
		{
			dispatchEvent(event);
		}

		private function requestAuthorize():void
		{
			var url:String=OAUTH_AUTHORIZE_REQUEST_URL;
			url+="?oauth_token=" + StringEncoders.urlEncodeUtf8String(_accessTokenKey);
			url+="&oauth_callback=oob";
			navigateToURL(new URLRequest(url));
		}
		private static const STATUS_UNREAD_REQUEST_URL:String = "/statuses/unread.xml";
		private var _useProxy:Boolean = true;
		private static const PROXY_URL:String = "http://api.t.sina.com.cn/flash/proxy.jsp";
		private static const RESET_STATUS_COUNT_REQUEST_URL:String = "/statuses/reset_count.xml";
		private function processUnread(data:XML):MicroBlogUnread
		{
			return new MicroBlogUnread(data);
		}
		private function processBooleanResult(result:XML):Boolean
		{
			return String(result[0]) == "true";
		}
		public function loadStatusUnread(withNewStatus:uint = 0, sinceID:String = null):void
		{
			if (withNewStatus != 0 && withNewStatus != 1) return;			
			addProcessor(STATUS_UNREAD_REQUEST_URL, processUnread, MicroBlogEvent.LOAD_STATUS_UNREAD_RESULT, MicroBlogErrorEvent.LOAD_STATUS_UNREAD_ERROR);
			var params:Object = new Object();
			params["_uri"] = STATUS_UNREAD_REQUEST_URL;
			if (sinceID != null) 
			{
				if(sinceID && sinceID.length > 0) params[SINCE_ID] = sinceID;
			}
			params["with_new_status"] = withNewStatus;
			if(_useProxy) executeRequest(STATUS_UNREAD_REQUEST_URL, getMicroBlogRequest(PROXY_URL, params, URLRequestMethod.POST));
			else executeRequest(STATUS_UNREAD_REQUEST_URL, getMicroBlogRequest(API_BASE_URL + STATUS_UNREAD_REQUEST_URL, params, URLRequestMethod.POST));
		}
		public function resetCount(type:int):void
		{
			if (!(type == 1 || type == 2 || type == 3 || type == 4)) return;
			addProcessor(RESET_STATUS_COUNT_REQUEST_URL, processBooleanResult, MicroBlogEvent.RESET_STATUS_COUNT_RESULT, MicroBlogErrorEvent.RESET_STATUS_COUNT_ERROR);
			var params:URLVariables = new URLVariables();
			params.type = type;
			params["_uri"] = RESET_STATUS_COUNT_REQUEST_URL;
			var req:URLRequest= (_useProxy) ? getMicroBlogRequest(PROXY_URL, params, URLRequestMethod.POST) : getMicroBlogRequest(API_BASE_URL + RESET_STATUS_COUNT_REQUEST_URL, params, URLRequestMethod.POST);
			executeRequest(RESET_STATUS_COUNT_REQUEST_URL, req);	
		}		
	}
}