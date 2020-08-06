local pdk_pb = require 'pdk_pb'

panelStageClear_pdk = {}
local this = panelStageClear_pdk;

local message;
local gameObject;

local mask
local names={}
local lefts={}
local bombs={}
local piaofens={}
local playerids={}
--local scores={}
local scoreAll={}
local icons={}
local bgwin={}
local bgshu={}
local redtenbgc={}
local redtenscorec={}
local redtenbgd={}
local redtenscored={}
local redten = {}
local cards = {}
local sprint={}
local playerNiao={}
local ButtonOK
local ButtonShare
local ButtonXiPai
-- local winOrlose
-- local winOrloseWord1
-- local winOrloseWord2
local  wintitle 
local  losetilte
local  roommsg
local  playercard={}
local  baba
--���¼�--
function this.Awake(obj)
	gameObject = obj;

	ButtonOK = gameObject.transform:Find('ButtonOK');
	ButtonShare = gameObject.transform:Find('ButtonShare');
	ButtonXiPai = gameObject.transform:Find('ButtonXiPai');
	baba = gameObject.transform:Find('baba');

	message = gameObject:GetComponent('LuaBehaviour');
    message:AddClick(ButtonOK.gameObject, this.OnClickButtonOK);
    message:AddClick(ButtonShare.gameObject, this.OnClickButtonShare);
    message:AddClick(ButtonXiPai.gameObject, this.OnClickButtonXiPai);

    for i=1,3 do
        names[i] = gameObject.transform:Find('player'..i..'/playerName');
        lefts[i] = gameObject.transform:Find('player'..i..'/playerLeft');
		bombs[i] = gameObject.transform:Find('player'..i..'/playerBomb');
		piaofens[i] = gameObject.transform:Find('player'..i..'/playerFloatScore');
		playerids[i] = gameObject.transform:Find('player'..i..'/playerId');
        --scores[i] = gameObject.transform:Find('player'..i..'/playerScore');
		icons[i] = gameObject.transform:Find('player'..i..'/Texture');
		scoreAll[i] = gameObject.transform:Find('player'..i..'/playerScoreAll')
		sprint[i] = gameObject.transform:Find('player'..i..'/sprint')
		bgwin[i] = gameObject.transform:Find('player'..i..'/bgwin')
		bgshu[i] = gameObject.transform:Find('player'..i..'/bgshu')
		redtenbgc[i] = gameObject.transform:Find('player'..i..'/redtenbgc')
		redtenbgd[i] = gameObject.transform:Find('player'..i..'/redtenbgd')
		redtenscorec[i] = gameObject.transform:Find('player'..i..'/redtenbgc/redtenscorec')
		redtenscored[i] = gameObject.transform:Find('player'..i..'/redtenbgd/redtenscored')
		redten[i] = gameObject.transform:Find('player'..i..'/redten')
		cards[i] = gameObject.transform:Find('player'..i..'/cards')
		playerNiao[i] = gameObject.transform:Find('player'..i..'/Niao')
	end
	roommsg = gameObject.transform:Find('roommsg');
	-- winOrloseWord1 = gameObject.transform:Find('winOrlose/word1');
	-- winOrloseWord2 = gameObject.transform:Find('winOrlose/word2');
	wintitle = gameObject.transform:Find('yinle');
	losetilte = gameObject.transform:Find('shule');
end

	-- winOrlose = gameObject.transform:Find('winOrlose');
function this.Update()
end
function this.Start()
end

function this.setButtonsStatus(hideXiPai)
    if hideXiPai==nil and RoundData.roomData.setting.openShuffle==true and RoundData.isInGame==true and RoundData.data.gameOver==false then
        ButtonXiPai.gameObject:SetActive(true)
        ButtonXiPai:Find('Label'):GetComponent('UILabel').text='洗牌'
        ButtonXiPai:GetComponent('UIButton').isEnabled=true
    else
        ButtonXiPai.gameObject:SetActive(false)
    end
end

function this.OnClickButtonXiPai(go)
    panelMessageBoxTiShi.SetParamers(OK_CANCLE, function ()
        ButtonXiPai:GetComponent('UIButton').isEnabled=false
        AudioManager.Instance:PlayAudio('btn')
        local msg = Message.New()
        msg.type = pdk_pb.SHUFFLE
        SendGameMessage(msg, nil)
    end, nil, '洗牌会消耗'..RoundData.roomData.setting.shuffleFee..'疲劳值，是否确认洗牌？(确认洗牌后将自动进入下一局)')
    PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
end

function this.onGetXiPaiResult(msg)
    local b = pdk_pb.RShuffle()
    b:ParseFromString(msg.body)
    if b.seat==RoundData.mySeat then
        --错误码 83:洗牌成功  84:洗牌失败非疲劳值不足  85:洗牌失败疲劳值不足  86:重复洗牌
        if b.code==83 then
			ButtonXiPai:Find('Label'):GetComponent('UILabel').text='已洗牌'
			local msg = Message.New()
			msg.type = pdk_pb.READY
			SendGameMessage(msg, nil)
			if RoundData.isInGame then 
				panelInGame_pdk.hasStageClear=false
			end 
			PanelManager.Instance:HideWindow(gameObject.name)
        elseif  b.code==84 then
            ButtonXiPai:GetComponent('UIButton').isEnabled=true
            panelMessageBox.SetParamers(ONLY_OK, nil, nil, '暂时不能洗牌')
            PanelManager.Instance:ShowWindow('panelMessageBox')
        elseif  b.code==85 then
            ButtonXiPai:GetComponent('UIButton').isEnabled=true
            panelMessageBox.SetParamers(ONLY_OK, nil, nil, '疲劳值不足')
            PanelManager.Instance:ShowWindow('panelMessageBox')
        elseif  b.code==86 then
            ButtonXiPai:GetComponent('UIButton').isEnabled=true
            panelMessageBox.SetParamers(ONLY_OK, nil, nil, '请勿重复点击')
            PanelManager.Instance:ShowWindow('panelMessageBox')
        else
            ButtonXiPai:GetComponent('UIButton').isEnabled=true
            panelMessageBox.SetParamers(ONLY_OK, nil, nil, '洗牌未知错误')
            PanelManager.Instance:ShowWindow('panelMessageBox')
        end
    end
    if panelInGame.needXiPai==false and b.code==83 then
        panelInGame.needXiPai=true
    end
end

function this.WhoShow(fuc)
	fuc()
end

function this.OnEnable()
   this.GetCardData()
   this.Refresh()
   RegisterGameCallBack(pdk_pb.SHUFFLE, this.onGetXiPaiResult)
   this.setButtonsStatus()
end

function this.OnClickButtonShare()
	if not RoundData.isInGame then 
		return
	end
    local data = {}
    data.showName = 'JieTuShare'
    PanelManager.Instance:ShowWindow('panelShared', data)
end

function this.GetCardData()
	local seatindex0 = 0
	local seatindex1 = 0
	local seatindex2 = 0
	playercard[1]={}
	playercard[2]={}
	playercard[3]={}
	for i = 1, #RoundData.data.records do
		if RoundData.data.records[i].seat == 0 then
			--seatindex0 = seatindex0 + 1
			--playercard[1][seatindex0] = RoundData.data.records[i].cards
			local copy = {}
			local cardcopy = RoundData.data.records[i].cards
            for k = 1, #RoundData.data.records[i].cards do
                copy[k] = RoundData.data.records[i].cards[k]
            end
            table.sort(copy, tableSortDesc)
            local cardGroups = GetCardsGroup(copy)
            local group4 = GetGroupByID(4, cardGroups)
            local group3 = GetGroupByID(3, cardGroups)
            if #group4 > 0 or #group3 > 0 then
            else
                cardcopy = reverseTable(RoundData.data.records[i].cards)
            end
			for k = 1, #cardcopy do
				table.insert(playercard[1], cardcopy[k])
			end
		elseif RoundData.data.records[i].seat == 1 then
			--seatindex0 = seatindex1 + 1
			--playercard[2][seatindex1] = RoundData.data.records[i].cards
			local copy = {}
			local cardcopy = RoundData.data.records[i].cards
            for k = 1, #RoundData.data.records[i].cards do
                copy[k] = RoundData.data.records[i].cards[k]
            end
            table.sort(copy, tableSortDesc)
            local cardGroups = GetCardsGroup(copy)
            local group4 = GetGroupByID(4, cardGroups)
            local group3 = GetGroupByID(3, cardGroups)
            if #group4 > 0 or #group3 > 0 then
            else
                cardcopy = reverseTable(RoundData.data.records[i].cards)
            end
			for k = 1, #cardcopy do
				table.insert(playercard[2], cardcopy[k])
			end
		elseif RoundData.data.records[i].seat == 2 then
			--seatindex0 = seatindex2 + 1
			--playercard[3][seatindex2] = RoundData.data.records[i].cards
			local copy = {}
			local cardcopy = RoundData.data.records[i].cards
			for k = 1, #RoundData.data.records[i].cards do
				copy[k] = RoundData.data.records[i].cards[k]
			end
             table.sort(copy, tableSortDesc)
             local cardGroups = GetCardsGroup(copy)
             local group4 = GetGroupByID(4, cardGroups)
             local group3 = GetGroupByID(3, cardGroups)
             if #group4 > 0 or #group3 > 0 then
             else
                cardcopy = reverseTable(RoundData.data.records[i].cards)
            end
			for k = 1, #cardcopy do
				table.insert(playercard[3], cardcopy[k])
			end
		end
	end
end
function this.GetUIIndexBySeat(seat)
    return ((#RoundData.playerData+1)-RoundData.mySeat+seat)%(#RoundData.playerData+1)
end
--�����¼�--
function this.OnClickMask(go)
    PanelManager.Instance:HideWindow(gameObject.name)
	if RoundData.isInGame then 
		panelInGame_pdk.hasStageClear=false
	end 
end
function this.jiangxu(a,b)
	print("a.score",a.score)
	print("b.score",b.score)
	return a.score > b.score
end
function this.Refresh()
	print(#RoundData.data.players)
	table.sort(RoundData.data.players,this.jiangxu)
	print("#names",#names)
	if #RoundData.data.players == 2 then
		names[2].transform.parent.localPosition = Vector3(0,-60,0)
		baba.gameObject:SetActive(true)
		this.ShowCard(baba:GetChild(0), RoundData.data.surplusCards)
	else
		baba.gameObject:SetActive(false)
		names[2].transform.parent.localPosition = Vector3(0,-26,0)
		names[3].transform.parent.localPosition = Vector3(0,-183,0)
	end
    for i=1,#names do
		local player = RoundData.data.players[i]
		if i <= #RoundData.data.players then
			names[i].transform.parent.gameObject:SetActive(true)
			print("iiiii",i,"#RoundData.data.players",#RoundData.data.players)
			print("names[i].transform.parent.gameObject",names[i].transform.parent.gameObject.name)
			names[i]:GetComponent('UILabel').text = RoundData.playerData[player.seat].name
			playerids[i]:GetComponent('UILabel').text = "ID:"..RoundData.playerData[player.seat].id
			lefts[i]:GetComponent('UILabel').text = #player.cards
			bombs[i]:GetComponent('UILabel').text = player.bombCount
			piaofens[i]:GetComponent('UILabel').text = player.floatScore
			--playerNiao[i].gameObject:SetActive(RoundData.playerData[player.seat].hitBird == 1)
			--scores[i]:GetComponent('UILabel').text = player.score
			if player.score > 0 then
				scoreAll[i]:GetComponent('UILabel').text = "+"..player.score--RoundData.playerData[player.seat].score
				scoreAll[i]:GetComponent('UILabel').color = Color(208/255,42/255,54/255)
			else
				scoreAll[i]:GetComponent('UILabel').text = player.score--RoundData.playerData[player.seat].score
				scoreAll[i]:GetComponent('UILabel').color = Color(6/255,68/255,176/255)
			end
			sprint[i].gameObject:SetActive(#player.cards == RoundData.setting.cardCount and player.singleProtecting == false)
			local index = this.GetUIIndexBySeat(player.seat)
			icons[i]:GetComponent('UITexture').mainTexture = RoundData.playerIcon[index]:GetComponent('UITexture').mainTexture
			--icons[i].gameObject:SetActive(true)
			if  player.score > 0 then
				bgwin[i].gameObject:SetActive(true)
				bgshu[i].gameObject:SetActive(false)
				--redtenbgc[i].gameObject:SetActive(true)
				--redtenbgd[i].gameObject:SetActive(false)
				--redtenscorec[i]:GetComponent('UILabel').text = "翻倍+"..player.redTenScore
			else
				bgwin[i].gameObject:SetActive(false)
				bgshu[i].gameObject:SetActive(true)
				--redtenbgc[i].gameObject:SetActive(false)
				--redtenbgd[i].gameObject:SetActive(true)
				--redtenscored[i]:GetComponent('UILabel').text =  player.redTenScore
			end
			--if RoundData.setting.redTen == 0 then
				--redtenbgc[i].gameObject:SetActive(false)
				--redtenbgd[i].gameObject:SetActive(false)
			--else
				if  player.redTenScore > 0 then
					--redtenbgd[i].gameObject:SetActive(true)
					--redtenbgc[i].gameObject:SetActive(false)
					-- if RoundData.setting.redTen == -1 then
					-- 	redtenscored[i]:GetComponent('UILabel').text = "翻倍+"..player.redTenScore
					-- else
						redten[i]:GetComponent('UILabel').text = "+"..player.redTenScore
					--end
				else
					--redtenbgd[i].gameObject:SetActive(true)
					--redtenbgc[i].gameObject:SetActive(false)
					redten[i]:GetComponent('UILabel').text =  player.redTenScore
				end
			--end
			this.ShowCard(cards[i], playercard[player.seat+1])
			this.ShowLeftCard(cards[i], player.cards)
		else
			print("影藏父节点")
			names[i].transform.parent.gameObject:SetActive(false)
			-- names[i]:GetComponent('UILabel').text = ''
			-- lefts[i]:GetComponent('UILabel').text = ''
			-- bombs[i]:GetComponent('UILabel').text = ''
			-- --scores[i]:GetComponent('UILabel').text = ''
			-- scoreAll[i]:GetComponent('UILabel').text = ''
			-- --sprint[i].gameObject:SetActive(false)
			-- icons[i].gameObject:SetActive(false)
		end
	end
	roommsg:GetComponent('UILabel').text = "第"..(RoundData.roomData.round-1).."/"..RoundData.roomData.setting.rounds.."局".."  房间号:"..roomInfo.roomNumber	
	print('mySeat is:'..RoundData.mySeat..' winner seat is:'..RoundData.data.winner)
	if RoundData.mySeat == RoundData.data.winner then
		-- winOrlose:GetComponent('UISprite').spriteName = 'fangjian_dadikuangtu1'
		-- winOrloseWord1:GetComponent('UISprite').spriteName = 'fangjian_word20'
		-- winOrloseWord2:GetComponent('UISprite').spriteName = 'fangjian_word21'
		wintitle.gameObject:SetActive(true)
		losetilte.gameObject:SetActive(false)
	else
		wintitle.gameObject:SetActive(false)
		losetilte.gameObject:SetActive(true)
		-- winOrlose:GetComponent('UISprite').spriteName = 'fangjian_dadikuangtu2'
		-- winOrloseWord1:GetComponent('UISprite').spriteName = 'fangjian_word22'
		-- winOrloseWord2:GetComponent('UISprite').spriteName = 'fangjian_word23'
	end
end

function this.OnClickButtonOK(go)
	AudioManager.Instance:PlayAudio('btn')
	print('RoundData.over:'..tostring(RoundData.over))
	if RoundData.isInGame then
		if RoundData.over or RoundAllData.over then
			PanelManager.Instance:ShowWindow('panelStageClearAll_pdk')
		else
			local msg = Message.New()
			msg.type = pdk_pb.READY
			SendGameMessage(msg, nil)
		end
	end 
	this.OnClickMask(go)
end

function this.ShowCard(grid, cards)
	print("refreshGrid name "..grid.name..' card num:'..#cards)
	--table.sort(cards,tableSortAsc)
	for i=0,grid.transform.childCount-1 do
		local item = grid.transform:GetChild(i)
		if i < #cards then
			item.gameObject:SetActive(true)
			item.gameObject.transform.localPosition = Vector3(-256+i*28,0,0)
			--print("-256+i*28",-256+i*28,"   @",item.gameObject.transform.localPositon)
			local t = item:Find('hua');
			--local tSmall = item:Find('typeSmall')
			--local tBig = item:Find('typeBig')
			local num = item:Find('num')
			local card = cards[i+1]
			local di = item:Find('item')
			di:GetComponent('UISprite').color = Color.white
			--tSmall.gameObject:SetActive(false)
			--tBig.gameObject:SetActive(false)
			--num.gameObject:SetActive(false)
			--t.gameObject:SetActive(false)
            --SetUserData(item.gameObject, card)
            --if grid.transform.parent.gameObject.name == "player0" then
                --item:GetComponent('UIPanel').depth = i+50
            -- else
            --     if i>=10  then
            --         item:GetComponent('UIPanel').depth = 50-i ----i+3
            --     else
            --         item:GetComponent('UIPanel').depth = 20-i ----i+3
            --     end
            -- end
			
            if card < 52 then
                local plateType = card%4
                local plateNum = getIntPart(card/4)+3
                local strType=''
				local col = Color.white
                if plateType == 0 then
                    strType='DiamondIcon'
					col = Color.white
                elseif plateType == 1 then
                    strType='ClubIcon'
					col.r = 51/255
					col.g = 52/255
					col.b = 57/255
                elseif plateType == 2 then
                    strType='HeartIcon'
					col = Color.white
                else
                    strType='SpadeIcon'
					col.r = 51/255
					col.g = 52/255
					col.b = 57/255
                end
				
				t.gameObject:SetActive(true)
                t:GetComponent('UISprite').spriteName=strType.."1"
				
                -- if plateNum >10 and plateNum < 14 and false then
                --     tBig.gameObject:SetActive(true)
				-- 	if plateNum == 11 then
				-- 		tBig:GetComponent('UISprite').spriteName='JackIcon'
				-- 	elseif plateNum == 12 then
				-- 		tBig:GetComponent('UISprite').spriteName='QueenIcon'
				-- 	else
				-- 		tBig:GetComponent('UISprite').spriteName='KingIcon'
				-- 	end
                -- else
                --     tSmall:GetComponent('UISprite').spriteName=strType
				-- 	tSmall:GetComponent('UISprite').color=col
                --     tSmall.gameObject:SetActive(true)
                -- end
				--num.gameObject:SetActive(true)
                num:GetComponent('UISprite').spriteName = 'card_'..plateNum
				num:GetComponent('UISprite').color=col
            -- else
            --     tBig.gameObject:SetActive(true)
			-- 	tBig:GetComponent('UISprite').spriteName='JokerIcon'
            end
		else
			item.gameObject:SetActive(false)
		end
	end
	--grid:GetComponent('UIGrid'):Reposition()
end
function this.ShowLeftCard(grid, cards)
	if #cards == 0 then
		return 
	end
	--table.sort(cards,tableSortAsc)
	local  cardindex = 1
	for i=0,grid.transform.childCount-1 do
		local item = grid.transform:GetChild(i)
		-- di:GetComponent('UISprite').color = Color.white
		if item.gameObject.activeSelf == false and cardindex <= #cards then
			item.gameObject:SetActive(true)
			item.gameObject.transform.localPosition = Vector3(-256+i*28+30,0,0)
			--print("-256+i*28",-256+i*28,"   @",item.gameObject.transform.localPositon)
			local t = item:Find('hua');
			local di = item:Find('item')
			local num = item:Find('num')
			local card = cards[cardindex]
			cardindex = cardindex + 1
            --item:GetComponent('UIPanel').depth = i+50
            if card < 52 then
                local plateType = card%4
                local plateNum = getIntPart(card/4)+3
                local strType=''
				local col = Color.white
                if plateType == 0 then
                    strType='DiamondIcon'
					col = Color.white
                elseif plateType == 1 then
                    strType='ClubIcon'
					col.r = 51/255
					col.g = 52/255
					col.b = 57/255
                elseif plateType == 2 then
                    strType='HeartIcon'
					col = Color.white
                else
                    strType='SpadeIcon'
					col.r = 51/255
					col.g = 52/255
					col.b = 57/255
                end
                t:GetComponent('UISprite').spriteName=strType.."1"
                num:GetComponent('UISprite').spriteName = 'card_'..plateNum
				num:GetComponent('UISprite').color=col
				local col1 = Color.white
				col1.r = 191/255
				col1.g = 191/255
				col1.b = 191/255
				di:GetComponent('UISprite').color=col1
            end
		end
	end
end