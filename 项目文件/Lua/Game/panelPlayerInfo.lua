local proxy_pb = require 'proxy_pb'
local dtz_pb = require 'dtz_pb'
local csm_pb = require "csm_pb"
local phz_pb = require "phz_pb"
local pdk_pb = require "pdk_pb"
local bbtz_pb = require "bbtz_pb"
panelPlayerInfo = {}
local this = panelPlayerInfo;

local message
local gameObject   
local photoTexture--照片
local lobbyRoot
local nameLobby
local ipLobby
local iconLobby
local idLobby
local fatigue
local LabelLobby--签名
local addressLabel
local autographLabel
local buttonEmoji = {}

local ButtonClose

local infoData
function this.Awake(obj)
    gameObject = obj;
    message = gameObject:GetComponent('LuaBehaviour')
    photoTexture = gameObject.transform:Find('photoKuang/photo')
    lobbyRoot = gameObject.transform:Find('lobby')
    nameLobby =lobbyRoot:Find('name')
    ipLobby = lobbyRoot:Find('ip')
    iconLobby = lobbyRoot:Find('icon/Texture')
    idLobby = lobbyRoot:Find('id')
    fatigue = lobbyRoot:Find('fatigue')
    autographLabel = lobbyRoot:Find('autograph/info')
    addressLabel = lobbyRoot:Find('address/info')
    ButtonClose = gameObject.transform:Find('BaseContent/ButtonClose')

    message:AddClick(ButtonClose.gameObject,this.OnClickClose)

    for i = 1, 6 do
        buttonEmoji[i] = gameObject.transform:Find('drag/emojGrid/'..i)
        message:AddClick(buttonEmoji[i].gameObject,this.OnClickEmoji)
    end

end

function this.Start()
end
function this.Update()
    
end
function this.OnEnable()
   
end

function this.WhoShow(data)
    infoData=data
    this.init()
    this.refresh()
end

function this.init()
    nameLobby:GetComponent('UILabel').text=''
    idLobby:GetComponent('UILabel').text=''
    ipLobby:GetComponent('UILabel').text=''
    autographLabel:GetComponent('UILabel').text=''
    addressLabel:GetComponent('UILabel').text=''
    photoTexture.gameObject:SetActive(false)
    iconLobby:GetComponent('UITexture').mainTexture = nil
end

function this.refresh()
    nameLobby.gameObject:GetComponent('UILabel').text = infoData.nickname
    print('infoData.fee : '..tostring(infoData.fee)..' infoData.gameMode:'..tostring(infoData.gameMode)..'  infoData.ip : '..tostring(infoData.ip))
    if infoData.fee then
        fatigue.gameObject:SetActive(infoData.gameMode)
        fatigue.gameObject:GetComponent('UILabel').text = '疲劳值：'..(infoData.gameMode and infoData.fee or 0)
    end
    if infoData.ip then
        ipLobby.gameObject:GetComponent('UILabel').text ='IP:'.. infoData.ip
    end
    local _id=''
    if infoData.isShowSomeID then
        local id={}
        for word in string.gmatch(infoData.userId, "%d") do
            table.insert(id,word)
        end
        for i = (#id>5 and 5 or 1), #id do
            id[i]='*'
        end
        for i = 1, #id do
            _id=_id..id[i]
        end
    else
        _id = infoData.userId
    end

    idLobby.gameObject:GetComponent('UILabel').text ='ID:'.._id
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
    if infoData.signature then
        autographLabel:GetComponent('UILabel').text=infoData.signature
    else
        autographLabel:GetComponent('UILabel').text=''   
	end
    coroutine.start(LoadPlayerIcon, iconLobby:GetComponent('UITexture'), infoData.icon)
    
    if infoData.imgUrl~='' then
        coroutine.start(LoadFengCaiZhao, photoTexture:GetComponent('UITexture'), infoData.imgUrl)
    end
end

function this.OnClickEmoji(go)
    if not infoData.isRePlay then
        if infoData.sendMsgAllowed then
            local msg = Message.New()
            if infoData.gameType == proxy_pb.XHZD then
                msg.type = xhzd_pb.GIFT
                local body = xhzd_pb.PGift();
                body.seat = infoData.rseat
                body.index = tonumber(go.name)
                msg.body = body:SerializeToString();
            elseif infoData.gameType == proxy_pb.DTZ then
                if infoData.mySeat == infoData.rseat then
                    return;
                end
                msg.type = dtz_pb.GIFT
                local body = dtz_pb.PGift();
                body.seat = infoData.rseat;
                body.index = tonumber(go.name)
                msg.body = body:SerializeToString();
            elseif infoData.gameType == proxy_pb.MJ then
                if infoData.mySeat == infoData.rseat then
                    return;
                end
                msg.type = csm_pb.GIFT
                local body = csm_pb.PGift();
                body.seat = infoData.rseat;
                body.index = tonumber(go.name)
                msg.body = body:SerializeToString();
            elseif infoData.gameType == proxy_pb.PHZ then
                if infoData.mySeat == infoData.rseat then
                    return;
                end
                msg.type = phz_pb.GIFT
                local body = phz_pb.PGift();
                body.seat = infoData.rseat;
                body.index = tonumber(go.name)
                msg.body = body:SerializeToString();
            elseif infoData.gameType == proxy_pb.PDK then
                if infoData.mySeat == infoData.rseat then
                    return;
                end
                msg.type = pdk_pb.GIFT
                local body = pdk_pb.PGift();
                body.seat = infoData.rseat;
                body.index = tonumber(go.name)
                msg.body = body:SerializeToString();
            elseif infoData.gameType == proxy_pb.BBTZ then
                if infoData.mySeat == infoData.rseat then
                    return;
                end
                local body = bbtz_pb.PGift();
                body.seat = infoData.rseat;
                body.index = tonumber(go.name)
                GameLogic:SendGameMsg(bbtz_pb.GIFT, body:SerializeToString())
            elseif infoData.gameType == proxy_pb.XPLP then
                if infoData.mySeat == infoData.rseat then
                    return;
                end
                local body = xplp_pb.PGift();
                body.seat = infoData.rseat;
                body.index = tonumber(go.name)
                GameLogic:SendGameMsg(xplp_pb.GIFT, body:SerializeToString())
            elseif infoData.gameType == proxy_pb.HNM then
                if infoData.mySeat == infoData.rseat then
                    return;
                end
                local body = hnm_pb.PGift();
                body.seat = infoData.rseat;
                body.index = tonumber(go.name)
                GameLogic:SendGameMsg(hnm_pb.GIFT, body:SerializeToString())
            elseif infoData.gameType == proxy_pb.YJQF then
                msg.type = yjqf_pb.GIFT
                local body = yjqf_pb.PGift()
                body.seat = infoData.rseat
                body.index = tonumber(go.name)
                msg.body = body:SerializeToString()
            end
    
            print('请求玩家表情动画消息 : '..'   index : '..tonumber(go.name))
            SendGameMessage(msg, nil)
            gameObject:SetActive(false)
        else
            panelMessageBoxTiShi.SetParamers(ONLY_OK, nil, nil, '群主已经禁止游戏过程中发送表情，如有疑问请联系群主')
            PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
        end
    end
end

function this.OnClickMask(go)
    PanelManager.Instance:HideWindow(gameObject.name)
end

function this.OnClickClose(go)
    PanelManager.Instance:HideWindow(gameObject.name)
end