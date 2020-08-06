


panelClubApply = {}
local this = panelClubApply;

local message
local gameObject
local strNum

local ButtonNums={}
local ButtonDelete
local ButtonReInput
local ButtonClose
local selectRoot

local mask

local SelectNums={}
function this.Update()
   
end
local allNum=8
--���¼�--
function this.Awake(obj)
	gameObject = obj;

	selectRoot = gameObject.transform:Find('mainObj/numSelect')
    ButtonDelete = gameObject.transform:Find('mainObj/ButtonDelete')
    ButtonReInput = gameObject.transform:Find('mainObj/ButtonReInput')
	ButtonClose = gameObject.transform:Find('mainObj/ButtonClose')
	
	message = gameObject:GetComponent('LuaBehaviour')
    mask = gameObject.transform:Find('mask')
    message:AddClick(ButtonDelete.gameObject, this.OnClickButtonDelete)
    message:AddClick(ButtonReInput.gameObject, this.OnClickButtonReInput)
	message:AddClick(ButtonClose.gameObject, this.OnClickMask)

	for i=0,9 do
        ButtonNums[i] = gameObject.transform:Find('mainObj/Button'..i);
        message:AddClick(ButtonNums[i].gameObject, this.OnClickButtonNum);
		SetUserData(ButtonNums[i].gameObject, i)
    end
	
    for i=1,allNum do
        SelectNums[i] = selectRoot:Find('num'..i);
    end
	
end

function this.Start()
	-- gameObject.transform.parent = panelLobby.gameObject.transform
end

function this.OnEnable()
	selectRoot.gameObject:SetActive(false)
	
    strNum=''
    this.Refresh()
end

--�����¼�--
function this.OnClickMask(go)
    PanelManager.Instance:HideWindow(gameObject.name)
end

function this.OnClickButtonDelete(go)
	AudioManager.Instance:PlayAudio('btn')
	strNum = string.sub(strNum, 1, -2)
	this.Refresh()

	if #strNum == 0 then
		selectRoot.gameObject:SetActive(false)
	end
end

function this.OnClickButtonNum(go)
	AudioManager.Instance:PlayAudio('btn')
	if #strNum >= allNum then
		return
	else
		strNum = strNum..GetUserData(go)
		this.Refresh()
	end
	
    if #strNum == allNum then
        this.OnEnter()
        return
    end
	
	selectRoot.gameObject:SetActive(true)
end

function this.OnClickButtonReInput(go)
	AudioManager.Instance:PlayAudio('btn')
    strNum=''
	this.Refresh()
	
	selectRoot.gameObject:SetActive(false)
end

function this.OnLogin()
	if #strNum == allNum and gameObject.activeSelf then
        this.OnEnter()
    end
end

function this.Refresh()
    for i=1,allNum do
        if i <= #strNum then
            SelectNums[i]:GetComponent('UILabel').text=string.sub(strNum, i, i)
        else
            SelectNums[i]:GetComponent('UILabel').text='';
        end
    end    
end

function this.OnEnter()
	print('JIARU'..userInfo.id..'strNum'..strNum)
	local msg = Message.New()
	msg.type = proxy_pb.JOIN_CLUB
	local body = proxy_pb.PJoinClub();
	body.clubId = strNum
	--body.userId = userInfo.id
	msg.body = body:SerializeToString();
	SendProxyMessage(msg, this.OnJoinClubResult);
end
function this.Update()
   
end
function this.OnJoinClubResult(msg)
	print('OnJoinClubResult')
	local b = proxy_pb.RResult()
	b:ParseFromString(msg.body)
	if b.code == 1 then
		panelMessageTip.SetParamers('申请成功', 1.5)
		PanelManager.Instance:ShowWindow('panelMessageTip')
	else
		panelMessageTip.SetParamers(b.msg, 1.5)
		PanelManager.Instance:ShowWindow('panelMessageTip')
	end
	PanelManager.Instance:HideWindow(gameObject.name)
end