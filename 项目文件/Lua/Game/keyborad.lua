


keyborad = {}
local this = keyborad;

local message
local gameObject
local strNum=''

local ButtonNums={}
local ButtonDelete
local ButtonReInput
local ButtonClose

local mask

function this.Update()
   
end
local allNum=7
--���¼�--
function this.Awake(obj)
	gameObject = obj;

    ButtonDelete = gameObject.transform:Find('Grid/ButtonDelete')
    ButtonReInput = gameObject.transform:Find('Grid/ButtonReInput')
	ButtonClose = gameObject.transform
	
	message = gameObject:GetComponent('LuaBehaviour')
    mask = gameObject.transform:Find('mask')
    message:AddClick(ButtonDelete.gameObject, this.OnClickButtonDelete)
    message:AddClick(ButtonReInput.gameObject, this.OnClickButtonReInput)
	message:AddClick(mask.gameObject, this.OnClickMask)

	for i=0,9 do
        ButtonNums[i] = gameObject.transform:Find('Grid/Button'..i);
        message:AddClick(ButtonNums[i].gameObject, this.OnClickButtonNum);
		SetUserData(ButtonNums[i].gameObject, i)
    end

	
end

local whoShow
function this.WhoShow(data)
	whoShow=data
	if whoShow=='panelMenberRecord' then
		ButtonDelete.parent.localPosition=Vector3(-95,120,0)
		ButtonDelete.parent.localScale=Vector3(1.5,1.5,1.5)
	elseif whoShow=='panelMenber+Menber' then
		ButtonDelete.parent.localPosition=Vector3(-67,60,0)
		ButtonDelete.parent.localScale=Vector3(1.5,1.5,1.5)
	elseif whoShow=='panelRoomRecord' then
		ButtonDelete.parent.localPosition=Vector3(238,135,0)
	elseif whoShow == 'panelSelMenber' then
		ButtonDelete.parent.localPosition=Vector3(238,179,0)
	elseif whoShow == 'panelFeeBillRecord' then
		ButtonDelete.parent.localPosition=Vector3(-268,101,0)
	end
end

function this.Start()
	-- gameObject.transform.parent = panelLobby.gameObject.transform
end

function this.OnEnable()
    strNum=''
    this.Refresh()
end

--�����¼�--
function this.OnClickMask(go)
	-- strNum=''
	-- this.Refresh()
    PanelManager.Instance:HideWindow(gameObject.name)
end

function this.OnClickButtonDelete(go)
	AudioManager.Instance:PlayAudio('btn')
	strNum = string.sub(strNum, 1, -2)
	this.Refresh()

	if #strNum == 0 then
		--selectRoot.gameObject:SetActive(false)
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
        return
    end
end
function this.OnClickButtonReInput(go)
	AudioManager.Instance:PlayAudio('btn')
    strNum=''
	this.Refresh()
end

function this.Refresh()
	if whoShow=='panelMenberRecord' then
		panelMenberRecord.setSearchInput(strNum)
	elseif whoShow=='panelRoomRecord' then
		panelRoomRecord.setSearchInput(strNum)
	elseif whoShow == 'panelMenber+Menber' then
		panelMenber.setMenberSearch(strNum)
	elseif whoShow == 'panelMenber+Manager' then
		panelMenber.setManagerSearch(strNum)
	elseif whoShow == 'panelMenber+BlackList' then
		panelMenber.setBlackListSearch(strNum)
	elseif whoShow == 'panelSelMenber' then
		panelSelMenber.setSearchInput(strNum)
	elseif whoShow == 'panelFeeBillRecord' then
		panelFeeBillRecord.setSearchInput(strNum)
	end    
end
