

panelSelctPlay = {}
local this = panelSelctPlay

local gameObject
local message

local nextButton
local closeButton

local zpToggle
local mjToggle
local pdkToggle

local zpGridTrans
local runfastTrans
local mjGridTrans

local curSelctPlay

local showRoomName={
	"邵阳字牌",
	"邵阳剥皮",
	"娄底放炮罚",
	"湘乡告胡子",
	--"安化跑胡子",
	--"怀化红拐弯",
	--"常德跑胡子",
	--"长沙跑胡子",
	--"衡阳十胡卡",
	--"衡阳六胡抢",
	--"耒阳字牌",
	--"汉寿跑胡子",
	--"常德多红对",
    --"宁乡跑胡子",
    --"湘潭跑胡子",
    --"攸县碰胡",
    --"沅江鬼胡子",
    --"郴州字牌",
	"跑得快15张",
	"跑得快16张",
	"打筒子",
	"半边天炸",
    "新化炸弹",
    --"沅江千分",
    --"衡山同花",
	"转转麻将",
	"红中麻将",
    "长沙麻将",
    --"划水麻将"
    --"溆浦老牌"
}

function this.SetGameShowOrHide()
	local firstShow
    for i=0, zpGridTrans.transform.childCount - 1 do
        local obj = zpGridTrans.transform:GetChild(i)
		obj.gameObject:SetActive(CONST.showAllGame)
		obj:GetComponent("UIToggle"):Set(false)
		for j=1,#showRoomName do
			if (obj:Find('Label'):GetComponent('UILabel').text == showRoomName[j]) then
				obj.gameObject:SetActive(true)
				if firstShow == nil then
					firstShow = obj
					obj:GetComponent("UIToggle"):Set(true)
				end
				if (curSelctPlay == showRoomName[j]) then
					firstShow:GetComponent("UIToggle"):Set(false)
					obj:GetComponent("UIToggle"):Set(true)
				end
				break
			end
		end
    end
	zpGridTrans:GetComponent('UIGrid'):Reposition()
 
	firstShow = nil
    for i = 0,runfastTrans.transform.childCount - 1 do
        local obj = runfastTrans.transform:GetChild(i);
        obj:GetComponent("UIToggle"):Set(i == 0)
		obj.gameObject:SetActive(CONST.showAllGame)
		for j=1,#showRoomName do
			if (obj:Find('Label'):GetComponent('UILabel').text == showRoomName[j]) then
				obj.gameObject:SetActive(true)
				obj.gameObject:SetActive(true)
				if firstShow == nil then
					firstShow = obj
					obj:GetComponent("UIToggle"):Set(true)
				end
				if (curSelctPlay == showRoomName[j]) then
					firstShow:GetComponent("UIToggle"):Set(false)
					obj:GetComponent("UIToggle"):Set(true)
				end
				break
			end
		end
    end
	runfastTrans:GetComponent('UIGrid'):Reposition()

	firstShow = nil
    for i = 0,mjGridTrans.transform.childCount - 1 do
        local obj = mjGridTrans.transform:GetChild(i);
        obj:GetComponent("UIToggle"):Set(i == 0)
		obj.gameObject:SetActive(CONST.showAllGame)
		for j=1,#showRoomName do
			if (obj:Find('Label'):GetComponent('UILabel').text == showRoomName[j]) then
				obj.gameObject:SetActive(true)
				obj.gameObject:SetActive(true)
				if firstShow == nil then
					firstShow = obj
					obj:GetComponent("UIToggle"):Set(true)
				end
				if (curSelctPlay == showRoomName[j]) then
					firstShow:GetComponent("UIToggle"):Set(false)
					obj:GetComponent("UIToggle"):Set(true)
				end
				break
			end
		end
    end
	mjGridTrans:GetComponent('UIGrid'):Reposition()
end

function this.Awake(go)
    gameObject = go
    message = gameObject:GetComponent('LuaBehaviour');

    zpToggle = gameObject.transform:Find('Plays/zp')
    mjToggle = gameObject.transform:Find('Plays/mj')
    pdkToggle = gameObject.transform:Find('Plays/pdk')

    nextButton = gameObject.transform:Find('nextBottun')
    closeButton = gameObject.transform:Find('BaseContent/ButtonClose')

    message:AddClick(zpToggle.gameObject, this.OnPlaySound)
    message:AddClick(mjToggle.gameObject, this.OnPlaySound)
    message:AddClick(pdkToggle.gameObject, this.OnPlaySound)

    message:AddClick(closeButton.gameObject, function (go)
        PanelManager.Instance:HideWindow(gameObject.name)
    end)
	
    zpGridTrans = gameObject.transform:Find('Toggles/zp/scrollView/zpGrid');
    for i=0, zpGridTrans.transform.childCount - 1 do
        local obj = zpGridTrans.transform:GetChild(i)
		message:AddClick(obj.gameObject, this.OnClickNext)
    end
    runfastTrans = gameObject.transform:Find('Toggles/pk/scrollView/runfast');
    for i = 0,runfastTrans.transform.childCount - 1 do
        local obj = runfastTrans.transform:GetChild(i)
		message:AddClick(obj.gameObject, this.onRunFastItemClick)
    end
    mjGridTrans = gameObject.transform:Find('Toggles/mj/scrollView/mjGrid');
    for i = 0,mjGridTrans.transform.childCount - 1 do
        local obj = mjGridTrans.transform:GetChild(i)
		message:AddClick(obj.gameObject, this.onMJItemClick)
    end
end

function this.Update()
   
end
function this.Start()

end

function this.WhoShow(data)

    this.clubInfo = data;
    this.SetGameShowOrHide()
end

function this.OnClickNext(go)
    AudioManager.Instance:PlayAudio('btn')
    curSelctPlay = this.getPlayName(zpGridTrans) 
    local data = {}
    data.name = curSelctPlay
    data.optionData = {}
    data.optionData.addPlay = true
    data.optionData.addRule = false
    data.roomType = playType[curSelctPlay]
    data.gameType = this.getGameType()
    PanelManager.Instance:HideWindow(gameObject.name)
    print('现在选择的：'..curSelctPlay..' data.gameType : '..data.gameType)
	PanelManager.Instance:ShowWindow('panelSetModify', data)
end

function this.onRunFastItemClick(go)
    print("onRunFastItemClick was called")
    AudioManager.Instance:PlayAudio('btn')
    curSelctPlay = this.getPlayName(runfastTrans)
    local data              = {}
    data.optionData         = {}
    data.optionData.addPlay = true
    data.optionData.addRule = false
    data.name               = curSelctPlay
    data.roomType           = playType[curSelctPlay]
    data.gameType           = this.getGameType()
    data.clubInfo           = this.clubInfo
    PanelManager.Instance:HideWindow(gameObject.name)
    if playType[curSelctPlay] == proxy_pb.PDKSWZ or playType[curSelctPlay] == proxy_pb.PDKSLZ then
        PanelManager.Instance:ShowWindow('panelCreatePDKSet', data)
    elseif playType[curSelctPlay] == proxy_pb.PKXHZD then
        PanelManager.Instance:ShowWindow('panelCreateXHZDSet', data)
    elseif playType[curSelctPlay] == proxy_pb.PKDTZ then
        PanelManager.Instance:ShowWindow('panelCreateDTZSet', data)
    elseif playType[curSelctPlay] == proxy_pb.PKBBTZ then
        PanelManager.Instance:ShowWindow('panelCreateBBTZSet', data)
    elseif playType[curSelctPlay] == proxy_pb.PKYJQF then
        PanelManager.Instance:ShowWindow('panelCreateYJQFSet', data)
    elseif playType[curSelctPlay] == proxy_pb.PKHSTH then
        PanelManager.Instance:ShowWindow('panelCreateHSTHSet', data)
    end
end

function this.onMJItemClick(go) --点击了 麻将 Item项
    AudioManager.Instance:PlayAudio('btn')
    curSelctPlay = this.getPlayName(mjGridTrans)
    local data              = {};
    data.optionData         = {};
    data.optionData.addPlay = true;
    data.optionData.addRule = false;
    data.name               = curSelctPlay;
    data.roomType           = playType[curSelctPlay];
    data.gameType           = this.getGameType();
    data.clubInfo           = this.clubInfo;
    PanelManager.Instance:HideWindow(gameObject.name);
    if data.gameType == proxy_pb.MJ then 
        PanelManager.Instance:ShowWindow('panelCreateMJSet', data)
    elseif data.gameType == proxy_pb.XPLP then 
        PanelManager.Instance:ShowWindow('panelCreateXPLPSet', data)
    elseif data.gameType == proxy_pb.HNM and data.roomType == proxy_pb.HNHSM then 
        PanelManager.Instance:ShowWindow('panelCreateHNHSMSet', data)
    elseif data.gameType == proxy_pb.HNM and data.roomType == proxy_pb.HNZZM then 
        PanelManager.Instance:ShowWindow('panelCreateHNZZMSet', data)
    elseif data.gameType == proxy_pb.DZM and data.roomType == proxy_pb.DZAHM then 
        PanelManager.Instance:ShowWindow('panelCreateDZAHMSet', data)
    end
end


function this.getGameType()
    local gameType = proxy_pb.PHZ
    if zpToggle:GetComponent("UIToggle").value then
        gameType = proxy_pb.PHZ
    elseif mjToggle:GetComponent("UIToggle").value then
        if playType[curSelctPlay] == proxy_pb.XPLPM then 
            gameType = proxy_pb.XPLP;
        elseif playType[curSelctPlay] == proxy_pb.CSM or  playType[curSelctPlay] == proxy_pb.ZZM or  playType[curSelctPlay] == proxy_pb.HZM then 
            gameType = proxy_pb.MJ; 
        elseif playType[curSelctPlay] == proxy_pb.HSM or playType[curSelctPlay] == proxy_pb.WLCBM then 
            gameType = proxy_pb.NMM;
        elseif playType[curSelctPlay] == proxy_pb.HNHSM or playType[curSelctPlay] == proxy_pb.HNZZM then 
            gameType = proxy_pb.HNM;
        elseif playType[curSelctPlay] == proxy_pb.DZAHM then
            gameType = proxy_pb.DZM;
        end
    elseif pdkToggle:GetComponent("UIToggle").value then
        if playType[curSelctPlay] == proxy_pb.PKXHZD then
            gameType = proxy_pb.XHZD
        elseif playType[curSelctPlay] == proxy_pb.PKDTZ then
            gameType = proxy_pb.DTZ
        elseif playType[curSelctPlay] == proxy_pb.PDKSWZ or playType[curSelctPlay] == proxy_pb.PDKSLZ then
            gameType = proxy_pb.PDK
        elseif playType[curSelctPlay] == proxy_pb.PKBBTZ then
            gameType = proxy_pb.BBTZ
        elseif playType[curSelctPlay] == proxy_pb.PKYJQF then
            gameType = proxy_pb.YJQF
        elseif playType[curSelctPlay] == proxy_pb.PKHSTH then
            gameType = proxy_pb.HSTH
        end
    end
    return gameType
end

function this.getPlayName(playGrid)
    for i=0,playGrid.transform.childCount - 1 do
        if playGrid.transform:GetChild(i):GetComponent("UIToggle").value then 
            return playGrid.transform:GetChild(i):Find('Label'):GetComponent('UILabel').text
        end
    end
end

function this.OnPlaySound(go)
    AudioManager.Instance:PlayAudio('btn')
end

