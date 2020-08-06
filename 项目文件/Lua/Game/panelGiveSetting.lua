require "Game.Tools.UITools"
require "Game.GameLogic.ClubLogic"

panelGiveSetting = {} 
local this = panelGiveSetting

local message;
local gameObject;

local GiveSettingPage = {}

local SettingPage = {}

local TipPage = {}

local CloseBtn

local WinValue2MyGiveValue
local curSelectInputObj = nil
function this.Awake(go)

    gameObject                      = go;
    message                         = gameObject:GetComponent('LuaBehaviour');

    GiveSettingPage.Page            = gameObject.transform:Find('DataPage')
    GiveSettingPage.Tip             = GiveSettingPage.Page.transform:Find('DataList/Tip')
    GiveSettingPage.Grid            = GiveSettingPage.Page.transform:Find('DataList/Scroll View/Grid')
    GiveSettingPage.DataItemPrefabe = gameObject.transform:Find('Prefabs/Item')
    GiveSettingPage.SubmissionBtn   = GiveSettingPage.Page.transform:Find('SubmissionBtn')

    SettingPage.Page                = gameObject.transform:Find('SettingPage')
    SettingPage.CloseBtn            = SettingPage.Page.transform:Find('BaseContent/ButtonClose')
    SettingPage.Grid                = SettingPage.Page.transform:Find('DataList/Scroll View/Grid')
    SettingPage.ItemPrefab          = gameObject.transform:Find('Prefabs/SetItem')
    SettingPage.SubmissionBtn       = SettingPage.Page.transform:Find('SubmissionBtn')
    SettingPage.IntroduceLabel      = SettingPage.Page.transform:Find('IntroduceLabel')
    SettingPage.TipBtn              = SettingPage.Page.transform:Find('TipBtn')

    TipPage.Page                    = gameObject.transform:Find('TipPanel')
    TipPage.CloseBtn                = TipPage.Page.transform:Find('BaseContent/ButtonClose')

    CloseBtn                        = gameObject.transform:Find('ButtonClose')
    WinValue2MyGiveValue            = GiveSettingPage.Tip:Find('WinValue2MyGiveValue')

    message:AddClick(CloseBtn.gameObject,                       this.OnClickCloseBtn)
    message:AddClick(TipPage.CloseBtn.gameObject,               this.OnClickCloseBtn)
    message:AddClick(SettingPage.CloseBtn.gameObject,           this.OnClickCloseBtn)
    message:AddClick(SettingPage.TipBtn.gameObject,             this.OnClickTipBtn)
    message:AddClick(SettingPage.SubmissionBtn.gameObject,      this.OnClickSetSubmissionBtn)
    message:AddClick(GiveSettingPage.SubmissionBtn.gameObject,  this.OnClickSubmissionBtn)
end

local isSelf
local isLord
local CurOperationPlayerId
function this.WhoShow(data)
    CurOperationPlayerId = data.userId
    curSelectInputObj = nil
    isSelf = data.userId == info_login.id
    isLord = panelClub.clubInfo.userType == proxy_pb.LORD

    GiveSettingPage.Tip:Find('WinFatigueValue').gameObject:SetActive(isLord)
    WinValue2MyGiveValue.gameObject:SetActive(not isLord)
    WinValue2MyGiveValue:GetComponent('UILabel').text=panelClub.clubInfo.ratioSetup==true and '大赢家疲劳值/我的分配疲劳值' or '我的分配疲劳值'

    GiveSettingPage.SubmissionBtn.gameObject:SetActive(not isSelf)

    PanelManager.Instance:ShowWindow("panelNetWaitting")
    this.GetUserPlayFees(
        panelClub.clubInfo.clubId,
        CurOperationPlayerId,
        function(data)
            PanelManager.Instance:HideWindow("panelNetWaitting")
            this.InitDataList(data.fees)
        end
    )

    --print(tostring(UITools.ScrollViewCanMove(GiveSettingPage.Grid.parent:GetComponent('UIScrollView'))))
end

local DataObjList = {}
function this.InitDataList(datas)
    DataObjList = {}
    Util.ClearChild(GiveSettingPage.Grid)

    for i=1, #datas do
        local obj = NGUITools.AddChild(GiveSettingPage.Grid.gameObject, GiveSettingPage.DataItemPrefabe.gameObject)
        SetUserData(obj.gameObject, datas[i])

        obj.transform:Find('PlayName'):GetComponent('UILabel').text = datas[i].playName
        
        if isLord then
            obj.transform:Find('WinValue'):GetComponent('UILabel').text = datas[i].bigWinnerFee
        else
            obj.transform:Find('WinValue2MyGiveValue'):GetComponent('UILabel').text = panelClub.clubInfo.ratioSetup==true and datas[i].bigWinnerFee..'/'..datas[i].fee or datas[i].fee
        end 

        obj.transform:Find('WinValue').gameObject:SetActive(isLord)
        obj.transform:Find('WinValue2MyGiveValue').gameObject:SetActive(not isLord)

        obj.transform:Find('GiveFatigueValue'):GetComponent('UIInput').value = ''
        obj.transform:Find('GiveFatigueValue'):GetComponent('UIInput').defaultText = tostring(datas[i].juniorFee)
        EventDelegate.AddForLua(obj.transform:Find('GiveFatigueValue'):GetComponent('UIInput').onChange, this.OnInputChangeGiveFatigueValue)
        message:AddClick(obj.transform:Find('GiveFatigueValue').gameObject,this.OnClickGiveFatigueValue)
        obj.transform:Find('GiveFatigueValue'):GetComponent('UIInput').onValidate=UITools.GetCheckFloatFunc(1)

        local AutoSetButton = obj.transform:Find('AutoSetButton')
        message:AddClick(AutoSetButton.gameObject, this.OnClickAutoSetBtn)

        AutoSetButton.gameObject:SetActive(isSelf)
        obj.transform:Find('GiveFatigueValue').gameObject:SetActive(not isSelf)

        table.insert(DataObjList, obj)
        obj.transform.gameObject:SetActive(true)
    end

    GiveSettingPage.Grid:GetComponent('UIGrid'):Reposition()
    GiveSettingPage.Grid.parent:GetComponent('UIScrollView'):ResetPosition()
end

function this.OnClickGiveFatigueValue(go)
    curSelectInputObj = go
end
function this.OnInputChangeGiveFatigueValue()
    if curSelectInputObj ~= nil then
        LimitInputFloat(curSelectInputObj:GetComponent('UIInput'),1)
    end
end
function this.GetUserPlayFees(clubId, userId, func)
    local msg = Message.New()
    msg.type = proxy_pb.JUNIOR_PLAY_FEE
    local body = proxy_pb.PJuniorPlayFee()
    body.clubId = clubId
    body.juniorUserId = userId
    msg.body = body:SerializeToString()
    SendProxyMessage(
        msg,
        function(msg)
            local body = proxy_pb.RJuniorPlayFee()
            body:ParseFromString(msg.body)
            if func then
                func(body)
            end
        end
    )
end

function this.UpdateUserPlayFees(clubId, userId, fees, func)
    local msg = Message.New()
    msg.type = proxy_pb.UPDATE_JUNIOR_PLAY_FEE
    local body = proxy_pb.PUpdateJuniorPlayFee()
    body.clubId = clubId
    body.juniorUserId = userId

    for i = 1, #fees do
        print(fees[i].playName, fees[1].juniorFee)
        table.insert(body.fees, fees[i])
    end
    msg.body = body:SerializeToString()
    SendProxyMessage(
        msg,
        function(msg)
            local b = proxy_pb.RResult()
            b:ParseFromString(msg.body)
            if b.code == 1 and func then
                func()
            end
        end
    )
end

function this.OnClickSubmissionBtn(go)
    local fees = {}
    for i=1, #DataObjList do
        local data = GetUserData(DataObjList[i])
        local juniorFee = tonumber(DataObjList[i].transform:Find('GiveFatigueValue'):GetComponent('UILabel').text)

        if juniorFee == nil then
            local str = '【'..data.playName..'】请输入有效的分配的疲劳值'
            panelMessageTip.SetParamers(str, 1)
            PanelManager.Instance:ShowWindow('panelMessageTip')
            return
        end
        if juniorFee < 0 or juniorFee > 999.9 then
            panelMessageTip.SetParamers('请输入0~999.9的值', 1.5)
            PanelManager.Instance:ShowWindow('panelMessageTip')
            return
        end
        if isLord and juniorFee > data.bigWinnerFee then
            local str = '【'..data.playName..'】分配的疲劳值必须小于大赢家疲劳值'
            panelMessageBoxTiShi.SetParamers(ONLY_OK, nil, nil, str)
            PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
            return
        elseif juniorFee > data.fee then
            local str = '【'..data.playName..'】分配的疲劳值必须小于分配给我的疲劳值'
            panelMessageBoxTiShi.SetParamers(ONLY_OK, nil, nil, str)
            PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
            return
        end

        data.juniorFee = juniorFee and juniorFee or 0
        table.insert(fees, data)
    end

    this.UpdateUserPlayFees(
        panelClub.clubInfo.clubId,
        CurOperationPlayerId,
        fees,
        function()
            panelMessageTip.SetParamers("保存成功", 1)
            PanelManager.Instance:ShowWindow("panelMessageTip")
        end
    )
end

function this.OnClickCloseBtn(go)
    AudioManager.Instance:PlayAudio('btn')
    
    if TipPage.Page.gameObject.activeSelf then
        TipPage.Page.gameObject:SetActive(false)
        return
    end

    if SettingPage.Page.gameObject.activeSelf then
        SettingPage.Page.gameObject:SetActive(false)
        return
    end

    PanelManager.Instance:HideWindow(gameObject.name)
end

local curUserPlayFee
function this.OnClickAutoSetBtn(go)
    AudioManager.Instance:PlayAudio('btn')
    
    curUserPlayFee = GetUserData(go.transform.parent.gameObject)
    this.InitSettingPage()
end

function this.InitSettingPage(playId)
    PanelManager.Instance:ShowWindow("panelNetWaitting")

    local msg       = Message.New()
    msg.type        = proxy_pb.MANAGER_FEE_SEND_SETTING_LIST
    local body      = proxy_pb.PManagerFeeSendSettingList()
    body.clubId     = panelClub.clubInfo.clubId
    body.userId     = CurOperationPlayerId
    body.playId     = curUserPlayFee.playId
    msg.body        = body:SerializeToString()
    print("CurOperationPlayerId", CurOperationPlayerId)
    SendProxyMessage(
        msg,
        function(msg)
            PanelManager.Instance:HideWindow("panelNetWaitting")
            local b = proxy_pb.RManagerFeeSendSettingList()
            b:ParseFromString(msg.body)
            this.RefreshSetView(b.datas)
        end
    )
    --SettingPage.Page.gameObject:SetActive(true)
end

local SetObjList = {}
function this.RefreshSetView(datas)

    SetObjList = {}
    Util.ClearChild(SettingPage.Grid)

    for i=1, #datas do
        local obj = NGUITools.AddChild(SettingPage.Grid.gameObject, SettingPage.ItemPrefab.gameObject);
        SetUserData(obj.gameObject, datas[i])
        obj.transform:Find('HasSetNum'):GetComponent('UILabel').text = datas[i].finishedNum;
        obj.transform:Find('NoHasSetNum'):GetComponent('UILabel').text = datas[i].unfinishedNum;
        obj.transform:Find('Type'):GetComponent('UILabel').text = ClubLogic.GetUserTypeString(datas[i].clubUserType);

        obj.transform:Find('Value'):GetComponent('UIInput').value = '';
        obj.transform:Find('Value'):GetComponent('UIInput').defaultText = 0
        obj.transform:Find('Value'):GetComponent('UIInput').onValidate=UITools.GetCheckFloatFunc(1)

        obj.gameObject:SetActive(true)
        table.insert(SetObjList, obj)
    end

    local introduce = curUserPlayFee.playName .. (panelClub.clubInfo.ratioSetup==true and '  大赢家'..curUserPlayFee.bigWinnerFee or '  ');

    if not isLord then
        introduce = introduce..'  分配'..curUserPlayFee.juniorFee
    end

    SettingPage.IntroduceLabel:GetComponent('UILabel').text = introduce

    SettingPage.Page.gameObject:SetActive(true)
    SettingPage.Grid:GetComponent('UIGrid'):Reposition()
    SettingPage.Grid.parent:GetComponent('UIScrollView'):ResetPosition()
end

function this.OnClickSetSubmissionBtn(go)
    local SettingDatas = {}
    for i=1, #SetObjList do
        local data                  = GetUserData(SetObjList[i])
        local settingData           = proxy_pb.SettingData()
        settingData.clubUserType    = data.clubUserType
        settingData.amount          = SetObjList[i].transform:Find('Value'):GetComponent('UILabel').text
        local userTypeStr           = ClubLogic.GetUserTypeString(settingData.clubUserType)

        if isLord and tonumber(settingData.amount) > curUserPlayFee.bigWinnerFee then
            local str = '【'..userTypeStr..'】分配的疲劳值必须小于大赢家疲劳值'
            panelMessageBoxTiShi.SetParamers(ONLY_OK, nil, nil, str)
            PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
            return
        elseif tonumber(settingData.amount) > curUserPlayFee.fee then
            local str = '【'..userTypeStr..'】分配的疲劳值必须小于分配给我的疲劳值'
            panelMessageBoxTiShi.SetParamers(ONLY_OK, nil, nil, str)
            PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
            return
        end

        table.insert(SettingDatas, settingData)
    end

    if #SettingDatas == 0 then
        return
    end

    local str = "只对分配值低于该设置值的直属下级生效。是否确认修改？"
    panelMessageBoxTiShi.SetParamers(
        OK_CANCLE,
        function()
            this.SetSubmissionManagerFeeSendSetting(
                SettingDatas,
                function()
                    panelMessageTip.SetParamers("保存成功", 1)
                    PanelManager.Instance:ShowWindow("panelMessageTip")
                end
            )
        end,
        nil,
        str
    )
    PanelManager.Instance:ShowWindow("panelMessageBoxTiShi")
end

function this.SetSubmissionManagerFeeSendSetting(settingDatas, func)
    local msg       = Message.New()
    msg.type        = proxy_pb.MANAGER_FEE_SEND_SETTING_SAVE
    local body      = proxy_pb.PManagerFeeSendSettingSave()
    body.playId     = curUserPlayFee.playId
    body.clubId     = panelClub.clubInfo.clubId
    for i = 1, #settingDatas do
        table.insert(body.datas, settingDatas[i])
    end
    print("body.playId", body.playId)
    print("body.clubId", body.clubId)
    msg.body = body:SerializeToString()
    SendProxyMessage(
        msg,
        function(msg)
            local b = proxy_pb.RResult()
            b:ParseFromString(msg.body)
            if b.code == 1 and func then
                func()
            end
        end
    )
end

function this.OnClickTipBtn(go)
    TipPage.Page.gameObject:SetActive(true)
end

function this.Update()
end