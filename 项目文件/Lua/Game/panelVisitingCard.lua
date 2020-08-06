local proxy_pb = require 'proxy_pb'
panelVisitingCard = {}
local this = panelVisitingCard;

local qianMingStr={
    '从前有首歌，上碰下自摸',
    '手气财气高，牌来张张好',
    '头顶锅盖，身披麻袋，我就是东方不败',
    '好牌本天成，妙手偶得之',
    '哪里跌倒就在哪里爬起来',
    '只要精神不滑坡 赢得总比输的多',
    '抓牌凭手气，出牌靠技术',
    '英雄不问出路，胡牌不看岁数',
    '谁掌控全局谁就能笑到最后',
    '减肥是不可能的，胡牌我是认真的',
    '明人不说暗话，我就是周润发',
    '浮生万物里，打牌最欢喜',
    '确认过眼神，你是放炮的人',
    '打牌没有巧，就靠手气好',
    '打牌风格好，天天有人找',
}

local lobbyRoot
local nameLobby
local message
local gameObject   
local ipLobby
local iconLobby
local idLobby
local LabelLobby--签名
local addressLabel
local share
local photoTexture--照片
local photoButton--照片上传按钮
local changeButton--更换签名按钮
local photoTip--上传提示

local changPoolButton
local changPoolHelpButton
local changPoolHelptishi
local ButtonClose
local changPoolHelptishiCloseBtn

local infoData
function this.Awake(obj)
    gameObject = obj;
    message = gameObject:GetComponent('LuaBehaviour')
    photoTexture = gameObject.transform:Find('photoKuang/photo')
    photoTip = gameObject.transform:Find('photoKuang/tip')
    photoButton = gameObject.transform:Find('photoKuang/ButtonUpdate')
    lobbyRoot = gameObject.transform:Find('lobby')
    ipLobby = lobbyRoot:Find('ip')
    iconLobby = lobbyRoot:Find('icon/Texture')
    idLobby = lobbyRoot:Find('id')
    LabelLobby =lobbyRoot:Find('Label')
    addressLabel = lobbyRoot:Find('address')
    nameLobby =lobbyRoot:Find('name')
    ButtonClose = gameObject.transform:Find('BaseContent/ButtonClose')
    share = lobbyRoot:Find('share')
    changeButton = gameObject.transform:Find('lobby/Label/change')

    changPoolButton = lobbyRoot:Find('changPool')
    changPoolHelpButton = lobbyRoot:Find('help')
    changPoolHelptishi = gameObject.transform:Find('changPoolHelp')
    changPoolHelptishiCloseBtn = gameObject.transform:Find('changPoolHelp/ButtonClose')
    message:AddSubmit(LabelLobby.gameObject, this.OnQianMingSubmit)
    message:AddClick(changeButton.gameObject,this.OnClickChange)
    message:AddClick(ButtonClose.gameObject,this.OnClickClose)
    message:AddClick(share.gameObject,this.OnClickShare)
    message:AddClick(photoButton.gameObject,this.OnClickUpdate)

    message:AddClick(changPoolButton.gameObject,this.OnClickChangPoolButton)
    message:AddClick(changPoolHelpButton.gameObject,this.OnClickChangPoolHelpButton)
    message:AddClick(changPoolHelptishiCloseBtn.gameObject,this.OnClickchangPoolHelptishiCloseBtn)
end

function this.Start()
end
function this.Update()
    
end
function this.OnEnable()
end

function this.OnQianMingSubmit(go)
    print('输入完成')
	local wenBen=trim(LabelLobby:GetComponent('UIInput').value)
	if wenBen and wenBen~='' and wenBen~=infoData.signature and #wenBen <=78 then
		this.updateQianMing(wenBen)
	else
		if #wenBen > 66 then
			panelMessageTip.SetParamers('签名不能超过22个字', 1)
            PanelManager.Instance:ShowWindow('panelMessageTip')
        elseif wenBen=='' then
            panelMessageTip.SetParamers('签名不能为空', 1)
            PanelManager.Instance:ShowWindow('panelMessageTip')
		end
	end
end

function this.OnClickChange(go)
    math.randomseed(tostring(os.time()):reverse():sub(1, 6))
    local suiji=math.random(1,15)
    print('随机数'..suiji)
    --LabelLobby:GetComponent('UILabel').text=qianMingStr[suiji]
    this.updateQianMing(qianMingStr[suiji])
end

function this.updateQianMing(str)
    local msg = Message.New()
    msg.type = proxy_pb.UPDATE_USER_SIGNATURE
    local body = proxy_pb.PUpdateUserSignature()
    body.signature = str
    msg.body = body:SerializeToString()
    SendProxyMessage(msg, this.onGetInfo)
end

--[[
    @desc: 上传按钮回调
    author:{author}
    time:2018-10-11 17:04:42
    --@go: 
    @return:
]]
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

function this.init()
    nameLobby:GetComponent('UILabel').text=''
    idLobby:GetComponent('UILabel').text=''
    ipLobby:GetComponent('UILabel').text=''
    LabelLobby:GetComponent('UILabel').text=''
    addressLabel:GetComponent('UILabel').text=''
    photoTexture.gameObject:SetActive(false)
    iconLobby:GetComponent('UITexture').mainTexture = nil
end

function this.WhoShow(data)
    infoData=data
    print('WhoShowminfo'..infoData.whoShow)
    print('玩家id'..data.userId)
    this.init()
    local needActive=(panelClub.clubInfo.userType == proxy_pb.LORD and panelClub.clubInfo.gameMode and (infoData.whoShow == 'panelClubManage'))
    changPoolButton.gameObject:SetActive(needActive)
    changPoolHelpButton.gameObject:SetActive(needActive)
    changPoolHelptishi.gameObject:SetActive(false)

    photoButton.gameObject:SetActive(infoData.userId==info_login.id)
    if infoData.whoShow == 'panelClubManage' then
        addressLabel.gameObject:SetActive(false)
        share.gameObject:SetActive(true)
        this.getInfo(infoData.userId)
        gameObject.transform:Find('BaseContent/bg/title/Label1'):GetComponent('UILabel').text = '查看资料'
        gameObject.transform:Find('BaseContent/bg/title/Label2'):GetComponent('UILabel').text = '查看资料'
    elseif infoData.whoShow=='panelMInfo' or infoData.whoShow=='panelLobby' then
        addressLabel.gameObject:SetActive(false)
        gameObject.transform:Find('BaseContent/bg/title/Label1'):GetComponent('UILabel').text = '我的名片'
        gameObject.transform:Find('BaseContent/bg/title/Label2'):GetComponent('UILabel').text = '我的名片'
        share.gameObject:SetActive(true)
        this.getInfo(infoData.userId)
    end
    
end

function this.getInfo(userId)
    local msg = Message.New()
    msg.type = proxy_pb.MY_INFO_CARD
    local body = proxy_pb.PMyInfoCard()
    body.userId = userId
    msg.body = body:SerializeToString()
    SendProxyMessage(msg, this.onGetInfo)
end

function this.onGetInfo(msg)
    local b = proxy_pb.RMyInfoCard();
    b:ParseFromString(msg.body);
    print('玩家imgUrl'..b.imgUrl)
    print('玩家icon'..b.icon)
    infoData.nickname = b.nickname
    infoData.icon = b.icon
    infoData.userId = b.userId
    infoData.imgUrl = b.imgUrl
    infoData.signature = b.signature

    this.refresh()
end

function this.refresh()
    
    if infoData.userId == info_login.id and infoData.imgUrl=='' then
        photoTip.gameObject:SetActive(true)
    else
        photoTip.gameObject:SetActive(false)
        photoTexture.gameObject:SetActive(true)
    end

	--lobbyRoot.gameObject:SetActive(true)
	
    nameLobby.gameObject:GetComponent('UILabel').text = infoData.nickname
    if infoData.ip then
        ipLobby.gameObject:GetComponent('UILabel').text ='IP:'.. infoData.ip
    end
    idLobby.gameObject:GetComponent('UILabel').text ='ID:'.. infoData.userId
    print("infoData.userId == info_login.id",infoData.userId == info_login.id)
    changeButton.gameObject:SetActive(infoData.userId == info_login.id)
    print("infoData.address",infoData.address)
    if infoData.address then
        local startIndex,endIndex=string.find(infoData.address,'路')
        if endIndex~=nil  then
            addressLabel:GetComponent('UILabel').text=string.sub(infoData.address,1,endIndex) 
        else
            addressLabel:GetComponent('UILabel').text=infoData.address
        end
    else
        addressLabel:GetComponent('UILabel').text='未获取到该玩家位置'   
    end
    --LabelLobby:GetComponent('BoxCollider').enabled = infoData.userId == info_login.id
    if infoData.signature then
        LabelLobby:GetComponent('UILabel').text=infoData.signature
    else
        LabelLobby:GetComponent('UILabel').text=''   
	end
    coroutine.start(LoadPlayerIcon, iconLobby:GetComponent('UITexture'), infoData.icon)
    
    if infoData.imgUrl~='' then
        coroutine.start(LoadFengCaiZhao, photoTexture:GetComponent('UITexture'), infoData.imgUrl)
    end
    
end

function this.OnClickMask(go)
    PanelManager.Instance:HideWindow(gameObject.name)
end

function this.OnClickClose()
    PanelManager.Instance:HideWindow(gameObject.name)
end

function this.OnClickShare(go)
    AudioManager.Instance:PlayAudio('btn')
    PlatformManager.Instance:ShareScreenshot('嗨皮跑胡子',false,0) 
end

function this.OnClickChangPoolButton(go)
    AudioManager.Instance:PlayAudio('btn')
    if panelClub.clubInfo.pauseRoom then
        PanelManager.Instance:ShowWindow('panelChangPool')
    else
        panelMessageBox.SetParamers(ONLY_OK,nil,nil,"本群未暂停开房或牌友群还有已开房间未解散");
        PanelManager.Instance:ShowWindow("panelMessageBox");
    end
end

function this.OnClickChangPoolHelpButton(go)
    AudioManager.Instance:PlayAudio('btn')
    changPoolHelptishi.gameObject:SetActive(true)
end

function this.OnClickchangPoolHelptishiCloseBtn(go)
    changPoolHelptishi.gameObject:SetActive(false)
end 