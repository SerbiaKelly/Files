require "Game.Tools.UITools"

panelMatchMenberManager = {}
local this = panelMatchMenberManager

local message;
local gameObject;

local BasicsInfoPage = {}

local AuthorityPage = {}

local EarlyWarningPage = {}

local CurOperationPlayer = {}

local operatorFeePrecent = 0

local CloseBtn

function this.Awake(go)
    gameObject = go;
    message = gameObject:GetComponent('LuaBehaviour');

    BasicsInfoPage.Page                 = gameObject.transform:Find('BasicsInfoPage')
    BasicsInfoPage.Image                = BasicsInfoPage.Page.transform:Find('Info/Image/Texture'):GetComponent('UITexture')
    BasicsInfoPage.Name                 = BasicsInfoPage.Page.transform:Find('Info/Name/Label'):GetComponent('UILabel')
    BasicsInfoPage.ID                   = BasicsInfoPage.Page.transform:Find('Info/ID/Label'):GetComponent('UILabel')
    BasicsInfoPage.Remarks              = BasicsInfoPage.Page.transform:Find('Info/Remarks/Label'):GetComponent('UILabel')
    BasicsInfoPage.JoinTime             = BasicsInfoPage.Page.transform:Find('Info/timeGrid/JoinTime/Label'):GetComponent('UILabel')
    BasicsInfoPage.LastGameTime         = BasicsInfoPage.Page.transform:Find('Info/timeGrid/LastGameTime/Label'):GetComponent('UILabel')
    BasicsInfoPage.Post                 = BasicsInfoPage.Page.transform:Find('Info/Post/Label'):GetComponent('UILabel')
    BasicsInfoPage.SetParentBtn         = BasicsInfoPage.Page.transform:Find('Info/Parent/SetParentBtn')
    BasicsInfoPage.HasParentTag         = BasicsInfoPage.Page.transform:Find('Info/Parent/HasParent')
    BasicsInfoPage.RemarksBtn           = BasicsInfoPage.Page.transform:Find('Info/RemarksBtn')
    BasicsInfoPage.SetIdentity          = BasicsInfoPage.Page.transform:Find('Info/SetIdentity')
    BasicsInfoPage.SetAuthorityBtn      = BasicsInfoPage.SetIdentity.transform:Find('SetAuthorityBtn')
    BasicsInfoPage.DeleteMembersBtn     = BasicsInfoPage.Page.transform:Find('Operation/DeleteMembersBtn')
    BasicsInfoPage.JoinBlackBtn         = BasicsInfoPage.Page.transform:Find('Operation/JoinBlackBtn')
    BasicsInfoPage.JoinTwooBlackBtn     = BasicsInfoPage.Page.transform:Find('Operation/JoinTwooBlackBtn')
    BasicsInfoPage.LookMemberBtn        = BasicsInfoPage.Page.transform:Find('Operation/LookMemberBtn')
    BasicsInfoPage.FatigueModifyBtn     = BasicsInfoPage.Page.transform:Find('FatigueValue/FatigueModifyBtn')
    BasicsInfoPage.ChangeRecordBtn      = BasicsInfoPage.Page.transform:Find('FatigueValue/ChangeRecordBtn')
    BasicsInfoPage.FatigueValue         = BasicsInfoPage.Page.transform:Find('FatigueValue/Value/Label'):GetComponent('UILabel')
    BasicsInfoPage.GiveSettigBtn        = BasicsInfoPage.Page.transform:Find('Info/GiveSettigBtn')
    BasicsInfoPage.EarlyWarningBtn      = BasicsInfoPage.Page.transform:Find('Info/EarlyWarningBtn')
    BasicsInfoPage.LiftLimitBtn         = BasicsInfoPage.Page.transform:Find('Info/LiftLimitBtn')
    BasicsInfoPage.LiftFreezeBtn        = BasicsInfoPage.Page.transform:Find('Info/LiftFreezeBtn')

    AuthorityPage.Page                  = gameObject.transform:Find('AuthorityPage')
    AuthorityPage.AuthorityToggles      = AuthorityPage.Page.transform:Find('BasicAuthority/scrollView/ToggleGrid')
    AuthorityPage.Score                 = AuthorityPage.Page.transform:Find('AssignAuthority/Score'):GetComponent('UILabel')
    AuthorityPage.SubmissionBtn         = AuthorityPage.Page.transform:Find('SubmissionBtn')
    AuthorityPage.TipBtn                = AuthorityPage.Page.transform:Find('AssignAuthority/TipBtn')
    AuthorityPage.TipPanel              = AuthorityPage.Page.transform:Find('TipPanel')
    AuthorityPage.NoEditor              = AuthorityPage.Page.transform:Find('NoEditor')

    EarlyWarningPage.Page                                   = gameObject.transform:Find('EarlyWarningPage')
    EarlyWarningPage.SubmissionBtn                          = EarlyWarningPage.Page.transform:Find('SubmissionBtn')

    EarlyWarningPage.EarlyWarningSetting                    = {}
    EarlyWarningPage.EarlyWarningSetting.transform          = EarlyWarningPage.Page.transform:Find('EarlyWarning/scrollView/EarlyWarningSetting')
    EarlyWarningPage.EarlyWarningSetting.tip                = EarlyWarningPage.EarlyWarningSetting.transform:Find('tip')
    EarlyWarningPage.EarlyWarningSetting.open               = EarlyWarningPage.EarlyWarningSetting.transform:Find('open')
    EarlyWarningPage.EarlyWarningSetting.close              = EarlyWarningPage.EarlyWarningSetting.transform:Find('close')
    EarlyWarningPage.EarlyWarningSetting.EarlyWarningValue  = EarlyWarningPage.EarlyWarningSetting.transform:Find('EarlyWarningValue/Value')
    EarlyWarningPage.EarlyWarningSetting.limitToggle        = EarlyWarningPage.EarlyWarningSetting.transform:Find('limitToggle')
    EarlyWarningPage.EarlyWarningSetting.limitValue         = EarlyWarningPage.EarlyWarningSetting.transform:Find('limitValue/Value')

    EarlyWarningPage.freezeSetting                          = {}
    EarlyWarningPage.freezeSetting.transform                = EarlyWarningPage.Page.transform:Find('EarlyWarning/scrollView/freezeSetting')
    EarlyWarningPage.freezeSetting.tip                      = EarlyWarningPage.freezeSetting.transform:Find('tip')
    EarlyWarningPage.freezeSetting.open                     = EarlyWarningPage.freezeSetting.transform:Find('open')
    EarlyWarningPage.freezeSetting.close                    = EarlyWarningPage.freezeSetting.transform:Find('close')
    EarlyWarningPage.freezeSetting.freezeValue              = EarlyWarningPage.freezeSetting.transform:Find('freezeValue/Value')

    CloseBtn = gameObject.transform:Find('BaseContent/ButtonClose')
    
    for i = 0, BasicsInfoPage.SetIdentity.childCount - 1 do
        local button = BasicsInfoPage.SetIdentity:GetChild(i)
        message:AddClick(button.gameObject, this.OnClickSetIdentityBtn)
    end

    for i = 0, AuthorityPage.AuthorityToggles.childCount - 1 do
        local toggle = AuthorityPage.AuthorityToggles:GetChild(i)
        message:AddClick(toggle.gameObject, this.OnClickAuthorityToggle)
    end

    message:RemoveClick(BasicsInfoPage.SetAuthorityBtn.gameObject)
    message:AddClick(BasicsInfoPage.SetAuthorityBtn.gameObject,                         this.OnClickSetAuthorityBtn)
    message:AddClick(AuthorityPage.TipBtn.gameObject,                                   this.OnClickTipBtn)
    message:AddClick(AuthorityPage.TipPanel:Find('BaseContent/ButtonClose').gameObject, this.OnClickTipBtn)
    message:AddClick(CloseBtn.gameObject,                                               this.OnClickCloseBtn)
    message:AddClick(AuthorityPage.Page:Find('BaseContent/ButtonClose').gameObject,     this.OnClickCloseBtn)
    message:AddClick(AuthorityPage.SubmissionBtn.gameObject,                            this.OnClickSubmissionBtn)
    message:AddClick(BasicsInfoPage.DeleteMembersBtn.gameObject,                        this.OnClickDeletBtn)
    message:AddClick(BasicsInfoPage.JoinBlackBtn.gameObject,                            this.OnClickJoinBlackHouse)
    message:AddClick(BasicsInfoPage.FatigueModifyBtn.gameObject,                        this.OnClickFatigueModifyBtn)
    message:AddClick(BasicsInfoPage.ChangeRecordBtn.gameObject,                         this.OnClickFatigueModifyBtn)
    message:AddClick(BasicsInfoPage.JoinTwooBlackBtn.gameObject,                        this.OnClickJoin2BlackHuose)
    message:AddClick(BasicsInfoPage.LookMemberBtn.gameObject,                           this.OnClickLookMemberBtn)
    message:AddClick(BasicsInfoPage.GiveSettigBtn.gameObject,                           this.OnClickGiveSettigBtn)
    message:AddClick(BasicsInfoPage.SetParentBtn.gameObject,                            this.OnClickSetParentBtn)
    message:AddClick(EarlyWarningPage.Page:Find('BaseContent/ButtonClose').gameObject,  this.OnClickCloseBtn)
    message:AddClick(BasicsInfoPage.EarlyWarningBtn.gameObject,                         this.OnClickEarlyWarningBtn)
    message:AddClick(BasicsInfoPage.LiftLimitBtn.gameObject,                            this.OnClickLiftLimitBtn)
    message:AddClick(BasicsInfoPage.LiftFreezeBtn.gameObject,                           this.OnClickFreezeBtn)
    message:AddClick(EarlyWarningPage.EarlyWarningSetting.open.gameObject,              this.OnClickEarlyWarning)
    message:AddClick(EarlyWarningPage.EarlyWarningSetting.close.gameObject,             this.OnClickEarlyWarning)
    message:AddClick(EarlyWarningPage.EarlyWarningSetting.limitToggle.gameObject,       this.OnClickLimit)
    message:AddClick(EarlyWarningPage.freezeSetting.open.gameObject,                    this.OnClickFreeze)
    message:AddClick(EarlyWarningPage.freezeSetting.close.gameObject,                   this.OnClickFreeze)
    message:AddClick(EarlyWarningPage.SubmissionBtn.gameObject,                            this.OnClickSure)
    -- EarlyWarningPage.EarlyWarningSetting.EarlyWarningValue:GetComponent('UIInput').onValidate=checkInteger
    -- EarlyWarningPage.EarlyWarningSetting.limitValue:GetComponent('UIInput').onValidate=checkInteger
    -- EarlyWarningPage.freezeSetting.freezeValue:GetComponent('UIInput').onValidate=checkInteger
    message:AddOnChange(EarlyWarningPage.EarlyWarningSetting.EarlyWarningValue.gameObject,this.OnEarlyWarningInput)
    message:AddOnChange(EarlyWarningPage.EarlyWarningSetting.limitValue.gameObject,this.OnLimitInput)
    message:AddOnChange(EarlyWarningPage.freezeSetting.freezeValue.gameObject,this.OnFreezeInput)
end

function this.WhoShow(data)
    if data.userData then
        this.InitViewFromUserData(data.userData)
    elseif data.managerData then
        this.InitViewFromManagerData(data.managerData)
    end
end

local isGiveBtn = false
function this.InitViewFromUserData(data)
    --this.InitPlayInfo(data.userId,data.nickname, data.icon,'', data.userType, data.managerId, data.managerNickname)
	isGiveBtn = (panelClub.clubInfo.userType ~= proxy_pb.LORD and data.userId == info_login.id)
	BasicsInfoPage.FatigueModifyBtn:Find('Label'):GetComponent('UILabel').text = not isGiveBtn and '修改' or '赠送'
    this.InitBasicsInfoPage(data.userId,data.nickname, data.icon, data.userType, data.remarks, data.joinTime, data.superiorId)
end

function this.InitViewFromManagerData(data)
	isGiveBtn = false
	BasicsInfoPage.FatigueModifyBtn:Find('Label'):GetComponent('UILabel').text = '修改' 
    this.InitBasicsInfoPage(data.userId, data.nickname, data.icon, data.userType, data.remarks, data.joinTime, info_login.id)
end

function this.InitBasicsInfoPage(id, name, image, userType, remarks, joinTime, managerId)
    BasicsInfoPage.ID.text = id
    --UITools.SetAutoLabel(BasicsInfoPage.Name, name)
    BasicsInfoPage.Name.text = name
    coroutine.start(LoadPlayerIcon, BasicsInfoPage.Image, image)
    BasicsInfoPage.Remarks.text = (remarks == nil or remarks == '') and '暂无备注' or remarks
    local IsHasManager = not (managerId == nil or managerId == '')
    local IsNotIdentity = userType == proxy_pb.GENERAL
    BasicsInfoPage.HasParentTag.gameObject:SetActive(IsHasManager)
    BasicsInfoPage.SetIdentity.gameObject:SetActive(false)
    CurOperationPlayer = this.BuildPlayerInfo(id, name, userType, managerId)

    this.RefrehBasicsInfoPage()
end

function this.RefrehBasicsInfoPage(data)
    PanelManager.Instance:ShowWindow('panelNetWaitting')

    if data ~= nil then
        this.SetBasicsInfo(data)
        return
    end

    this.QueryPlayerAuthority(CurOperationPlayer.userId, function (data)
        PanelManager.Instance:HideWindow('panelNetWaitting')
        this.SetBasicsInfo(data)
        print('当前玩家的权限：'..tostring(data.privilege))
    end)
end

function this.SetBasicsInfo(data)
    operatorFeePrecent                  = data.operatorFeePrecent
    CurOperationPlayer.Authorities      = data.privilege
    CurOperationPlayer.feePrecent       = data.feePrecent
    CurOperationPlayer.feeBalance       = data.feeBalance
    CurOperationPlayer.membership       = data.membership
    BasicsInfoPage.FatigueValue.text    = data.feeBalance
    CurOperationPlayer.forbidStatus     = data.forbidStatus
    CurOperationPlayer.freezeStatus     = data.freezeStatus
    CurOperationPlayer.showAlert        = data.showAlert
    print('data.privilege:'..tostring(data.privilege))

    BasicsInfoPage.JoinTime.transform.parent.gameObject:SetActive(panelClub.clubInfo.showJoinTime)
    BasicsInfoPage.LastGameTime.transform.parent.gameObject:SetActive(panelClub.clubInfo.showPlayTime)
    BasicsInfoPage.LastGameTime.transform.parent.parent:GetComponent('UIGrid'):Reposition()
    BasicsInfoPage.JoinTime.text = os.date('%Y.%m.%d %H:%M:%S', data.joinTime)
	BasicsInfoPage.LastGameTime.text = data.lastPlayerTime==0 and '无' or os.date('%Y.%m.%d %H:%M:%S', data.lastPlayerTime)
    this.InitButtons()
end

function this.GetNeedHideButtons()
    local buttons = {
        BasicsInfoPage.RemarksBtn,
        BasicsInfoPage.GiveSettigBtn,
        BasicsInfoPage.DeleteMembersBtn,
        BasicsInfoPage.JoinBlackBtn,
        BasicsInfoPage.JoinTwooBlackBtn,
        BasicsInfoPage.SetAuthorityBtn,
        BasicsInfoPage.FatigueModifyBtn,
        BasicsInfoPage.LookMemberBtn,
        BasicsInfoPage.EarlyWarningBtn,
        BasicsInfoPage.LiftLimitBtn,
        BasicsInfoPage.LiftFreezeBtn,
    }
    return buttons
end

--按钮 对玩家身份不同会有所变化
function this.InitButtons()

    local hideButtons           = this.GetNeedHideButtons()
    local membership            = CurOperationPlayer.membership
    local isSelf                = CurOperationPlayer.userId == info_login.id
    local isLord                = panelClub.clubInfo.userType == proxy_pb.LORD
    local isManager             = panelClub.clubInfo.userType == proxy_pb.MANAGER

    local isCanOperatingMenber  = IsCanOperatingMenber()
    local isHasParent           = CurOperationPlayer.manageId ~= nil and CurOperationPlayer.manageId ~= ''
    local IsHasIdentity         = CurOperationPlayer.userType == proxy_pb.GENERAL
    local isCanOperatingFatigue = isCanCleanAllFeeBalance() or ((membership == 1) and isCanCleanMySelfFeeBalance()) or (membership == 2 and isCanCleanMemangerFeeBalance()) or isGiveBtn

    this.SetOperationButtonEnable(BasicsInfoPage.DeleteMembersBtn, (isCanOperatingMenber or  membership == 1))
    --BasicsInfoPage.DeleteMembersBtn:GetComponent('BoxCollider').enabled = (isCanOperatingMenber or  membership == 1)

    --加入小黑屋 和 互斥 需要群主和管理员
    this.SetOperationButtonEnable(BasicsInfoPage.JoinBlackBtn, (isCanOperatingMenber or  membership == 1) and (isManager or isLord))
    this.SetOperationButtonEnable(BasicsInfoPage.JoinTwooBlackBtn, (isCanOperatingMenber or  membership == 1) and (isManager or isLord))
    this.SetOperationButtonEnable(BasicsInfoPage.LookMemberBtn, not IsHasIdentity and panelClub.clubInfo.userType ~= proxy_pb.GENERAL)
    BasicsInfoPage.EarlyWarningBtn.gameObject:SetActive(CurOperationPlayer.showAlert)
    BasicsInfoPage.LiftLimitBtn.gameObject:SetActive(CurOperationPlayer.forbidStatus)
    BasicsInfoPage.LiftFreezeBtn.gameObject:SetActive(CurOperationPlayer.freezeStatus)
    --BasicsInfoPage.JoinBlackBtn:GetComponent('BoxCollider').enabled = (isCanOperatingMenber or  membership == 1) and (isManager or isLord)
    --BasicsInfoPage.JoinTwooBlackBtn:GetComponent('BoxCollider').enabled = (isCanOperatingMenber or  membership == 1) and (isManager or isLord)

    BasicsInfoPage.ChangeRecordBtn.gameObject:SetActive(isCanOperatingFatigue or membership == 0)
    BasicsInfoPage.FatigueModifyBtn.gameObject:SetActive(isCanOperatingFatigue)

    this.UpdateIdentityView(CurOperationPlayer.userType, panelClub.clubInfo.userType, membership == 1)

    BasicsInfoPage.RemarksBtn.gameObject:SetActive(false)

    for i = 1, #hideButtons do
        hideButtons[i].gameObject:SetActive(not hideButtons[i].gameObject.activeSelf)
        hideButtons[i].gameObject:SetActive(not hideButtons[i].gameObject.activeSelf)
    end

    BasicsInfoPage.SetIdentity:GetComponent('UIGrid'):Reposition() --对button牌一下序

end

function this.UpdateIdentityView(userType, selfType, isDirectlyUnder)
    local isGamer = userType == proxy_pb.GENERAL
    local isLord = selfType == proxy_pb.LORD
    local canSetTypes = this.GetCanSetIdentity(userType, selfType)

    print('是不是直属：'..tostring(isDirectlyUnder))
    BasicsInfoPage.SetIdentity.gameObject:SetActive(false)
    for i = 0, BasicsInfoPage.SetIdentity.transform.childCount - 2 do
        BasicsInfoPage.SetIdentity.transform:GetChild(i).gameObject:SetActive(false)
    end

    print(#canSetTypes)
    for i = 1, #canSetTypes do
        local button = BasicsInfoPage.SetIdentity.transform:Find(canSetTypes[i])
        button.transform:Find('SetLabel').gameObject:SetActive(isGamer)
        button.transform:Find('ElevateLabel').gameObject:SetActive(not isGamer)

        button.gameObject:SetActive(isDirectlyUnder)
    end
    
    BasicsInfoPage.SetIdentity.gameObject:SetActive(true)
    BasicsInfoPage.SetAuthorityBtn.gameObject:SetActive(CurOperationPlayer.membership == 1 and not isGamer)
    BasicsInfoPage.SetIdentity:GetComponent('UIGrid'):Reposition()
    BasicsInfoPage.Post.text = this.GetTypeNameFromUserType(userType)
    BasicsInfoPage.SetParentBtn.gameObject:SetActive(CurOperationPlayer.userType == proxy_pb.GENERAL and isLord and CurOperationPlayer.membership == 1)
    BasicsInfoPage.GiveSettigBtn.gameObject:SetActive((CurOperationPlayer.membership == 1 or CurOperationPlayer.membership == 0)
        and userType ~= proxy_pb.GENERAL and (selfType ~= proxy_pb.GENERAL)) --and (selfType ~= proxy_pb.ASSISTANT)) 
end

function this.BuildPlayerInfo(id, name, userType, managerId)
    return {userId = id, nickname = name, userType = userType, 
        managerId = managerId, Authorities = 1, feePrecent = 0, feeBalance = 0, membership = 3}
end

local CurAuthoritiesTmep
local ConstAuthorities = {1,2,4,8,32,64,128,256,512,1024,2048,4096,8192,16384,32768,65536,131072,262144}
function this.InitAuthorityPage(playerAuthorities, feePrecent, membership, isAdd)
    print("playerAuthorities:"..playerAuthorities);
	print('64 : '..tostring(bit:_and(playerAuthorities, 64)==64)..' 128 : '..tostring(bit:_and(playerAuthorities, 128)==128)..' 256 : '..tostring(bit:_and(playerAuthorities, 256)==256)..' 4096 : '..tostring(bit:_and(playerAuthorities, 4096)==4096)..' 8192 : '..tostring(bit:_and(playerAuthorities, 8192)==8192)..' 16384 : '..tostring(bit:_and(playerAuthorities, 16384)==16384)..' 32768 : '..tostring(bit:_and(playerAuthorities, 32768)==32768)..' 65536 : '..tostring(bit:_and(playerAuthorities, 65536)==65536)..' 131072 : '..tostring(bit:_and(playerAuthorities, 131072)==131072))
    for i = 1, #ConstAuthorities do
        local toggle = AuthorityPage.AuthorityToggles:Find(ConstAuthorities[i])
		
        if isAdd then
            toggle:GetComponent('UIToggle'):Set(false)
        else
            if playerAuthorities ~= nil then
                toggle:GetComponent('UIToggle'):Set(bit:_and(playerAuthorities, ConstAuthorities[i]) == ConstAuthorities[i])
            end
        end

        --管理员
        if CurOperationPlayer.userType == proxy_pb.MANAGER then
            toggle.gameObject:SetActive(true);
        end

        --馆长，副馆长，会长
        if CurOperationPlayer.userType == proxy_pb.VICE_MANAGER or
                CurOperationPlayer.userType == proxy_pb.ASSISTANT or
                CurOperationPlayer.userType == proxy_pb.PRESIDENT
        then
            toggle.gameObject:SetActive(ConstAuthorities[i] == 1024 or ConstAuthorities[i] == 4096 or ConstAuthorities[i] == 8192 or ConstAuthorities[i] == 16384 or ConstAuthorities[i] == 32768)
        end

        --副会长
        if CurOperationPlayer.userType == proxy_pb.VICE_PRESIDENT then
            toggle.gameObject:SetActive(ConstAuthorities[i] == 1024 or ConstAuthorities[i] == 4096 or ConstAuthorities[i] == 8192)
        end
        
        if ConstAuthorities[i]==262144 then
            if (panelClub.clubInfo.userType == proxy_pb.LORD or bit:_and(panelClub.clubInfo.privilege, 262144)==262144) and (CurOperationPlayer.userType ~= proxy_pb.VICE_PRESIDENT and CurOperationPlayer.userType ~= proxy_pb.GENERAL) then
                print('有权限262144')
                toggle.gameObject:SetActive(true)
                --toggle:GetComponent('UIToggle'):Set(bit:_and(playerAuthorities, 262144)==262144)
            else   
                print('没有权限262144')
                toggle.gameObject:SetActive(false) 
            end
        end
    end
    
	if bit:_and(playerAuthorities, 64) == 64 then
		playerAuthorities = bit:_xor(playerAuthorities, 64)
		AuthorityPage.AuthorityToggles:Find('4096'):GetComponent('UIToggle'):Set(true)
		playerAuthorities = bit:_or(playerAuthorities, 4096)
		AuthorityPage.AuthorityToggles:Find('8192'):GetComponent('UIToggle'):Set(true)
		playerAuthorities = bit:_or(playerAuthorities, 8192)
	end
	if bit:_and(playerAuthorities, 256) == 256 then
		playerAuthorities = bit:_xor(playerAuthorities, 256)
		AuthorityPage.AuthorityToggles:Find('16384'):GetComponent('UIToggle'):Set(true)
		playerAuthorities = bit:_or(playerAuthorities, 16384)
		AuthorityPage.AuthorityToggles:Find('32768'):GetComponent('UIToggle'):Set(true)
		playerAuthorities = bit:_or(playerAuthorities, 32768)
	end
	if bit:_and(playerAuthorities, 128) == 128 then
		playerAuthorities = bit:_xor(playerAuthorities, 128)
		AuthorityPage.AuthorityToggles:Find('65536'):GetComponent('UIToggle'):Set(true)
		playerAuthorities = bit:_or(playerAuthorities, 65536)
		AuthorityPage.AuthorityToggles:Find('131072'):GetComponent('UIToggle'):Set(true)
		playerAuthorities = bit:_or(playerAuthorities, 131072)
	end
    
	AuthorityPage.AuthorityToggles:Find('64').gameObject:SetActive(false)
	AuthorityPage.AuthorityToggles:Find('256').gameObject:SetActive(false)
	AuthorityPage.AuthorityToggles:Find('128').gameObject:SetActive(false)
    CurAuthoritiesTmep = 0
    CurAuthoritiesTmep = playerAuthorities
    AuthorityPage.Score.text = feePrecent
    AuthorityPage.Score:GetComponent('UIInput').value = feePrecent
    AuthorityPage.SubmissionBtn.gameObject:SetActive(membership == 1 or membership == 2)
    AuthorityPage.NoEditor.gameObject:SetActive(not (membership == 1 or membership == 2))
    AuthorityPage.Score.transform.parent.gameObject:SetActive(CurOperationPlayer.userType == proxy_pb.MANAGER)
    AuthorityPage.Page.gameObject:SetActive(true)
	--AuthorityPage.AuthorityToggles:GetComponent('UIGrid'):Reposition()
	AuthorityPage.AuthorityToggles.parent:GetComponent('UIScrollView'):ResetPosition()
end

function this.OnClickAuthorityToggle(go)
    AudioManager.Instance:PlayAudio('btn')
    local privilege = tonumber(go.gameObject.name) 
    print('添加新的权限：'..privilege.."  || "..bit:_or(CurAuthoritiesTmep, privilege))
    if bit:_and(CurAuthoritiesTmep, privilege) == privilege then
        if privilege==262144 then
            panelMessageBoxTiShi.SetParamers(OK_CANCLE, function()
                CurAuthoritiesTmep = bit:_xor(CurAuthoritiesTmep, privilege)
            end, function()
                go.transform:GetComponent('UIToggle'):Set(true)
            end, '取消该权限后，该管家整条线预警设置自动关闭，已暂停的或已限制的管家自动解除暂停与限制')
            PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
        else
            CurAuthoritiesTmep = bit:_xor(CurAuthoritiesTmep, privilege)
        end
    else
        CurAuthoritiesTmep = bit:_or(CurAuthoritiesTmep, privilege)
    end
    print('添加权限后的：'..CurAuthoritiesTmep)
end

function this.OnClickSubmissionBtn(go)
    AudioManager.Instance:PlayAudio('btn')
    local feePerecent = AuthorityPage.Score:GetComponent('UIInput').value
    this.UpdateManagerAuthority(CurOperationPlayer.userId, CurOperationPlayer.userType, CurAuthoritiesTmep, tonumber(feePerecent), 
    CurOperationPlayer.userType == proxy_pb.GENERAL,
    function (data)
        CurOperationPlayer.Authorities = CurAuthoritiesTmep
        CurOperationPlayer.feePrecent = tonumber(feePerecent)
        panelMessageTip.SetParamers('操作成功', 1)
        PanelManager.Instance:ShowWindow('panelMessageTip')
        AuthorityPage.Page.gameObject:SetActive(false)
    end)
end

function this.OnClickSetAuthorityBtn(go)
    AudioManager.Instance:PlayAudio('btn')
    PanelManager.Instance:ShowWindow('panelNetWaitting')
    this.QueryPlayerAuthority(CurOperationPlayer.userId, function (data)
        PanelManager.Instance:HideWindow('panelNetWaitting')
        CurOperationPlayer.Authorities = data.privilege
        CurOperationPlayer.feePrecent = data.feePrecent
        CurOperationPlayer.forbidStatus     = data.forbidStatus
        CurOperationPlayer.freezeStatus     = data.freezeStatus
        CurOperationPlayer.showAlert        = data.showAlert

        this.InitAuthorityPage(data.privilege, data.feePrecent, data.membership, 
            CurOperationPlayer.userType == proxy_pb.GENERAL)
    end)
end

--proxy_pb.MY_INFO_CARD
function this.QueryPlayerAuthority(id, func)
    local msg = Message.New()
    msg.type = proxy_pb.MY_INFO_CARD
    local body = proxy_pb.PMyInfoCard()
    body.userId = id
    body.clubId = panelClub.clubInfo.clubId
    print('拉取用户名片id：'..body.userId..", 俱乐部id："..body.clubId)
    msg.body = body:SerializeToString()
    SendProxyMessage(msg, function (msg)
        local b = proxy_pb.RMyInfoCard();
        b:ParseFromString(msg.body);
        if func then
            func(b)
        end
    end)
end

function this.OnClickTipBtn(go)
    AudioManager.Instance:PlayAudio('btn')
    AuthorityPage.TipPanel.gameObject:SetActive(not AuthorityPage.TipPanel.gameObject.activeSelf)
end

function this.OnClickCloseBtn(go)
    AudioManager.Instance:PlayAudio('btn')
    if AuthorityPage.Page.gameObject.activeSelf then
        AuthorityPage.Page.gameObject:SetActive(false)
        return
    end
    if EarlyWarningPage.Page.gameObject.activeSelf then
        EarlyWarningPage.Page.gameObject:SetActive(false)
        return
    end
    PanelManager.Instance:HideWindow(gameObject.name)
end

function this.OnClickSetIdentityBtn(go)
    AudioManager.Instance:PlayAudio('btn')
    local type = tonumber(go.name)
    print('Type：'..tostring(type))

    local str = "您确定是否将【"..CurOperationPlayer.nickname.."】设置为"..this.GetTypeNameFromUserType(type)

    panelMessageBoxTiShi.SetParamers(OK_CANCLE, function ()
        this.UpdateManagerAuthority(CurOperationPlayer.userId,
                type,
                CurOperationPlayer.Authorities,
                CurOperationPlayer.feePrecent,
                CurOperationPlayer.userType == proxy_pb.GENERAL,
                function ()
                    CurOperationPlayer.userType = type
                    this.UpdateIdentityView(type, panelClub.clubInfo.userType, CurOperationPlayer.membership == 1)
                    panelMessageTip.SetParamers('操作成功', 1) ;
                    PanelManager.Instance:ShowWindow('panelMessageTip');
                    this.RefrehBasicsInfoPage()--刷新名片
                    --在管理员列表或成员列表中更新这个用户的身份
                    if panelMenber then
                        panelMenber.UpdateManagerItemType(CurOperationPlayer.userId,type);
                        panelMenber.UpdateMemberItemType(CurOperationPlayer.userId,type);
                    end
                end)
    end, nil, str)
    PanelManager.Instance:ShowWindow('panelMessageBoxTiShi');
end

function this.OnClickDeletBtn(go)
    AudioManager.Instance:PlayAudio('btn')
    
    if CurOperationPlayer.userId == info_login.id then
        panelMessageTip.SetParamers('无法操作自己', 1)
        PanelManager.Instance:ShowWindow('panelMessageTip')
        return 
    end

    if not IsCanOperatingRemoveMenber() then
        panelMessageBox.SetParamers(ONLY_OK, nil, nil,"你当前没有该权限，如有疑问请联系你的管家")
        PanelManager.Instance:ShowWindow("panelMessageBox")
        return
    end

    local tipStr = ''
    if CurOperationPlayer.userType == proxy_pb.GENERAL then
        tipStr = '是否确认移除成员 "'..CurOperationPlayer.nickname..'" 出群？'
    else
        tipStr = '是否确认取消“'..CurOperationPlayer.nickname..'”的身份？  若删除成功，则其直属的玩家将全部从本群移除！'
    end

    panelMessageBoxTiShi.SetParamers(OK_CANCLE, function ()
        this.DeletPlayer(CurOperationPlayer.userId, function ()
            gameObject:SetActive(false)
            panelMessageTip.SetParamers('操作成功', 1)
            PanelManager.Instance:ShowWindow('panelMessageTip')
        end)
    end, nil, tipStr)
    PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
end

function this.OnClickFatigueModifyBtn(go)
    AudioManager.Instance:PlayAudio('btn')
    
    local index = BasicsInfoPage.ChangeRecordBtn.gameObject == go and 2 or 1
	index = (BasicsInfoPage.FatigueModifyBtn:Find('Label'):GetComponent('UILabel').text == '赠送' and BasicsInfoPage.FatigueModifyBtn.gameObject == go) and 5 or index
	local showGiveFatigue = false
	if panelClub.clubInfo.userType ~= proxy_pb.LORD and CurOperationPlayer.userId == info_login.id then
		showGiveFatigue = true
	end
    PanelManager.Instance:ShowWindow('panelMatchFeeBillRecord', 
    {pageIndex = index, userId = CurOperationPlayer.userId, 
        membership = CurOperationPlayer.membership,
        nickname = CurOperationPlayer.nickname, 
        manageId = CurOperationPlayer.managerId, userType = CurOperationPlayer.userType, fromWindow = gameObject.name,isShowGiveFatigue=showGiveFatigue})
    return    
end

function this.OnClickJoinBlackHouse(go)
    AudioManager.Instance:PlayAudio('btn')
    
    if CurOperationPlayer.userId == info_login.id then
        panelMessageTip.SetParamers('无法操作自己', 1)
        PanelManager.Instance:ShowWindow('panelMessageTip')
        return 
    end

    local str = '是否确认将玩家:“'..CurOperationPlayer.nickname..'”加入小黑屋吗？ 若加入小黑屋，则玩家无法在本群进入任何房间；', '确 定'

    panelMessageBoxTiShi.SetParamers(OK_CANCLE, function ()
        this.JoinBlackHouse(CurOperationPlayer.userId, function ()
            panelMessageTip.SetParamers('添加成功。', 1)
            PanelManager.Instance:ShowWindow('panelMessageTip')
        end)
    end, nil, str)
	PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
end

function this.OnClickJoin2BlackHuose(go)
    AudioManager.Instance:PlayAudio('btn')
    local data = {}
    data.index = 4
    data.playerIDFuFeeValue = 0
    PanelManager.Instance:ShowWindow('panelMenber', data)
    PanelManager.Instance:HideWindow(gameObject.name)
end

function this.OnClickGiveSettigBtn(go)
    AudioManager.Instance:PlayAudio('btn')

    if operatorFeePrecent ~= 0 then
        local str = '您的分配比已启用，需要归零后才能使用赠送设置'
        panelMessageBoxTiShi.SetParamers(ONLY_OK, nil, nil, str)
        PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
        return
    end

    if CurOperationPlayer.feePrecent ~= 0 then
        local str = '您与【'..CurOperationPlayer.nickname..'】的疲劳值分配比不为0%，通过修改权限，设置为0%后，才能进行赠送设置'
        panelMessageBoxTiShi.SetParamers(ONLY_OK, nil, nil, str)
        PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
        return
    end

    PanelManager.Instance:ShowWindow('panelGiveSetting', CurOperationPlayer)
end

function this.OnClickSetParentBtn(go)
    AudioManager.Instance:PlayAudio('btn')

    local func = function (userData)
        local str = '您确定将【'..userData.nickname..'】'..'设置为【'..CurOperationPlayer.nickname..'】的管家？'

        panelMessageBoxTiShi.SetParamers(OK_CANCLE, function ()
            this.SetParent(CurOperationPlayer.userId, userData.userId, function ()
                CurOperationPlayer.managerId = userData.userId
                BasicsInfoPage.SetParentBtn.gameObject:SetActive(false)
                panelMessageTip.SetParamers('添加成功。', 1)
                PanelManager.Instance:ShowWindow('panelMessageTip')
            end)
        end, nil, str)

        PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
    end

    PanelManager.Instance:ShowWindow('panelSelectManager', {assign = true, func = func})
end

function this.OnClickLookMemberBtn(go)
    AudioManager.Instance:PlayAudio('btn')

    if PanelManager.Instance:IsActive('panelMenber') then
        panelMenber.setMenberSearch('')
        panelMenber.GetManagerMenber(CurOperationPlayer.userId,false,true)

        PanelManager.Instance:HideWindow(gameObject.name)
    end
end

--删除玩家
function this.DeletPlayer(id, func)
    local msg       = Message.New()
    msg.type        = proxy_pb.CLUB_USER_MANAGE
    local body      = proxy_pb.PClubUserManage()
    body.operation  = proxy_pb.DELETE
    body.clubId     = panelClub.clubInfo.clubId
    body.userId     = id
    msg.body        = body:SerializeToString()
    SendProxyMessage(msg, function (msg)
        local b = proxy_pb.RResult()
        b:ParseFromString(msg.body)
        if b.code == 1 and func then
            func()
        end
    end) 
end

--加入小黑屋
function this.JoinBlackHouse(id, func)
    local msg       = Message.New()
    msg.type        = proxy_pb.ADD_BLACK_PLAYER
    local body      = proxy_pb.PAddBlackPlayer()
    body.clubId     = panelClub.clubInfo.clubId
    body.userId     = id
    msg.body        = body:SerializeToString()
    SendProxyMessage(msg, function (msgResult)
        local b = proxy_pb.RResult()
        b:ParseFromString(msgResult.body)
        if b.code == 1 and func then
            func()
        end
    end)
end

--设置他的上级
function this.SetParent(id, parentId, func)
    local msg       = Message.New()
    msg.type        = proxy_pb.CLUB_USER_MANAGE
    local body      = proxy_pb.PClubUserManage()
    body.clubId     = panelClub.clubInfo.clubId
    body.operation  = proxy_pb.ADD_USER_MANAGER
    body.userId     = id;
    body.managerId  = parentId
    msg.body        = body:SerializeToString()
    SendProxyMessage(msg, function (msg)
        local b = proxy_pb.RResult()
        b:ParseFromString(msg.body)
        if b.code == 1 and func then
            func()
        end
    end)
end

--添加管理员或者 修改管理权限
function this.UpdateManagerAuthority(userId, userType, Authorities, feePrecent, isAdd, func)
    local msg       =Message.New()
    local body      = proxy_pb.PAddManager()
    body.clubId     = panelClub.clubInfo.clubId
    body.userId     = userId
    body.privilege  = Authorities
    body.feePrecent = feePrecent
    body.userType   = userType
    msg.body        = body:SerializeToString();

    if feePrecent <0 or feePrecent > 100 then
        panelMessageTip.SetParamers('收益百分比必须在0 ~ 100%之间', 1)
        PanelManager.Instance:ShowWindow('panelMessageTip')
        return 
    end

    print("是不是添加："..tostring(isAdd))
    print('俱乐部：'..body.clubId..' 用户ID：'..body.userId.." 用户权限："..body.privilege.." 分数："..body.feePrecent)
    msg.type = isAdd and  proxy_pb.ADD_MANAGER or proxy_pb.UPDATE_MANAGER
   
    SendProxyMessage(msg, function (msg)
        local b = proxy_pb.RResult()
        b:ParseFromString(msg.body)
        if b.code == 1 and func ~= nil then
            func(b)
        end
    end)
end

function this.GetTypeNameFromUserType(userType)
    local str = ""
    if userType == proxy_pb.GENERAL then
        str = '玩家'
    elseif userType == proxy_pb.MANAGER then
        str = '管理员'
    elseif userType == proxy_pb.LORD then
        str = '群主'
    elseif userType == proxy_pb.VICE_MANAGER then
        str = '馆长'
    elseif userType == proxy_pb.ASSISTANT then
        str = '副馆长'
    elseif userType == proxy_pb.PRESIDENT then
        str = '会长'
    elseif userType == proxy_pb.VICE_PRESIDENT then
        str = '副会长'
    end

    return str
end

--当我是何种身份的时候，可以把对方设置成什么身份
--selfType自己的身份
--userType对方的身份
function this.GetCanSetIdentity(userType, selfType)
    local types = {}
    types[proxy_pb.LORD]            = {}
    types[proxy_pb.MANAGER]         = {}
    types[proxy_pb.VICE_MANAGER]    = {proxy_pb.MANAGER,}
    types[proxy_pb.ASSISTANT]       = {proxy_pb.MANAGER, proxy_pb.VICE_MANAGER,}
    types[proxy_pb.PRESIDENT]       = {proxy_pb.MANAGER, proxy_pb.VICE_MANAGER, proxy_pb.ASSISTANT}
    types[proxy_pb.VICE_PRESIDENT]  = {proxy_pb.MANAGER, proxy_pb.VICE_MANAGER, proxy_pb.ASSISTANT,proxy_pb.PRESIDENT}
    types[proxy_pb.GENERAL]         = {proxy_pb.MANAGER, proxy_pb.VICE_MANAGER, proxy_pb.ASSISTANT,proxy_pb.PRESIDENT,proxy_pb.VICE_PRESIDENT}

    local canSet = types[userType]
    local canMySet = {}
    for i=1, #canSet do
        if selfType == proxy_pb.MANAGER and canSet[i] > proxy_pb.MANAGER then
            table.insert(canMySet, canSet[i]);
        elseif selfType == proxy_pb.VICE_MANAGER and canSet[i] > proxy_pb.VICE_MANAGER  then
            table.insert(canMySet, canSet[i])
        elseif selfType == proxy_pb.ASSISTANT and canSet[i] > proxy_pb.ASSISTANT then
            table.insert(canMySet,canSet[i]);
        elseif selfType == proxy_pb.PRESIDENT and canSet[i] > proxy_pb.PRESIDENT then
             table.insert(canMySet,canSet[i]);
        elseif selfType == proxy_pb.VICE_PRESIDENT and canSet[i] > proxy_pb.VICE_PRESIDENT then
            table.insert(canMySet,canSet[i]);
        elseif selfType == proxy_pb.LORD and canSet[i] > proxy_pb.LORD then
            table.insert(canMySet, canSet[i])
        end
    end
    return canMySet
end

function this.SetOperationButtonEnable(button, enabled)

    if button == nil then
        return
    end

    button:GetComponent('BoxCollider').enabled = enabled
    button:Find('EnableLabel').gameObject:SetActive(enabled)
    button:Find('DisableLabel').gameObject:SetActive(not enabled)
end

function this.Update()
end

local AlertData={} --客户端维护的数据
local oldAlertData --服务端的数据
function this.OnClickEarlyWarningBtn(go)
    AudioManager.Instance:PlayAudio('btn')
    local msg = Message.New()
    msg.type = proxy_pb.MY_INFO_ALERT
    local body = proxy_pb.PMyInfoAlert()
    body.userId = CurOperationPlayer.userId
    body.clubId = panelClub.clubInfo.clubId
    print('拉取用户预警设置id：'..body.userId..", 俱乐部id："..body.clubId)
    msg.body = body:SerializeToString()
    SendProxyMessage(msg, this.onGetInfoAlert)
end


function this.OnEarlyWarningInput(go)
    AlertData.alertFee=tonumber(EarlyWarningPage.EarlyWarningSetting.EarlyWarningValue:GetComponent('UIInput').value) 
end

function this.OnLimitInput(go)
    AlertData.forbidFee=tonumber(EarlyWarningPage.EarlyWarningSetting.limitValue:GetComponent('UIInput').value)
end

function this.OnFreezeInput(go)
    AlertData.freezeFee=tonumber(EarlyWarningPage.freezeSetting.freezeValue:GetComponent('UIInput').value)
end

function this.OnClickSure(go)
    AudioManager.Instance:PlayAudio('btn')
    if AlertData.alertFee < -100000 and AlertData.alertFee > 10000000
    and AlertData.forbidFee < -100000 and AlertData.forbidFee > 10000000
    and AlertData.freezeFee < -100000 and AlertData.freezeFee > 10000000 then
        panelMessageTip.SetParamers('输入不能小于-10万且不能大于1000万', 2)
        PanelManager.Instance:ShowWindow('panelMessageTip')
        return
    end
    if AlertData.openAlert==oldAlertData.openAlert
    and AlertData.alertFee==oldAlertData.alertFee
    and AlertData.openForbidFee==oldAlertData.openForbidFee
    and AlertData.forbidFee==oldAlertData.forbidFee
    and AlertData.openFreeze==oldAlertData.openFreeze
    and AlertData.freezeFee==oldAlertData.freezeFee then
        EarlyWarningPage.Page.gameObject:SetActive(false)
        panelMessageTip.SetParamers('修改成功', 2)
        PanelManager.Instance:ShowWindow('panelMessageTip')
        return
    end
    
    local msg = Message.New()
    msg.type = proxy_pb.MY_INFO_UPDATE_TIPS
    local body = proxy_pb.PUpdateMyInfoTips()
    body.userId = CurOperationPlayer.userId
    body.clubId = panelClub.clubInfo.clubId
    print('拉取用户总疲劳值id：'..body.userId..", 俱乐部id："..body.clubId)
    msg.body = body:SerializeToString()
    SendProxyMessage(msg, function(data)
        local b = proxy_pb.RUpdateMyInfoTips();
        b:ParseFromString(data.body);
        AlertData.butlerAllFee=b.butlerAllFee
        print('该玩家这条线总疲劳值',b.butlerAllFee)
        this.tiShi()
    end)
end

function this.tiShi()
    if CurOperationPlayer.freezeStatus==false and AlertData.openFreeze and AlertData.freezeFee>=tonumber(AlertData.butlerAllFee) and (AlertData.freezeFee~=oldAlertData.freezeFee or oldAlertData.openFreeze==false) then
        this.showMessageBox('当前设置的值已高于该管家整条线总疲劳值，管该家整条线将会直接暂停，是否确定？',function()
            if CurOperationPlayer.forbidStatus==false and AlertData.openAlert and AlertData.openForbidFee and AlertData.forbidFee>=tonumber(AlertData.butlerAllFee) and (AlertData.forbidFee~=oldAlertData.forbidFee or oldAlertData.openForbidFee==false) then
                this.showMessageBox('当前设置的值已高于该管家整条线总疲劳值，该管家将会被限制操作疲劳值，是否确定？',function()
                    if AlertData.alertFee>=tonumber(AlertData.butlerAllFee) and (AlertData.alertFee~=oldAlertData.alertFee or oldAlertData.openAlert==false) then
                        this.showMessageBox('当前设置的值已高于该管家整条线总疲劳值，将会直接发送预警信息，是否确定？',this.sendSure)
                    else
                        this.sendSure() 
                    end
                end)
            elseif AlertData.openAlert and AlertData.alertFee>=tonumber(AlertData.butlerAllFee) and (AlertData.alertFee~=oldAlertData.alertFee or oldAlertData.openAlert==false) then
                this.showMessageBox('当前设置的值已高于该管家整条线总疲劳值，将会直接发送预警信息，是否确定？',this.sendSure)
            else
                this.sendSure() 
            end
        end)
    elseif CurOperationPlayer.forbidStatus==false and AlertData.openAlert and AlertData.openForbidFee and AlertData.forbidFee>=tonumber(AlertData.butlerAllFee) and (AlertData.forbidFee~=oldAlertData.forbidFee or oldAlertData.openForbidFee==false) then
        this.showMessageBox('当前设置的值已高于该管家整条线总疲劳值，该管家将会被限制操作疲劳值，是否确定？',function()
            if AlertData.alertFee>=tonumber(AlertData.butlerAllFee) and (AlertData.alertFee~=oldAlertData.alertFee or oldAlertData.openAlert==false) then
                this.showMessageBox('当前设置的值已高于该管家整条线总疲劳值，将会直接发送预警信息，是否确定？',this.sendSure)
            else
                this.sendSure() 
            end
        end)
    elseif AlertData.openAlert and AlertData.alertFee>=tonumber(AlertData.butlerAllFee) and (AlertData.alertFee~=oldAlertData.alertFee or oldAlertData.openAlert==false) then
        this.showMessageBox('当前设置的值已高于该管家整条线总疲劳值，将会直接发送预警信息，是否确定？',this.sendSure)
    else
        this.sendSure()
    end
end

function this.showMessageBox(string,fuc)
    panelMessageBoxTiShi.SetParamers(OK_CANCLE, fuc, nil, string)
    PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
end

function this.sendSure()
    local msg = Message.New()
    msg.type = proxy_pb.MY_INFO_UPDATE_ALERT
    local body = proxy_pb.PUpdateMyInfoAlert()
    body.userId = CurOperationPlayer.userId
    body.clubId = panelClub.clubInfo.clubId
    body.openAlert = AlertData.openAlert
    body.alertFee = AlertData.alertFee
    body.openForbidFee = AlertData.openForbidFee
    body.forbidFee = AlertData.forbidFee
    body.openFreeze = AlertData.openFreeze
    body.freezeFee = AlertData.freezeFee
    body.totalOff = true
    print('确定修改 id：'..body.userId..", 俱乐部id："..body.clubId)
    msg.body = body:SerializeToString()
    SendProxyMessage(msg, this.onGetUpdateResult)
end

function this.onGetUpdateResult(msg)
    local b = proxy_pb.RUpdateMyInfoAlert();
    b:ParseFromString(msg.body);
    if b.code==1 then
        EarlyWarningPage.Page.gameObject:SetActive(false)
        panelMessageTip.SetParamers('修改成功', 2)
        PanelManager.Instance:ShowWindow('panelMessageTip')
        this.RefrehBasicsInfoPage()--刷新名片
    else
        panelMessageBoxTiShi.SetParamers(ONLY_OK, nil, nil, '修改失败')
        PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
    end
end

function this.OnClickEarlyWarning(go)
    AudioManager.Instance:PlayAudio('btn')
    AlertData.openAlert=EarlyWarningPage.EarlyWarningSetting.open:GetComponent('UIToggle').value
    if AlertData.openAlert==true then
        EarlyWarningPage.EarlyWarningSetting.tip:GetComponent('UILabel').text='（选择后，若该管家与整条线总疲劳值低于设置的值，则该管家与您将收到预警消息）'
    else    
        EarlyWarningPage.EarlyWarningSetting.tip:GetComponent('UILabel').text='（选择后，该管家与整条线总疲劳值不管低于多少，谁都不会收到预警消息）'
    end             
    EarlyWarningPage.EarlyWarningSetting.EarlyWarningValue:GetComponent('BoxCollider').enabled = AlertData.openAlert  
    EarlyWarningPage.EarlyWarningSetting.limitToggle:GetComponent('BoxCollider').enabled = AlertData.openAlert
    EarlyWarningPage.EarlyWarningSetting.limitValue:GetComponent('BoxCollider').enabled = AlertData.openAlert
    if AlertData.openAlert==false then
        EarlyWarningPage.EarlyWarningSetting.limitToggle:GetComponent('UIToggle'):Set(false)
        AlertData.openForbidFee=false
    end
end

function this.OnClickLimit(go)
    AudioManager.Instance:PlayAudio('btn')
    AlertData.openForbidFee=EarlyWarningPage.EarlyWarningSetting.limitToggle:GetComponent('UIToggle').value
    EarlyWarningPage.EarlyWarningSetting.limitValue:GetComponent('BoxCollider').enabled = AlertData.openForbidFee
end

function this.OnClickFreeze(go)
    AudioManager.Instance:PlayAudio('btn')
    AlertData.openFreeze=EarlyWarningPage.freezeSetting.open:GetComponent('UIToggle').value
    if AlertData.openFreeze==true then
        EarlyWarningPage.freezeSetting.tip:GetComponent('UILabel').text='（选择后，若该管家与整条线总疲劳值低于设置的值，则该管家与整条线的玩家将不可进入房间）'
    else    
        EarlyWarningPage.freezeSetting.tip:GetComponent('UILabel').text='（选择后，该管家与整条线总疲劳值不管低于多少，都不会暂停玩家）'
    end          
    EarlyWarningPage.freezeSetting.freezeValue:GetComponent('BoxCollider').enabled = AlertData.openFreeze
end

function this.onGetInfoAlert(msg)
    local b = proxy_pb.RMyInfoAlert();
    b:ParseFromString(msg.body);
    EarlyWarningPage.EarlyWarningSetting.open:GetComponent('UIToggle'):Set(b.openAlert)
    EarlyWarningPage.EarlyWarningSetting.close:GetComponent('UIToggle'):Set(not b.openAlert)
    EarlyWarningPage.EarlyWarningSetting.EarlyWarningValue:GetComponent('UIInput').value=b.alertFee
    EarlyWarningPage.EarlyWarningSetting.limitToggle:GetComponent('UIToggle'):Set(b.openForbidFee)
    EarlyWarningPage.EarlyWarningSetting.limitValue:GetComponent('UIInput'):Set(b.forbidFee)
    EarlyWarningPage.freezeSetting.open:GetComponent('UIToggle'):Set(b.openFreeze)
    EarlyWarningPage.freezeSetting.close:GetComponent('UIToggle'):Set(not b.openFreeze)
    EarlyWarningPage.freezeSetting.freezeValue:GetComponent('UIInput').value=b.freezeFee
    EarlyWarningPage.Page.gameObject:SetActive(true)
    AlertData.alertFee=b.alertFee
    AlertData.openAlert=b.openAlert
    AlertData.openForbidFee=b.openForbidFee
    AlertData.forbidFee=b.forbidFee
    AlertData.openFreeze=b.openFreeze
    AlertData.freezeFee=b.freezeFee
    EarlyWarningPage.EarlyWarningSetting.EarlyWarningValue:GetComponent('BoxCollider').enabled = AlertData.openAlert  
    EarlyWarningPage.EarlyWarningSetting.limitToggle:GetComponent('BoxCollider').enabled = AlertData.openAlert
    EarlyWarningPage.EarlyWarningSetting.limitValue:GetComponent('BoxCollider').enabled = AlertData.openAlert 
    EarlyWarningPage.freezeSetting.freezeValue:GetComponent('BoxCollider').enabled = AlertData.openFreeze
    oldAlertData=b
end

function this.OnClickLiftLimitBtn(go)
    AudioManager.Instance:PlayAudio('btn')
    panelMessageBoxTiShi.SetParamers(OK_CANCLE, function()
        local msg = Message.New()
        msg.type = proxy_pb.MY_INFO_RELIEVE
        local body = proxy_pb.PMyInfoRelieve()
        body.userId = CurOperationPlayer.userId
        body.clubId = panelClub.clubInfo.clubId
        body.relieveType = 0
        print('接触疲劳值限制 id：'..body.userId..", 俱乐部id："..body.clubId)
        msg.body = body:SerializeToString()
        SendProxyMessage(msg, this.onGetInfoRelieve)
        end, nil, '是否解除限制？')
    PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
end

function this.OnClickFreezeBtn(go)
    AudioManager.Instance:PlayAudio('btn')
    panelMessageBoxTiShi.SetParamers(OK_CANCLE, function()
        local msg = Message.New()
        msg.type = proxy_pb.MY_INFO_RELIEVE
        local body = proxy_pb.PMyInfoRelieve()
        body.userId = CurOperationPlayer.userId
        body.clubId = panelClub.clubInfo.clubId
        body.relieveType = 1
        print('接触暂停限制 id：'..body.userId..", 俱乐部id："..body.clubId)
        msg.body = body:SerializeToString()
        SendProxyMessage(msg, this.onGetInfoRelieve)
        end, nil, '是否解除暂停？')
    PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
end

function this.onGetInfoRelieve(msg)
    local b = proxy_pb.RMyInfoRelieve();
    b:ParseFromString(msg.body);
    if b.relieveType==0 then
        if b.code==1 then
            BasicsInfoPage.LiftLimitBtn.gameObject:SetActive(false)
            panelMessageTip.SetParamers('解除限制成功', 2)
            PanelManager.Instance:ShowWindow('panelMessageTip')
        else
            panelMessageBoxTiShi.SetParamers(ONLY_OK, nil, nil, '该管家整条线总疲劳值低于设置的限制值，无法解除')
            PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
        end
    elseif b.relieveType==1 then
        if b.code==1 then
            BasicsInfoPage.LiftFreezeBtn.gameObject:SetActive(false)
            panelMessageTip.SetParamers('解除暂停成功', 2)
            PanelManager.Instance:ShowWindow('panelMessageTip')
        else
            panelMessageBoxTiShi.SetParamers(ONLY_OK, nil, nil, '该管家整条线总疲劳值低于设置的暂停值，无法解除')
            PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
        end
    end
end