local phz_pb = require "phz_pb"

panelChiPai = {}
local this = panelChiPai

local message
local gameObject

local spritePortrait
local bipai1
local bipai2
local chipai
local bipai1Grid
local bipai1Select
local bipai1Label
local bipai1Labelland
local bipai1Spriteland
local bipai2Grid
local bipai2Select
local bipai2Label
local bipai2Labelland
local bipai2Spriteland
local chipaiGrid
local chipaiSelect
local chipaiLabelPortrait
local chipaiLabelland
local chipaiSpriteland
local ButtonOkChiPortrait
local ButtonOKChiLand
local mask

--牌组
local paiGrouo
local tiPaiGrouo
local chiIndex = -1
local bi1Index = -1
local bi2Index = -1

function this.Awake(obj)
	gameObject = obj

	paiGrouo = gameObject.transform:Find("PaiGroup")
	tiPaiGrouo = gameObject.transform:Find("tiPaiGroup")

	spritePortrait = gameObject.transform:Find("SpritePortrait")

	bipai1 = gameObject.transform:Find("bipai1")
	bipai1Grid = bipai1:Find("Grid")
	bipai1Select = bipai1:Find("selecte")
	bipai1Label = bipai1:Find("LabelPortrait")
	bipai1Labelland = bipai1:Find("Labelland")
	bipai1Spriteland = bipai1:Find("Spriteland")

	bipai2 = gameObject.transform:Find("bipai2")
	bipai2Grid = bipai2:Find("Grid")
	bipai2Select = bipai2:Find("selecte")
	bipai2Label = bipai2:Find("LabelPortrait")
	bipai2Labelland = bipai2:Find("Labelland")
	bipai2Spriteland = bipai2:Find("Spriteland")

	chipai = gameObject.transform:Find("chipai")
	chipaiGrid = chipai:Find("Grid")
	--chipaiSelect = chipai:Find('selecte')
	chipaiLabelPortrait = chipai:Find("LabelPortrait")
	chipaiLabelland = chipai:Find("Labelland")
	chipaiSpriteland = chipai:Find("Spriteland")

	ButtonOkChiPortrait = gameObject.transform:Find("ButtonOkChiPortrait")
	ButtonOkChiLand = gameObject.transform:Find("ButtonOkChiLand")
	mask = gameObject.transform:Find("mask")

	message = gameObject:GetComponent("LuaBehaviour")
	--message:AddClick(ButtonOkChiPortrait.gameObject, this.OnClickButtonOk)
	--message:AddClick(ButtonOkChiLand.gameObject, this.OnClickButtonOk)
	--message:AddClick(chipaiSpriteland.gameObject, this.OnClickSpriteLand)
	--message:AddClick(bipai1Spriteland.gameObject, this.OnClickSpriteLand)
	--message:AddClick(bipai2Spriteland.gameObject, this.OnClickSpriteLand)
	--message:AddClick(mask.gameObject, this.OnClickMask)
end

function this.Start()
end

function this.OnEnable()
	chiIndex = -1
	bi1Index = -1
	bi2Index = -1
	-- if #ROperationChiData.selectChi == 1 and #ROperationChiData.selectChi[1].childs == 0 then
	-- 	chiIndex = 1
	-- 	this.OnClickButtonOk(ButtonOkChiLand)
	-- 	print("吃牌 只有一种情况。。。。。。。。。。。。。。。。。。。。。。")
	-- else
	-- 	print("吃牌 吃牌数："..#ROperationChiData.selectChi.."比牌1数："..#ROperationChiData.selectChi[1].childs)
	-- 	this.Refresh()
	-- end

	this.Refresh()
end

function this.Refresh()
	local chiData
	local bi1Data
	local bi2Data

	this.ShowPaiPanel(chipai)
	if roomData.setting.roomTypeValue == proxy_pb.YJGHZ and ROperationChiData.operation == phz_pb.TI then
		this.RefreshTiGrid(chipaiGrid, ROperationChiData.plates, this.OnClickChiGrid)
		this.HidePaiPanel(bipai1)
		this.HidePaiPanel(bipai2)
		chipaiLabelland.gameObject:SetActive(false)
		return
	end
	chipaiLabelland.gameObject:SetActive(true)
	this.RefreshGrid(chipaiGrid, ROperationChiData.selectChi, this.OnClickChiGrid)

	-- ButtonOkChiLand.gameObject:SetActive(true)
	-- ButtonOkChiLand.position = panelInGame.ChiPaiPosition()

	if chiIndex < 0 then
		--chipaiSelect.gameObject:SetActive(false)
	else
		chiData = ROperationChiData.selectChi[chiIndex]
		--chipaiSelect.gameObject:SetActive(true)

		chipaiGrid:GetChild(chiIndex - 1):Find("selecte").gameObject:SetActive(true)
	end

	if chiData then
		print("比牌数量" .. #chiData.childs)
	end

	if chiData and #chiData.childs > 0 then
		this.ShowPaiPanel(bipai1)
		this.RefreshGrid(bipai1Grid, chiData.childs, this.OnClickBi1Grid)
	else
		this.HidePaiPanel(bipai1)
	end
	if bi1Index < 0 then
		--bipai1Select.gameObject:SetActive(false)
	else
		bi1Data = chiData.childs[bi1Index]
		--bipai1Select.gameObject:SetActive(true)
		bipai1Grid:GetChild(bi1Index - 1):Find("selecte").gameObject:SetActive(true)
	end

	if bi1Data and #bi1Data.childs > 0 then
		bipai2.gameObject:SetActive(true)
		this.ShowPaiPanel(bipai2)
		this.RefreshGrid(bipai2Grid, bi1Data.childs, this.OnClickBi2Grid)
	else
		this.HidePaiPanel(bipai2)
	end
	if bi2Index < 0 then
		--bipai2Select.gameObject:SetActive(false)
	else
		bi2Data = bi1Data.childs[bi2Index]
		--bipai2Select.gameObject:SetActive(true)
		bipai2Grid:GetChild(bi2Index - 1):Find("selecte").gameObject:SetActive(true)
	end
end

function this.OnClickChiGrid(go)
	chiIndex = GetUserData(go)
	bi1Index = -1
	bi2Index = -1
	print("OnClickChiGrid chiIndex:" .. chiIndex)
	this.Refresh()
	this.OnClickButtonOk(go)
end

function this.Update()
	--chipaiSelect.position = chipaiGrid:GetChild(chiIndex - 1).position
end

function this.OnClickBi1Grid(go)
	bi1Index = GetUserData(go)
	bi2Index = -1
	print("OnClickBi1Grid bi1Index:" .. bi1Index)
	this.Refresh()
	this.OnClickButtonOk(go)
end

function this.OnClickBi2Grid(go)
	bi2Index = GetUserData(go)
	print("OnClickBi2Grid bi2Index:" .. bi2Index)
	this.Refresh()
	this.OnClickButtonOk(go)
end

function this.OnClickMask(go)
	PanelManager.Instance:HideWindow(gameObject.name)
	print("mask.....................")
end

function this.OnClickSpriteLand(go)
end

--记录点击的
local oldChupai
local oldChupaiCount = 0

function this.OnClickButtonOk(go)

	if roomData.setting.roomTypeValue == proxy_pb.YJGHZ and ROperationChiData.operation == phz_pb.TI then
		local msg = Message.New()
		msg.type = phz_pb.TI_PAI
		local body = phz_pb.POperation()
		body.plate = ROperationChiData.plates[chiIndex]
		msg.body = body:SerializeToString()
		SendGameMessage(msg, nil)
		this.OnClickMask(go)
		panelInGame.HideOperationSend()
	end
	if chiIndex < 0 then
		oldChupai = "nil"
		return
	elseif #ROperationChiData.selectChi[chiIndex].childs > 0 and bi1Index < 0 then
		oldChupai = "nil"
		return
	elseif
		#ROperationChiData.selectChi[chiIndex].childs > 0 and bi1Index >= 0 and
			#ROperationChiData.selectChi[chiIndex].childs[bi1Index].childs > 0 and
			bi2Index < 0
	 then
		oldChupai = "nil"
		return
	end

	-- if chiIndex < 0 and #ROperationChiData.selectChi[chiIndex].childs > 0 and bi1Index < 0 and #ROperationChiData.selectChi[chiIndex].childs > 0 and bi1Index >= 0 and
	-- 	#ROperationChiData.selectChi[chiIndex].childs[bi1Index].childs > 0 and bi2Index < 0 then
	-- 		oldChupai = "nil"
	-- 	return
	-- end

	if lastOperat.plate ~= ROperationChiData.selectChi[1].plates[1] then
		this.OnClickMask(go)
		--print("lastOperat plate:" .. lastOperat.plate .. " cur chi plate:" .. ROperationChiData.selectChi[1].plates[1])
		return
	end

	if go.transform ~= ButtonOkChiLand then
		if oldChupai == go.name then
			oldChupaiCount = oldChupaiCount + 1
		else
			oldChupaiCount = 1
			oldChupai = go.name
		end

		if oldChupaiCount < 1 then
			return
		end
	end

	AudioManager.Instance:PlayAudio("btn")

	print("要发生吃牌了//////////////////////////////////////")

	local msg = Message.New()
	msg.type = phz_pb.CHI_PAI
	local body = phz_pb.POperation()
	local chiData = ROperationChiData.selectChi[chiIndex]
	local t_chiData = phz_pb.RSelectChi()
	t_chiData.id = chiData.id
	t_chiData.plates:append(chiData.plates[1])
	t_chiData.plates:append(chiData.plates[2])
	t_chiData.plates:append(chiData.plates[3])
	table.insert(body.selectChi, t_chiData)
	print("chiIndex plates:" .. table.concat(t_chiData.plates, ","))
	if #chiData.childs > 0 then
		local bi1Data = chiData.childs[bi1Index]
		local t_bi1Data = phz_pb.RSelectChi()
		t_bi1Data.id = bi1Data.id
		t_bi1Data.plates:append(bi1Data.plates[1])
		t_bi1Data.plates:append(bi1Data.plates[2])
		t_bi1Data.plates:append(bi1Data.plates[3])
		table.insert(body.selectChi, t_bi1Data)
		print("bi1Index plates:" .. table.concat(bi1Data.plates, ","))
		if #bi1Data.childs > 0 then
			local bi2Data = bi1Data.childs[bi2Index]
			local t_bi2Data = phz_pb.RSelectChi()
			t_bi2Data.id = bi2Data.id
			t_bi2Data.plates:append(bi2Data.plates[1])
			t_bi2Data.plates:append(bi2Data.plates[2])
			t_bi2Data.plates:append(bi2Data.plates[3])
			table.insert(body.selectChi, t_bi2Data)
			print("bi2Index plates:" .. table.concat(bi2Data.plates, ","))
		end
	end

	msg.body = body:SerializeToString()
	SendGameMessage(msg, nil)
	this.OnClickMask(go)
	panelInGame.HideOperationSend()

	oldChupai = "nil"
	print("chiIndex plates:" .. table.concat(chiData.plates, ","))
end

function this.RefreshGrid2(grid, data, onClickFunction)
	Util.ClearChild(grid)
	local wide = grid:GetComponent("UIGrid").cellWidth
	grid.transform.parent:GetComponent("UISprite").width = 140 + (#data - 1) * wide

	for i = 1, #data do
		local pai = NGUITools.AddChild(grid.gameObject, paiGrouo.gameObject)
		for j = 1, #data[i].plates do
			if j > pai.transform.childCount then
				return
			end
			pai.transform:GetChild(j - 1).gameObject:SetActive(true)
			--pai.transform:GetChild(j - 1):Find("plate"):GetComponent("UISprite").spriteName = "card_" .. data[i].plates[j]
			panelInGame.setPaiMian(pai.transform:GetChild(j - 1):Find("plate"),data[i].plates[j]);
		end
		pai.gameObject.name = i
		pai.gameObject:SetActive(true)

		SetUserData(pai.gameObject, i)
		UIEventListener.Get(pai.gameObject).onClick = onClickFunction
	end

	grid:GetComponent("UIGrid").repositionNow = true
	grid:GetComponent("UIGrid"):Reposition()
end
function this.RefreshTiGrid(grid, data, onClickFunction)
	Util.ClearChild(grid)
	for i=grid.childCount,#data-1 do
		NGUITools.AddChild(grid.gameObject,tiPaiGrouo.gameObject)
	end
	local wide = grid:GetComponent("UIGrid").cellWidth
	grid.transform.parent:GetComponent("UISprite").width=140+(#data-1)*wide
	grid.transform.parent:GetComponent("UISprite").height = 356

	for i = 0, grid.childCount - 1 do
		local paiGroup = grid:GetChild(i)
		if i < #data then
			for j=0,paiGroup.childCount-1 do
				local pai=paiGroup:GetChild(j)
				if j < 4 then
					pai.gameObject:SetActive(true)
					--pai.transform:GetChild(j - 1):Find("plate"):GetComponent("UISprite").spriteName = "card_" .. data[i].plates[j]
					panelInGame.setPaiMian(pai:Find("plate"),data[i+1])
				else
					pai.gameObject:SetActive(false)
				end
			end
			paiGroup.gameObject.name =i+1
			paiGroup.gameObject:SetActive(true)			
			SetUserData(paiGroup.gameObject,i+1)
			UIEventListener.Get(paiGroup.gameObject).onClick=onClickFunction
		else
			paiGroup.gameObject:SetActive(false)
		end
	end
end
function this.RefreshGrid(grid, data, onClickFunction)
	Util.ClearChild(grid)
	for i=grid.childCount,#data-1 do
		NGUITools.AddChild(grid.gameObject,paiGrouo.gameObject)
	end
	local wide = grid:GetComponent("UIGrid").cellWidth
	grid.transform.parent:GetComponent("UISprite").width=140+(#data-1)*wide
	grid.transform.parent:GetComponent("UISprite").height = 280

	for i = 0, grid.childCount - 1 do
		local paiGroup = grid:GetChild(i)
		if i < #data then
			for j=0,paiGroup.childCount-1 do
				local pai=paiGroup:GetChild(j)
				if j<#data[i+1].plates then
					pai.gameObject:SetActive(true)
					--pai.transform:GetChild(j - 1):Find("plate"):GetComponent("UISprite").spriteName = "card_" .. data[i].plates[j]
					panelInGame.setPaiMian(pai:Find("plate"),data[i+1].plates[j+1]);
				else
					pai.gameObject:SetActive(false)
				end
			end
			paiGroup.gameObject.name =i+1
			paiGroup.gameObject:SetActive(true)			
			SetUserData(paiGroup.gameObject,i+1)
			UIEventListener.Get(paiGroup.gameObject).onClick=onClickFunction
		else
			paiGroup.gameObject:SetActive(false)
		end
	end

	grid:GetComponent("UIGrid").repositionNow=true
	grid:GetComponent("UIGrid"):Reposition()
end

function this.RefreshGrid3(grid, data, onClickFunction)
	for i = 0, grid.childCount - 1 do
		if i < #data then
			local item = grid:GetChild(i)
			item.gameObject:SetActive(true)
			for j = 0, item.childCount - 1 do
				if j < #data[i + 1].plates then
					item:GetChild(j).gameObject:SetActive(true)
					--item:GetChild(j):Find("plate"):GetComponent("UISprite").spriteName = "card_" .. data[i + 1].plates[j + 1]
					panelInGame.setPaiMian(item:GetChild(j):Find("plate"),data[i + 1].plates[j + 1]);
				else
					item:GetChild(j).gameObject:SetActive(false)
				end
			end
			item.gameObject.name = i
			SetUserData(item.gameObject, i + 1)
			UIEventListener.Get(item.gameObject).onClick = onClickFunction
		else
			grid:GetChild(i).gameObject:SetActive(false)
		end
	end
	grid:GetComponent("UIGrid"):Reposition()

	local wide = grid:GetComponent("UIGrid").cellWidth
	grid.transform.parent:GetComponent("UISprite").width = 140 + (#data - 1) * wide
end

function this.HidePaiPanel(go)
	go:GetComponent("UISprite").alpha = 0
end

function this.ShowPaiPanel(go)
	go:GetComponent("UISprite").alpha = 1
end
