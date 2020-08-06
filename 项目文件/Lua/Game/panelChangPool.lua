local proxy_pb = require 'proxy_pb'

panelChangPool = {}
local this = panelChangPool

local message
local gameObject   

local inputQunID
local lableQunID
local inputPass
local lablePass

local buttonClose
local buttonOK
local buttonNo

local tishi
local tishiOK
local tishiClose
local tishiCancle
local tishiMsg

this.issendmsg=false
this.ischangsus=false

function this.Awake(obj)
    gameObject = obj;
    message = gameObject:GetComponent('LuaBehaviour')
    inputQunID = gameObject.transform:Find('Button/InputQunID')
    lableQunID = gameObject.transform:Find('Button/InputQunID/Label')

    inputPass = gameObject.transform:Find('Button/InputVerification')
    lablePass = gameObject.transform:Find('Button/InputVerification/Label')

    buttonClose = gameObject.transform:Find('Button/ButtonClose')
    buttonOK = gameObject.transform:Find('Button/OKBtn')
    buttonNo = gameObject.transform:Find('Button/NoBtn')

    tishi = gameObject.transform:Find('tishi')  
    tishiOK =  gameObject.transform:Find('tishi/grid/ButtonOK') 
    tishiClose = gameObject.transform:Find('tishi/ButtonClose')
    tishiCancle = gameObject.transform:Find('tishi/grid/ButtonCancle') 
    tishiMsg = gameObject.transform:Find('tishi/message1')

    message:AddClick(buttonClose.gameObject,this.OnClickClose)
    message:AddClick(buttonNo.gameObject,this.OnClickClose)
    message:AddClick(buttonOK.gameObject,this.OnClickOK)

    message:AddClick(tishiOK.gameObject,this.OnClickTiShiOK)
    message:AddClick(tishiClose.gameObject,this.OnClickTiShiClose)
    message:AddClick(tishiCancle.gameObject,this.OnClickTiShiClose)
    
end

function this.Start()
end
function this.Update()
end
function this.OnEnable()
    this.issendmsg=false
    this.ischangsus=false
    lableQunID:GetComponent('UILabel').text = '请输入转入的牌友群ID'
    lablePass:GetComponent('UILabel').text = '请输入本群代理后台登录密码'
    inputQunID:GetComponent("UIInput").value = ""
    inputPass:GetComponent("UIInput").value = ""
    tishi.gameObject:SetActive(false)
    tishiMsg:GetComponent('UILabel').text = ''
    tishiOK.gameObject:SetActive(false)
    tishiClose.gameObject:SetActive(false)
    tishiCancle.gameObject:SetActive(false)
end

function this.WhoShow()

end

function this.OnClickOK(go)
    print('sdsadsadsadas : '..tostring(inputPass:GetComponent("UIInput").value))
    AudioManager.Instance:PlayAudio('btn')
    if #inputQunID:GetComponent("UIInput").value<1 then
        panelMessageTip.SetParamers('输入的牌友群ID不能为空', 1)
        PanelManager.Instance:ShowWindow('panelMessageTip')
    elseif #inputPass:GetComponent("UIInput").value<1 then
        panelMessageTip.SetParamers('输入的代理后台登录密码不能为空', 1)
        PanelManager.Instance:ShowWindow('panelMessageTip')
    elseif #inputQunID:GetComponent("UIInput").value ~= 8 then
        panelMessageTip.SetParamers('请输入正确的牌友群ID', 1)
        PanelManager.Instance:ShowWindow('panelMessageTip')
    elseif #inputQunID:GetComponent("UIInput").value == 8 then
        tishi.gameObject:SetActive(true)
        this.issendmsg=true
        this.refreshTiShiTxt('您确定要转入群吗？转入成功后，群数据只保留群成员疲劳值和绑定关系、赠送设置以及玩法设置、群管理设置，其他数据将清空，原群将自动解散，不可还原',true,true,true)
    end
end

function this.refreshTiShiTxt(txt,isshowOK,isshowClose,isshowCancle,isclose)
    tishiMsg:GetComponent('UILabel').text = txt
    tishiOK.gameObject:SetActive(isshowOK)
    tishiClose.gameObject:SetActive(isshowClose)
    tishiCancle.gameObject:SetActive(isshowCancle)
    gameObject.transform:Find('tishi/grid'):GetComponent('UIGrid'):Reposition()
end

function this.HideTiShi()
    tishi.gameObject:SetActive(false)
end

function this.OnClickClose(go)
    AudioManager.Instance:PlayAudio('btn')
    PanelManager.Instance:HideWindow(gameObject.name)
end

function this.OnClickTiShiClose(go)
    AudioManager.Instance:PlayAudio('btn')
    this.HideTiShi()
end

function this.OnClickTiShiOK(go)
    AudioManager.Instance:PlayAudio('btn')
    if this.issendmsg then
        tishi.gameObject:SetActive(true)
        this.refreshTiShiTxt('牌友群数据正在转入，请稍等....',false,false,false)
        local msg = Message.New()
        msg.type = proxy_pb.TRANSFER_CLUB
        local body = proxy_pb.PTransferClub()
        body.clubId = panelClub.clubInfo.clubId
        body.receiveClubId = inputQunID:GetComponent("UIInput").value
        body.password = inputPass:GetComponent("UIInput").value
        msg.body = body:SerializeToString()
        SendProxyMessage(msg,function (msg)
            local data = proxy_pb.RResult()
            data:ParseFromString(msg.body)
            if data.code == 1 then
                this.issendmsg=false
                this.ischangsus=true
                this.refreshTiShiTxt('牌友群数据已转让成功',true,true,false)
                PanelManager.Instance:HideWindow('panelClubManage')
                PanelManager.Instance:HideWindow('panelVisitingCard')
            end
        end)
    elseif this.ischangsus then
        PanelManager.Instance:HideWindow(gameObject.name)
    else
        this.HideTiShi()
    end
end