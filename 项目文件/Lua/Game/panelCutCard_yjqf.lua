local proxy_pb = require 'proxy_pb'
panelCutCard_yjqf = {}
local this = panelCutCard_yjqf

local message
local gameObject
local mask

local Grid
local cutBTN
local cutPai = nil
local shouShi
local slider
local cardMask
local waitLabel
local selectedCard = nil--最后选择的牌
local currentSelectCard = 43
local ButtonRefresh
local ButtonMore
local depth=5
local cardNum=0

function this.Awake(obj)
	gameObject = obj
    mask = gameObject.transform:Find('mask')
	message = gameObject:GetComponent('LuaBehaviour')

	waitLabel = gameObject.transform:Find('waitLabel')
	cutBTN = gameObject.transform:Find('cutBTN')
    message:AddClick(cutBTN.gameObject, this.OnClickCut)
	Grid = gameObject.transform:Find('grid')
	slider = gameObject.transform:Find('slider')
	shouShi = gameObject.transform:Find('slider/shouShi')
	cardMask = gameObject.transform:Find('slider/cardMask')
	message:AddPress(shouShi.gameObject, this.OnHoverFinger)
	message:AddClick(gameObject.transform:Find('btn/ButtonRefresh').gameObject, function()
        AudioManager.Instance:PlayAudio('btn')
        PanelManager.Instance:RestartGame()
	end)
	message:AddClick(gameObject.transform:Find('btn/ButtonMore').gameObject, function()
        AudioManager.Instance:PlayAudio('btn')
		PanelManager.Instance:ShowWindow('panelGameSetting_yjqf')
	end)
end
function this.Start()
end
function this.Update()
end
function this.OnEnable()
	RegisterGameCallBack(yjqf_pb.CUT_MOVE, this.OnCutCardAnimation)
	RegisterGameCallBack(yjqf_pb.CUT_SELECT, this.onGetCutResult)
	this.Refresh()
end
function this.WhoShow()
end
function this.Refresh()
	currentSelectCard = panelInGame.cutCardInfo.index
	cardNum = (roomData.setting.size == 2 and (roomData.setting.retainCard and 90 or 74) or (roomData.setting.retainCard and 132 or 108))
	for i = 0, cardNum-1 do
		if Grid.childCount<cardNum then
			local obj = NGUITools.AddChild(Grid.gameObject,gameObject.transform:Find('cardItem').gameObject)
			obj.name = Grid.childCount -1
			obj:SetActive(false)
			obj.transform:Find('bg'):GetComponent('UISprite').spriteName = 'UI-跑得快-背面_大'
			obj.transform:Find('type').gameObject:SetActive(false)
			obj.transform:Find('num').gameObject:SetActive(false)
			message:AddClick(obj, this.OnClickCard)
		end
	end
	for i = 0, Grid.childCount - 1 do
		Grid:GetChild(i).gameObject:SetActive(i < cardNum)
		if i < cardNum then
			Grid:GetChild(i):Find('bg'):GetComponent('UISprite').depth = ((i*2)+depth-1)
			Grid:GetChild(i):Find('type'):GetComponent('UISprite').depth = ((i*2)+depth)
			Grid:GetChild(i):Find('num'):GetComponent('UISprite').depth = ((i*2)+depth)
		end
	end
	Grid:GetComponent('UIGrid').cellWidth = (roomData.setting.size == 2 and (roomData.setting.retainCard and 10.7 or 13.05) or (roomData.setting.retainCard and 7.3 or 8.95))
	Grid:GetComponent('UIGrid'):Reposition()
	local x = Grid:GetChild(currentSelectCard).transform.localPosition.x
	slider:GetComponent('UISlider').value = x/Grid:GetChild(cardNum-1).transform.localPosition.x 
	if panelInGame.cutCardInfo.isMeCut then
		for i = 0, Grid.childCount-1 do
			Grid:GetChild(i).gameObject:GetComponent('BoxCollider').enabled = true
		end
	else
		for i = 0, Grid.childCount-1 do
			Grid:GetChild(i).gameObject:GetComponent('BoxCollider').enabled = false
		end
	end
	cutBTN.gameObject:SetActive(panelInGame.cutCardInfo.isMeCut)
	shouShi.gameObject:SetActive(panelInGame.cutCardInfo.isMeCut)
	waitLabel.gameObject:SetActive(not panelInGame.cutCardInfo.isMeCut)
	waitLabel:GetComponent('UILabel').text = '请稍等，\"[f0cf85]'..panelInGame.cutCardInfo.name..'[-]\"正在切牌...'
	if cutPai ~= nil then
		UnityEngine.Object.Destroy(cutPai.gameObject)
		cutPai = nil
	end
end
function this.OnClickCut(go)
	AudioManager.Instance:PlayAudio('btn')
	local msg = Message.New()
	msg.type = yjqf_pb.CUT_SELECT
	local body = yjqf_pb.PCutSelect()
	body.index = currentSelectCard
	msg.body = body:SerializeToString()
	SendGameMessage(msg, nil)
end
function this.onGetCutResult(msg)
	local data = yjqf_pb.RCutSelect()
	data:ParseFromString(msg.body)
	cutBTN.gameObject:SetActive(false)
	local selectPai = Grid:GetChild(data.index)
	cutPai = NGUITools.AddChild(slider.gameObject,selectPai.gameObject)
	cutPai.transform.position = selectPai.transform.position
	local bg =cutPai.transform:Find('bg')
	local type =cutPai.transform:Find('type')
	local num =cutPai.transform:Find('num')
	bg:GetComponent('UISprite').depth = 604
	type:GetComponent('UISprite').depth = 605
	num:GetComponent('UISprite').depth = 605
	bg:GetComponent('UISprite').spriteName='UI-跑得快-大牌面'
	bg.gameObject:SetActive(true)
	type.gameObject:SetActive(true)
	num.gameObject:SetActive(true)
	panelInGame.UpdataCardInfo(cutPai.transform,data.cardValue)
end
function this.OnClickCard(go)
	currentSelectCard = tonumber(go.name)
	local x = go.transform.localPosition.x
	slider:GetComponent('UISlider').value = x/Grid:GetChild(cardNum-1).transform.localPosition.x 
	local msg = Message.New()
	msg.type = yjqf_pb.CUT_MOVE
	local body = yjqf_pb.PCutMove()
	print('currentSelectCard: '..currentSelectCard)
	body.index = currentSelectCard
	msg.body = body:SerializeToString()
	SendGameMessage(msg, nil)
end
function this.OnHoverFinger(go,isHover)
	if not isHover then
		print('我松开了..........')
		if panelInGame.cutCardInfo.isMeCut then
			local pos = roomData.setting.size == 4 and (shouShi.transform.localPosition.x-5)*957/964 or (shouShi.transform.localPosition.x-5)*946/964
			local num = cardNum-1
			for i = 1, num do
				if i <= num then
					local pos1 = Grid:GetChild(i-1).transform.localPosition.x
					local pos2 = Grid:GetChild(i).transform.localPosition.x
					if pos > pos1 and pos < pos2  then
						currentSelectCard = tonumber(Grid:GetChild(i).name)-1
					elseif pos == pos1 then
						currentSelectCard = tonumber(Grid:GetChild(i-1).name)
					elseif pos == pos2 then
						currentSelectCard = tonumber(Grid:GetChild(i).name)
					end
				end
			end
			local msg = Message.New()
			msg.type = yjqf_pb.CUT_MOVE
			local body = yjqf_pb.PCutMove()
			print('currentSelectCard: '..currentSelectCard)
			body.index = currentSelectCard
			msg.body = body:SerializeToString()
			SendGameMessage(msg, nil)
		end
	end
end
function this.OnCutCardAnimation(msg)
	local b = yjqf_pb.RCutMove()
	b:ParseFromString(msg.body)
	currentSelectCard = b.index
	if panelInGame.cutCardInfo.isMeCut then
		return 
	else
		local x = Grid:GetChild(b.index).transform.localPosition.x
		slider:GetComponent('UISlider').value = x/Grid:GetChild(cardNum-1).transform.localPosition.x 
	end
end



