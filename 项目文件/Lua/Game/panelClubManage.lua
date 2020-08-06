panelClubManage = {}
local this = panelClubManage

local message;
local gameObject;
local closeButton;
local toggleGroupInfo;
local toggleGroupNotice;
local toggleDissolve;
local toggleDarkHouse;
local toggleBusiness;
local toggleActiveSetting;
local toggleOtherSetting;
local toggleGrid;

--群信息游戏对象
local groupInfoObjTable =
{
    groupName           = nil,
    groupID             = nil,
    exitGroupButton     = nil,
    editGroupNameButton = nil,
    copyGroupNameButton = nil,
    groupLordName       = nil,
    lordImg             = nil,
    lordID              = nil,
    lordCardButton      = nil,
    warnButton          = nil,
    recordImg           = nil,
    copyURLButton       = nil,
    shareURLButton      = nil,
    urlText             = nil,
}

--群公告游戏对象
local groupNoticeObjTable =
{
    noticeInput     = nil,
    OKButton        = nil,
}
--解散方式游戏对象
local dissolveModeObjTable =
{
    OKButton                = nil,
    toggleAll               = nil,
    toggleHalf              = nil,
    toggleForbidden         = nil,
    toggleDissolve5         = nil,
    toggleDissolve3         = nil,
    toggleDissolve1         = nil,
    dissolveTypeTip         = nil,
    dissolveTimeTip         = nil,
    toggleUnlimited         = nil,
    toggleApply5times       = nil,
    toggleInterval          = nil,
    toggleDissolveLimitTips = nil,
    autoDissolveTimeAddButton              = nil,
    autoDissolveTimeSubButton              = nil,
    autoDissolveTimeValueLable             = nil,
}
--小黑屋设置游戏对象
local darkHouseOjbTable =
{
    toggleDHOn      = nil,
    toggleDHOff     = nil,
    tiredValueInput = nil,
    OKButton        = nil;
    darkHouseTip    = nil,
}
--营业模式游戏对象
local businessModeObjTable =
{
    OKButton        = nil,
    toggleBMOn      = nil,
    toggleBMOff     = nil,
    inputBM         = nil,
    pauseRoomTip    = nil,
    fuFee    = nil,
    fuFeeOn    = nil,
    fuFeeOff    = nil,
    fuFeeTip    = nil,
}

--活动设置
local activeSettingObjTable = {
    OKButton = nil,
    toggleTotalFieldRank = nil,
    toggleUsefulFieldRank = nil,
    toggleWinPlayerRank = nil,
    toggleFeeValueRank = nil,
    toggleManageFieldRank = nil,
    toggleManageDirectBranchFieldRank = nil,
    toggleMyManageFieldRank = nil,
    toggleMyMenberFieldRank = nil
}

--其他设置游戏对象
local otherSettingObjTable =
{
    OKButton                    = nil,
    toggleAuto                  = nil,
    toggleManu                  = nil,
    toggleNoLimit               = nil,
    toggleIfStart               = nil,
    toggleTable2                = nil,
    toggleTable5                = nil,
    toggleTable10               = nil,
    toggleTable20                = nil,
    toggleTable30                = nil,
    toggleTable40               = nil,
    togglePrivatePermit         = nil,
    togglePrivateNotAllow       = nil,
    togglePublicPermit          = nil,
    togglePublicNotAllow        = nil,
    toggleInviteMemeberPermit   = nil,
    toggleInviteMemeberNotAllow = nil,
    autoReadyTip                = nil,
    tableSettingTip             = nil,
    privateRoomTip              = nil,
    publicRoomTip               = nil,
    memberInviteTip             = nil,
    memeberOutToggleOn          = nil,
    memeberOutToggleOff         = nil,
    memeberOutTip               = nil,
    sendTextAndEmojiTip         = nil,
    sendTextAndEmojiToggleOn    = nil,
    sendTextAndEmojiToggleOff   = nil,
    sendAudioTip                = nil,
    sendAudioToggleOn           = nil,
    sendAudioToggleOff          = nil,
    huangDissolveToggleNoLimit  = nil,
    huangDissolveToggleLimit    = nil,
    limitAddButton              = nil,
    limitSubButton              = nil,
    limitValueLable             = nil,
    huangLimitTip               = nil,
    phzAutoDissolve             = 1,
	
	emptyTablePositionTip       = nil,
    emptyTablePositionAhead     = nil,
	emptyTablePositionBehind    = nil,
	showBigWinTip       		= nil,
    showBigWinOff     			= nil,
	showBigWinOn    			= nil,
	
	showManageDiamondTip		= nil,
	totalMemberNoCanSee			= nil,
	limitManageCanSee			= nil,
	nanageCanSee				= nil,
	totalManageHomeCanSee		= nil,
    
    applyMemberJoinTip		    = nil,
	agreeJoin			        = nil,
	disagreeJoin			    = nil,
    
    allowInactiveQuit           = nil,
    forbidInactiveQuit          = nil,
    allowAddButton              = nil,
    allowSubButton              = nil,
    allowValueLable             = nil,
    allowInactiveQuitTip        = nil,
    fomalMember                 = nil,
    managerMember               = nil,

    allowDeleteToggleOn          = nil,
    allowDeleteToggleOff         = nil,
    allowDeleteToggleOnTip       = nil,

	showScaleBigWinTip       		= nil,
    showScaleBigWinOff     			= nil,
	showScaleBigWinOn    			= nil,
}

function this.Awake(go)
    gameObject          = go;
    message             = gameObject:GetComponent('LuaBehaviour');
    closeButton         = gameObject.transform:Find("CloseButton");
    toggleGroupInfo     = gameObject.transform:Find("grid/item_groupInfo");
    toggleGroupNotice   = gameObject.transform:Find("grid/item_groupNotice");
    toggleDissolve      = gameObject.transform:Find("grid/item_dissolveMode");
    toggleDarkHouse     = gameObject.transform:Find("grid/item_darkHouse");
    toggleBusiness      = gameObject.transform:Find("grid/item_businessMode");
    toggleOtherSetting  = gameObject.transform:Find("grid/item_otherSetting");
    toggleActiveSetting = gameObject.transform:Find("grid/item_activeSetting")
    toggleGrid          = gameObject.transform:Find("grid");




    this.getGroupInfoObj();
    this.getGroupNoticeObj();
    this.getDarkHouseObj();
    this.getDissolveModeObj();
    this.getBusinessModeObj();
    this.getOtherSettingObj();
    this.getActiveSettingObj()
    this.BindEvents();

end

function this.getGroupInfoObj()
    groupInfoObjTable.groupName             = gameObject.transform:Find("panels/panelGroupInfo/body/ClubInfo/Name/Name");
    groupInfoObjTable.groupID               = gameObject.transform:Find("panels/panelGroupInfo/body/ClubInfo/Name/ID");
    groupInfoObjTable.exitGroupButton       = gameObject.transform:Find("panels/panelGroupInfo/body/ClubInfo/Buttons/DeletButton");
    groupInfoObjTable.editGroupNameButton   = gameObject.transform:Find("panels/panelGroupInfo/body/ClubInfo/Buttons/SetNameButton");
    groupInfoObjTable.copyGroupNameButton   = gameObject.transform:Find("panels/panelGroupInfo/body/ClubInfo/Buttons/CopyButton");
    groupInfoObjTable.groupLordName         = gameObject.transform:Find("panels/panelGroupInfo/body/LordInfo/Lord/LordName");
    groupInfoObjTable.lordImg               = gameObject.transform:Find("panels/panelGroupInfo/body/LordInfo/headTexture");
    groupInfoObjTable.lordID                = gameObject.transform:Find("panels/panelGroupInfo/body/LordInfo/Lord/LordID");
    groupInfoObjTable.lordCardButton        = gameObject.transform:Find("panels/panelGroupInfo/body/LordInfo/SharedButton");
    groupInfoObjTable.warnButton            = gameObject.transform:Find("panels/panelGroupInfo/body/LordInfo/WarnButton");
    groupInfoObjTable.recordImg             = gameObject.transform:Find("panels/panelGroupInfo/body/RecordURL/Texture");
    groupInfoObjTable.copyURLButton         = gameObject.transform:Find("panels/panelGroupInfo/body/RecordURL/CopyButton");
    groupInfoObjTable.shareURLButton        = gameObject.transform:Find("panels/panelGroupInfo/body/RecordURL/SharedButton");
    groupInfoObjTable.urlText               = gameObject.transform:Find("panels/panelGroupInfo/body/RecordURL/url");


end

function this.getGroupNoticeObj()
    groupNoticeObjTable.noticeInput = gameObject.transform:Find("panels/panelGroupNotice/NoticeInput");
    groupNoticeObjTable.OKButton    = gameObject.transform:Find("panels/panelGroupNotice/ButtonOK");

end

function this.getDissolveModeObj()
    dissolveModeObjTable.OKButton           = gameObject.transform:Find("panels/panelDissolveMode/ButtonOK")
    dissolveModeObjTable.toggleAll          = gameObject.transform:Find("panels/panelDissolveMode/panel/body/dissolveTypes/all")
    dissolveModeObjTable.toggleHalf         = gameObject.transform:Find("panels/panelDissolveMode/panel/body/dissolveTypes/half")
    dissolveModeObjTable.toggleForbidden    = gameObject.transform:Find("panels/panelDissolveMode/panel/body/dissolveTypes/forbidden")
    dissolveModeObjTable.toggleDissolve5    = gameObject.transform:Find("panels/panelDissolveMode/panel/body/dissolveTime/5")
    dissolveModeObjTable.toggleDissolve3    = gameObject.transform:Find("panels/panelDissolveMode/panel/body/dissolveTime/3")
    dissolveModeObjTable.toggleDissolve1    = gameObject.transform:Find("panels/panelDissolveMode/panel/body/dissolveTime/1")
    dissolveModeObjTable.dissolveTypeTip    = gameObject.transform:Find("panels/panelDissolveMode/panel/body/dissolveTypes/tip")
    dissolveModeObjTable.dissolveTimeTip    = gameObject.transform:Find("panels/panelDissolveMode/panel/body/dissolveTime/tip")
    dissolveModeObjTable.toggleUnlimited    = gameObject.transform:Find("panels/panelDissolveMode/panel/body/dissolveLimit/unlimited")
    dissolveModeObjTable.toggleApply5times  = gameObject.transform:Find("panels/panelDissolveMode/panel/body/dissolveLimit/apply5times")
    dissolveModeObjTable.toggleInterval     = gameObject.transform:Find("panels/panelDissolveMode/panel/body/dissolveLimit/interval")
    dissolveModeObjTable.toggleDissolveLimitTips = gameObject.transform:Find("panels/panelDissolveMode/panel/body/dissolveLimit/tip")

    dissolveModeObjTable.autoDissolveTimeAddButton  = gameObject.transform:Find("panels/panelDissolveMode/panel/body/autoDissolveTime/AddButton")
    dissolveModeObjTable.autoDissolveTimeSubButton  = gameObject.transform:Find("panels/panelDissolveMode/panel/body/autoDissolveTime/SubtractButton")
    dissolveModeObjTable.autoDissolveTimeValueLable = gameObject.transform:Find("panels/panelDissolveMode/panel/body/autoDissolveTime/Value")
end

function this.getDarkHouseObj()
    darkHouseOjbTable.OKButton          = gameObject.transform:Find("panels/panelDarkHouse/ButtonOK");
    darkHouseOjbTable.toggleDHOff       = gameObject.transform:Find("panels/panelDarkHouse/panel/body/autoPullDarkHouse/Off");
    darkHouseOjbTable.toggleDHOn        = gameObject.transform:Find("panels/panelDarkHouse/panel/body/autoPullDarkHouse/On");
    darkHouseOjbTable.tiredValueInput   = gameObject.transform:Find("panels/panelDarkHouse/panel/body/darkHouseValue/input");
    darkHouseOjbTable.darkHouseTip      = gameObject.transform:Find("panels/panelDarkHouse/panel/body/autoPullDarkHouse/tip");
end

function this.getBusinessModeObj()
    businessModeObjTable.OKButton       = gameObject.transform:Find("panels/panelBusinessMode/ButtonOK");
    businessModeObjTable.toggleBMOn     = gameObject.transform:Find("panels/panelBusinessMode/panel/body/On");
    businessModeObjTable.toggleBMOff    = gameObject.transform:Find("panels/panelBusinessMode/panel/body/Off");
    businessModeObjTable.inputBM        = gameObject.transform:Find("panels/panelBusinessMode/panel/body/input");
    businessModeObjTable.pauseRoomTip   = gameObject.transform:Find("panels/panelBusinessMode/panel/body/tip");
    businessModeObjTable.fuFee = gameObject.transform:Find("panels/panelBusinessMode/panel/fuFee")
    businessModeObjTable.fuFeeOn = gameObject.transform:Find("panels/panelBusinessMode/panel/fuFee/On")
    businessModeObjTable.fuFeeOff = gameObject.transform:Find("panels/panelBusinessMode/panel/fuFee/Off")
    businessModeObjTable.fuFeeTip = gameObject.transform:Find("panels/panelBusinessMode/panel/fuFee/tip")
end

function this.getActiveSettingObj()
    activeSettingObjTable.OKButton = gameObject.transform:Find("panels/panelActiveSetting/ButtonOK")
    activeSettingObjTable.toggleTotalFieldRank = gameObject.transform:Find("panels/panelActiveSetting/panel/tableSet/totalFieldRank")
    activeSettingObjTable.toggleUsefulFieldRank = gameObject.transform:Find("panels/panelActiveSetting/panel/tableSet/usefulFieldRank")
    activeSettingObjTable.toggleWinPlayerRank = gameObject.transform:Find("panels/panelActiveSetting/panel/tableSet/winPlayerRank")
    activeSettingObjTable.toggleFeeValueRank = gameObject.transform:Find("panels/panelActiveSetting/panel/tableSet/feeValueRank")
    activeSettingObjTable.toggleManageFieldRank = gameObject.transform:Find("panels/panelActiveSetting/panel/tableSet/manageFieldRank")
    activeSettingObjTable.toggleManageDirectBranchFieldRank = gameObject.transform:Find("panels/panelActiveSetting/panel/tableSet/manageDirectBranchFieldRank")
    activeSettingObjTable.toggleMyManageFieldRank = gameObject.transform:Find("panels/panelActiveSetting/panel/tableSet/myManageFieldRank")
    activeSettingObjTable.toggleMyMenberFieldRank = gameObject.transform:Find("panels/panelActiveSetting/panel/tableSet/myMenberFieldRank")
end

function this.getOtherSettingObj()
    otherSettingObjTable.OKButton                       = gameObject.transform:Find("panels/panelOtherSetting/ButtonOK");
    otherSettingObjTable.toggleAuto                     = gameObject.transform:Find("panels/panelOtherSetting/panel/body/gamePrepare/auto");
    otherSettingObjTable.toggleManu                     = gameObject.transform:Find("panels/panelOtherSetting/panel/body/gamePrepare/manu");
    otherSettingObjTable.toggleNoLimit                  = gameObject.transform:Find("panels/panelOtherSetting/panel/body/tableSet/noLimit");
    otherSettingObjTable.toggleIfStart                  = gameObject.transform:Find("panels/panelOtherSetting/panel/body/tableSet/hideIfStart");
    otherSettingObjTable.toggleTable2                   = gameObject.transform:Find("panels/panelOtherSetting/panel/body/tableSet/table2");
    otherSettingObjTable.toggleTable5                   = gameObject.transform:Find("panels/panelOtherSetting/panel/body/tableSet/table5");
    otherSettingObjTable.toggleTable10                  = gameObject.transform:Find("panels/panelOtherSetting/panel/body/tableSet/table10");
    otherSettingObjTable.toggleTable20                  = gameObject.transform:Find("panels/panelOtherSetting/panel/body/tableSet/table20");
    otherSettingObjTable.toggleTable30                  = gameObject.transform:Find("panels/panelOtherSetting/panel/body/tableSet/table30");
    otherSettingObjTable.toggleTable40                  = gameObject.transform:Find("panels/panelOtherSetting/panel/body/tableSet/table40");
    otherSettingObjTable.memeberOutToggleOn             = gameObject.transform:Find("panels/panelOtherSetting/panel/body/MemeberOut/on")
    otherSettingObjTable.memeberOutToggleOff            = gameObject.transform:Find("panels/panelOtherSetting/panel/body/MemeberOut/off")
    otherSettingObjTable.sendTextAndEmojiToggleOn       = gameObject.transform:Find("panels/panelOtherSetting/panel/body/SendTextAndEmoji/on")
    otherSettingObjTable.sendTextAndEmojiToggleOff      = gameObject.transform:Find("panels/panelOtherSetting/panel/body/SendTextAndEmoji/off")
    otherSettingObjTable.sendAudioToggleOn              = gameObject.transform:Find("panels/panelOtherSetting/panel/body/SendAudio/on")
    otherSettingObjTable.sendAudioToggleOff             = gameObject.transform:Find("panels/panelOtherSetting/panel/body/SendAudio/off")
    --print("otherSettingObjTable.toggleTable40"..tostring(otherSettingObjTable.toggleTable40));
    
    otherSettingObjTable.togglePrivatePermit            = gameObject.transform:Find("panels/panelOtherSetting/panel/body/privateRoom/pemit");
    otherSettingObjTable.togglePrivateNotAllow          = gameObject.transform:Find("panels/panelOtherSetting/panel/body/privateRoom/notAllow");
    otherSettingObjTable.togglePublicPermit             = gameObject.transform:Find("panels/panelOtherSetting/panel/body/publicRoom/pemit");
    otherSettingObjTable.togglePublicNotAllow           = gameObject.transform:Find("panels/panelOtherSetting/panel/body/publicRoom/notAllow");
    otherSettingObjTable.toggleInviteMemeberPermit      = gameObject.transform:Find("panels/panelOtherSetting/panel/body/InviteMemeber/pemit");
    otherSettingObjTable.toggleInviteMemeberNotAllow    = gameObject.transform:Find("panels/panelOtherSetting/panel/body/InviteMemeber/notAllow");

    otherSettingObjTable.autoReadyTip                   = gameObject.transform:Find("panels/panelOtherSetting/panel/body/gamePrepare/tip");
    otherSettingObjTable.tableSettingTip                = gameObject.transform:Find("panels/panelOtherSetting/panel/body/tableSet/tip");
    otherSettingObjTable.privateRoomTip                 = gameObject.transform:Find("panels/panelOtherSetting/panel/body/privateRoom/tip");
    otherSettingObjTable.publicRoomTip                  = gameObject.transform:Find("panels/panelOtherSetting/panel/body/publicRoom/tip");
    otherSettingObjTable.memberInviteTip                = gameObject.transform:Find("panels/panelOtherSetting/panel/body/InviteMemeber/tip");
    otherSettingObjTable.memeberOutTip                  = gameObject.transform:Find("panels/panelOtherSetting/panel/body/MemeberOut/tip")
    otherSettingObjTable.sendTextAndEmojiTip            = gameObject.transform:Find("panels/panelOtherSetting/panel/body/SendTextAndEmoji/tip")
    otherSettingObjTable.sendAudioTip                   = gameObject.transform:Find("panels/panelOtherSetting/panel/body/SendAudio/tip")

    otherSettingObjTable.huangDissolveToggleNoLimit     = gameObject.transform:Find("panels/panelOtherSetting/panel/body/HuangDissolve/NoLimit")
    otherSettingObjTable.huangDissolveToggleLimit       = gameObject.transform:Find("panels/panelOtherSetting/panel/body/HuangDissolve/Limit")
    otherSettingObjTable.limitAddButton                 = gameObject.transform:Find("panels/panelOtherSetting/panel/body/HuangDissolve/LimitValue/AddButton")
    otherSettingObjTable.limitSubButton                 = gameObject.transform:Find("panels/panelOtherSetting/panel/body/HuangDissolve/LimitValue/SubtractButton")
    otherSettingObjTable.limitValueLable                = gameObject.transform:Find("panels/panelOtherSetting/panel/body/HuangDissolve/LimitValue/Value")
    otherSettingObjTable.huangLimitTip                  = gameObject.transform:Find("panels/panelOtherSetting/panel/body/HuangDissolve/tip")
	
	otherSettingObjTable.emptyTablePositionTip    		= gameObject.transform:Find("panels/panelOtherSetting/panel/body/emptyTablePosition/tip")
    otherSettingObjTable.emptyTablePositionAhead     	= gameObject.transform:Find("panels/panelOtherSetting/panel/body/emptyTablePosition/ahead")
	otherSettingObjTable.emptyTablePositionBehind    	= gameObject.transform:Find("panels/panelOtherSetting/panel/body/emptyTablePosition/behind")
	
	otherSettingObjTable.showBigWinTip       			= gameObject.transform:Find("panels/panelOtherSetting/panel/body/showBigWin/tip")
    otherSettingObjTable.showBigWinOff     				= gameObject.transform:Find("panels/panelOtherSetting/panel/body/showBigWin/noShow")
	otherSettingObjTable.showBigWinOn    				= gameObject.transform:Find("panels/panelOtherSetting/panel/body/showBigWin/show")
	
	otherSettingObjTable.showManageDiamondTip    		= gameObject.transform:Find("panels/panelOtherSetting/panel/body/showManageDiamond/tip")
	otherSettingObjTable.totalMemberNoCanSee    		= gameObject.transform:Find("panels/panelOtherSetting/panel/body/showManageDiamond/member")
	otherSettingObjTable.limitManageCanSee    			= gameObject.transform:Find("panels/panelOtherSetting/panel/body/showManageDiamond/limitManage")
	otherSettingObjTable.manageCanSee    				= gameObject.transform:Find("panels/panelOtherSetting/panel/body/showManageDiamond/manage")
	otherSettingObjTable.totalManageHomeCanSee    		= gameObject.transform:Find("panels/panelOtherSetting/panel/body/showManageDiamond/manageHome")
	
    
    otherSettingObjTable.applyMemberJoinTip		        = gameObject.transform:Find("panels/panelOtherSetting/panel/body/applyMemberJoin/tip")
	otherSettingObjTable.agreeJoin			            = gameObject.transform:Find("panels/panelOtherSetting/panel/body/applyMemberJoin/agree")
	otherSettingObjTable.disagreeJoin			        = gameObject.transform:Find("panels/panelOtherSetting/panel/body/applyMemberJoin/disagree")
    
    otherSettingObjTable.allowInactiveQuit              = gameObject.transform:Find("panels/panelOtherSetting/panel/body/allowInactiveQuit/agree")
    otherSettingObjTable.forbidInactiveQuit             = gameObject.transform:Find("panels/panelOtherSetting/panel/body/allowInactiveQuit/disagree")
    otherSettingObjTable.allowAddButton                 = gameObject.transform:Find("panels/panelOtherSetting/panel/body/allowInactiveQuit/allowDaysValue/AddButton")
    otherSettingObjTable.allowSubButton                 = gameObject.transform:Find("panels/panelOtherSetting/panel/body/allowInactiveQuit/allowDaysValue/SubtractButton")
    otherSettingObjTable.allowValueLable                = gameObject.transform:Find("panels/panelOtherSetting/panel/body/allowInactiveQuit/allowDaysValue/Value")
    otherSettingObjTable.allowInactiveQuitTip           = gameObject.transform:Find("panels/panelOtherSetting/panel/body/allowInactiveQuit/tip")
    otherSettingObjTable.fomalMember                    = gameObject.transform:Find("panels/panelOtherSetting/panel/body/allowInactiveQuit/fomalMember")
    otherSettingObjTable.managerMember                  = gameObject.transform:Find("panels/panelOtherSetting/panel/body/allowInactiveQuit/managerMember")
    
    otherSettingObjTable.allowNoGameQuit                = gameObject.transform:Find("panels/panelOtherSetting/panel/body/allowNoGameQuit/agree")
    otherSettingObjTable.forbidNoGameQuit               = gameObject.transform:Find("panels/panelOtherSetting/panel/body/allowNoGameQuit/disagree")
    otherSettingObjTable.allowNoGameQuitTip             = gameObject.transform:Find("panels/panelOtherSetting/panel/body/allowNoGameQuit/tip")
    otherSettingObjTable.fomalMemberNoGame              = gameObject.transform:Find("panels/panelOtherSetting/panel/body/allowNoGameQuit/fomalMember")
    otherSettingObjTable.managerMemberNoGame            = gameObject.transform:Find("panels/panelOtherSetting/panel/body/allowNoGameQuit/managerMember")

    otherSettingObjTable.allowDeleteToggleOn             = gameObject.transform:Find("panels/panelOtherSetting/panel/body/allowDelete/on")
    otherSettingObjTable.allowDeleteToggleOff            = gameObject.transform:Find("panels/panelOtherSetting/panel/body/allowDelete/off")
    otherSettingObjTable.allowDeleteTip                  = gameObject.transform:Find("panels/panelOtherSetting/panel/body/allowDelete/tip")

	otherSettingObjTable.showScaleBigWinTip       			= gameObject.transform:Find("panels/panelOtherSetting/panel/body/showScaleBigWin/tip")
    otherSettingObjTable.showScaleBigWinOff     			= gameObject.transform:Find("panels/panelOtherSetting/panel/body/showScaleBigWin/noShow")
	otherSettingObjTable.showScaleBigWinOn    				= gameObject.transform:Find("panels/panelOtherSetting/panel/body/showScaleBigWin/show")
end

function this.InitGroupInfo()
    groupInfoObjTable.groupName:GetComponent("UILabel").text = panelClub.clubInfo.name;
    groupInfoObjTable.groupID:GetComponent("UILabel").text = "（ID："..panelClub.clubInfo.clubId.."）";
    groupInfoObjTable.groupLordName:GetComponent("UILabel").text = panelClub.clubInfo.lordNickname;
    groupInfoObjTable.lordID:GetComponent("UILabel").text = "（ID："..panelClub.clubInfo.lordId.."）";
    coroutine.start(LoadPlayerIcon,groupInfoObjTable.lordImg:GetComponent("UITexture"),panelClub.clubInfo.clubLeaderIcon);
    groupInfoObjTable.editGroupNameButton.gameObject:SetActive(panelClub.clubInfo.userType == proxy_pb.LORD);
    if panelClub.clubInfo.userType == proxy_pb.LORD  then
        groupInfoObjTable.exitGroupButton:Find("Label"):GetComponent("UILabel").text = "解散本群";
    else
        groupInfoObjTable.exitGroupButton:Find("Label"):GetComponent("UILabel").text = "退出本群";
    end

    groupInfoObjTable.editGroupNameButton.parent:GetComponent("UIGrid"):Reposition();

end

function this.InitGroupNotice()
end

function this.InitDissolveMode()
    dissolveModeObjTable.toggleAll:GetComponent("UIToggle"):Set(panelClub.clubInfo.dissolveType == 0);
    dissolveModeObjTable.toggleHalf:GetComponent("UIToggle"):Set(panelClub.clubInfo.dissolveType == 1);
    dissolveModeObjTable.toggleForbidden:GetComponent("UIToggle"):Set(panelClub.clubInfo.dissolveType == 3);
    dissolveModeObjTable.toggleDissolve1:GetComponent("UIToggle"):Set(panelClub.clubInfo.waitTime == 1);
    dissolveModeObjTable.toggleDissolve3:GetComponent("UIToggle"):Set(panelClub.clubInfo.waitTime == 3);
    dissolveModeObjTable.toggleDissolve5:GetComponent("UIToggle"):Set(panelClub.clubInfo.waitTime == 5);
    dissolveModeObjTable.toggleApply5times:GetComponent('UIToggle'):Set(panelClub.clubInfo.dissolveLimit == proxy_pb.FIVE_TIMES)
    dissolveModeObjTable.toggleInterval:GetComponent('UIToggle'):Set(panelClub.clubInfo.dissolveLimit == proxy_pb.FIVE_SECONDS)
    dissolveModeObjTable.toggleUnlimited:GetComponent('UIToggle'):Set(panelClub.clubInfo.dissolveLimit == proxy_pb.UNLIMITED)
    dissolveModeObjTable.autoDissolveTimeValueLable:GetComponent('UILabel').text = panelClub.clubInfo.autoDissolveTime..'分钟'
end

function this.InitDarkHouse(go)
    print("InitDarkHouse was called");
    darkHouseOjbTable.toggleDHOn:GetComponent("UIToggle"):Set(panelClub.clubInfo.autoBlackHouse);
    darkHouseOjbTable.toggleDHOff:GetComponent("UIToggle"):Set(not panelClub.clubInfo.autoBlackHouse);
    darkHouseOjbTable.tiredValueInput:GetComponent("UIInput").value = panelClub.clubInfo.blackHouseValue;
    --toggleDarkHouse.gameObject:SetActive(not panelClub.clubInfo.gameMode);

    toggleGroupNotice:GetComponent("UIToggle"):Set(false);
    toggleDissolve:GetComponent("UIToggle"):Set(false);
    toggleBusiness:GetComponent("UIToggle"):Set(false);
    toggleOtherSetting:GetComponent("UIToggle"):Set(false);
    toggleActiveSetting:GetComponent("UIToggle"):Set(false)
    if panelClub.clubInfo.gameMode then
        if toggleDarkHouse:GetComponent("UIToggle").value  then
            toggleGroupInfo:GetComponent("UIToggle"):Set(true);--如果开始选择了小黑屋，要取消选择，并且选择一个默认的toggle
            darkHouseOjbTable.OKButton.transform.parent.gameObject:SetActive(false)
        else
            toggleGroupInfo:GetComponent("UIToggle"):Set(true);
        end
    else
        toggleDarkHouse.gameObject:SetActive(panelClub.clubInfo.userType == proxy_pb.LORD);
        if not go then
            toggleGroupInfo:GetComponent("UIToggle"):Set(true);
        end
    end
    toggleGrid:GetComponent("UIGrid"):Reposition();
end

function this.InitBusinessMode()
    businessModeObjTable.toggleBMOn:GetComponent("UIToggle"):Set(not panelClub.clubInfo.pauseRoom);
    businessModeObjTable.toggleBMOff:GetComponent("UIToggle"):Set(panelClub.clubInfo.pauseRoom);
    businessModeObjTable.inputBM:GetComponent("UIInput").value = panelClub.clubInfo.pauseInfo;

    businessModeObjTable.fuFee.gameObject:SetActive(panelClub.clubInfo.gameMode and panelClub.clubInfo.userType == proxy_pb.LORD)
    businessModeObjTable.fuFeeOn:GetComponent("UIToggle"):Set(panelClub.clubInfo.allowMinus)
    businessModeObjTable.fuFeeOff:GetComponent("UIToggle"):Set(not panelClub.clubInfo.allowMinus)

end

function this.InitActiveSetting()
    activeSettingObjTable.toggleTotalFieldRank:GetComponent("UIToggle"):Set(panelClub.clubInfo.timesAllowed)
    activeSettingObjTable.toggleUsefulFieldRank:GetComponent("UIToggle"):Set(panelClub.clubInfo.validTimesAllowed)
    activeSettingObjTable.toggleWinPlayerRank:GetComponent("UIToggle"):Set(panelClub.clubInfo.bigTimesAllowed)
    activeSettingObjTable.toggleFeeValueRank:GetComponent("UIToggle"):Set(panelClub.clubInfo.feeAllowed)
    activeSettingObjTable.toggleManageFieldRank:GetComponent("UIToggle"):Set(panelClub.clubInfo.feeAllowed)
    activeSettingObjTable.toggleManageDirectBranchFieldRank:GetComponent("UIToggle"):Set(panelClub.clubInfo.butlerAllowed)
    activeSettingObjTable.toggleMyManageFieldRank:GetComponent("UIToggle"):Set(panelClub.clubInfo.myButlerAllowed)
    activeSettingObjTable.toggleMyMenberFieldRank:GetComponent("UIToggle"):Set(panelClub.clubInfo.myUserAllowed)
	activeSettingObjTable.toggleManageFieldRank:GetComponent("UIToggle"):Set(panelClub.clubInfo.managerAllowed)
end

function this.InitOtherSetting()
    print("InitOtherSetting was called,panelClub.clubInfo.deskNum:"..panelClub.clubInfo.deskNum);
    otherSettingObjTable.toggleAuto:GetComponent("UIToggle"):Set(panelClub.clubInfo.autoReady);
    otherSettingObjTable.toggleManu:GetComponent("UIToggle"):Set(not panelClub.clubInfo.autoReady);
    otherSettingObjTable.toggleIfStart:GetComponent("UIToggle"):Set(panelClub.clubInfo.deskNum == 0);
    otherSettingObjTable.toggleNoLimit:GetComponent("UIToggle"):Set(panelClub.clubInfo.deskNum == -1);
    otherSettingObjTable.toggleTable2:GetComponent("UIToggle"):Set(panelClub.clubInfo.deskNum == 2);
    otherSettingObjTable.toggleTable5:GetComponent("UIToggle"):Set(panelClub.clubInfo.deskNum == 5);
    otherSettingObjTable.toggleTable10:GetComponent("UIToggle"):Set(panelClub.clubInfo.deskNum == 10);
    otherSettingObjTable.toggleTable20:GetComponent("UIToggle"):Set(panelClub.clubInfo.deskNum == 20);
    otherSettingObjTable.toggleTable30:GetComponent("UIToggle"):Set(panelClub.clubInfo.deskNum == 30);
    otherSettingObjTable.toggleTable40:GetComponent("UIToggle"):Set(panelClub.clubInfo.deskNum == 40);
    otherSettingObjTable.toggleInviteMemeberPermit:GetComponent("UIToggle"):Set(true);--TODO 这是新功能，需要跟服务器对接
    otherSettingObjTable.togglePrivatePermit:GetComponent("UIToggle"):Set(panelClub.clubInfo.privateRoom);
    otherSettingObjTable.togglePrivateNotAllow:GetComponent("UIToggle"):Set(not panelClub.clubInfo.privateRoom);
    otherSettingObjTable.togglePublicPermit:GetComponent("UIToggle"):Set(panelClub.clubInfo.publicRoom);
    otherSettingObjTable.togglePublicNotAllow:GetComponent("UIToggle"):Set(not panelClub.clubInfo.publicRoom);
    otherSettingObjTable.memeberOutToggleOn:GetComponent("UIToggle"):Set(panelClub.clubInfo.quitAllowed)
    otherSettingObjTable.memeberOutToggleOff:GetComponent("UIToggle"):Set(not panelClub.clubInfo.quitAllowed)


    otherSettingObjTable.sendTextAndEmojiToggleOn:GetComponent("UIToggle"):Set(panelClub.clubInfo.sendMsgAllowed)
    otherSettingObjTable.sendTextAndEmojiToggleOff:GetComponent("UIToggle"):Set(not panelClub.clubInfo.sendMsgAllowed)
    otherSettingObjTable.sendAudioToggleOn:GetComponent("UIToggle"):Set(panelClub.clubInfo.sendVoiceAllowed)
    otherSettingObjTable.sendAudioToggleOff:GetComponent("UIToggle"):Set(not panelClub.clubInfo.sendVoiceAllowed)

    print("panelClub.clubInfo.phzAutoDissolve:"..tostring(panelClub.clubInfo.phzAutoDissolve));

    otherSettingObjTable.phzAutoDissolve = panelClub.clubInfo.phzAutoDissolve == nil and 0 or panelClub.clubInfo.phzAutoDissolve;

    otherSettingObjTable.huangDissolveToggleNoLimit:GetComponent("UIToggle"):Set(otherSettingObjTable.phzAutoDissolve == 0);
    otherSettingObjTable.huangDissolveToggleLimit:GetComponent("UIToggle"):Set(otherSettingObjTable.phzAutoDissolve~=0);
    otherSettingObjTable.limitValueLable:GetComponent("UILabel").text = (otherSettingObjTable.phzAutoDissolve == 0 and 1 or otherSettingObjTable.phzAutoDissolve).."局";
    otherSettingObjTable.limitAddButton.parent.gameObject:SetActive(otherSettingObjTable.phzAutoDissolve~=0);
	
	otherSettingObjTable.emptyTablePositionAhead:GetComponent("UIToggle"):Set(panelClub.clubInfo.deskDirect)
	otherSettingObjTable.emptyTablePositionBehind:GetComponent("UIToggle"):Set(not panelClub.clubInfo.deskDirect)
	
    otherSettingObjTable.showBigWinOff:GetComponent("UIToggle"):Set(not panelClub.clubInfo.showBigWin)
	otherSettingObjTable.showBigWinOn:GetComponent("UIToggle"):Set(panelClub.clubInfo.showBigWin)
	
    otherSettingObjTable.showScaleBigWinOff:GetComponent("UIToggle"):Set(not panelClub.clubInfo.ratioSetup)
    otherSettingObjTable.showScaleBigWinOn:GetComponent("UIToggle"):Set(panelClub.clubInfo.ratioSetup)
    
	otherSettingObjTable.totalMemberNoCanSee:GetComponent("UIToggle"):Set(panelClub.clubInfo.showLordBalance == 0)
	otherSettingObjTable.limitManageCanSee:GetComponent("UIToggle"):Set(panelClub.clubInfo.showLordBalance == 1)
	otherSettingObjTable.manageCanSee:GetComponent("UIToggle"):Set(panelClub.clubInfo.showLordBalance == 2)
	otherSettingObjTable.totalManageHomeCanSee:GetComponent("UIToggle"):Set(panelClub.clubInfo.showLordBalance == 3)
    
	otherSettingObjTable.agreeJoin:GetComponent("UIToggle"):Set(panelClub.clubInfo.applyClub == true)
	otherSettingObjTable.disagreeJoin:GetComponent("UIToggle"):Set(panelClub.clubInfo.applyClub == false)
    
    otherSettingObjTable.allowInactiveQuit.parent.gameObject:SetActive(not panelClub.clubInfo.quitAllowed)
    otherSettingObjTable.allowInactiveQuit:GetComponent("UIToggle"):Set(panelClub.clubInfo.noActive ~= 0)
    otherSettingObjTable.forbidInactiveQuit:GetComponent("UIToggle"):Set(panelClub.clubInfo.noActive == 0)
    otherSettingObjTable.allowValueLable:GetComponent("UILabel").text = panelClub.clubInfo.noActive==0 and 30 or panelClub.clubInfo.noActive;
    otherSettingObjTable.allowAddButton.parent.gameObject:SetActive(panelClub.clubInfo.noActive ~= 0)
    otherSettingObjTable.fomalMember.gameObject:SetActive(panelClub.clubInfo.noActive ~= 0)
    otherSettingObjTable.managerMember.gameObject:SetActive(panelClub.clubInfo.noActive ~= 0)
    
    --otherSettingObjTable.fomalMember:GetComponent("UIToggle"):Set(panelClub.clubInfo.generalExit)
    otherSettingObjTable.managerMember:GetComponent("UIToggle"):Set(panelClub.clubInfo.managerExit)

    print('panelClub.clubInfo.playNotActive :'..tostring(panelClub.clubInfo.playNotActive))
    otherSettingObjTable.allowNoGameQuit:GetComponent("UIToggle"):Set(panelClub.clubInfo.playNotActive)
    otherSettingObjTable.forbidNoGameQuit:GetComponent("UIToggle"):Set(not panelClub.clubInfo.playNotActive)
    --otherSettingObjTable.fomalMemberNoGame:GetComponent("UIToggle"):Set(panelClub.clubInfo.generalNotPlay)
    otherSettingObjTable.managerMemberNoGame:GetComponent("UIToggle"):Set(panelClub.clubInfo.managerNotPlay)
    if not panelClub.clubInfo.quitAllowed and panelClub.clubInfo.noActive ~= 0 then
        otherSettingObjTable.allowNoGameQuit.parent.gameObject:SetActive(true)
        otherSettingObjTable.fomalMemberNoGame.gameObject:SetActive(panelClub.clubInfo.playNotActive)
        otherSettingObjTable.managerMemberNoGame.gameObject:SetActive(panelClub.clubInfo.playNotActive)
    else
        print('隐藏')
        otherSettingObjTable.allowNoGameQuit.parent.gameObject:SetActive(false)
        otherSettingObjTable.fomalMemberNoGame.gameObject:SetActive(false)
        otherSettingObjTable.managerMemberNoGame.gameObject:SetActive(false)
    end

    otherSettingObjTable.allowDeleteToggleOn:GetComponent("UIToggle"):Set(panelClub.clubInfo.deleteAllowed)
    otherSettingObjTable.allowDeleteToggleOff:GetComponent("UIToggle"):Set(not panelClub.clubInfo.deleteAllowed)
end

function this.OnEnable()

    this.InitGroupInfo();
    this.InitGroupNotice();
    this.InitDissolveMode();

    this.InitBusinessMode();
    this.InitOtherSetting();
    this.InitActiveSetting()
    this.SetDissolveTips();
    this.SetDarkHouseTips();
    this.SetBusinessModeTips();
    this.SetOtherSettingTips();
    this.SetkDissolveLimitTips();
    groupInfoObjTable.warnButton.gameObject:SetActive(panelClub.clubInfo.gameMode and panelClub.clubInfo.userType ~= proxy_pb.GENERAL)
    toggleDissolve.gameObject:SetActive(panelClub.clubInfo.userType == proxy_pb.LORD)
    toggleDarkHouse.gameObject:SetActive((not panelClub.clubInfo.gameMode) and panelClub.clubInfo.userType == proxy_pb.LORD)
    toggleBusiness.gameObject:SetActive(panelClub.clubInfo.userType == proxy_pb.LORD or IsCanStopRoom())
    toggleOtherSetting.gameObject:SetActive(panelClub.clubInfo.userType == proxy_pb.LORD);
    toggleActiveSetting.gameObject:SetActive(panelClub.clubInfo.userType == proxy_pb.LORD and panelClub.clubInfo.gameMode)
    toggleGroupInfo:GetComponent("UIToggle"):Set(true)
    toggleGroupNotice:GetComponent("UIToggle"):Set(false)
    toggleDissolve:GetComponent("UIToggle"):Set(false)
    toggleDarkHouse:GetComponent("UIToggle"):Set(false)
    toggleBusiness:GetComponent("UIToggle"):Set(false)
    toggleActiveSetting:GetComponent("UIToggle"):Set(false)
    toggleOtherSetting:GetComponent("UIToggle"):Set(false)
    
    toggleGrid:GetComponent("UIGrid"):Reposition()
end



function this.Start()
    
end

function this.Update()
    
end

function this.BindEvents()
    message:AddClick(closeButton.gameObject,        this.OnCloseButtonClick);
    message:AddClick(toggleGroupInfo.gameObject,    this.OnToggleGroupInfoClick);
    message:AddClick(toggleGroupNotice.gameObject,  this.OnToggleGroupNoticeClick);
    message:AddClick(toggleDissolve.gameObject,     this.OnToggleDissolveClick);
    message:AddClick(toggleDarkHouse.gameObject,    this.OnToggleDarkHouseClick);
    message:AddClick(toggleBusiness.gameObject,     this.OnToggleBusinessInfoClick);
    message:AddClick(toggleOtherSetting.gameObject, this.OnToggleOtherSettingInfoClick);
    message:AddClick(toggleActiveSetting.gameObject, this.OnToggleActiveSettingInfoClick);
    this.BindGroupInfoEvent();
    this.BindGroupNoticeEvent();
    this.BindDissolveModeEvent();
    this.BindDarkHouseEvent();
    this.BindBusinessModeEvent();
    this.BindOtherSettingEvent();
    this.BindActiveSettingEvent()
end



function this.BindGroupInfoEvent()

    message:AddClick(groupInfoObjTable.exitGroupButton.gameObject       ,this.OnClickDelet);
    message:AddClick(groupInfoObjTable.editGroupNameButton.gameObject   ,this.OnGroupNameSubmit);
    message:AddClick(groupInfoObjTable.copyGroupNameButton.gameObject   ,this.OnClickCopyName);
    message:AddClick(groupInfoObjTable.lordCardButton.gameObject        ,this.OnClickLookLord);
    message:AddClick(groupInfoObjTable.warnButton.gameObject            ,this.OnClickWarnButton);
    message:AddClick(groupInfoObjTable.copyURLButton.gameObject         ,this.OnClickCopyURL);
    message:AddClick(groupInfoObjTable.shareURLButton.gameObject        ,this.OnClickSharedURL);
end

function this.BindGroupNoticeEvent()
    message:AddClick(groupNoticeObjTable.OKButton.gameObject,this.OnGroupNoticeOKClick);
end

function this.BindDissolveModeEvent()
    message:AddClick(dissolveModeObjTable.OKButton.gameObject,          this.OnDissolveOKClick);

    message:AddClick(dissolveModeObjTable.toggleAll.gameObject,         this.OnClickDissolveType);
    message:AddClick(dissolveModeObjTable.toggleHalf.gameObject,        this.OnClickDissolveType);
    message:AddClick(dissolveModeObjTable.toggleForbidden.gameObject,   this.OnClickDissolveType);
    message:AddClick(dissolveModeObjTable.toggleDissolve1.gameObject,   this.OnClickDissolveTime);
    message:AddClick(dissolveModeObjTable.toggleDissolve3.gameObject,   this.OnClickDissolveTime);
    message:AddClick(dissolveModeObjTable.toggleDissolve5.gameObject,   this.OnClickDissolveTime);

    message:AddClick(dissolveModeObjTable.toggleUnlimited.gameObject,   this.OnClickDissolveLimit);
    message:AddClick(dissolveModeObjTable.toggleInterval.gameObject,    this.OnClickDissolveLimit);
    message:AddClick(dissolveModeObjTable.toggleApply5times.gameObject, this.OnClickDissolveLimit);
    
    message:AddClick(dissolveModeObjTable.autoDissolveTimeAddButton.gameObject,   this.OnClickAutoDissolveTimeChange);
    message:AddClick(dissolveModeObjTable.autoDissolveTimeSubButton.gameObject,   this.OnClickAutoDissolveTimeChange);
end

function this.BindDarkHouseEvent()
    message:AddClick(darkHouseOjbTable.OKButton.gameObject      ,this.OnDarkHouseOKClick);
    message:AddClick(darkHouseOjbTable.toggleDHOn.gameObject    ,this.OnClickDarkHouse);
    message:AddClick(darkHouseOjbTable.toggleDHOff.gameObject   ,this.OnClickDarkHouse);
end

function this.BindBusinessModeEvent()
    message:AddClick(businessModeObjTable.OKButton.gameObject,      this.OnBusinessModeOKClick);
    message:AddClick(businessModeObjTable.toggleBMOn.gameObject,    this.OnClickStopRoom);
    message:AddClick(businessModeObjTable.toggleBMOff.gameObject,   this.OnClickStopRoom);
    message:AddClick(businessModeObjTable.fuFeeOn.gameObject,    this.OnClickFuFee)
    message:AddClick(businessModeObjTable.fuFeeOff.gameObject,   this.OnClickFuFee)
end

function this.BindOtherSettingEvent()
    message:AddClick(otherSettingObjTable.OKButton.gameObject,                      this.OnOtherSettingOKClick);
    message:AddClick(otherSettingObjTable.toggleAuto.gameObject,                    this.OnClickAutoReady);
    message:AddClick(otherSettingObjTable.toggleManu.gameObject,                    this.OnClickAutoReady);
    message:AddClick(otherSettingObjTable.toggleNoLimit.gameObject,                 this.OnClickTableShow)
    message:AddClick(otherSettingObjTable.toggleIfStart.gameObject,                 this.OnClickTableShow)
    message:AddClick(otherSettingObjTable.toggleTable2.gameObject,                  this.OnClickTableShow)
    message:AddClick(otherSettingObjTable.toggleTable5.gameObject,                  this.OnClickTableShow)
    message:AddClick(otherSettingObjTable.toggleTable10.gameObject,                 this.OnClickTableShow)
    message:AddClick(otherSettingObjTable.toggleTable20.gameObject,                  this.OnClickTableShow)
    message:AddClick(otherSettingObjTable.toggleTable30.gameObject,                  this.OnClickTableShow)
    message:AddClick(otherSettingObjTable.toggleTable40.gameObject,                 this.OnClickTableShow)
    message:AddClick(otherSettingObjTable.togglePrivatePermit.gameObject,           this.OnClickSetPrivateRoom)
    message:AddClick(otherSettingObjTable.togglePrivateNotAllow.gameObject,         this.OnClickSetPrivateRoom)
    message:AddClick(otherSettingObjTable.togglePublicPermit.gameObject,            this.OnClickSetPublicRoom)
    message:AddClick(otherSettingObjTable.togglePublicNotAllow.gameObject,          this.OnClickSetPublicRoom)
    message:AddClick(otherSettingObjTable.toggleInviteMemeberPermit.gameObject,     this.OnClickSetPublicRoom)
    message:AddClick(otherSettingObjTable.toggleInviteMemeberNotAllow.gameObject,   this.OnClickSetPublicRoom)
    message:AddClick(otherSettingObjTable.memeberOutToggleOn.gameObject,            this.OnToggleMemberOutClick)
    message:AddClick(otherSettingObjTable.memeberOutToggleOff.gameObject,           this.OnToggleMemberOutClick)

    message:AddClick(otherSettingObjTable.sendTextAndEmojiToggleOn.gameObject,      this.OnToggleSendTextAndEmojiClick)
    message:AddClick(otherSettingObjTable.sendTextAndEmojiToggleOff.gameObject,     this.OnToggleSendTextAndEmojiClick)
    message:AddClick(otherSettingObjTable.sendAudioToggleOn.gameObject,             this.OnToggleSendAudioClick)
    message:AddClick(otherSettingObjTable.sendAudioToggleOff.gameObject,            this.OnToggleSendAudioClick)

    message:AddClick(otherSettingObjTable.huangDissolveToggleLimit.gameObject,      this.OnHuangDissolveToggleLimitClick)
    message:AddClick(otherSettingObjTable.huangDissolveToggleNoLimit.gameObject,    this.OnHuangDissolveToggleLimitClick)
    message:AddClick(otherSettingObjTable.limitAddButton.gameObject,                this.OnChangeHuangLimitValueClick)
    message:AddClick(otherSettingObjTable.limitSubButton.gameObject,                this.OnChangeHuangLimitValueClick)
		
	message:AddClick(otherSettingObjTable.emptyTablePositionAhead.gameObject,      	this.OnEmptyTablePositionClick)
    message:AddClick(otherSettingObjTable.emptyTablePositionBehind.gameObject,    	this.OnEmptyTablePositionClick)
	
	message:AddClick(otherSettingObjTable.showBigWinOff.gameObject,      	this.OnShowBigWinClick)
    message:AddClick(otherSettingObjTable.showBigWinOn.gameObject,    	this.OnShowBigWinClick)
	
	message:AddClick(otherSettingObjTable.showScaleBigWinOff.gameObject,      	this.OnShowScaleBigWinClick)
    message:AddClick(otherSettingObjTable.showScaleBigWinOn.gameObject,    	this.OnShowScaleBigWinClick)

	message:AddClick(otherSettingObjTable.totalMemberNoCanSee.gameObject,    	this.OnShowManageDiamondClick)
	message:AddClick(otherSettingObjTable.limitManageCanSee.gameObject,    	this.OnShowManageDiamondClick)
	message:AddClick(otherSettingObjTable.manageCanSee.gameObject,    	this.OnShowManageDiamondClick)
	message:AddClick(otherSettingObjTable.totalManageHomeCanSee.gameObject,    	this.OnShowManageDiamondClick)
	
	message:AddClick(otherSettingObjTable.agreeJoin.gameObject,    	this.OnApplyMemberJoinClick)
	message:AddClick(otherSettingObjTable.disagreeJoin.gameObject,    	this.OnApplyMemberJoinClick)
	
    message:AddClick(otherSettingObjTable.allowInactiveQuit.gameObject,      this.OnAllowInactiveQuitClick)
    message:AddClick(otherSettingObjTable.forbidInactiveQuit.gameObject,    this.OnAllowInactiveQuitClick)
    message:AddClick(otherSettingObjTable.allowAddButton.gameObject,                this.OnChangeAllowDaysValueClick)
    message:AddClick(otherSettingObjTable.allowSubButton.gameObject,                this.OnChangeAllowDaysValueClick)
    
    message:AddClick(otherSettingObjTable.allowNoGameQuit.gameObject,      this.OnAllowNoGameQuitClick)
    message:AddClick(otherSettingObjTable.forbidNoGameQuit.gameObject,    this.OnAllowNoGameQuitClick)

    message:AddClick(otherSettingObjTable.allowDeleteToggleOn.gameObject,            this.OnToggleAllowDeleteClick)
    message:AddClick(otherSettingObjTable.allowDeleteToggleOff.gameObject,           this.OnToggleAllowDeleteClick)
end

function this.BindActiveSettingEvent()
    message:AddClick(activeSettingObjTable.OKButton.gameObject,this.OnActiveSettingOKClick)
end

function this.OnCloseButtonClick(go)
    PanelManager.Instance:HideWindow("panelClubManage");
end

function this.OnClickCopyName(go)
    Util.CopyToSystemClipbrd("群名称："..panelClub.clubInfo.name..", 群ID："..panelClub.clubInfo.clubId)
    panelMessageTip.SetParamers('复制成功', 1.5)
	PanelManager.Instance:ShowWindow('panelMessageTip')	
end

function this.OnGroupNameSubmit(go)
	local wenBen=trim(groupInfoObjTable.editGroupNameButton:GetComponent("UIInput").value);
	if wenBen and wenBen~='' and wenBen~=panelClub.clubInfo.name and #wenBen <=21 then
		this.SetName(wenBen)
	else
		if #wenBen > 21 then
			panelMessageTip.SetParamers('牌友群名称不能超过七个字', 1)
			PanelManager.Instance:ShowWindow('panelMessageTip')
		else
			panelMessageTip.SetParamers('请输入牌友群名称', 1)
			PanelManager.Instance:ShowWindow('panelMessageTip')
		end
	end
end

function this.OnClickLookLord(go)
    local data = {}
    data.whoShow = gameObject.name
    data.userId = panelClub.clubInfo.lordId
    PanelManager.Instance:ShowWindow('panelVisitingCard', data)
end
function this.OnClickWarnButton(go)
    AudioManager.Instance:PlayAudio('btn')
    PanelManager.Instance:ShowWindow('panelWarnSetting')
end
function this.OnClickCopyURL(go)
    Util.CopyToSystemClipbrd(groupInfoObjTable.urlText:GetComponent("UILabel").text);
    panelMessageTip.SetParamers('复制成功', 1.5)
    PanelManager.Instance:ShowWindow('panelMessageTip')	
end

function this.OnClickSharedURL(go)
    PlatformManager.Instance:ShareLink(groupInfoObjTable.urlText:GetComponent("UILabel").text, '嗨皮湖南棋牌', '群战绩中心', 0)
end


--修改公告确定
function this.OnGroupNoticeOKClick(go)
    --print("OnGroupNoticeOKClick was called");
    AudioManager.Instance:PlayAudio('btn')
    local wenBen = groupNoticeObjTable.noticeInput:GetComponent('UIInput').value

    local msg = Message.New()
    msg.type = proxy_pb.EDIT_CLUB_NOTICE;
    local body=proxy_pb.PEditClubNotice()
    body.clubId=panelClub.clubInfo.clubId
    body.content=wenBen
    msg.body = body:SerializeToString()
    SendProxyMessage(msg, this.editGroupNoticeResult);
end

--修改公告返回
function this.editGroupNoticeResult(msg)
    local b = proxy_pb.RResult()
    b:ParseFromString(msg.body)
    if b.code == 1 then
        panelClub.NoticeContent = groupNoticeObjTable.noticeInput:GetComponent('UIInput').value
        panelClub.OnGetNotice()
        panelMessageTip.SetParamers('修改成功', 1.5)
        PanelManager.Instance:ShowWindow('panelMessageTip')
    end
end


--解散设置确定
function this.OnDissolveOKClick(go)
    --print("OnDissolveOKClick was called");
    AudioManager.Instance:PlayAudio('btn');

    local msg, body = this.GetMessageBody();
    --申请解散方式
    local dissolveType = panelClub.clubInfo.dissolveType;
    if dissolveModeObjTable.toggleAll:GetComponent("UIToggle").value then
        dissolveType = 0;
    elseif dissolveModeObjTable.toggleHalf:GetComponent("UIToggle").value then
        dissolveType = 1;
    elseif dissolveModeObjTable.toggleForbidden:GetComponent("UIToggle").value then
        dissolveType = 3;
    end
    body.dissolveType = dissolveType;
    --申请解散等待时间
    local dissolveTime = panelClub.clubInfo.waitTime;
    if dissolveModeObjTable.toggleDissolve1:GetComponent("UIToggle").value then
        dissolveTime = 1;
    elseif dissolveModeObjTable.toggleDissolve3:GetComponent("UIToggle").value then
        dissolveTime = 3;
    elseif dissolveModeObjTable.toggleDissolve5:GetComponent("UIToggle").value then
        dissolveTime = 5;
    end
    body.waitTime = dissolveTime;

    local dissolveLimit = proxy_pb.UNLIMITED;
    if dissolveModeObjTable.toggleUnlimited:GetComponent("UIToggle").value then
        dissolveLimit = proxy_pb.UNLIMITED;
    elseif dissolveModeObjTable.toggleApply5times:GetComponent("UIToggle").value then
        dissolveLimit = proxy_pb.FIVE_TIMES;
    elseif dissolveModeObjTable.toggleInterval:GetComponent("UIToggle").value then
        dissolveLimit = proxy_pb.FIVE_SECONDS;
    end

    body.dissolveLimit = dissolveLimit;
    body.autoDissolveTime=tonumber(string.sub(dissolveModeObjTable.autoDissolveTimeValueLable:GetComponent('UILabel').text,1,-7))

    msg.body = body:SerializeToString();
    this.SendMessage(msg,function ()
       --设置提示
        this.SetDissolveTips();
    end)


end

--小黑屋设置
function this.OnDarkHouseOKClick(go)
    --print("OnDarkHouseOKClick was called");
    AudioManager.Instance:PlayAudio('btn');
    local isTure = panelClub.clubInfo.autoBlackHouse;
    local blackValue = panelClub.clubInfo.blackHouseValue;
    isTure = darkHouseOjbTable.toggleDHOn:GetComponent("UIToggle").value;
    blackValue = darkHouseOjbTable.tiredValueInput:GetComponent("UIInput").value;
    local msg, body = this.GetMessageBody();
    body.autoBlackHouse = isTure;
    body.blackHouseValue = tonumber(blackValue);
    msg.body = body:SerializeToString()
    this.SendMessage(msg, function ()
       --T设置提示
        this.SetDarkHouseTips();
    end)

end

--营业设置
function this.OnBusinessModeOKClick(go)
    --print("OnBusinessModeOKClick was called");
    AudioManager.Instance:PlayAudio('btn');
    local msg, body = this.GetMessageBody()
    local pauseRoom = panelClub.clubInfo.pauseRoom;
    local pauseInfo = panelClub.clubInfo.pauseInfo;
    pauseRoom = businessModeObjTable.toggleBMOff:GetComponent("UIToggle").value;
    pauseInfo = businessModeObjTable.inputBM:GetComponent("UIInput").value;
    body.pauseRoom = pauseRoom;
    body.pauseInfo = pauseInfo;
    body.allowMinus = businessModeObjTable.fuFeeOn:GetComponent("UIToggle").value
    print('body.allowMinus : '..tostring(body.allowMinus))
    msg.body = body:SerializeToString()

    this.SendMessage(msg, function ()
        --设置提示
        this.SetBusinessModeTips();
    end)

end

--其他设置
function this.OnOtherSettingOKClick(go)
    --print("OnOtherSettingOKClick was called");
    AudioManager.Instance:PlayAudio('btn');
    local msg, body = this.GetMessageBody()
    --自动准备
    local autpReady = panelClub.clubInfo.autoReady;
    autpReady = otherSettingObjTable.toggleAuto:GetComponent("UIToggle").value;
    --牌桌最多显示
    local deskNum = panelClub.clubInfo.deskNum;
    if otherSettingObjTable.toggleNoLimit:GetComponent("UIToggle").value then
        deskNum = -1;
    elseif otherSettingObjTable.toggleIfStart:GetComponent("UIToggle").value then
        deskNum = 0;
    elseif otherSettingObjTable.toggleTable10:GetComponent("UIToggle").value then
        deskNum = 10;
    elseif otherSettingObjTable.toggleTable2:GetComponent("UIToggle").value then
        deskNum = 2;
    elseif otherSettingObjTable.toggleTable5:GetComponent('UIToggle').value then
        deskNum = 5
    elseif otherSettingObjTable.toggleTable20:GetComponent("UIToggle").value then
        deskNum = 20;
    elseif otherSettingObjTable.toggleTable30:GetComponent("UIToggle").value then
        deskNum = 30;
    elseif otherSettingObjTable.toggleTable40:GetComponent('UIToggle').value then
        deskNum = 40
    end
    --创建私密房间
    local private = panelClub.clubInfo.privateRoom;
    private = otherSettingObjTable.togglePrivatePermit:GetComponent("UIToggle").value;

    --创建公共房间
    local public = panelClub.clubInfo.publicRoom;
    public = otherSettingObjTable.togglePublicPermit:GetComponent("UIToggle").value;

    local quitAllowed = otherSettingObjTable.memeberOutToggleOn:GetComponent("UIToggle").value;
    local sendMsgAllowed = otherSettingObjTable.sendTextAndEmojiToggleOn:GetComponent("UIToggle").value;
    local sendVoiceAllowed = otherSettingObjTable.sendAudioToggleOn:GetComponent("UIToggle").value;
	local showManage = 0
	if otherSettingObjTable.totalMemberNoCanSee:GetComponent("UIToggle").value then
		showManage = 0
	elseif otherSettingObjTable.limitManageCanSee:GetComponent("UIToggle").value then
		showManage = 1
	elseif otherSettingObjTable.manageCanSee:GetComponent("UIToggle").value then
		showManage = 2
	elseif otherSettingObjTable.totalManageHomeCanSee:GetComponent("UIToggle").value then
		showManage = 3
	end

    local agreeMenberJoin = true
	if otherSettingObjTable.agreeJoin:GetComponent("UIToggle").value then
		agreeMenberJoin = true
	elseif otherSettingObjTable.disagreeJoin:GetComponent("UIToggle").value then
		agreeMenberJoin = false
    end
    
    local deleteAllowed = otherSettingObjTable.allowDeleteToggleOn:GetComponent("UIToggle").value;
    --允许玩家直接邀请成员
    body.privateRoom        = private;
    body.publicRoom         = public;
    body.autoReady          = autpReady;
    body.desks              = deskNum;
    body.quitAllowed        = quitAllowed
    body.sendMsgAllowed     = sendMsgAllowed
    body.sendVoiceAllowed   = sendVoiceAllowed
    body.phzAutoDissolve    = otherSettingObjTable.phzAutoDissolve;
	body.deskDirect 		= otherSettingObjTable.emptyTablePositionAhead:GetComponent("UIToggle").value
	body.showBigWin			= otherSettingObjTable.showBigWinOn:GetComponent("UIToggle").value
	body.showLordBalance    = showManage	
    body.applyClub	        = agreeMenberJoin
    body.noActive           = otherSettingObjTable.allowInactiveQuit:GetComponent("UIToggle").value==true and tonumber(otherSettingObjTable.allowValueLable:GetComponent("UILabel").text) or 0   
    
    body.generalExit        = body.noActive~=0
	body.managerExit		= otherSettingObjTable.managerMember:GetComponent("UIToggle").value
    body.playNotActive      = otherSettingObjTable.allowNoGameQuit:GetComponent("UIToggle").value
    body.generalNotPlay	    = body.playNotActive
    body.managerNotPlay     = otherSettingObjTable.managerMemberNoGame:GetComponent("UIToggle").value
	body.ratioSetup			= otherSettingObjTable.showScaleBigWinOn:GetComponent("UIToggle").value

    body.deleteAllowed	        = deleteAllowed
    print('body.deskDirect : '..tostring(body.deskDirect))
	print('body.showBigWin : '..tostring(body.showBigWin))
    print("quitAllowed", quitAllowed)
    print("deleteAllowed", deleteAllowed)
    print('phzAutoDissolve : '.. body.phzAutoDissolve)
    msg.body = body:SerializeToString()
    this.SendMessage(msg, function ()
        -- 设置提醒
        this.SetOtherSettingTips()
    end)
end

function this.OnActiveSettingOKClick(go)
    AudioManager.Instance:PlayAudio('btn')
    local msg = Message.New()
    msg.type = proxy_pb.UPDATE_CLUB_RANK_LIST
    local body = proxy_pb.PUpdateRankList()
    body.clubId = panelClub.clubInfo.clubId
    body.timesAllowed = activeSettingObjTable.toggleTotalFieldRank:GetComponent("UIToggle").value
    body.validTimesAllowed = activeSettingObjTable.toggleUsefulFieldRank:GetComponent("UIToggle").value
    body.bigTimesAllowed = activeSettingObjTable.toggleWinPlayerRank:GetComponent("UIToggle").value
    body.feeAllowed = activeSettingObjTable.toggleFeeValueRank:GetComponent("UIToggle").value
    body.managerAllowed = activeSettingObjTable.toggleManageFieldRank:GetComponent("UIToggle").value
    body.butlerAllowed = activeSettingObjTable.toggleManageDirectBranchFieldRank:GetComponent("UIToggle").value
    body.myButlerAllowed = activeSettingObjTable.toggleMyManageFieldRank:GetComponent("UIToggle").value
    body.myUserAllowed = activeSettingObjTable.toggleMyMenberFieldRank:GetComponent("UIToggle").value
	print('timesAllowed : '..tostring(body.timesAllowed)..' validTimesAllowed : '..tostring(body.validTimesAllowed)..' bigTimesAllowed : '..tostring(body.bigTimesAllowed)..' feeAllowed : '..tostring(body.feeAllowed)..' managerAllowed : '..tostring(body.managerAllowed)..' butlerAllowed : '..tostring(body.butlerAllowed)..' myButlerAllowed : '..tostring(body.myButlerAllowed)..' myUserAllowed : '..tostring(body.myUserAllowed))
    msg.body = body:SerializeToString()
    SendProxyMessage(msg, function (msg)
        local data = proxy_pb.RResult()
        data:ParseFromString(msg.body)
        if data.code == 1 then
            panelClub.shuaXinClub()
            panelMessageTip.SetParamers('修改成功', 1.5)
            PanelManager.Instance:ShowWindow('panelMessageTip')
        end
    end)
end

function this.OnClickStopRoom(go)
    AudioManager.Instance:PlayAudio('btn');
    --print("OnClickStopRoom was called");
    -- 设置提示
    this.SetBusinessModeTips();
end

function this.OnClickSetPauseInfo(go)
    local str = PauseRoomPanel.transform:Find('input'):GetComponent('UIInput').value
    if string.len(str)/3 > 20 then
        panelMessageTip.SetParamers('文字控制在20字以内', 1)
        PanelManager.Instance:ShowWindow('panelMessageTip')
        return
    end

    this.SetpauseRoomInfo(true, str)
end

function this.OnClickDissolveType(go)
    AudioManager.Instance:PlayAudio('btn');
    --print("OnClickDissolveType was called");
    -- 设置提示
    this.SetDissolveTips();
end



function this.OnClickDissolveTime(go)
    AudioManager.Instance:PlayAudio('btn');
    --print("OnClickDissolveTime was called");
    -- 设置提示
    this.SetDissolveTips();
end

function this.OnClickDissolveLimit(go)
    AudioManager.Instance:PlayAudio('btn');

    this.SetkDissolveLimitTips();
end

function this.OnClickAutoDissolveTimeChange(go)
    AudioManager.Instance:PlayAudio('btn');
    local label_= dissolveModeObjTable.autoDissolveTimeValueLable:GetComponent('UILabel').text
    local timeNum=tonumber(string.sub(label_,1,-7))
	if dissolveModeObjTable.autoDissolveTimeAddButton.gameObject == go then
		timeNum = timeNum + 1
		if timeNum > 30 then
			timeNum = 1
		end
	else
		timeNum = timeNum - 1
		if timeNum < 1 then
			timeNum = 30
		end
	end
    dissolveModeObjTable.autoDissolveTimeValueLable:GetComponent('UILabel').text = timeNum..'分钟'
end

function this.OnClickAutoReady(go)
    AudioManager.Instance:PlayAudio('btn');
    --print("OnClickAutoReady was called");
    -- 设置提示
    --this.SetAutoReady(ClubInfo.AutoReadyToggle.value)
    this.SetOtherSettingTips();
end


function this.OnClickTableShow(go)
    AudioManager.Instance:PlayAudio('btn');
    --print("OnClickAutoReady was called");
    this.SetOtherSettingTips();
end


function this.OnClickMemberInvite(go)
    AudioManager.Instance:PlayAudio('btn');
    --print("OnClickAutoReady was called");
    this.SetOtherSettingTips();
end

function this.OnClickSetPrivateRoom(go)
    AudioManager.Instance:PlayAudio('btn');
    --print("OnClickSetPrivateRoom was called");
    -- 设置提示
    this.SetOtherSettingTips();

end

function this.OnClickSetPublicRoom(go)
    AudioManager.Instance:PlayAudio('btn');
    --print("OnClickSetPrivateRoom was called");
    -- 设置提示
    this.SetOtherSettingTips();

end

function this.OnClickDarkHouse(go)

    AudioManager.Instance:PlayAudio('btn');
    --print("OnClickDissolveType was called");
    -- 设置提示
    this.SetDarkHouseTips();
end




function this.OnClickCreate(go)
    AudioManager.Instance:PlayAudio('btn')
    PanelManager.Instance:HideAllWindow()
	PanelManager.Instance:ShowWindow('panelClubHome','panelClub');
end

function this.OnClickDelet(go)
    AudioManager.Instance:PlayAudio('btn')
    if panelClub.clubInfo.userType==proxy_pb.LORD then
        --print("进的这：1")
        panelMessageBoxTiShi.SetParamers(OK_CANCLE, this.DeletClub, nil, '该操作不可逆，请确认是否解散该牌友群！', '确 定')
		PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
    else
        if panelClub.clubInfo.userType==proxy_pb.MANAGER then
            --print("进的这：2")
			panelMessageBoxTiShi.SetParamers(OK_CANCLE, this.QuitClub, nil, '是否确定退出本群？ 若退出成功，则您的直属玩家将全部从本群移除；请谨慎操作！', '确 定')
			
        else
            --print("进的这：3")
			panelMessageBoxTiShi.SetParamers(OK_CANCLE, this.QuitClub, nil, '该操作不可逆，请确认是否退出该牌友群！', '确 定')
		end
		PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
    end
end

function this.OnClickCollection(go)
    local isEnable = ClubInfo.collectionToggle.value
    this.SetCollection(isEnable)
end

function this.DeletClub()
    local msg = Message.New()
    msg.type = proxy_pb.DELETE_CLUB
	local body = proxy_pb.PDeleteClub()
	body.clubId = panelClub.clubInfo.clubId
    msg.body = body:SerializeToString()
    --print('我发送的msg'..msg.body)
    SendProxyMessage(msg, function (msg)
        local b = proxy_pb.RResult()
        b:ParseFromString(msg.body)
        if b.code == 1 then
            PanelManager.Instance:HideWindow(gameObject.name)
            panelMessageTip.SetParamers('您已成功解散“'..panelClub.clubInfo.name..'”牌友群', 1.5)
            PanelManager.Instance:ShowWindow('panelMessageTip')
        end
    end);
end

function this.QuitClub()
    local msg = Message.New()
    msg.type = proxy_pb.CLUB_USER_MANAGE
	local body = proxy_pb.PClubUserManage()
	body.clubId = panelClub.clubInfo.clubId
	body.userId = info_login.id
	body.operation = proxy_pb.QUIT
	msg.body = body:SerializeToString()
    SendProxyMessage(msg, function (msg)
        local b = proxy_pb.RResult()
        b:ParseFromString(msg.body)
        if b.code == 1 then
            PanelManager.Instance:HideWindow(gameObject.name)
            panelMessageTip.SetParamers('您已成功退出“'..panelClub.clubInfo.name..'”牌友群', 1.5)
            PanelManager.Instance:ShowWindow('panelMessageTip')
        end
    end);
end

function this.SetName(name)
    local msg, body = this.GetMessageBody()
    body.name = name
    msg.body = body:SerializeToString()
    this.SendMessage(msg, nil)
end

function this.OnDefResult(msg)
        local b = proxy_pb.RResult()
        b:ParseFromString(msg.body)
        if b.code == 1 then
            panelMessageTip.SetParamers('修改成功', 1.5)
            PanelManager.Instance:ShowWindow('panelMessageTip')
        end
end

function this.SetCollection(isEnable)
    local msg, body = this.GetMessageBody()
    body.lobby = isEnable
    msg.body = body:SerializeToString()
    this.SendMessage(msg, function ()
        ClubInfo.collectionToggle:Set(isEnable)
        ClubInfo.collectionLabel.text = (isEnable and '已开启' or '未开启')
    end)
end

function this.GetMessageBody()
    local msg = Message.New()
    msg.type = proxy_pb.UPDATE_CLUB
    local body = proxy_pb.PUpdateClub()
    body.clubId = panelClub.clubInfo.clubId
    return msg, body
end

function this.SendMessage(msg, func)
    SendProxyMessage(msg, function (data)
        local b = proxy_pb.RResult()
        b:ParseFromString(data.body)
        --print(b.code)
        if b.code == 1 then
            if func ~= nil then
                func()
            end
            panelClub.shuaXinPlays(panelClub.clubInfo.clubId)
            panelMessageTip.SetParamers('修改成功', 1.5)
            PanelManager.Instance:ShowWindow('panelMessageTip')
        end
    end)
end

function this.GetClubNotice(go)

    local msg = Message.New()
    msg.type = proxy_pb.CLUB_NOTICE;
    local body=proxy_pb.PClubNotice()
    body.clubId=panelClub.clubInfo.clubId
    msg.body = body:SerializeToString()
    SendProxyMessage(msg, this.OnGetClubNotice);
end

function this.OnGetClubNotice(msg)
    local b = proxy_pb.RClubNotice();
    b:ParseFromString(msg.body);
    this.SetClubNotice(b)
end

function this.SetClubNotice(data)
    local str
    if data.content ~= '' then
        str = data.content
    else
        if data.canEdit then
            str = '输入公告内容'
        else
            str = '暂无公告'
        end
    end

    groupNoticeObjTable.noticeInput:GetComponent("UIInput").value = str;
    groupNoticeObjTable.OKButton.gameObject:SetActive(IsCanSetGonggao())
end


function this.OnToggleGroupInfoClick(go)
    --print("OnToggleGroupInfoClick was called");
    AudioManager.Instance:PlayAudio('btn');
    this.InitGroupInfo();
end

function this.OnToggleGroupNoticeClick(go)
    AudioManager.Instance:PlayAudio('btn');
    --print("OnToggleGroupNoticeClick was called");
    this.InitGroupNotice();
    this.GetClubNotice(go);
end

function this.OnToggleDissolveClick(go)
    AudioManager.Instance:PlayAudio('btn');
    --print("OnToggleDissolveClick was called");

    this.InitDissolveMode();
end

function this.OnToggleDarkHouseClick(go)
    AudioManager.Instance:PlayAudio('btn');
    --print("OnToggleDarkHouseClick was called");

    this.InitDarkHouse(go);
end

function this.OnToggleBusinessInfoClick(go)
    AudioManager.Instance:PlayAudio('btn');
    --print("OnToggleBusinessInfoClick was called");

    this.InitBusinessMode();
end

function this.OnToggleOtherSettingInfoClick(go)
    AudioManager.Instance:PlayAudio('btn');
    --print("OnToggleOtherSettingInfoClick was called");
    this.InitOtherSetting();
end

function this.OnToggleActiveSettingInfoClick(go)
    AudioManager.Instance:PlayAudio('btn')
    this.InitActiveSetting()
end

function this.OnToggleSendTextAndEmojiClick(go)
    AudioManager.Instance:PlayAudio('btn')
    this.SetOtherSettingTips()
end

function this.OnHuangDissolveToggleLimitClick(go)
    AudioManager.Instance:PlayAudio('btn');
    this.SetOtherSettingTips();
    if otherSettingObjTable.huangDissolveToggleNoLimit.gameObject == go then
        otherSettingObjTable.limitAddButton.parent.gameObject:SetActive(false);
        otherSettingObjTable.phzAutoDissolve = 0;
    elseif otherSettingObjTable.huangDissolveToggleLimit.gameObject == go then
        otherSettingObjTable.limitAddButton.parent.gameObject:SetActive(true);
		otherSettingObjTable.phzAutoDissolve = 1
        otherSettingObjTable.limitValueLable:GetComponent("UILabel").text = otherSettingObjTable.phzAutoDissolve.."局";
    end
end

function this.OnAllowInactiveQuitClick(go)
    AudioManager.Instance:PlayAudio('btn')
    this.SetOtherSettingTips()
    if otherSettingObjTable.allowInactiveQuit.gameObject == go then
        otherSettingObjTable.allowAddButton.parent.gameObject:SetActive(true)
        otherSettingObjTable.fomalMember.gameObject:SetActive(true)
        otherSettingObjTable.managerMember.gameObject:SetActive(true)
        otherSettingObjTable.allowNoGameQuit.parent.gameObject:SetActive(true)
    elseif otherSettingObjTable.forbidInactiveQuit.gameObject == go then
        otherSettingObjTable.allowAddButton.parent.gameObject:SetActive(false)
        otherSettingObjTable.fomalMember.gameObject:SetActive(false)
        otherSettingObjTable.managerMember.gameObject:SetActive(false)
        otherSettingObjTable.allowNoGameQuit.parent.gameObject:SetActive(false)
    end
end

function this.OnAllowNoGameQuitClick(go)
    AudioManager.Instance:PlayAudio('btn')
    this.SetOtherSettingTips()
    if otherSettingObjTable.allowNoGameQuit.gameObject == go then
        otherSettingObjTable.fomalMemberNoGame.gameObject:SetActive(true)
        otherSettingObjTable.managerMemberNoGame.gameObject:SetActive(true)

    elseif otherSettingObjTable.forbidNoGameQuit.gameObject == go then
        otherSettingObjTable.fomalMemberNoGame.gameObject:SetActive(false)
        otherSettingObjTable.managerMemberNoGame.gameObject:SetActive(false)
    end
end

function this.OnEmptyTablePositionClick(go)
    AudioManager.Instance:PlayAudio('btn');
    this.SetOtherSettingTips();
end

function this.OnShowBigWinClick(go)
    AudioManager.Instance:PlayAudio('btn');
    this.SetOtherSettingTips();
end

function this.OnShowScaleBigWinClick(go)
    AudioManager.Instance:PlayAudio('btn');
    this.SetOtherSettingTips();
end

function this.OnShowManageDiamondClick(go)
    AudioManager.Instance:PlayAudio('btn');
    this.SetOtherSettingTips();
end

function this.OnApplyMemberJoinClick(go)
    AudioManager.Instance:PlayAudio('btn');
    this.SetOtherSettingTips();
end

function this.OnChangeHuangLimitValueClick(go)
    print("OnChangeHuangLimitValueClick was called");
    AudioManager.Instance:PlayAudio('btn');
    otherSettingObjTable.phzAutoDissolve = otherSettingObjTable.phzAutoDissolve == 0 and 1 or otherSettingObjTable.phzAutoDissolve;
    if go == otherSettingObjTable.limitAddButton.gameObject  then
        if otherSettingObjTable.phzAutoDissolve < 20 then
            otherSettingObjTable.phzAutoDissolve = otherSettingObjTable.phzAutoDissolve + 1;
        end

    elseif go == otherSettingObjTable.limitSubButton.gameObject  then
        if otherSettingObjTable.phzAutoDissolve >= 2 then
            otherSettingObjTable.phzAutoDissolve = otherSettingObjTable.phzAutoDissolve -1;
        end

    end

    otherSettingObjTable.limitValueLable:GetComponent("UILabel").text = otherSettingObjTable.phzAutoDissolve.."局";


end

function this.OnChangeAllowDaysValueClick(go)
    print("OnChangeAllowDaysValueClick was called");
    AudioManager.Instance:PlayAudio('btn');
    local daysNum=tonumber(otherSettingObjTable.allowValueLable:GetComponent("UILabel").text)
    if go == otherSettingObjTable.allowAddButton.gameObject  then
        if daysNum < 90 then
            daysNum = daysNum + 1;
        end
    elseif go == otherSettingObjTable.allowSubButton.gameObject  then
        if daysNum > 20 then
            daysNum = daysNum -1;
        end
    end
    otherSettingObjTable.allowValueLable:GetComponent("UILabel").text = daysNum;
end

function this.OnToggleSendAudioClick(go)
    AudioManager.Instance:PlayAudio('btn')
    this.SetOtherSettingTips()
end

function this.OnToggleMemberOutClick(go)
    AudioManager.Instance:PlayAudio('btn')
    this.SetOtherSettingTips()
    if otherSettingObjTable.memeberOutToggleOff:GetComponent("UIToggle").value then
        otherSettingObjTable.allowInactiveQuit.parent.gameObject:SetActive(true)
        otherSettingObjTable.allowNoGameQuit.parent.gameObject:SetActive(otherSettingObjTable.allowInactiveQuit:GetComponent("UIToggle").value)
    else
        otherSettingObjTable.allowInactiveQuit.parent.gameObject:SetActive(false)
        otherSettingObjTable.allowNoGameQuit.parent.gameObject:SetActive(false)
    end
end

function this.OnToggleAllowDeleteClick(go)
    AudioManager.Instance:PlayAudio('btn')
    this.SetOtherSettingTips()
end

function this.SetDissolveTips()
    if dissolveModeObjTable.toggleAll:GetComponent("UIToggle").value then
        dissolveModeObjTable.dissolveTypeTip:GetComponent("UILabel").text = "（选择后，需要牌桌中的玩家全部同意才能解散）";
    elseif dissolveModeObjTable.toggleHalf:GetComponent("UIToggle").value then
        dissolveModeObjTable.dissolveTypeTip:GetComponent("UILabel").text = "（选择后，需要牌桌中的玩家超过一半才能解散）";
    elseif dissolveModeObjTable.toggleForbidden:GetComponent("UIToggle").value then
        dissolveModeObjTable.dissolveTypeTip:GetComponent("UILabel").text = "（选择后，玩家将无法申请解散房间）";
    end

    if dissolveModeObjTable.toggleDissolve1:GetComponent("UIToggle").value then
        dissolveModeObjTable.dissolveTimeTip:GetComponent("UILabel").text = "（选择后，房间在等待1分钟后自动解散）";
    elseif dissolveModeObjTable.toggleDissolve3:GetComponent("UIToggle").value then
        dissolveModeObjTable.dissolveTimeTip:GetComponent("UILabel").text = "（选择后，房间在等待3分钟后自动解散）";
    elseif dissolveModeObjTable.toggleDissolve5:GetComponent("UIToggle").value then
        dissolveModeObjTable.dissolveTimeTip:GetComponent("UILabel").text = "（选择后，房间在等待5分钟后自动解散）";
    end
end

function this.SetDarkHouseTips()
    if darkHouseOjbTable.toggleDHOn:GetComponent("UIToggle").value then
        darkHouseOjbTable.darkHouseTip:GetComponent("UILabel").text = "（选择后，玩家在满足自动加入小黑屋条件时进入小黑屋，不可再进入房间";
    else
        darkHouseOjbTable.darkHouseTip:GetComponent("UILabel").text = "（选择后，玩家不会被系统自动拉入小黑屋）"
    end
end


function this.SetBusinessModeTips()
    if businessModeObjTable.toggleBMOff:GetComponent("UIToggle").value then
        businessModeObjTable.pauseRoomTip:GetComponent("UILabel").text = "（选择后，玩家不可再创建新的房间，已创建的房间玩家进入不受影响）"
    else
        businessModeObjTable.pauseRoomTip:GetComponent("UILabel").text = "（选择后，玩家可自由创建房间）"
    end
	if businessModeObjTable.fuFeeOn:GetComponent("UIToggle").value then
        businessModeObjTable.fuFeeTip:GetComponent("UILabel").text = "（选择后，群成员在对局结束后，疲劳值不够允许负疲劳值进行结算）"
    else
		businessModeObjTable.fuFeeTip:GetComponent("UILabel").text = "（选择后，群成员在对局结束后，疲劳值不够不允许负疲劳值进行结算）"
    end
end

function this.OnClickFuFee()
	this.SetBusinessModeTips()
    --[[if businessModeObjTable.fuFeeOff:GetComponent("UIToggle").value then
		panelMessageBoxTiShi.SetParamers(ONLY_OK, nil, nil, '在不允许出现负疲劳值模式下，所有玩法“自动解散最低疲劳值”将无效，但是玩家在游戏过程中，如果疲劳值为0时，房间将自动解散')
		PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
    end]]
end

function this.SetOtherSettingTips()
    if otherSettingObjTable.toggleAuto:GetComponent("UIToggle").value then
        otherSettingObjTable.autoReadyTip:GetComponent("UILabel").text = "（选择后，玩家进入房间不需要需要点击准备，游戏可直接开始）";
    else
        otherSettingObjTable.autoReadyTip:GetComponent("UILabel").text = "（选择后，玩家进入房间需要点击准备，所有玩家均点击准备后游戏方可开始）";
    end

    -- 需要跟服务器对接口，现在没有接口，先弄个默认值
    if otherSettingObjTable.toggleNoLimit:GetComponent("UIToggle").value then
        otherSettingObjTable.tableSettingTip:GetComponent("UILabel").text = "（选择后，大厅中的牌桌根据实际情况全部进行显示）";
    elseif otherSettingObjTable.toggleIfStart:GetComponent("UIToggle").value then
        otherSettingObjTable.tableSettingTip:GetComponent("UILabel").text = "（选择后，已开始的牌桌不在大厅中进行显示）";
    elseif otherSettingObjTable.toggleTable10:GetComponent("UIToggle").value then
        otherSettingObjTable.tableSettingTip:GetComponent("UILabel").text = "（选择后，玩法标签最多显示10桌，集合大厅最多显示300桌）";
    elseif otherSettingObjTable.toggleTable2:GetComponent("UIToggle").value then
        otherSettingObjTable.tableSettingTip:GetComponent("UILabel").text = "（选择后，玩法标签最多显示2桌，集合大厅最多显示60桌）";
    elseif otherSettingObjTable.toggleTable5:GetComponent("UIToggle").value then
        otherSettingObjTable.tableSettingTip:GetComponent("UILabel").text = "（选择后，玩法标签最多显示5桌，集合大厅最多显示150桌）";
    elseif otherSettingObjTable.toggleTable20:GetComponent("UIToggle").value then
        otherSettingObjTable.tableSettingTip:GetComponent("UILabel").text = "（选择后，玩法标签最多显示20桌，集合大厅最多显示600桌）";
    elseif otherSettingObjTable.toggleTable30:GetComponent("UIToggle").value then
        otherSettingObjTable.tableSettingTip:GetComponent("UILabel").text = "（选择后，玩法标签最多显示30桌，集合大厅最多显示900桌）";
    elseif otherSettingObjTable.toggleTable40:GetComponent("UIToggle").value then
        otherSettingObjTable.tableSettingTip:GetComponent("UILabel").text = "（选择后，玩法标签最多显示40桌，集合大厅最多显示1200桌）";
    end

    if otherSettingObjTable.toggleIfStart:GetComponent("UIToggle").value then
        otherSettingObjTable.tableSettingTip:GetComponent("UILabel").text = "（选择后，已开始的牌桌不在大厅中进行显示）";
    end

    if otherSettingObjTable.togglePrivatePermit:GetComponent("UIToggle").value then
        otherSettingObjTable.privateRoomTip:GetComponent("UILabel").text = "（选择后，显示开房空桌，允许玩家创建私密房，其余玩家进入需要输入房间号）";
    else
        otherSettingObjTable.privateRoomTip:GetComponent("UILabel").text = "（选择后，不允许玩家创建私密房，若同时不允许创建公共房，则不显示开房空桌）";
    end

    if otherSettingObjTable.togglePublicPermit:GetComponent("UIToggle").value then
        otherSettingObjTable.publicRoomTip:GetComponent("UILabel").text = "（选择后，显示开房空桌，允许玩家自由创建公共房）";
    else
        otherSettingObjTable.publicRoomTip:GetComponent("UILabel").text = "（选择后，不允许玩家创建公共房，若同时不允许创建私密房，则不显示开房空桌）";
    end

    --TODO 需要跟服务器对接口，现在没有接口，先弄个默认值
    if otherSettingObjTable.toggleInviteMemeberPermit:GetComponent("UIToggle").value then
        otherSettingObjTable.memberInviteTip:GetComponent("UILabel").text = "（选择后，玩家能够添加成员、邀请好友，但需群主或有权限的管理员同意才能加入）";
    else
        otherSettingObjTable.memberInviteTip:GetComponent("UILabel").text = "（选择后，玩家不可以添加成员、邀请好友）";
    end

    if otherSettingObjTable.memeberOutToggleOn:GetComponent("UIToggle").value then
        otherSettingObjTable.memeberOutTip:GetComponent("UILabel").text = "（选择后，群成员可以自行退出牌友群）"
    else
        otherSettingObjTable.memeberOutTip:GetComponent("UILabel").text = "（选择后，群成员将无法自己退出牌友群）"
    end

    if otherSettingObjTable.sendTextAndEmojiToggleOn:GetComponent("UIToggle").value then
        otherSettingObjTable.sendTextAndEmojiTip:GetComponent("UILabel").text = "（选择后，群成员可以在游戏过程中发送快捷信息与表情）"
    else
        otherSettingObjTable.sendTextAndEmojiTip:GetComponent("UILabel").text = "（选择后，群成员不可以在游戏过程中发送快捷信息与表情）"
    end

    if otherSettingObjTable.sendAudioToggleOn:GetComponent("UIToggle").value then
        otherSettingObjTable.sendAudioTip:GetComponent("UILabel").text = "（选择后，群成员可以在游戏过程中发送语音）"
    else
        otherSettingObjTable.sendAudioTip:GetComponent("UILabel").text = "（选择后，群成员不可以在游戏过程中发送语音）"
    end

    if otherSettingObjTable.huangDissolveToggleNoLimit:GetComponent("UIToggle").value then
        otherSettingObjTable.huangLimitTip:GetComponent("UILabel").text = "（选择后，不限制跑胡子荒庄次数，不会自动解散）";
    else
        otherSettingObjTable.huangLimitTip:GetComponent("UILabel").text = "（选择后，任意成员不连续荒庄设置的次数，房间自动解散）";
    end
	
	if otherSettingObjTable.emptyTablePositionAhead:GetComponent("UIToggle").value then
        otherSettingObjTable.emptyTablePositionTip:GetComponent("UILabel").text = "（选择后，集合大厅没有人的桌子按顺序排在已开始对局的牌桌前面）";
    else
        otherSettingObjTable.emptyTablePositionTip:GetComponent("UILabel").text = "（选择后，集合大厅没有人的桌子按顺序排在已开始对局的牌桌后面）";
    end
	
	if otherSettingObjTable.showBigWinOn:GetComponent("UIToggle").value then
        otherSettingObjTable.showBigWinTip:GetComponent("UILabel").text = "（选择后，普通成员在群战绩可以看见大赢家疲劳值）";
    else
        otherSettingObjTable.showBigWinTip:GetComponent("UILabel").text = "（选择后，普通成员在群战绩不可以看见大赢家疲劳值）";
    end
			
	if otherSettingObjTable.showScaleBigWinOn:GetComponent("UIToggle").value then
        otherSettingObjTable.showScaleBigWinTip:GetComponent("UILabel").text = "（选择后，管家在比例设置可以看见每个玩法的大赢家疲劳值）";
    else
        otherSettingObjTable.showScaleBigWinTip:GetComponent("UILabel").text = "（选择后，管家在比例设置不能看见每个玩法的大赢家疲劳值）";
    end

	if otherSettingObjTable.totalMemberNoCanSee:GetComponent("UIToggle").value then
		otherSettingObjTable.showManageDiamondTip:GetComponent("UILabel").text = "（选择后，所有成员都不能看见群主剩余钻石数量）";
	elseif otherSettingObjTable.limitManageCanSee:GetComponent("UIToggle").value then
		otherSettingObjTable.showManageDiamondTip:GetComponent("UILabel").text = "（选择后，只有“可操作所有成员”权限的管理员能看见群主剩余钻石数量）";
	elseif otherSettingObjTable.manageCanSee:GetComponent("UIToggle").value then
		otherSettingObjTable.showManageDiamondTip:GetComponent("UILabel").text = "（选择后，只有管理员能看见群主剩余钻石数量）";
	elseif otherSettingObjTable.totalManageHomeCanSee:GetComponent("UIToggle").value then
		otherSettingObjTable.showManageDiamondTip:GetComponent("UILabel").text = "（选择后，除普通成员以外，所有管家都能看见群主剩余钻石数量）";
	end
    
    if otherSettingObjTable.agreeJoin:GetComponent("UIToggle").value then
		otherSettingObjTable.applyMemberJoinTip:GetComponent("UILabel").text = "（选择后，允许任何玩家申请加入牌友群）";
	elseif otherSettingObjTable.disagreeJoin:GetComponent("UIToggle").value then
		otherSettingObjTable.applyMemberJoinTip:GetComponent("UILabel").text = "（选择后，不允许玩家申请加入牌友群）";
    end

    if otherSettingObjTable.allowInactiveQuit:GetComponent("UIToggle").value then
        otherSettingObjTable.allowInactiveQuitTip:GetComponent("UILabel").text = "（选择后，群成员如果达到设置的天数没有进行游戏过，可自行退出牌友群）";
    elseif otherSettingObjTable.forbidInactiveQuit:GetComponent("UIToggle").value then
        otherSettingObjTable.allowInactiveQuitTip:GetComponent("UILabel").text = "（选择后，群成员任何时候不能退出牌友群）";
    end

    if otherSettingObjTable.allowNoGameQuit:GetComponent("UIToggle").value then
        otherSettingObjTable.allowNoGameQuitTip:GetComponent("UILabel").text = "（选择后，在本群未游戏过的成员可以主动退群）";
    elseif otherSettingObjTable.forbidNoGameQuit:GetComponent("UIToggle").value then
        otherSettingObjTable.allowNoGameQuitTip:GetComponent("UILabel").text = "（选择后，在本群未游戏过的成员也不可以主动退群）";
    end

    if otherSettingObjTable.allowDeleteToggleOn:GetComponent("UIToggle").value then
        otherSettingObjTable.allowDeleteTip:GetComponent("UILabel").text = "（选择后，有职位的管家如果有删除成员权限，可以删除自己成员）"
    else
        otherSettingObjTable.allowDeleteTip:GetComponent("UILabel").text = "（选择后，有职位的管家不管是否有删除成员权限，都不能删除自己的成员）"
    end
end

function this.SetkDissolveLimitTips()
    if dissolveModeObjTable.toggleUnlimited:GetComponent("UIToggle").value then
        dissolveModeObjTable.toggleDissolveLimitTips:GetComponent('UILabel').text = "（选择后，申请解散没有限制，可随时申请解散）"
    elseif dissolveModeObjTable.toggleApply5times:GetComponent("UIToggle").value then
        dissolveModeObjTable.toggleDissolveLimitTips:GetComponent('UILabel').text = "（选择后，每大局每一个人只能申请解散5次，超过5次后不可申请解散）"
    elseif dissolveModeObjTable.toggleInterval:GetComponent("UIToggle").value then
        dissolveModeObjTable.toggleDissolveLimitTips:GetComponent('UILabel').text = "（选择后，申请解散若被拒绝，之后的每次申请都需要等待5秒）"
    end
end





