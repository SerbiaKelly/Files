require("stringTool");
DZAHM_EventBind      = {};
local this          = DZAHM_EventBind;
local uiLayer       = nil;
local gameUIObjects = nil;
local DZAHM_Logic   = nil;
local message       = nil;
local isEventInit   = false;


function this.Init(_uiLayer,_gameUIObjects,_logic )
    uiLayer         = _uiLayer;
    gameUIObjects   = _gameUIObjects;
    DZAHM_Logic     = _logic;
    message         = uiLayer.gameObject:GetComponent('LuaBehaviour');
    if isEventInit then
        return ;
    end

    message:AddClick(gameUIObjects.ButtonChat.gameObject, 		this.OnClickButtonChat)
    message:AddPress(gameUIObjects.ButtonSound.gameObject,	 	this.OnPressButtonSound)
	message:AddClick(gameUIObjects.ButtonCloseRoom.gameObject, 	this.OnClickButtonCloseRoom)
	message:AddClick(gameUIObjects.ButtonExitRoom.gameObject, 	this.OnClicButtonLeaveRoom)
	message:AddClick(gameUIObjects.ButtonReady.gameObject, 		this.OnClickButtonNext)
	message:AddClick(gameUIObjects.ButtonHu.gameObject, 		this.OnClickOperationButton)
	message:AddClick(gameUIObjects.ButtonGang.gameObject, 		this.OnClickOperationButton)
	message:AddClick(gameUIObjects.ButtonPeng.gameObject, 		this.OnClickOperationButton)
	message:AddClick(gameUIObjects.ButtonChi.gameObject, 		this.OnClickOperationButton)
	message:AddClick(gameUIObjects.ButtonGuo.gameObject, 		this.SureGuoMsgBox)
	message:AddClick(gameUIObjects.ButtonBu.gameObject, 		this.OnClickOperationButton)
    message:AddClick(gameUIObjects.ButtonRefresh.gameObject,	this.OnClickButtonRefresh);
    message:AddClick(gameUIObjects.ButtonMore.gameObject, 		this.OnClickButtonSetting);
    message:AddClick(gameUIObjects.ButtonInvite.gameObject,     this.ShowPanelShare);
    message:AddClick(gameUIObjects.playerTingButton.gameObject, this.OnClickButtonTing);


    message:AddClick(gameUIObjects.panelShare:Find('xianLiao').gameObject,    this.OnClickButtonXLInvite);
    message:AddClick(gameUIObjects.panelShare:Find('friendGroup').gameObject, this.OnClickButtonInvite);
	message:AddClick(gameUIObjects.panelShare:Find('copy').gameObject,        this.OnClickButtonCopy);
    message:AddClick(gameUIObjects.panelShare:Find('ButtonClose').gameObject, this.ClosePanelShare);
    message:AddClick(gameUIObjects.panelShare:Find('mask').gameObject,        this.ClosePanelShare);
    message:AddClick(gameUIObjects.TrusteeShipCancelButton.gameObject,        this.OnClickCancelTrustesship);
    message:AddClick(gameUIObjects.lessPlayerStartToggle.gameObject, 	      this.OnClickLessPlayerStartToggle)

    for i=0,3 do
        message:AddClick(gameUIObjects.piaofendlg:Find(tostring(i)).gameObject, this.OnClickPiaofenItem);
    end


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
    AudioManager.Instance:PlayAudio('btn');
	PanelManager.Instance:RestartGame();
end

--离开房间或者解散房间（房主）
function this.OnClickButtonCloseRoom(go)
    print("OnClickButtonCloseRoom------------------------------>");
    AudioManager.Instance:PlayAudio('btn');
    if DZAHM_Logic.mySeat == 0 then 
        print("房主申请解散房间---------->");
        local msg       = Message.New();
        msg.type        = uiLayer.dzm_pb.DISSOLVE;
        local body      = uiLayer.dzm_pb.PDissolve();
        body.decision   = uiLayer.dzm_pb.APPLY;
        msg.body        = body:SerializeToString();
        SendGameMessage(msg, nil);
    else
        print("玩家申请离开房间---------->");
        local msg   = Message.New()
		msg.type    = uiLayer.dzm_pb.LEAVE_ROOM;
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
end

--准备按钮
function this.OnClickButtonNext(go)
    AudioManager.Instance:PlayAudio('btn');
    local msg = Message.New();
    msg.type = uiLayer.dzm_pb.READY;
    SendGameMessage(msg, nil);
end

--点击设置按钮
function this.OnClickButtonSetting(go)
    local sendData      = {};
    sendData.roomData   = DZAHM_Logic.roomData;
    sendData.playerSize = DZAHM_Logic.totalSize;
    sendData.logic      = DZAHM_Logic;
    if DZAHM_Logic.roomData.round > 1 or DZAHM_Logic:IsAllReaded() then 
        sendData.ingame = true;
    else
        sendData.ingame = false;
    end
    PanelManager.Instance:ShowWindow('panelGameSetting_dzahm', sendData);

end

--点击操作按钮
function this.OnClickOperationButton(go)
    print("OnClickOperationButton---------------------->was called");
    local msg       = Message.New();
    local body      = uiLayer.dzm_pb.POperation();
    local myData    = DZAHM_Logic:GetPlayerDataBySeat(DZAHM_Logic.mySeat);
    uiLayer:OperationForbidden(myData.sealPai);
    if go == gameUIObjects.ButtonHu.gameObject then 
        uiLayer:SetWaitOpTip(myData.waitOperateTip,"请等待其他玩家操作");
        local op_mahjong    = DZAHM_PlayLogic.GetOpeartionPlates(myData.operations,uiLayer.dzm_pb.HU)[1];
        body.mahjong        = op_mahjong;
        msg.type            = uiLayer.dzm_pb.HUPAI;
    elseif go == gameUIObjects.ButtonGuo.gameObject then 
        msg.type = uiLayer.dzm_pb.FOLD;
        PanelManager.Instance:HideWindow('panelChiPai_mj');
        playerView = uiLayer:GetgameUIObjects().playerViews[DZAHM_Logic:GetCorrectUIIndex(DZAHM_Logic:GetPlayerViewIndexBySeat(DZAHM_Logic.mySeat))]
        uiLayer:SetPlateUIColor(playerView.dzahm_GridTool.gridHand,{},false);
    elseif  go == gameUIObjects.ButtonChi.gameObject or 
            go == gameUIObjects.ButtonPeng.gameObject or 
            go == gameUIObjects.ButtonBu.gameObject or 
            go == gameUIObjects.ButtonGang.gameObject then 

        if gameUIObjects.ButtonHu.gameObject.activeInHierarchy then --此时有胡牌操作
            panelMessageBox.SetParamers(OK_CANCLE,
					function () this.SureIgnoreHuPai(go); end, nil, '是否确定放弃胡牌？');
			PanelManager.Instance:ShowWindow('panelMessageBox');
        else
            this.SureIgnoreHuPai(go);
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
		op = dzm_pb.CHI;
	elseif go.transform == gameUIObjects.ButtonPeng then
		op = dzm_pb.PENG;
	elseif go.transform == gameUIObjects.ButtonGang  then
		op = dzm_pb.GANG;
	else
		op = dzm_pb.BU;
	end
	--筛选操作
	local opdata = {};
	local newOperationData =  this.FilterOp(uiLayer.relevantOpTable,op);

	opdata.op = op;
    opdata.newOperationData = newOperationData;
    opdata.gameType = proxy_pb.NMM;
	if  #newOperationData > 1 then
		PanelManager.Instance:ShowWindow('panelChiPai_mj',opdata);
	else
		this.SendMsg(1,newOperationData);
    end

    print("newOperationData.length="..#newOperationData);
    for i=1,#newOperationData do
        
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
	if op.type == dzm_pb.CHI then
		msg.type = dzm_pb.CHIPAI
	elseif op.type == dzm_pb.PENG then
		msg.type = dzm_pb.PENGPAI
	elseif op.type == dzm_pb.GANG then
		msg.type = dzm_pb.GANGPAI
	elseif op.type == dzm_pb.BU then
		msg.type = dzm_pb.BUPAI
	else
		Debugger.LogError('send msg type error', nil)
		return
	end
	local body = dzm_pb.POperation()
	body.mahjong = OperationData[chiIndex].mahjong;
	for i=1,#OperationData[chiIndex].mahjongs do
		if op.type == dzm_pb.CHI then
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
    if DZAHM_Logic.roomData.setting.sendVoiceAllowed then 
        if state == true then 
            gameUIObjects.RecordTiShi.gameObject:SetActive(true);
            DZAHM_Logic:RequestRecord();
        else
            local mousePositionY = UnityEngine.Input.mousePosition.y
            local buttonY = UnityEngine.Screen.height / 2 + (obj.transform.localPosition.y * UnityEngine.Screen.height / 750)
            local buttonHeight = 3 * UnityEngine.Screen.height / 50
            DZAHM_Logic:ResponseRecord(not (mousePositionY > buttonY + buttonHeight))
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
	str = str .."安化麻将,";
	str = str ..GetDZAHMRuleText(DZAHM_Logic.roomData.setting,false,true);
	str = str .."房已开好,就等你来！";
	print("分享信息", str);
	local que = DZAHM_Logic.roomData.setting.size - DZAHM_Logic:GetPlayerDataLength();
	local title = roomInfo.roomNumber.."房,"..DZAHM_Logic.roomData.playName..DZAHM_Logic.roomData.setting.size.."缺"..que;
	print("title",title);
	--print("panelLogin.HttpUrl:"..tostring(panelLogin.HttpUrl));
	PlatformManager.Instance:ShareLinkToXL('http://'..panelLogin.HttpUrl..'/share/xl/jionRoom.html?roomId='..roomInfo.roomNumber..'&gameType='..proxy_pb.MJ.."&roomType="..proxy_pb.DZAHM..'&appType=1', title, str);
end

--微信朋友圈分享
function this.OnClickButtonInvite(go)
	print("OnClickButtonInvite was called");
	local str = "";
	str = str ..'房间号：' .. roomInfo.roomNumber .. ',';
	str = str .."安化麻将,";
	str = str ..GetDZAHMRuleText(DZAHM_Logic.roomData.setting,false,true);
	str = str .."房已开好,就等你来！"
	print("分享信息", str);
	local que = DZAHM_Logic.roomData.setting.size - DZAHM_Logic:GetPlayerDataLength();
	local title = roomInfo.roomNumber.."房，"..DZAHM_Logic.roomData.playName..DZAHM_Logic.roomData.setting.size.."缺"..que
	print("title",title);
	--print("panelLogin.HttpUrl:"..tostring(panelLogin.HttpUrl));

	PlatformManager.Instance:ShareLink('http://'..panelLogin.HttpUrl..'/shareRoom.html?appType=1&state=' ..proxy_pb.MJ.."&roomType="..proxy_pb.DZAHM..roomInfo.roomNumber, title, str, 0);

end

function this.OnClickButtonCopy(go)
	local str = "";
	str = str.."安化麻将,";
	str = str..'房号:' .. roomInfo.roomNumber..",";
	str = str .. GetDZAHMRuleText(DZAHM_Logic.roomData.setting,false,true);
	Util.CopyToSystemClipbrd(str);
	panelMessageTip.SetParamers('复制成功', 1.5);
	PanelManager.Instance:ShowWindow('panelMessageTip');
end

--取消托管
function this.OnClickCancelTrustesship(go)
    local msg       = Message.New();
	msg.type        = dzm_pb.TRUSTEESHIP;
	local body      = dzm_pb.PTrusteeship();
	body.enable     = false
	msg.body        = body:SerializeToString();
	uiLayer.TrusteeshipFsmMachine:Switch(uiLayer:GetTrusteeShipStates().TrusteeShipEnd);
	SendGameMessage(msg)
end

--玩家选择飘分
function this.OnClickPiaofenItem(go)
    local score = tonumber( string.sub(go.name,string.find(go.name,"%d",1,false)));
    local playerSelectPiaofen = dzm_pb.PFloatScore();
    playerSelectPiaofen.score = score;
    DZAHM_Logic:SendGameMsg(dzm_pb.FLOAT_SCORE,playerSelectPiaofen:SerializeToString(),nil);
    uiLayer.TrusteeshipFsmMachine:Switch(uiLayer:GetTrusteeShipStates().TrusteeShipEnd);--取消托管状态
end

--少人开局
function this.OnClickLessPlayerStartToggle(go)
	AudioManager.Instance:PlayAudio('btn')
	local msg = Message.New()
	msg.type = dzm_pb.CHOICE_MINORITY
	local body = dzm_pb.PChoiceMinority()
	body.enable = gameUIObjects.lessPlayerStartToggle:GetComponent('UIToggle').value
	msg.body = body:SerializeToString();
	SendGameMessage(msg)
end