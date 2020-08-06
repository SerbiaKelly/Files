panelSelectTime = {}
local this = panelSelectTime;

local message
local gameObject

local ButtonStartTime
local ButtonEndTime
local selectTime
local selectTimeText
local selectTimeGrid
local selectTimeItem
local selectTimeMask

local listTimeItem={}

local nowtimeChuo = os.time()
local nowtime = os.date('%Y/%m/%d', nowtimeChuo)

local ButtonClose
local ButtonSure

local inputStartTimeHour
local inputStartTimeMin
local inputEndTimeHour
local inputEndTimeMin

local selectTimeHour
local selectTimeHourItem
local selectTimeHourScrollView
local selectTimeHourGrid
local selectTimeHourMask
local tishi
local selectTimeBtn
local startTime--开始时间
local endTime--结束时间
function this.Update()
   
end

--���¼�--
function this.Awake(obj)
	gameObject = obj;
	message = gameObject:GetComponent('LuaBehaviour');
	ButtonClose = gameObject.transform:Find('BaseContent/ButtonClose');
	message:AddClick(ButtonClose.gameObject, this.OnClickClose);
	
	ButtonSure = gameObject.transform:Find('ButtonSure');
	message:AddClick(ButtonSure.gameObject, this.OnClickSure);
    selectTimeBtn = gameObject.transform:Find('selectTimeBtn');
    ButtonStartTime = selectTimeBtn.transform:Find('ButtonStartTime');
    ButtonStartTime:Find('Label'):GetComponent('UILabel').text = nowtime
    ButtonEndTime = selectTimeBtn.transform:Find('ButtonEndTime');
    ButtonEndTime:Find('Label'):GetComponent('UILabel').text = nowtime
    selectTime = gameObject.transform:Find('selecTime');
    selectTimeText = selectTime:Find('Label');
    selectTimeGrid = selectTime:Find('TimeGrid');
    selectTimeItem = selectTime:Find('item');
    selectTimeMask = selectTime.transform:Find('mask');
    inputStartTimeMin = selectTimeBtn.transform:Find('StartTimeMinAndSecond/inputStartTimeMin')
    inputStartTimeHour = selectTimeBtn.transform:Find('StartTimeMinAndSecond/inputStartTimeHour')
    inputEndTimeMin = selectTimeBtn.transform:Find('EndTimeMinAndSecond/inputEndTimeMin')
    inputEndTimeHour = selectTimeBtn.transform:Find('EndTimeMinAndSecond/inputEndTimeHour')
    tishi = gameObject.transform:Find('tishi')
    selectTimeHour = gameObject.transform:Find('selecTimeHour')
    selectTimeHourItem = selectTimeHour:Find('itemTime')
    selectTimeHourScrollView = selectTimeHour:Find('TimeScrollView')
    selectTimeHourGrid = selectTimeHourScrollView:Find('grid')
    selectTimeHourMask = selectTimeHour:Find('mask')
    message:AddClick(selectTimeHourMask.gameObject, function (go)
        AudioManager.Instance:PlayAudio('btn')
        selectTimeHour.gameObject:SetActive(false)
    end)

    message:AddClick(inputStartTimeHour.gameObject, this.OnClickTimeHour)
    message:AddClick(inputEndTimeHour.gameObject, this.OnClickTimeHour)

    message:AddClick(ButtonStartTime.gameObject, this.OnClickStartTime)
    message:AddClick(ButtonEndTime.gameObject, this.OnClickEndTime)
    message:AddClick(selectTimeMask.gameObject, this.OnClickTimeMask)
end

function this.OnClickClose(go)
	AudioManager.Instance:PlayAudio('btn')
    
    PanelManager.Instance:HideWindow(gameObject.name)
end

function this.OnClickTimeMask(go)
    AudioManager.Instance:PlayAudio('btn')
    selectTime.gameObject:SetActive(false)
end

function this.OnClickStartTime(go)
    AudioManager.Instance:PlayAudio('btn')
    Util.ClearChild(selectTimeGrid)
    for i=#listTimeItem,1,-1 do
        table.remove(listTimeItem,i)
    end
    selectTime.gameObject:SetActive(true)
    selectTimeText:GetComponent('UILabel').text = '选择开始时间'
    for i=1,8 do
        local item = {}
        item.GO = NGUITools.AddChild(selectTimeGrid.gameObject, selectTimeItem.gameObject)
        item.GO:SetActive(true)
        item.GO.name = 'item'..i
        item.timeChou = nowtimeChuo-86400*(i-1)
        local timeToggle = item.GO.transform:Find('ButtonTime'):GetComponent('UIToggle')
        message:AddClick(item.GO.transform:Find('ButtonTime'):GetComponent('UIButton').gameObject, this.ButtonSound);
        if ButtonStartTime:Find('Label'):GetComponent('UILabel').text==os.date('%Y/%m/%d', item.timeChou) then
            timeToggle.value=true
        else
            timeToggle.value=false
        end
        item.GO.transform:Find('ButtonTime/Label'):GetComponent('UILabel').text = os.date('%Y/%m/%d', item.timeChou)
        listTimeItem[i]=item
    end
    selectTimeGrid:GetComponent('UIGrid'):Reposition()
end

function this.OnClickEndTime(go)
    AudioManager.Instance:PlayAudio('btn')
    Util.ClearChild(selectTimeGrid)
    for i=#listTimeItem,1,-1 do
        table.remove(listTimeItem,i)
    end
    selectTime.gameObject:SetActive(true)
    selectTimeText:GetComponent('UILabel').text = '选择结束时间'
    local needMoRen=false
    for i=1,8 do
        local item = {}
        item.GO = NGUITools.AddChild(selectTimeGrid.gameObject, selectTimeItem.gameObject)
        
        item.GO.name = 'item'..i
        item.timeChou = nowtimeChuo-86400*(i-1)
        local timeToggle = item.GO.transform:Find('ButtonTime'):GetComponent('UIToggle')
        message:AddClick(item.GO.transform:Find('ButtonTime'):GetComponent('UIButton').gameObject, this.ButtonSound);
        if ButtonStartTime:Find('Label'):GetComponent('UILabel').text>os.date('%Y/%m/%d', item.timeChou) then
            item.GO:SetActive(false)
            timeToggle.value=false
            if ButtonEndTime:Find('Label'):GetComponent('UILabel').text==os.date('%Y/%m/%d', item.timeChou) then
                needMoRen=true
            end
        else
            item.GO:SetActive(true)
            if ButtonEndTime:Find('Label'):GetComponent('UILabel').text==os.date('%Y/%m/%d', item.timeChou) then
                timeToggle.value=true
            else
                timeToggle.value=false
            end
        end
        
        item.GO.transform:Find('ButtonTime/Label'):GetComponent('UILabel').text = os.date('%Y/%m/%d', item.timeChou)
        listTimeItem[i]=item
    end
    if needMoRen then
        selectTimeGrid:Find('item1/ButtonTime'):GetComponent('UIToggle'):Set(true)
    end
    selectTimeGrid:GetComponent('UIGrid'):Reposition()
end

function this.ButtonSound(go)
	AudioManager.Instance:PlayAudio('btn')
	selectTime.gameObject:SetActive(false)
    for i=1,#listTimeItem do
        if listTimeItem[i].GO.transform:Find('ButtonTime'):GetComponent('UIToggle').value then
            if selectTimeText:GetComponent('UILabel').text == '选择开始时间' then
                ButtonStartTime:Find('Label'):GetComponent('UILabel').text = os.date('%Y/%m/%d', listTimeItem[i].timeChou)
                break
            else
                ButtonEndTime:Find('Label'):GetComponent('UILabel').text = os.date('%Y/%m/%d', listTimeItem[i].timeChou)
                break
            end
        end
    end
end

local whoShow
function this.WhoShow(data)
    whoShow=data
    ButtonStartTime.localPosition = whoShow=='panelRank' and Vector3(-293,-17,0) or Vector3(-225,-17,0)
    ButtonEndTime.localPosition = whoShow=='panelRank' and Vector3(156,-15,0) or Vector3(220,-15,0)
    inputStartTimeHour:GetComponent('UILabel').text = whoShow=='panelRank' and (UnityEngine.PlayerPrefs.GetString('inputStartTimeHour', '00')..'点') or '00'
    inputStartTimeMin:GetComponent('UILabel').text = '00'
    inputEndTimeHour:GetComponent('UILabel').text = whoShow=='panelRank' and (UnityEngine.PlayerPrefs.GetString('inputEndTimeHour', '23')..'点') or '23'
    inputEndTimeMin:GetComponent('UILabel').text = whoShow=='panelRank' and '00' or '59'
    inputStartTimeHour.gameObject:SetActive(whoShow=='panelRank')
    inputEndTimeHour.gameObject:SetActive(whoShow=='panelRank')
    selectTimeHour.gameObject:SetActive(false)
    selectTimeBtn.localPosition = whoShow=='panelRank' and Vector3(0,135,0) or Vector3(0,0,0)
    tishi.gameObject:SetActive((whoShow=='panelRank'))
end

function this.OnClickSure(go)
	AudioManager.Instance:PlayAudio('btn')
    local st= ButtonStartTime:Find('Label'):GetComponent('UILabel').text
    local ed= ButtonEndTime:Find('Label'):GetComponent('UILabel').text
    local startHour = tonumber(string.match(inputStartTimeHour:GetComponent('UILabel').text,"%d+"))
    local startMin = tonumber(string.match(inputStartTimeMin:GetComponent('UILabel').text,"%d+"))
    local endHour = tonumber(string.match(inputEndTimeHour:GetComponent('UILabel').text,"%d+")) 
    local endMin = tonumber(string.match(inputEndTimeMin:GetComponent('UILabel').text,"%d+")) 
    
    startTime = os.time({year=string.sub (st, 1,4),month=string.sub (st, 6,7),day=string.sub (st, 9,10),hour=startHour,min=startMin});
	endTime = os.time({year=string.sub (ed, 1,4),month=string.sub (ed, 6,7),day=string.sub (ed, 9,10),hour=endHour,min=endMin});
	if startTime ~= endTime then 
		endTime = endTime - 60
	else
		endTime = endTime + 59*60
	end
	print('开始时间 : '..os.date('%Y-%m-%d,%H:%M', startTime)..' 结束时间 : '..os.date('%Y-%m-%d,%H:%M', endTime))
    UnityEngine.PlayerPrefs.SetString('inputStartTimeHour', string.match(inputStartTimeHour:GetComponent('UILabel').text,"%d+"))
    UnityEngine.PlayerPrefs.SetString('inputEndTimeHour', string.match(inputEndTimeHour:GetComponent('UILabel').text,"%d+"))
	PanelManager.Instance:HideWindow(gameObject.name)

	if whoShow=='panelMenberRecord' then
		panelMenberRecord.onSelectTime(startTime,endTime)
	elseif whoShow=='panelRoomRecord' then
		panelRoomRecord.onSelectTime(startTime,endTime)
	elseif whoShow == 'panelMenber+Menber' then
		panelMenber.onSelectTime(startTime,endTime)
	elseif whoShow == 'panelMenber+Manager' then
		panelMenber.onSelectTime(startTime,endTime)
	elseif whoShow == 'panelSelMenber' then
        panelSelMenber.onSelectTime(startTime,endTime)
    elseif whoShow == 'panelMatchFeeBillRecord' then
        panelMatchFeeBillRecord.onSelectTime(startTime, endTime)
    elseif whoShow == 'panelRecord' then
        panelRecord.onSelectTime(startTime, endTime)
    elseif whoShow == 'panelRank' then
        panelRank.onSelectTime(startTime, endTime)
	end    
end

function this.Start()
end

function this.OnEnable()
   
end

local isStartTimeHour = false
function this.OnClickTimeHour(go)
    AudioManager.Instance:PlayAudio('btn')
    selectTimeHour.gameObject:SetActive(true)
    if inputStartTimeHour.gameObject == go then
        isStartTimeHour = true
        selectTimeHour.localPosition = Vector3(40,0,0)
    else
        isStartTimeHour = false
        selectTimeHour.localPosition = Vector3(185,0,0)
    end
    this.InitSelectTimeHour()
end

function this.InitSelectTimeHour()
    local num = 0
    local st= ButtonStartTime:Find('Label'):GetComponent('UILabel').text
    local ed= ButtonEndTime:Find('Label'):GetComponent('UILabel').text
    local numStart = tonumber(UnityEngine.PlayerPrefs.GetString('inputStartTimeHour', '00'))
    local numEnd = tonumber(UnityEngine.PlayerPrefs.GetString('inputEndTimeHour', '23'))
    for i = 0, 23 do
        if selectTimeHourGrid.childCount<24 then
            local obj = {}
            obj = NGUITools.AddChild(selectTimeHourGrid.gameObject, selectTimeHourItem.gameObject)
            message:AddClick(obj.gameObject, this.OnClickSelectTimeHour)
            obj.gameObject:SetActive(true)
            local str=''
            if i>9 then
                str=i
            else
                str='0'..i
            end
            obj.name = str
            obj.transform:Find('Label'):GetComponent('UILabel').text = str..'点' 
            obj.transform:GetComponent('UIToggle'):Set(false)
        end
    end
    if isStartTimeHour then
        num = numStart
        for i = 0,23 do
            selectTimeHourGrid.transform:GetChild(i).gameObject:SetActive(true)
        end
    else
        if st == ed then
            num = (numStart > numEnd) and numStart or numEnd
            for i = numStart-1,0,-1 do
                selectTimeHourGrid.transform:GetChild(i).gameObject:SetActive(false)
            end
        else
            num = numEnd 
			for i = 0,23 do
				selectTimeHourGrid.transform:GetChild(i).gameObject:SetActive(true)
			end
        end
    end
    selectTimeHourGrid.transform:GetChild(num):GetComponent('UIToggle'):Set(true)
    selectTimeHourGrid:GetComponent('UIGrid'):Reposition()
    selectTimeHourScrollView:GetComponent('UIScrollView'):ResetPosition()
end
function this.OnClickSelectTimeHour(go)
    AudioManager.Instance:PlayAudio('btn')
    selectTimeHour.gameObject:SetActive(false)
    if isStartTimeHour then
        inputStartTimeHour:GetComponent('UILabel').text = go.name..'点'
        UnityEngine.PlayerPrefs.SetString('inputStartTimeHour',go.name)
		local st= ButtonStartTime:Find('Label'):GetComponent('UILabel').text
		local ed= ButtonEndTime:Find('Label'):GetComponent('UILabel').text
		local numStart = tonumber(UnityEngine.PlayerPrefs.GetString('inputStartTimeHour', '00'))
		local numEnd = tonumber(UnityEngine.PlayerPrefs.GetString('inputEndTimeHour', '23'))
		if tonumber(string.sub (st, 9,10)) == tonumber(string.sub (ed, 9,10)) then
			if numStart > numEnd then 
				inputEndTimeHour:GetComponent('UILabel').text = go.name..'点'
				UnityEngine.PlayerPrefs.SetString('inputEndTimeHour',go.name)
			end
        end
    else
        inputEndTimeHour:GetComponent('UILabel').text = go.name..'点'
        UnityEngine.PlayerPrefs.SetString('inputEndTimeHour',go.name)
    end
end