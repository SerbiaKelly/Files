local proxy_pb = require 'proxy_pb'
require "Lua.Game.Tools.UITools"
panelCutCard = {}
local this = panelCutCard;

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

local isMeCut=false
local cutPlayerName
local currentSelectCard = 43
local ButtonRefresh
local ButtonMore

function this.Awake(obj)
	gameObject = obj;
    mask = gameObject.transform:Find('mask')
	message = gameObject:GetComponent('LuaBehaviour')

	cutBTN = gameObject.transform:Find('cutBTN')
    message:AddClick(cutBTN.gameObject, this.OnClickCut)

	Grid = gameObject.transform:Find('grid')

	--刷新按钮   更多按钮
	ButtonRefresh = gameObject.transform:Find('btn/ButtonRefresh');
	ButtonMore = gameObject.transform:Find('btn/ButtonMore');
	message:AddClick(ButtonRefresh.gameObject, this.OnClickButtonRefresh)
	message:AddClick(ButtonMore.gameObject, this.OnClickButtonSetting)

	for i = 0, Grid.childCount-1 do
		Grid:GetChild(i).name = tostring(i)
		message:AddClick(Grid:GetChild(i).gameObject, this.OnClickCard)
	end
	slider = gameObject.transform:Find('slider')
	shouShi = gameObject.transform:Find('slider/shouShi')
	cardMask = gameObject.transform:Find('slider/cardMask')
	message:AddPress(shouShi.gameObject, this.OnHoverFinger)
	waitLabel = gameObject.transform:Find('waitLabel')

end

function this.Start()

end

function this.Update()

end

function this.OnEnable()
	for i=0,87 do
		local obj = Grid:GetChild(i)
		local bg =obj:Find('bg')
		local type =obj:Find('type')
		local typeSmall =obj:Find('typeSmall')
		local typeBig =obj:Find('typeBig')
		local num =obj:Find('num')
		local shouchu =obj:Find('shouchu')
		bg:GetComponent('UISprite').spriteName='UI-跑得快-背面_大'
        bg:GetComponent('UISprite').depth = i *3 + 4
        type:GetComponent('UISprite').depth = i *3+ 5
        typeSmall:GetComponent('UISprite').depth = i *3+ 5
        typeBig:GetComponent('UISprite').depth = i *3+ 5
        num:GetComponent('UISprite').depth = i *3+ 5
		shouchu:GetComponent('UISprite').depth = i *3+ 6
		bg.gameObject:SetActive(true);
		type.gameObject:SetActive(false);
		typeSmall.gameObject:SetActive(false);
		typeBig.gameObject:SetActive(false);
		num.gameObject:SetActive(false);
		shouchu.gameObject:SetActive(false);
	end
	for i = 44, 87 do
		Grid:GetChild(i).gameObject:SetActive(roomData.setting.size == 4)
	end
	Grid:GetComponent('UIGrid').cellWidth = roomData.setting.size == 4 and 11 or 22
	Grid:GetComponent('UIGrid'):Reposition()
end

function this.WhoShow(data)
	print('WhoShowminfo')
	RegisterGameCallBack(xhzd_pb.CUT_POSTION, this.OnCutCardAnimation)
	isMeCut=data.isMeCut
	cutPlayerName=data.name
	currentSelectCard = data.endX
	cutBTN.gameObject:SetActive(isMeCut==true)
	shouShi.gameObject:SetActive(isMeCut==true)
	waitLabel.gameObject:SetActive(isMeCut==false)
	waitLabel:GetComponent('UILabel').text = '请稍等，\"[f0cf85]'..cutPlayerName..'[-]\"正在切牌...'
	local x = Grid:GetChild(data.endX).transform.localPosition.x
	slider:GetComponent('UISlider').value = roomData.setting.size == 4 and x/Grid:GetChild(87).transform.localPosition.x or x/Grid:GetChild(43).transform.localPosition.x  
	if cutPai ~= nil then
		UnityEngine.Object.Destroy(cutPai.gameObject)
		cutPai = nil
	end
	
	if isMeCut then
		for i = 0, Grid.childCount-1 do
			Grid:GetChild(i).gameObject:GetComponent('BoxCollider').enabled = true;
		end
	else
		for i = 0, Grid.childCount-1 do
			Grid:GetChild(i).gameObject:GetComponent('BoxCollider').enabled = false;
		end
	end
end



function this.OnClickButtonRefresh(GO)
	panelInGame_xhzd.OnClickButtonRefresh(GO)
end

function this.OnClickButtonSetting(go)
	panelInGame_xhzd.OnClickButtonSetting(go)
end

function this.OnClickCut(go)
	AudioManager.Instance:PlayAudio('btn')
	local msg = Message.New()
	msg.type = xhzd_pb.CUT_CARD
	local body = xhzd_pb.PCutCard();
	body.cardIndex = currentSelectCard
	msg.body = body:SerializeToString();
	SendGameMessage(msg, nil)
end

function this.OnClickCard(go)
	currentSelectCard = tonumber(go.name)
	local x = go.transform.localPosition.x
	--print('name : '..go.name..'  x : '..(x/957))
	slider:GetComponent('UISlider').value = roomData.setting.size == 4 and x/Grid:GetChild(87).transform.localPosition.x or x/Grid:GetChild(43).transform.localPosition.x
	local msg = Message.New()
	msg.type = xhzd_pb.CUT_POSTION
	local body = xhzd_pb.PCutPostion();
	body.endX = currentSelectCard
	msg.body = body:SerializeToString();
	SendGameMessage(msg, this.OnCutCardAnimation)
end

function this.OnHoverFinger(go,isHover)
	if not isHover then
		print('我松开了..........')
		if isMeCut==true then
			local pos = roomData.setting.size == 4 and (shouShi.transform.localPosition.x-5)*957/964 or (shouShi.transform.localPosition.x-5)*946/964
			print('pos : '..pos)
			local num = roomData.setting.size == 4 and 87 or 43
			for i = 1, num do
				if i <= num then
					local pos1 = Grid:GetChild(i-1).transform.localPosition.x
					local pos2 = Grid:GetChild(i).transform.localPosition.x
					if pos > pos1 and pos < pos2  then
						currentSelectCard = tonumber(Grid:GetChild(i).name)-1
						print('pos : '..pos..'  pos1 : '..pos1..'  pos2 : '..pos2..' currentSelectCard：'..currentSelectCard)
					elseif pos == pos1 then
						currentSelectCard = tonumber(Grid:GetChild(i-1).name)
						print('pos : '..pos..'  pos1 : '..pos1..'  pos2 : '..pos2..' currentSelectCard：'..currentSelectCard)
					elseif pos == pos2 then
						currentSelectCard = tonumber(Grid:GetChild(i).name)
						print('pos : '..pos..'  pos1 : '..pos1..'  pos2 : '..pos2..' currentSelectCard：'..currentSelectCard)
					end
				end
			end
			
			local msg = Message.New()
			msg.type = xhzd_pb.CUT_POSTION
			local body = xhzd_pb.PCutPostion();
			body.endX = currentSelectCard
			msg.body = body:SerializeToString();
			SendGameMessage(msg, nil)
		end
	end
end

function this.OnCutCardAnimation(msg)
	local b = xhzd_pb.RCutPostion()
	b:ParseFromString(msg.body)
	--print(' 收到切牌同步动画位置 ：'..tostring(isMeCut)..'  endX : '..b.endX)
	currentSelectCard = b.endX
	if isMeCut == true then
		return 
	else
		local x = Grid:GetChild(b.endX).transform.localPosition.x
		slider:GetComponent('UISlider').value = roomData.setting.size == 4 and x/Grid:GetChild(87).transform.localPosition.x or x/Grid:GetChild(43).transform.localPosition.x
	end
end

function this.onGetCutResult(data)
	cutBTN.gameObject:SetActive(false)
	local selectPai = Grid:GetChild(currentSelectCard)
	cutPai = NGUITools.AddChild(slider.gameObject,selectPai.gameObject)
	cutPai.transform.position = selectPai.transform.position
	local bg =cutPai.transform:Find('bg')
	local type =cutPai.transform:Find('type')
	local typeSmall =cutPai.transform:Find('typeSmall')
	local typeBig =cutPai.transform:Find('typeBig')
	local num =cutPai.transform:Find('num')
	local shouchu =cutPai.transform:Find('shouchu')
	bg:GetComponent('UISprite').depth = 604
	type:GetComponent('UISprite').depth = 605
	typeSmall:GetComponent('UISprite').depth = 605
	typeBig:GetComponent('UISprite').depth = 604
	num:GetComponent('UISprite').depth = 605
	shouchu:GetComponent('UISprite').depth = 606
	bg:GetComponent('UISprite').spriteName='UI-跑得快-大牌面'
	bg.gameObject:SetActive(true);
	type.gameObject:SetActive(true);
	typeSmall.gameObject:SetActive(true);
	typeBig.gameObject:SetActive(false);
	num.gameObject:SetActive(true);
	shouchu.gameObject:SetActive(false);
	local mycard={trueValues={data.card},type={GetPlateType(data.card)},value=GetPlateNum(data.card)+2}
	panelInGame_xhzd.setPai(cutPai,mycard,1)
end

