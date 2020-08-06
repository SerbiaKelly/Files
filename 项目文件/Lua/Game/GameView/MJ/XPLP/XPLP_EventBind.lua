require("stringTool");
XPLP_EventBind      = {};
local this          = XPLP_EventBind;
local uiLayer       = nil;
local gameUIObjects = nil;
local XPLP_Logic    = nil;
local message       = nil;
local isEventInit   = false;


function this.Init(_uiLayer,_gameUIObjects,_logic )
    print("Event bing--------------------------------");
    uiLayer         = _uiLayer;
    gameUIObjects   = _gameUIObjects;
    XPLP_Logic      = _logic;
    message         = uiLayer.gameObject:GetComponent('LuaBehaviour');
    if isEventInit then
        return ;
    end

    message:AddClick(gameUIObjects.ButtonChat.gameObject, 		                this.OnClickButtonChat)
    message:AddPress(gameUIObjects.ButtonSound.gameObject,	 	                this.OnPressButtonSound)
	message:AddClick(gameUIObjects.ButtonCloseRoom.gameObject, 	                this.OnClickButtonCloseRoom)
	message:AddClick(gameUIObjects.ButtonExitRoom.gameObject, 	                this.OnClicButtonLeaveRoom)
	message:AddClick(gameUIObjects.ButtonReady.gameObject, 		                this.OnClickButtonNext)
	message:AddClick(gameUIObjects.ButtonHu.gameObject, 		                this.OnClickOperationButton)
	message:AddClick(gameUIObjects.ButtonGang.gameObject, 		                this.OnClickOperationButton)
	message:AddClick(gameUIObjects.ButtonPeng.gameObject, 		                this.OnClickOperationButton)
	message:AddClick(gameUIObjects.ButtonChi.gameObject, 		                this.OnClickOperationButton)
	message:AddClick(gameUIObjects.ButtonGuo.gameObject, 		                this.SureGuoMsgBox)
	message:AddClick(gameUIObjects.ButtonBu.gameObject, 		                this.OnClickOperationButton)
    message:AddClick(gameUIObjects.ButtonRefresh.gameObject,	                this.OnClickButtonRefresh);
    message:AddClick(gameUIObjects.ButtonMore.gameObject, 		                this.OnClickButtonSetting);
    message:AddClick(gameUIObjects.ButtonInvite.gameObject,                     this.ShowPanelShare);
    message:AddClick(gameUIObjects.playerTingButton.gameObject,                 this.OnClickButtonTing);
    message:AddClick(gameUIObjects.panelShare:Find('xianLiao').gameObject,      this.OnClickButtonXLInvite);
    message:AddClick(gameUIObjects.panelShare:Find('friendGroup').gameObject,   this.OnClickButtonInvite);
	message:AddClick(gameUIObjects.panelShare:Find('copy').gameObject,          this.OnClickButtonCopy);
    message:AddClick(gameUIObjects.panelShare:Find('ButtonClose').gameObject,   this.ClosePanelShare);
    message:AddClick(gameUIObjects.panelShare:Find('mask').gameObject,          this.ClosePanelShare);
    message:AddClick(gameUIObjects.TrusteeShipCancelButton.gameObject,          this.OnClickCancelTrustesship);
    message:AddClick(gameUIObjects.ButtonPlatesRecord.gameObject,               this.OnClickButtonPlatesRecord);
    --箍臭
    message:AddClick(gameUIObjects.ButtonGuChou.gameObject,                     this.OnClickGuChouChoose);
    message:AddClick(gameUIObjects.ButtonNoGuChou.gameObject,                   this.OnClickGuChouChoose);
    --冲分
    message:AddClick(gameUIObjects.chongOperation:Find("Chong0").gameObject,    this.OnClickChongChoose);
    message:AddClick(gameUIObjects.chongOperation:Find("Chong1").gameObject,    this.OnClickChongChoose);
    message:AddClick(gameUIObjects.chongOperation:Find("Chong2").gameObject,    this.OnClickChongChoose);
    message:AddClick(gameUIObjects.chongOperation:Find("Chong3").gameObject,    this.OnClickChongChoose);
    message:AddClick(gameUIObjects.chongOperation:Find("Chong4").gameObject,    this.OnClickChongChoose);



    isEventInit = true;

end

--聊天按钮
function this.OnClickButtonChat(go)
    AudioManager.Instance:PlayAudio('btn');
    if uiLayer.roomData.setting.sendMsgAllowed then 
        PanelManager.Instance:ShowWindow('panelChat');
    else
        panelMessageBoxTiShi.SetParamers(ONLY_OK, nil, nil, '群主已经禁止游戏过程中聊天，如有疑问请联系群主')
        PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
    end
end

--重启按钮
function this.OnClickButtonRefresh(go)
    print("OnClickButtonRefresh---------------was called");
    AudioManager.Instance:PlayAudio('btn');
	PanelManager.Instance:RestartGame();
end

--离开房间或者解散房间（房主）
function this.OnClickButtonCloseRoom(go)
    print("OnClickButtonCloseRoom------------------------------>");
    AudioManager.Instance:PlayAudio('btn');
    if XPLP_Logic.mySeat == 0 then 
        print("房主申请解散房间---------->");
        local msg       = Message.New();
        msg.type        = uiLayer.xplp_pb.DISSOLVE;
        local body      = uiLayer.xplp_pb.PDissolve();
        body.decision   = uiLayer.xplp_pb.APPLY;
        msg.body        = body:SerializeToString();
        SendGameMessage(msg, nil);
    else
        print("玩家申请离开房间---------->");
        local msg   = Message.New()
		msg.type    = uiLayer.xplp_pb.LEAVE_ROOM;
		SendGameMessage(msg, nil)
    end
    panelInGame.fanHuiRoomNumber = nil;
end

--离开房间【还可以回来的，房间不会解散】
function this.OnClicButtonLeaveRoom(go)
    print("OnClicButtonLeaveRoom------------------------------>");
    if uiLayer.roomData.clubId == '0' then 
        print('不在在牌友群中');
        PanelManager.Instance:ShowWindow('panelLobby',uiLayer.gameObject.name);
        panelMessageTip.SetParamers('返回大厅后，您的房间将会继续保留哦', 1);
		PanelManager.Instance:ShowWindow('panelMessageTip');
    else
        print('在牌友群中');
        PanelManager.Instance:ShowWindow('panelClub',{name = uiLayer.gameObject.name})
        panelMessageTip.SetParamers('返回俱乐部后，您的房间将会继续保留哦', 1)
        PanelManager.Instance:ShowWindow('panelMessageTip')
    end
    uiLayer:ClearUI();
end

--准备按钮
function this.OnClickButtonNext(go)
    AudioManager.Instance:PlayAudio('btn');
    local msg = Message.New();
    msg.type = uiLayer.xplp_pb.READY;
    SendGameMessage(msg, nil);
end

--点击设置按钮
function this.OnClickButtonSetting(go)
    print("xplp OnClickButtonSetting---")
    local sendData      = {};
    sendData.roomData   = XPLP_Logic.roomData;
    sendData.playerSize = XPLP_Logic.totalSize;
    sendData.logic      = XPLP_Logic;
    if XPLP_Logic.roomData.round > 1 or XPLP_Logic:IsAllReaded() then 
        sendData.ingame = true;
    else
        sendData.ingame = false;
    end
    PanelManager.Instance:ShowWindow('panelGameSetting_xplp', sendData);

end

--点击操作按钮
function this.OnClickOperationButton(go)
    print("OnClickOperationButton---------------------->was called");
    local msg       = Message.New();
    local body      = uiLayer.xplp_pb.POperation();
    local myData    = XPLP_Logic:GetPlayerDataBySeat(XPLP_Logic.mySeat);
    uiLayer:OperationForbidden(myData.sealPai);
    if go == gameUIObjects.ButtonHu.gameObject then 
        uiLayer:SetWaitOpTip(myData.waitOperateTip,"请等待其他玩家操作");
        local op_mahjong    = XPLP_PlayLogic.GetOpeartionPlates(myData.operations,uiLayer.xplp_pb.HU)[1];
        body.mahjong        = op_mahjong;
        msg.type            = uiLayer.xplp_pb.HUPAI;
    elseif go == gameUIObjects.ButtonGuo.gameObject then 
        msg.type = uiLayer.xplp_pb.FOLD;
        PanelManager.Instance:HideWindow('panelChiPai_xplp');
        playerView = uiLayer:GetgameUIObjects().playerViews[XPLP_Logic:GetCorrectUIIndex(XPLP_Logic:GetPlayerViewIndexBySeat(XPLP_Logic.mySeat))]
        uiLayer:SetPlateUIColor(playerView.xplp_GridTool.gridHand,{},false);
    elseif  go == gameUIObjects.ButtonChi.gameObject or 
            go == gameUIObjects.ButtonPeng.gameObject then 

        if gameUIObjects.ButtonHu.gameObject.activeInHierarchy then --此时有胡牌操作
            panelMessageBox.SetParamers(OK_CANCLE,
					function () this.SureIgnoreHuPai(go); end, nil, '是否确定放弃胡牌？');
			PanelManager.Instance:ShowWindow('panelMessageBox');
        else
            if uiLayer.roomData.setting.operateConfirm then --吃碰需要确认
                panelMessageBox.SetParamers(
                    OK_CANCLE,
                    function() this.SureIgnoreHuPai(go);end,
                    nil,
                    "是否"..((go == gameUIObjects.ButtonChi.gameObject) and "吃牌" or "碰牌")
                )
                PanelManager.Instance:ShowWindow('panelMessageBox');
            else
                 this.SureIgnoreHuPai(go);
            end
			return;
        end
        return;
    else
        Debugger.LogError('OnClickOperationButton unkown button {0}', go.name);
    end

    msg.body = body:SerializeToString();
    SendGameMessage(msg, nil)
    uiLayer.TrusteeshipFsmMachine:Switch(uiLayer:GetTrusteeShipStates().TrusteeShipEnd);--取消托管状态
    gameUIObjects.operation_send.gameObject:SetActive(false);
   
end

--过牌操作
function this.SureIgnoreHuPai(go)
    print("SureIgnoreHuPai was called");
    local op = nil
	if go.transform == gameUIObjects.ButtonChi then
		op = xplp_pb.CHI;
	elseif go.transform == gameUIObjects.ButtonPeng then
		op = xplp_pb.PENG;
	elseif go.transform == gameUIObjects.ButtonGang  then
		op = xplp_pb.GANG;
	else
		op = xplp_pb.BU;
	end
	--筛选操作
	local opdata = {};
	local newOperationData =  this.FilterOp(uiLayer.relevantOpTable,op);

	opdata.op = op;
    opdata.newOperationData = newOperationData;
    opdata.EventTool = this;
	if  #newOperationData > 1 then
		PanelManager.Instance:ShowWindow('panelChiPai_xplp',opdata);
	else
        this.SendMsg(1,newOperationData);
        
    end
end

--筛选操作
function this.FilterOp(OperationData, opType)
	if OperationData == nil or #OperationData ==0 then
		return {};
	end
	local newROperationData = {};
	for i = 1, #OperationData do
		if OperationData[i].type == opType then
			table.insert(newROperationData,OperationData[i]);
		end
	end
	return newROperationData;

end

function this.SendMsg(chiIndex,OperationData)
	--print("SendMsg was called,chiIndex:"..chiIndex);
	--print("OperationData.length:"..(#OperationData));
	local msg = Message.New()
	local op = OperationData[chiIndex];
	if not op then
		Debugger.LogError('send msg error', nil)
		return
	end
	if op.type == xplp_pb.CHI then
		msg.type = xplp_pb.CHIPAI
	elseif op.type == xplp_pb.PENG then
		msg.type = xplp_pb.PENGPAI
	else
		Debugger.LogError('send msg type error', nil)
		return
	end
	local body = xplp_pb.POperation()
	body.mahjong = OperationData[chiIndex].mahjong;
	for i=1,#OperationData[chiIndex].mahjongs do
		if op.type == xplp_pb.CHI then
			if body.mahjong ~= OperationData[chiIndex].mahjongs[i] then
				body.mahjongs:append(OperationData[chiIndex].mahjongs[i])
			end
		else
			body.mahjongs:append(OperationData[chiIndex].mahjongs[i])
		end
    end
    print("SendMsg-------->body.mahjong="..tostring(body.mahjong)..",body.mahjongs=")
    for i=1,#body.mahjongs do
        print("body.mahjongs["..i.."]="..tostring(body.mahjongs[i]));
    end
    uiLayer.TrusteeshipFsmMachine:Switch(uiLayer:GetTrusteeShipStates().TrusteeShipEnd);--取消托管状态
	--print('send msg mahjong:'..body.mahjong..' mahjongs:'..table.concat(body.mahjongs, ','))
	msg.body = body:SerializeToString();
    SendGameMessage(msg, nil);
    gameUIObjects.operation_send.gameObject:SetActive(false);
end

--当有胡牌的时候选择过胡
function this.SureGuoMsgBox(go)
    if gameUIObjects.ButtonHu.gameObject.activeSelf then --表示此时是有胡牌的操作
        panelMessageBox.SetParamers(OK_CANCLE,
		function ()
			this.OnClickOperationButton(gameUIObjects.ButtonGuo.gameObject);
		end, nil, '是否确定放弃胡牌？')
		PanelManager.Instance:ShowWindow('panelMessageBox');
    else
        this.OnClickOperationButton(gameUIObjects.ButtonGuo.gameObject);
    end
end
    

--点击听牌
function  this.OnClickButtonTingItem(go)
	-- print("OnClickButtonTingItem was called:"..tostring(obj));
	-- local plate = GetUserData(obj);
	-- print("plate:"..plate);
end


--听牌按钮
function this.OnClickButtonTing(obj)
	print("OnClickButtonTing");
	local bgFrame = gameUIObjects.playerTingButton:Find("frame");
    bgFrame.gameObject:SetActive(not bgFrame.gameObject.activeSelf);
    gameUIObjects.newTingOperation.gameObject:SetActive(not bgFrame.gameObject.activeSelf);
	local tingMahjongs = GetUserData(gameUIObjects.playerTingButton.gameObject);
	uiLayer:SetTingScrollView(tingMahjongs);
	uiLayer:SetNewTingScrollView(tingMahjongs);
end

--发送语音
function this.OnPressButtonSound(obj,state)
    if XPLP_Logic.roomData.setting.sendVoiceAllowed then 
        if state == true then 
            gameUIObjects.RecordTiShi.gameObject:SetActive(true);
            XPLP_Logic:RequestRecord();
        else
            local mousePositionY = UnityEngine.Input.mousePosition.y
            local buttonY = UnityEngine.Screen.height / 2 + (obj.transform.localPosition.y * UnityEngine.Screen.height / 750)
            local buttonHeight = 3 * UnityEngine.Screen.height / 50
            XPLP_Logic:ResponseRecord(not (mousePositionY > buttonY + buttonHeight))
            gameUIObjects.RecordTiShi.gameObject:SetActive(false)
        end
    else
        panelMessageBoxTiShi.SetParamers(ONLY_OK, nil, nil, '群主已经禁止游戏过程中发送语音，如有疑问请联系群主')
        PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
    end
end


--邀请
function this.ShowPanelShare(go)
    gameUIObjects.panelShare.gameObject:SetActive(true);
end

--关闭邀请弹窗
function this.ClosePanelShare(go)
    gameUIObjects.panelShare.gameObject:SetActive(false);
end

--闲聊邀请
function this.OnClickButtonXLInvite(go)
    local str = "";
	str = str ..'房间号：' .. roomInfo.roomNumber .. ',';
	str = str .."呼市麻将,";
	str = str ..GetXPLPRuleText(XPLP_Logic.roomData.setting,false,true);
	str = str .."房已开好,就等你来！";
	print("分享信息", str);
	local que = XPLP_Logic.roomData.setting.size - XPLP_Logic:GetPlayerDataLength();
	local title = roomInfo.roomNumber.."房,"..XPLP_Logic.roomData.playName..XPLP_Logic.roomData.setting.size.."缺"..que;
	print("title",title);
	--print("panelLogin.HttpUrl:"..tostring(panelLogin.HttpUrl));
	PlatformManager.Instance:ShareLinkToXL('http://'..panelLogin.HttpUrl..'/share/xl/jionRoom.html?roomId='..roomInfo.roomNumber..'&gameType='..proxy_pb.XPLP.."&appType=1", title, str);
end

--微信朋友圈分享
function this.OnClickButtonInvite(go)
	print("OnClickButtonInvite was called");
	local str = "";
	str = str ..'房间号：' .. roomInfo.roomNumber .. ',';
	str = str .."呼市麻将,";
	str = str ..GetXPLPRuleText(XPLP_Logic.roomData.setting,false,true);
	str = str .."房已开好,就等你来！"
	print("分享信息", str);
	local que = XPLP_Logic.roomData.setting.size - XPLP_Logic:GetPlayerDataLength();
	local title = roomInfo.roomNumber.."房，"..XPLP_Logic.roomData.playName..XPLP_Logic.roomData.setting.size.."缺"..que
	print("title",title);
	--print("panelLogin.HttpUrl:"..tostring(panelLogin.HttpUrl));

	PlatformManager.Instance:ShareLink('http://'..panelLogin.HttpUrl..'/shareRoom.html?appType=1&state=' ..proxy_pb.XPLP..roomInfo.roomNumber, title, str, 0);

end

function this.OnClickButtonCopy(go)
	local str = "";
	str = str.."呼市麻将,";
	str = str..'房号:' .. roomInfo.roomNumber..",";
	str = str .. GetXPLPRuleText(XPLP_Logic.roomData.setting,false,true);
	Util.CopyToSystemClipbrd(str);
	panelMessageTip.SetParamers('复制成功', 1.5);
	PanelManager.Instance:ShowWindow('panelMessageTip');
end

--取消托管
function this.OnClickCancelTrustesship(go)
    local msg       = Message.New();
	msg.type        = xplp_pb.TRUSTEESHIP;
	local body      = xplp_pb.PTrusteeship();
	body.enable     = false
	msg.body        = body:SerializeToString();
	uiLayer.TrusteeshipFsmMachine:Switch(uiLayer:GetTrusteeShipStates().TrusteeShipEnd);
	SendGameMessage(msg)
end

--听牌计算器
function this.OnClickButtonPlatesRecord(go)
    local data      = {};
    data.uiLayer    = uiLayer;
    data.logic      = XPLP_Logic;
    PanelManager.Instance:ShowWindow("panelPlatesCount_xplp",data);
end

--箍臭选择
function this.OnClickGuChouChoose(go)
    print("OnClickGuChouChoose was called");
    local guchouResult = false;
    if go == gameUIObjects.ButtonGuChou.gameObject then
        guchouResult = true; 
    elseif go == gameUIObjects.ButtonNoGuChou then 
        guchouResult = false;
    end
    print("guchouResult="..tostring(guchouResult));
    
    local body = XPLP_Logic.game_pb.PGuChou();
    body.apply = guchouResult;
    XPLP_Logic:SendGameMsg(XPLP_Logic.game_pb.GU_CHOU,body:SerializeToString(),nil);
    uiLayer.TrusteeshipFsmMachine:Switch(uiLayer:GetTrusteeShipStates().TrusteeShipEnd);--取消托管状态

end

--冲分选择
function this.OnClickChongChoose(go)
    local chongScore = 0;
    if go == gameUIObjects.chongOperation:Find("Chong0").gameObject then 
        chongScore = 0;
    elseif go == gameUIObjects.chongOperation:Find("Chong1").gameObject then 
        chongScore = XPLP_Logic.roomData.setting.chongType == 1 and 1 or 2;
        print("path-----------1");
    elseif go == gameUIObjects.chongOperation:Find("Chong2").gameObject then 
        chongScore = XPLP_Logic.roomData.setting.chongType == 1 and 2 or 4;
        print("path-----------2");
    elseif go == gameUIObjects.chongOperation:Find("Chong3").gameObject then 
        chongScore = XPLP_Logic.roomData.setting.chongType == 1 and 3 or 6;
        print("path-----------3");
    elseif go == gameUIObjects.chongOperation:Find("Chong4").gameObject then 
        chongScore = XPLP_Logic.roomData.setting.chongType == 1 and 4 or 8;
        print("path-----------4");
    else
        chongScore = 0;
    end
    print("chongScore:"..chongScore);
    local body = XPLP_Logic.game_pb.PChongScore();
    body.score = chongScore;
    XPLP_Logic:SendGameMsg(XPLP_Logic.game_pb.CHONG_SCORE,body:SerializeToString(),nil);

    uiLayer.TrusteeshipFsmMachine:Switch(uiLayer:GetTrusteeShipStates().TrusteeShipEnd);--取消托管状态

end

--点击打开玩家已出牌的弹窗
function this.OnClickOutMahjong(go)
    if go == nil then 
        return;
    end

    local grid = go.transform.parent;
    local plates = {};
    for i=0,grid.childCount-1 do
        if grid:GetChild(i).gameObject.activeSelf then 
            table.insert( plates, GetUserData(grid:GetChild(i).gameObject));
        end
    end
    local data = {};
    data.plates = plates;
    PanelManager.Instance:ShowWindow("panelOutPlates_xplp",data);
    
end

--点击打开玩家已吃碰牌的弹窗（自己的不用弹窗）
function this.OnClickXiMahjong(go)
    print("OnClickXiMahjong----------->");
    if go == nil then 
        return ;
    end

    local plates = {};
    for i=0,go.transform.childCount -1 do
        local plateItem = go.transform:GetChild(i);
        table.insert( plates, GetUserData(plateItem.gameObject));
    end

    local data = {};
    data.plates = plates;
    PanelManager.Instance:ShowWindow("panelOutPlates_xplp",data);
end