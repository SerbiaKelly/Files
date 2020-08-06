panelWarnSetting = {}

local this=panelWarnSetting

local message
local gameObject
local closeBtn
local OKBtn

local scrollViewSetting

local startSetting
local closeSetting
local tip
local settingValue
local addSettingBtn
local subSettingBtn
local changeSettingValue

local fuFeeWinLimit
local fuFeeLimitOn
local fuFeeLimitOff
local fuFeeLimitTip
local fuFeeNumLimitValue
local fuFeeNumLimitAddBtn
local fuFeeNumLimitSubBtn
local winLimitNum
local fuFeeLimitValue
local fuFeeLimitAddBtn
local fuFeeLimitSubBtn
local winLimitValue
--启动事件--
function this.Awake(obj)
	gameObject = obj
    message = gameObject:GetComponent('LuaBehaviour')

    closeBtn = gameObject.transform:Find('CloseButton')
    OKBtn = gameObject.transform:Find('ButtonOK')

    scrollViewSetting = gameObject.transform:Find('fuFeeScrollView')

    startSetting = gameObject.transform:Find('fuFeeScrollView/fuFeeMsg/start') 
    closeSetting = gameObject.transform:Find('fuFeeScrollView/fuFeeMsg/close') 

    tip = gameObject.transform:Find('fuFeeScrollView/fuFeeMsg/tip')
    settingValue = gameObject.transform:Find('fuFeeScrollView/fuFeeMsg/warnValue/Value')
    addSettingBtn = gameObject.transform:Find('fuFeeScrollView/fuFeeMsg/warnValue/AddButton')
    subSettingBtn = gameObject.transform:Find('fuFeeScrollView/fuFeeMsg/warnValue/SubtractButton')

    fuFeeWinLimit = gameObject.transform:Find('fuFeeScrollView/fuFeeWinLimit')
    fuFeeLimitOn = fuFeeWinLimit.transform:Find('start')
    fuFeeLimitOff = fuFeeWinLimit.transform:Find('close')
    fuFeeLimitTip = fuFeeWinLimit.transform:Find('tip')
    fuFeeNumLimitValue = fuFeeWinLimit.transform:Find('warnValue/numWarnValue/Value')
    fuFeeNumLimitAddBtn = fuFeeWinLimit.transform:Find('warnValue/numWarnValue/AddButton')
    fuFeeNumLimitSubBtn = fuFeeWinLimit.transform:Find('warnValue/numWarnValue/SubtractButton')
	
	fuFeeLimitValue = fuFeeWinLimit.transform:Find('warnValue/fuFeeWarnValue/Value')
    fuFeeLimitAddBtn = fuFeeWinLimit.transform:Find('warnValue/fuFeeWarnValue/AddButton')
    fuFeeLimitSubBtn = fuFeeWinLimit.transform:Find('warnValue/fuFeeWarnValue/SubtractButton')

    message:AddClick(closeBtn.gameObject, this.OnCloseButtonClick)
    message:AddClick(OKBtn.gameObject, this.OnOKButtonClick)
    message:AddClick(startSetting.gameObject, this.OnSettingButtonClick)
    message:AddClick(closeSetting.gameObject, this.OnSettingButtonClick)
    message:AddClick(addSettingBtn.gameObject, this.OnChangeSettingValueButtonClick)
    message:AddClick(subSettingBtn.gameObject, this.OnChangeSettingValueButtonClick)

    message:AddClick(fuFeeLimitOn.gameObject, this.OnFuFeeWinLimitBtnClick)
    message:AddClick(fuFeeLimitOff.gameObject, this.OnFuFeeWinLimitBtnClick)
    message:AddClick(fuFeeNumLimitAddBtn.gameObject, this.OnFuFeeWinLimitNumBtnClick)
    message:AddClick(fuFeeNumLimitSubBtn.gameObject, this.OnFuFeeWinLimitNumBtnClick)
	message:AddClick(fuFeeLimitAddBtn.gameObject, this.OnFuFeeWinLimitValueBtnClick)
    message:AddClick(fuFeeLimitSubBtn.gameObject, this.OnFuFeeWinLimitValueBtnClick)
end

function this.Start()
end

function this.OnEnable()
    changeSettingValue = panelClub.clubInfo.lossFee
    winLimitNum = panelClub.clubInfo.lossWin
	winLimitValue = panelClub.clubInfo.lossWinFee
    print('changeSettingValue : '..changeSettingValue..' winLimitNum : '..winLimitNum..' winLimitValue : '..winLimitValue)
    if panelClub.clubInfo.userType == proxy_pb.LORD then
        tip:GetComponent('UILabel').text = changeSettingValue ~= 0 and '（选择后，群成员疲劳值若大于等于设定的负疲劳值数，系统会通过消息通知直属管家或上级管理员、群主）' or '（选择后，群成员疲劳值不管负多少，都不发送消息给相应管家）'
    elseif panelClub.clubInfo.userType ~= proxy_pb.GENERAL then
        tip:GetComponent('UILabel').text = changeSettingValue ~= 0 and '（选择后，直属与管家成员疲劳值若大于等于设定的负疲劳值数，系统会通过消息通知你）' or '（选择后，直属与管家成员疲劳值不管负多少，都不发送消息给你）'
    end
    startSetting:GetComponent('UIToggle'):Set(changeSettingValue ~= 0)
    closeSetting:GetComponent('UIToggle'):Set(changeSettingValue == 0)
    settingValue:GetComponent('UILabel').text = changeSettingValue
    settingValue.parent.gameObject:SetActive(changeSettingValue ~= 0)

    fuFeeWinLimit.gameObject:SetActive(panelClub.clubInfo.userType == proxy_pb.LORD and changeSettingValue ~= 0)
    fuFeeLimitOn:GetComponent('UIToggle'):Set(winLimitValue ~= 0)
    fuFeeLimitOff:GetComponent('UIToggle'):Set(winLimitValue == 0)
    fuFeeNumLimitValue:GetComponent('UILabel').text = winLimitNum
	fuFeeLimitValue:GetComponent('UILabel').text = winLimitValue
    fuFeeNumLimitValue.parent.parent.gameObject:SetActive(winLimitValue ~= 0)
    fuFeeLimitTip:GetComponent('UILabel').text = winLimitValue ~= 0 and '（选择后，赢家的对局中，如果输家负疲劳值数达到了设定的限制值，且赢家的次数达到了设定的次数，则该赢家将被限制减疲劳值，并且会被系统自动拉入小黑屋，不可进入游戏）' or '（选择后，不限制赢家的次数，赢家不会被自动拉入小黑屋，可随时减疲劳值）'
	fuFeeNumLimitValue.parent.parent.localPosition = winLimitValue ~= 0 and Vector3(0,-80,0) or Vector3(0,0,0)
	scrollViewSetting:GetComponent('UIScrollView'):ResetPosition()
end

function this.Update()
end

function this.WhoShow()
end
function this.OnCloseButtonClick(go)
    AudioManager.Instance:PlayAudio('btn')
    PanelManager.Instance:HideWindow(gameObject.name)
end

function this.OnOKButtonClick(go)
    AudioManager.Instance:PlayAudio('btn')
    local msg = Message.New()
    msg.type = proxy_pb.UPDATE_CLUB_OVER_FLOW
    local body = proxy_pb.PUpdateOverFlow()
    body.clubId = panelClub.clubInfo.clubId
    body.lossFee = changeSettingValue
    body.lossWin = changeSettingValue==0 and 0 or winLimitNum
	body.lossWinFee = changeSettingValue==0 and 0 or winLimitValue
    msg.body = body:SerializeToString()
	print('body.lossFee : '..body.lossFee..' body.lossWin : '..body.lossWin..' body.lossWinFee : '..body.lossWinFee)
    SendProxyMessage(msg, function (msg)
            local data = proxy_pb.RUpdateOverFlow()
			data:ParseFromString(msg.body)
			panelClub.clubInfo.lossFee = data.lossFee
			panelClub.clubInfo.lossWin = data.lossWin
			panelClub.clubInfo.lossWinFee = data.lossWinFee
			PanelManager.Instance:HideWindow(gameObject.name)
			panelMessageTip.SetParamers('设置成功', 1.5)
			PanelManager.Instance:ShowWindow('panelMessageTip')	
			print('data.lossFee : '..data.lossFee..' data.lossWin : '..data.lossWin..' data.lossWinFee : '..data.lossWinFee)
        end) 
end

function this.OnSettingButtonClick(go)
    AudioManager.Instance:PlayAudio('btn')
    if go == startSetting.gameObject then
        if panelClub.clubInfo.userType == proxy_pb.LORD and changeSettingValue == 0 then
            changeSettingValue =  100
        elseif panelClub.clubInfo.userType ~= proxy_pb.GENERAL and changeSettingValue == 0 then
            changeSettingValue =  50
        end
        settingValue:GetComponent('UILabel').text = changeSettingValue
    else
        scrollViewSetting:GetComponent('UIScrollView'):ResetPosition()
        changeSettingValue=0
    end
    fuFeeWinLimit.gameObject:SetActive(panelClub.clubInfo.userType == proxy_pb.LORD and changeSettingValue ~= 0)
    fuFeeNumLimitValue.parent.parent.gameObject:SetActive(winLimitValue ~= 0)
    settingValue.parent.gameObject:SetActive(changeSettingValue ~= 0)
    if panelClub.clubInfo.userType == proxy_pb.LORD then
        tip:GetComponent('UILabel').text = go == startSetting.gameObject and '（选择后，群成员疲劳值若大于等于设定的负疲劳值数，系统会通过消息通知直属管家或上级管理员、群主）' or '（选择后，群成员疲劳值不管负多少，都不发送消息给相应管家）'
    elseif panelClub.clubInfo.userType ~= proxy_pb.GENERAL then
        tip:GetComponent('UILabel').text = go == startSetting.gameObject and '（选择后，直属与管家成员疲劳值若大于等于设定的负疲劳值数，系统会通过消息通知你）' or '（选择后，直属与管家成员疲劳值不管负多少，都不发送消息给你）'
    end
end

function this.OnChangeSettingValueButtonClick(go)
    AudioManager.Instance:PlayAudio('btn')
    if go == addSettingBtn.gameObject then
        changeSettingValue = changeSettingValue+5
        if changeSettingValue>300 then
            changeSettingValue = 300
        end
    elseif go == subSettingBtn.gameObject then
        changeSettingValue = changeSettingValue-5
        if changeSettingValue<30 then
            changeSettingValue = 30
        end
    end
    settingValue:GetComponent('UILabel').text = changeSettingValue
end

function this.OnFuFeeWinLimitBtnClick(go)
    AudioManager.Instance:PlayAudio('btn')
    if go == fuFeeLimitOn.gameObject then
        if winLimitNum == 0 then
            winLimitNum = 1
        end
		if winLimitValue == 0 then
            winLimitValue = 100
        end
    else
        winLimitNum = 0
		winLimitValue = 0
    end
	fuFeeNumLimitValue:GetComponent('UILabel').text = winLimitNum
	fuFeeLimitValue:GetComponent('UILabel').text = winLimitValue
    fuFeeNumLimitValue.parent.parent.gameObject:SetActive(winLimitValue ~= 0)
    fuFeeLimitTip:GetComponent('UILabel').text = winLimitValue ~= 0 and '（选择后，赢家的对局中，如果输家负疲劳值数达到了设定的限制值，且赢家的次数达到了设定的次数，则该赢家将被限制减疲劳值，并且会被系统自动拉入小黑屋，不可进入游戏）' or '（选择后，不限制赢家的次数，赢家不会被自动拉入小黑屋，可随时减疲劳值）'
	fuFeeNumLimitValue.parent.parent.localPosition = winLimitValue ~= 0 and Vector3(0,-80,0) or Vector3(0,0,0)
end

function this.OnFuFeeWinLimitNumBtnClick(go)
    AudioManager.Instance:PlayAudio('btn')
    if go == fuFeeNumLimitAddBtn.gameObject then
        winLimitNum = winLimitNum+1
        if winLimitNum>5 then
            winLimitNum = 5
        end
    elseif go == fuFeeNumLimitSubBtn.gameObject then
        winLimitNum = winLimitNum-1
        if winLimitNum<1 then
            winLimitNum = 1
        end
    end
    fuFeeNumLimitValue:GetComponent('UILabel').text = winLimitNum
end

function this.OnFuFeeWinLimitValueBtnClick(go)
    AudioManager.Instance:PlayAudio('btn')
    if go == fuFeeLimitAddBtn.gameObject then
        winLimitValue = winLimitValue+5
        if winLimitValue>300 then
            winLimitValue = 300
        end
    elseif go == fuFeeLimitSubBtn.gameObject then
        winLimitValue = winLimitValue-5
        if winLimitValue<30 then
            winLimitValue = 30
        end
    end
    fuFeeLimitValue:GetComponent('UILabel').text = winLimitValue
end