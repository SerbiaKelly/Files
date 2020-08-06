local proxy_pb = require 'proxy_pb'
local json = require 'json'

panelSetPlayName = {}

local this=panelSetPlayName
local RecordList={}
local message;
local gameObject;
local mask
local Grid
local prefabItem
local buttonClose
local tip

local inputName
local inputNum
local wanFaText
local ButtonSure


local On
local Off
local isEnable=1
local rule--传入的规则table
local IsCreate = true--当前流程是否为创建
local curSelectPlay--当前选择的玩法
--启动事件--
function this.Awake(obj)
    gameObject = obj;
	message = gameObject:GetComponent('LuaBehaviour');

    mask = gameObject.transform:Find('mask');
	buttonClose = gameObject.transform:Find('ButtonClose');
	tip = gameObject.transform:Find('tip');
    wanFaText = gameObject.transform:Find('wanfa');
    ButtonSure = gameObject.transform:Find('ButtonSure');
    inputName = gameObject.transform:Find('inputName')
    inputNum = gameObject.transform:Find('inputNum')
    On = gameObject.transform:Find('on')
    Off = gameObject.transform:Find('off')
    
    
	message:AddClick(On.gameObject, this.OnClickOn);
	message:AddClick(Off.gameObject, this.OnClickOff);
	message:AddClick(ButtonSure.gameObject, this.OnClickSure);
    --message:AddClick(gameObject.transform:Find('ButtonLast').gameObject,this.OnClickLastStep)
	message:AddClick(buttonClose.gameObject, this.OnClickMask);
end

function this.OnClickOn(go)
	AudioManager.Instance:PlayAudio('btn')
    isEnable = 1
    -- UnityEngine.PlayerPrefs.SetInt('isEnable', isEnable)

end
function this.OnClickOff(go)
	AudioManager.Instance:PlayAudio('btn')
    isEnable = 0
    -- UnityEngine.PlayerPrefs.SetInt('isEnable', isEnable)

end


function this.Update()
   
end
function this.Start()
end


function this.OnEnable()
    
end

--单击事件--
function this.OnClickMask(go)
	AudioManager.Instance:PlayAudio('btn')
    PanelManager.Instance:HideWindow(gameObject.name)
end


function this.WhoShow(data)
    rule=data.rule
    IsCreate = data.isCreate
    curSelectPlay = data.curSelectPlay 
    -- print("是否启用："..tostring(data.curSelectPlay.enable))
    wanFaText:GetComponent('UILabel').text='当前玩法：'..getWanFaText(rule,true,false, true)

    if IsCreate then
        gameObject.transform:Find("bg/Sprite/Label2"):GetComponent('UILabel').text = "玩法设置"
        gameObject.transform:Find("bg/Sprite/Label1"):GetComponent('UILabel').text = "玩法设置"
        local nameString
        if rule.roomType == proxy_pb.SYZP then
            nameString = '邵阳字牌'
        elseif rule.roomType == proxy_pb.HHHGW then
            nameString = '怀化红拐弯'
		elseif rule.roomType == proxy_pb.AHPHZ then
            nameString = '安化跑胡子'
        elseif rule.roomType == proxy_pb.SYBP then
            nameString = '邵阳剥皮'
        elseif rule.roomType == proxy_pb.LDFPF then
            nameString = '娄底放炮罚'
        elseif rule.roomType == proxy_pb.CSPHZ then
            nameString = '长沙跑胡子'
        else
            nameString = '常德跑胡子'
        end
        inputNum:GetComponent('UIInput').value = 1
        inputName:GetComponent('UIInput').value = nameString
        On:GetComponent('UIToggle'):Set(true)
    else
        gameObject.transform:Find("bg/Sprite/Label2"):GetComponent('UILabel').text = "修改玩法"
        gameObject.transform:Find("bg/Sprite/Label1"):GetComponent('UILabel').text = "修改玩法"

        inputNum:GetComponent('UIInput').value = curSelectPlay.sn
        inputName:GetComponent('UIInput').value = curSelectPlay.name
        On:GetComponent('UIToggle'):Set(curSelectPlay.enable)
        Off:GetComponent('UIToggle'):Set(not curSelectPlay.enable)
    end

end

local function deleteHeadZero(str)
    if string.sub(str, 1, 1)=='0' then
        return deleteHeadZero(string.sub(str, 2))
    end
    return str
end

function this.OnClickSure(go)
    AudioManager.Instance:PlayAudio('btn')
    local inputNameText=deleteHeadZero(inputName:GetComponent('UIInput').value)
    local inputNumText=trim(inputNum:GetComponent('UIInput').value)
    if string.find( inputNumText,'-' ) then 
        panelMessageTip.SetParamers('请在排序框内输入0~999以内的数字', 1)
        PanelManager.Instance:ShowWindow('panelMessageTip')
        inputNum:GetComponent('UIInput').value = ''
        return 
    end
    if inputNameText~='' and inputNumText~='' then
        local msg = Message.New()
        
        if IsCreate then
            msg.type = proxy_pb.CREATE_CLUB_PLAY
            local body = proxy_pb.PCreateClubPlay();
            body.clubId=panelClub.clubInfo.clubId
            body.name=inputNameText
            --body.sn=  tonumber(inputNumText)
            body.enable=isEnable==1
            body.settings = json:encode(rule)  
            -- print('名称='..body.name)
            -- print('排序='..body.sn)
            -- print('clubid='..body.clubId)
            -- print('enable='..tostring(body.enable))
            -- print('settings='..wanFaText:GetComponent('UILabel').text)
            msg.body = body:SerializeToString()
        else
            msg.type = proxy_pb.UPDATE_CLUB_PLAY
            local body = proxy_pb.PUpdateClubPlay();
            body.playId= curSelectPlay.playId
            body.name= inputNameText
            body.sn = tonumber(inputNumText)
            body.enable = isEnable==1
            body.clubId=panelClub.clubInfo.clubId
            body.settings = json:encode(rule)
            msg.body = body:SerializeToString()
        end

        
        SendProxyMessage(msg, this.OnCreateClubPlayResult)
    else
        panelMessageTip.SetParamers('请输入完整的信息', 1.5)
	    PanelManager.Instance:ShowWindow('panelMessageTip')
    end
    
end

function this.OnCreateClubPlayResult(msg)
    local b = proxy_pb.RResult()
	b:ParseFromString(msg.body)
    if b.code == 1 then
        PanelManager.Instance:HideWindow('panelSetPlayName')
        PanelManager.Instance:HideWindow('panelModify')
        local str = IsCreate and "创建玩法成功" or "修改玩法成功" 
        panelMessageTip.SetParamers(str, 1.5)
        PanelManager.Instance:ShowWindow('panelMessageTip')
        panelClub.shuaXinClub()
	end
end

--function this.OnClickLastStep(go)
--    if IsCreate == true then
--        PanelManager.Instance:HideWindow(gameObject.name)
--        PanelManager.Instance:ShowWindow('panelCreateClub')
--    else
--        PanelManager.Instance:HideWindow(gameObject.name)
--        PanelManager.Instance:ShowWindow('panelModify')
--    end
--end