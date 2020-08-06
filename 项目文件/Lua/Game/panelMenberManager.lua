require "Game.bitlogic"
panelMenberManager = {}
local this = panelMenberManager

local message;
local gameObject;

local MenberManagerBtn;
local ShardCardBtn;
local DeletMeberBtn;
local UpdateButton
local PurviewManagementBtn;
local SetManagerButton;
local UpdateManagerBtn;
local SuperiorAdministratorLabel;
local JoinBlackRoomBtn;
local ClearFeeBalanceBtn;
local FeeBalance;

local PlayerPanel;
local PurviewPanel;
local privileges = {1,2,4,8,16,32,64,128}

function this.Awake(obj)
    gameObject = obj;
    message = gameObject:GetComponent('LuaBehaviour');

    PlayerPanel = gameObject.transform:Find('PlayerPanel')
    MenberManagerBtn = gameObject.transform:Find('PlayerPanel/lobby/MenberManagerBtn')
    ShardCardBtn = gameObject.transform:Find('PlayerPanel/Buttons/ShardCardBtn')
    DeletMeberBtn = gameObject.transform:Find('PlayerPanel/lobby/DeletMeberBtn')
    UpdateButton = gameObject.transform:Find('PlayerPanel/photoKuang/ButtonUpdate')
    PurviewManagementBtn = gameObject.transform:Find('PlayerPanel/lobby/PurviewManagementBtn')
    UpdateManagerBtn = gameObject.transform:Find('PlayerPanel/lobby/UpdateManagerBtn')
    SuperiorAdministratorLabel = gameObject.transform:Find('PlayerPanel/lobby/SuperiorAdministrator')
    JoinBlackRoomBtn = gameObject.transform:Find('PlayerPanel/lobby/JoinBlackRoomBtn')
    ClearFeeBalanceBtn = gameObject.transform:Find('PlayerPanel/ClearFeeBalanceBtn')
    FeeBalance = gameObject.transform:Find('PlayerPanel/FeeBalance')

    PurviewPanel = gameObject.transform:Find('PurviewPanel')
    for i = 1, #privileges do
        local toggle = PurviewPanel:Find(privileges[i])
        message:AddClick(toggle.gameObject, this.OnClickAddPurview)
    end
    PurviewPanel.gameObject:SetActive(false)
    SetManagerButton = PurviewPanel:Find('OkBtn')
    message:AddClick(SetManagerButton.gameObject, this.OnPurviewPanelOkButton)
    message:AddClick(PurviewPanel.transform:Find('TipBtn').gameObject, function (go)
        PurviewPanel.transform:Find('TipPanel').gameObject:SetActive(true)
    end)
    message:AddClick(PurviewPanel.transform:Find('TipPanel/BaseContent/ButtonClose').gameObject, function (go)
        PurviewPanel.transform:Find('TipPanel').gameObject:SetActive(false)
    end)
    message:AddClick(PurviewPanel:Find('BaseContent/ButtonClose').gameObject, function (go)
        PurviewPanel.gameObject:SetActive(false)
    end)

    message:AddClick(PurviewManagementBtn.gameObject ,this.OnClickPurviewManagementBtn)
    message:AddClick(DeletMeberBtn.gameObject, this.OnClickDeletOperation)
    message:AddClick(UpdateButton.gameObject, this.OnClickUpdate)
    message:AddClick(ShardCardBtn.gameObject, this.OnClickShare)
    message:AddClick(MenberManagerBtn.gameObject, this.LookTAMenber)
    message:AddClick(UpdateManagerBtn.gameObject, this.OnClickUpdateManager)

    message:AddClick(gameObject.transform:Find('BaseContent/ButtonClose').gameObject, function (go)
        PlayerPanel.gameObject:SetActive(true)
        PurviewPanel.gameObject:SetActive(false)
        PanelManager.Instance:HideWindow(gameObject.name)
    end)

    message:AddClick(JoinBlackRoomBtn.gameObject, this.OnClickJoinBlackRoom)
    message:AddClick(ClearFeeBalanceBtn.gameObject, this.OnCilickClearFeeBalance)
end

function this.Start()

end

function this.Update()
   
end

local CurPlayer = {}
function this.WhoShow(data)
    CurPlayer = {}
    
    DeletMeberBtn.gameObject:SetActive(proxy_pb.LORD == panelClub.clubInfo.userType)
    PurviewManagementBtn.gameObject:SetActive(proxy_pb.LORD == panelClub.clubInfo.userType)

    if data.userData ~= nil then
        this.InitViewFromUser(data.userData)
    elseif data.managerData ~= nil then
        this.InitViewFromManager(data.managerData)
    end

    --PurviewManagementBtn.gameObject:SetActive(proxy_pb.LORD == panelClub.clubInfo.userType)
end

local userTypes = {}
userTypes[proxy_pb.GENERAL] = '成员'
userTypes[proxy_pb.MANAGER] = '管理员'
userTypes[proxy_pb.LORD] = '群主'
function this.InitViewFromUser(data)
    this.InitPlayInfo(data.userId,data.nickname, data.icon,'', data.userType, data.superiorId, data.superiorNickname)
end

function this.InitViewFromManager(data)
    this.InitPlayInfo(data.userId,data.nickname, data.icon,'', proxy_pb.MANAGER, panelClub.clubInfo.lordId, panelClub.clubInfo.lordNickname)
end

function this.InitPlayInfo(userId, nickname, icon, ip, userType, managerId, managerNickname)
    print('managerId:'..tostring(managerId))
    CurPlayer.info = {}
    local panel = gameObject.transform:Find('PlayerPanel/lobby')
    panel:Find('name'):GetComponent('UILabel').text = nickname
    panel:Find('ip'):GetComponent('UILabel').text = "IP:"..ip
    panel:Find('userType'):GetComponent('UILabel').text = userTypes[userType]
    coroutine.start(LoadPlayerIcon, panel:Find('icon/Texture'):GetComponent('UITexture'), icon)

    local isNeedShowUserId = IsCanOperatingMenber() or managerId == info_login.id 
    local useridText = (isNeedShowUserId or userId == info_login.id) and  userId or string.sub (userId, 1,4).."***"
    panel:Find('id'):GetComponent('UILabel').text = 'ID:'..useridText

    local managerIdText = ''
    if managerId == '' then
        managerIdText = (proxy_pb.MANAGER == userType) and "群主" or '无'
    else
        if (not IsCanOperatingMenber() and managerId ~= info_login.id)  then
            managerIdText = managerNickname.."(ID:"..string.sub (managerId, 1,4).."***"..')'
        else
            managerIdText = managerNickname.."(ID:"..managerId..')'
        end
    end
    SuperiorAdministratorLabel:GetComponent('UILabel').text = managerIdText

    print('是不是群主:'..tostring(userType == proxy_pb.LORD))
    if userType == proxy_pb.LORD then
        DeletMeberBtn.gameObject:SetActive(false)
        MenberManagerBtn.gameObject:SetActive(false)
        UpdateManagerBtn.gameObject:SetActive(false)
        PurviewManagementBtn.gameObject:SetActive(false)
    else
        local isLord = proxy_pb.LORD == panelClub.clubInfo.userType;
        MenberManagerBtn.gameObject:SetActive(isLord and userType==proxy_pb.MANAGER)
        UpdateManagerBtn.gameObject:SetActive(isLord and userType==proxy_pb.GENERAL and (managerId == '' or managerId == info_login.id))
        DeletMeberBtn.gameObject:SetActive(isNeedShowUserId and (info_login.id ~= userId) )
        PurviewManagementBtn.transform:Find('Label'):GetComponent('UILabel').text = userType==proxy_pb.MANAGER and "查看权限" or "设为管理员" 
        -- if userType~=proxy_pb.GENERAL then
        --     PurviewManagementBtn.gameObject:SetActive(false)
        -- end
    end

    CurPlayer.info = {}
    CurPlayer.info.icon = icon
    CurPlayer.info.userId = userId
    CurPlayer.info.nickname = nickname
    CurPlayer.info.userType = userType
    CurPlayer.info.managerId = managerId

    PlayerPanel.gameObject:SetActive(true)
    PurviewPanel.gameObject:SetActive(false)

    FeeBalance.gameObject:SetActive(false)
    ClearFeeBalanceBtn.gameObject:SetActive(false)
    if isCanCleanAllFeeBalance() then
        print("jajajajaaj:"..1)
        FeeBalance.gameObject:SetActive(true)
        ClearFeeBalanceBtn.gameObject:SetActive(true)
    elseif userId == info_login.id then
        print("jajajajaaj:"..2)
        FeeBalance.gameObject:SetActive(true)
        ClearFeeBalanceBtn.gameObject:SetActive(false)
    elseif isCanCleanMySelfFeeBalance() and managerId == info_login.id then
        print("jajajajaaj:"..3)
        FeeBalance.gameObject:SetActive(true)
        ClearFeeBalanceBtn.gameObject:SetActive(true)
    end

    JoinBlackRoomBtn.gameObject:SetActive(userId ~= info_login.id and (userType ~= proxy_pb.LORD) and (IsCanOperatingMenber() or (managerId == info_login.id)))

    PanelManager.Instance:ShowWindow('panelNetWaitting')
    this.getInfo(userId, function (msg)
	    panelLogin.HideNetWaitting()
        local b = proxy_pb.RMyInfoCard();
        b:ParseFromString(msg.body);
        panel:Find('Label'):GetComponent('UILabel').text =  b.signature
        print('feeBalance'..b.feeBalance)
        CurPlayer.feePrecent = b.feePrecent ~= nil and b.feePrecent or 0
        CurPlayer.privilege = b.privilege ~= nil and  b.privilege or 0
        CurPlayer.feeBalance = b.feeBalance
        PlayerPanel:Find('FeeBalance/Label'):GetComponent('UILabel').text = CurPlayer.feeBalance
        if b.imgUrl ~= nil and b.imgUrl ~= "" then
            print('名片地址：'..b.imgUrl)
            coroutine.start(LoadFengCaiZhao, gameObject.transform:Find('PlayerPanel/photoKuang/photo'):GetComponent('UITexture'), b.imgUrl)
        end
    end)
end

function this.getInfo(userId, func)
    local msg = Message.New()
    msg.type = proxy_pb.MY_INFO_CARD
    local body = proxy_pb.PMyInfoCard()
    body.userId = userId
    body.clubId = panelClub.clubInfo.clubId
    print('拉取用户名片id：'..body.userId..", 俱乐部id："..body.clubId)
    msg.body = body:SerializeToString()
    SendProxyMessage(msg, func)
end

function this.OnClickDeletOperation(go)
    AudioManager.Instance:PlayAudio('btn')
    local msg = Message.New()
    msg.type = proxy_pb.CLUB_USER_MANAGE
    local body = proxy_pb.PClubUserManage()
    body.clubId = panelClub.clubInfo.clubId
    body.userId = CurPlayer.info.userId
    body.operation=proxy_pb.DELETE
    print('删除玩家'..body.userId)
    msg.body = body:SerializeToString()

    local tipStr = ''
    if CurPlayer.info.userType == proxy_pb.MANAGER then
        tipStr = '是否确认取消“'..CurPlayer.info.nickname..'”的身份？  若删除成功，则其直属的玩家将全部从本群移除！'
    else
        tipStr = '是否确认移除成员 "'..CurPlayer.info.nickname..'" 出群？'
    end

    panelMessageBoxTiShi.SetParamers(OK_CANCLE, function ()
        SendProxyMessage(msg, this.DeletResult) 
    end, nil, tipStr)
    PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
end

function this.DeletResult(msg)
    local b = proxy_pb.RResult()
	b:ParseFromString(msg.body)
    if b.code == 1 then
        PanelManager.Instance:HideWindow(gameObject.name)
    end
end

function this.OnClickUpdate(go)
    AudioManager.Instance:PlayAudio('btn')
    if Util.GetPlatformStr() == 'ios' then
        PlatformManager.Instance:TakePhoto(UnityEngine.Application.persistentDataPath..'/tupian.jpg')
    else
        PlatformManager.Instance:TakePhoto('photo')
    end
end
--[[
    @desc: 选择图片后的回调
    author:{author}
    time:2018-10-11 16:58:44
    --@texture:选择的图片
	--@strData: 图片base64string格式的数据
    @return:
]]
function this.textureCallBack(texture,strData)
    if strData and string.len(strData)>0 then
        coroutine.start(
		function()
			while not isLogin do
				coroutine.wait(1)
			end
			if isLogin then
				local msg = Message.New()
                msg.type = proxy_pb.UPLOAD_USER_PHOTO
                local body = proxy_pb.PUploadUserPhoto()
                body.img = strData
                msg.body = body:SerializeToString()
                SendProxyMessage(msg, this.OnUpdatePhotoResult)
			end
		end
        )
    else
        panelMessageTip.SetParamers('图片不能为空，请重新选取', 1)
        PanelManager.Instance:ShowWindow('panelMessageTip')    
    end
    
end
--[[
    @desc: 上传照片结果
    author:{author}
    time:2018-10-11 17:05:09
    --@msg: 消息
    @return:
]]
function this.OnUpdatePhotoResult(msg)
    local b = proxy_pb.RUploadUserPhoto();
    b:ParseFromString(msg.body);
    print("服务器返回的url"..b.imgUrl)
    photoTexture.gameObject:SetActive(true)
    coroutine.start(LoadFengCaiZhao, photoTexture:GetComponent('UITexture'), b.imgUrl)
    panelMessageTip.SetParamers('上传成功', 1)
	PanelManager.Instance:ShowWindow('panelMessageTip')
end

function this.OnClickUpdateManager(go)
    local msg = Message.New()
    msg.type = proxy_pb.CLUB_USER_MANAGE
    local body = proxy_pb.PClubUserManage()
    body.clubId = panelClub.clubInfo.clubId
    body.operation = proxy_pb.ADD_USER_MANAGER
    body.userId = CurPlayer.info.userId;

    local func = function (data)
        body.managerId = data.userId
        msg.body = body:SerializeToString()
        SendProxyMessage(msg, function (msg)
            local b = proxy_pb.RResult()
            b:ParseFromString(msg.body)
            if b.code == 1 then
                SuperiorAdministratorLabel:GetComponent('UILabel').text = data.nickname..'(ID:'..data.userId..')'
                panelMessageTip.SetParamers('设置成功', 1)
                UpdateManagerBtn.gameObject:SetActive(false)
            else
                panelMessageTip.SetParamers('设置失败', 1)
            end
            PanelManager.Instance:ShowWindow('panelMessageTip')
        end)
    end

    PanelManager.Instance:ShowWindow('panelSelectManager',  {assign = true, func = func})
end

function this.InitPurviewView()
    for i = 1, #privileges do
        local toggle = PurviewPanel:Find(privileges[i])
        toggle:GetComponent('UIToggle'):Set(false)
    end

    print(PurviewPanel)
    PurviewPanel.gameObject:SetActive(false)
end

local IsAdd = true
local curPlayerPrivileges
function this.ShowPurviewPanel(isAdd)
    for i = 1, #privileges do
        local toggle = PurviewPanel.transform:Find(privileges[i])
        if isAdd then
            toggle:GetComponent('UIToggle'):Set(false)
        else
            if CurPlayer.privilege ~= nil then
                toggle:GetComponent('UIToggle'):Set(bit:_and(CurPlayer.privilege, privileges[i]) == privileges[i])
            end
        end
    end

    IsAdd = isAdd
    PurviewPanel.gameObject:SetActive(true)
    
    print(CurPlayer.feePrecent)
    curPlayerPrivileges = CurPlayer.privilege
    PurviewPanel:Find('Score'):GetComponent('UILabel').text = CurPlayer.feePrecent
    PurviewPanel:Find('Score'):GetComponent('UIInput').value = CurPlayer.feePrecent

    SetManagerButton.transform.gameObject:SetActive(proxy_pb.LORD == panelClub.clubInfo.userType)
    PurviewPanel.transform:GetComponent('BoxCollider').enabled = (info_login.id == CurPlayer.info.userId)
end

function this.OnClickAddPurview(go)
    local privilege = tonumber(go.gameObject.name) 
    print('添加新的权限：'..privilege.."  || "..bit:_or(curPlayerPrivileges, privilege))
    if bit:_and(curPlayerPrivileges, privilege) == privilege then
        curPlayerPrivileges = bit:_xor(curPlayerPrivileges, privilege)
    else
        curPlayerPrivileges = bit:_or(curPlayerPrivileges, privilege)
    end
    print('添加权限后的：'..curPlayerPrivileges)
end

function this.OnClickShare(go)
    AudioManager.Instance:PlayAudio('btn')
    PlatformManager.Instance:ShareScreenshot('嗨皮跑胡子',false,0) 
end

function this.OnClickPurviewManagementBtn(go)

    if CurPlayer.info.userType==proxy_pb.GENERAL then
        panelMessageBoxTiShi.SetParamers(OK_CANCLE, function ()
            this.ShowPurviewPanel(true)
        end, nil, '是否确认将 "'..CurPlayer.info.nickname..'" 设为管理员？')
        PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
    elseif CurPlayer.info.userType==proxy_pb.MANAGER then
        this.ShowPurviewPanel(false) 
    end
end

function this.OnPurviewPanelOkButton(go)
    local feePerecent = PurviewPanel:Find('Score'):GetComponent('UIInput').value
    this.SetManager(IsAdd, CurPlayer.info.userId, curPlayerPrivileges, tonumber(feePerecent))
end

function this.SetManager(isAdd, userId, privilege, feePrecent)
    local msg =Message.New()
    msg.type = isAdd and  proxy_pb.ADD_MANAGER or proxy_pb.UPDATE_MANAGER
    local body = proxy_pb.PAddManager()
    body.clubId = panelClub.clubInfo.clubId
    body.userId = userId
    body.privilege = privilege
    body.feePrecent = feePrecent
    body.userType = proxy_pb.MANAGER
    msg.body = body:SerializeToString()

    if feePrecent <0 or feePrecent > 100 then
        panelMessageTip.SetParamers('收益百分比必须在0 ~ 100%之间', 1)
        PanelManager.Instance:ShowWindow('panelMessageTip')
        return 
    end
    print('添加'..'俱乐部：'..body.clubId..' 用户ID：'..body.userId.." 用户权限："..body.privilege.." 分数："..body.feePrecent)

    panelMessageBoxTiShi.SetParamers(OK_CANCLE, function ()
        SendProxyMessage(msg, this.ManagerResult)
    end, nil, '是否确认提交？', '确 定')
	PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
end

function this.ManagerResult(msg)
    local b = proxy_pb.RResult()
    b:ParseFromString(msg.body)
    print('lalalal：'..b.code)
    if b.code == 1 then
        panelMenber.RefreshMenber()
        panelMenber.GetManagerData()
        panelMessageTip.SetParamers('操作成功', 1)
        PanelManager.Instance:ShowWindow('panelMessageTip')
        PanelManager.Instance:HideWindow(gameObject.name)
    end
end

function this.LookTAMenber(go)
    if PanelManager.Instance:IsActive('panelMenber') then
        panelMenber.GetManagerMenber(CurPlayer.info.userId,false,true)
        PanelManager.Instance:HideWindow(gameObject.name)
    end
end

function this.OnClickJoinBlackRoom(go)
    local msg = Message.New()
    msg.type = proxy_pb.ADD_BLACK_PLAYER
    local body=proxy_pb.PAddBlackPlayer()
    body.clubId = panelClub.clubInfo.clubId
    body.userId = CurPlayer.info.userId

    if body.userId == info_login.id then
        panelMessageTip.SetParamers('无法自己添加自己进入小黑屋名单', 1)
        PanelManager.Instance:ShowWindow('panelMessageTip')
        return 
    end

    msg.body = body:SerializeToString()

    local userName = CurPlayer.info.nickname
    panelMessageBoxTiShi.SetParamers(OK_CANCLE, function ()
        SendProxyMessage(msg, function (msgResult)
            local b = proxy_pb.RResult()
            b:ParseFromString(msgResult.body)
            print('请求添加玩家返回值code'..b.code)
            print('请求添加玩家返回值msg'..b.msg)
            if b.code == 1 then
                panelMessageTip.SetParamers('添加成功。', 2)
                PanelManager.Instance:ShowWindow('panelMessageTip')
            end
        end)
    end, nil, '是否确认将“'..userName..'”加入小黑屋吗？ 若加入小黑屋，则玩家无法在本群进入任何房间；', '确 定')
	PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
end

function this.OnCilickClearFeeBalance(go)
    -- local msg = Message.New()
    -- msg.type = proxy_pb.FEE_DEDUCT;
    -- local body = proxy_pb.PFeeDeduct();
    -- body.clubId = panelClub.clubInfo.clubId;
    -- body.userId = CurPlayer.info.userId;
    -- body.amount = CurPlayer.feeBalance;
    -- msg.body = body:SerializeToString()
    -- print('扣除的：'..body.amount)
    -- panelMessageBoxTiShi.SetParamers(OK_CANCLE, function ()
    --     SendProxyMessage(msg, this.operationResult) 
    -- end, nil, '是否确定扣除玩家\"'..CurPlayer.info.nickname..'\"'..body.amount..'分疲劳值？')
    -- PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')

    -- if panelClub.clubInfo.gameMode then
    --     panelMessageBoxTiShi.SetParamers(OK_CANCLE, function ()
    --         PlatformManager.Instance:ShareLink('http://zj.17hiya.net', '嗨皮湖南棋牌', '群战绩中心', 0)
    --     end, nil, '请通过战绩链接中心查看  链接地址：http://zj.17hiya.net')
    --     PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
    --     return 
    -- end

    if panelClub.clubInfo.gameMode then
        PanelManager.Instance:ShowWindow('panelMatchFeeBillRecord', 
            {pageIndex = 1, userId = CurPlayer.info.userId, nickname = CurPlayer.info.nickname, icon = CurPlayer.info.icon, manageId = CurPlayer.info.managerId, userType = CurPlayer.info.userType})
        PanelManager.Instance:HideWindow(gameObject.name)
        return 
    end

    local shuju={}
    shuju.data = CurPlayer.info
    shuju.GO=go
    PanelManager.Instance:ShowWindow('panelFeeBillRecord',shuju)
end

function this.RefreshFee()
    this.getInfo(CurPlayer.info.userId, function (msg)
        local b = proxy_pb.RMyInfoCard();
        b:ParseFromString(msg.body);
        local panel = gameObject.transform:Find('PlayerPanel/lobby')
        panel:Find('Label'):GetComponent('UILabel').text =  b.signature
        if b.imgUrl ~= nil and b.imgUrl ~= "" then
            print('名片地址：'..b.imgUrl)
            coroutine.start(LoadFengCaiZhao, gameObject.transform:Find('PlayerPanel/photoKuang/photo'):GetComponent('UITexture'), b.imgUrl)
        end
        print('feeBalance'..b.feeBalance)
        CurPlayer.feePrecent = b.feePrecent ~= nil and b.feePrecent or 0
        CurPlayer.privilege = b.privilege ~= nil and  b.privilege or 0
        CurPlayer.feeBalance = b.feeBalance
        PlayerPanel:Find('FeeBalance/Label'):GetComponent('UILabel').text = CurPlayer.feeBalance
    end)
end