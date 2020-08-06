local proxy_pb = require 'proxy_pb'

panelFeeBillRecord = {}

local this=panelFeeBillRecord
local RecordList={}
local message;
local gameObject;
local mask
local Grid
local ScrollView
local prefabItem
local buttonClose
local tip

local page=1--页数 从1开始
local pageSize=20--每页个数

local ButtonSure
local ButtonClear

local lastFeeNum
local billNum
local billNumLabel

local FindButton

local showData

local GOLabel
--启动事件--
function this.Awake(obj)
    gameObject = obj;
	message = gameObject:GetComponent('LuaBehaviour');


    mask = gameObject.transform:Find('mask');
    ScrollView = gameObject.transform:Find('recordList/Scroll View');
    Grid = gameObject.transform:Find('recordList/Scroll View/Grid');
	buttonClose = gameObject.transform:Find('ButtonClose');
	message:AddClick(buttonClose.gameObject, this.OnClickMask);
	tip = gameObject.transform:Find('tip');
    prefabItem = gameObject.transform:Find('recordList/item');
    
    ButtonSure = gameObject.transform:Find('recordList/ButtonSure');
    ButtonClear = gameObject.transform:Find('recordList/ButtonClear');

    lastFeeNum = gameObject.transform:Find('recordList/lastFeeNum/Label');
    billNum=gameObject.transform:Find('recordList/billNum');
    message:AddClick(billNum.gameObject, this.OnClickNum);
    billNumLabel = gameObject.transform:Find('recordList/billNum/Label');

    FindButton = gameObject.transform:Find('recordList/FindButton')

    message:AddClick(ButtonSure.gameObject, this.OnClickSure);
    message:AddClick(ButtonClear.gameObject, this.OnClickClear);
    message:AddClick(FindButton.gameObject,  this.OnClickFindLord)

    ScrollView:GetComponent('UIScrollView').onMomentumMove = this.OnScroll

end

function this.OnClickNum(go)
    print('jinjjjjjj')
    --PanelManager.Instance:ShowWindow('keyborad', gameObject.name)
end
--[[
    @desc: 键盘的回调
    author:{author}
    time:2018-11-21 16:51:06
    --@strNum: 输入的数字
    @return:
]]
function this.setSearchInput(strNum)
    print('输入了'..strNum)
    if strNum~='' then
        billNumLabel:GetComponent('UILabel').text=strNum
    else
        billNumLabel:GetComponent('UILabel').text='请输入数量'
    end
    
end
local operatType
function this.OnClickSure(go)
    operatType='疲劳值扣除'
    AudioManager.Instance:PlayAudio('btn')
    local num=billNumLabel:GetComponent('UILabel').text
    if num=='请输入数量' then
        panelMessageTip.SetParamers('请输入数量', 1)
		PanelManager.Instance:ShowWindow('panelMessageTip')
    elseif num=='0' or num=='0.00' then
        panelMessageTip.SetParamers('请输入大于0的数量', 1)
		PanelManager.Instance:ShowWindow('panelMessageTip')
    else
        this.feeDelete(num,showData.userId)
    end
end

--疲劳值扣除
function this.feeDelete(amount,userId)
    
    local msg = Message.New()
    msg.type = proxy_pb.FEE_DEDUCT;
    local body = proxy_pb.PFeeDeduct();
    body.clubId = panelClub.clubInfo.clubId;
    body.userId = userId;
    body.amount = tostring(amount);
    msg.body = body:SerializeToString()
    panelMessageBoxTiShi.SetParamers(OK_CANCLE, function ()
        SendProxyMessage(msg, this.operationResult) 
    end, nil, '是否确定扣除玩家\"'..showData.nickname..'\"'..amount..'分疲劳值？')
    PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
end

--操作结果
function this.operationResult(msg)
    local b = proxy_pb.RResult();
    b:ParseFromString(msg.body);
    if b.code==1 then
        if operatType=='疲劳值清零' then
            lastFeeNum:GetComponent('UILabel').text='0.00'
        elseif operatType=='疲劳值扣除' then
            lastFeeNum:GetComponent('UILabel').text=lastFeeNum:GetComponent('UILabel').text-billNumLabel:GetComponent('UILabel').text
        end

        if panelMenberRecord ~= nil and PanelManager.Instance:IsActive('panelMenberRecord')then
            panelMenberRecord.initAll()
            panelMenberRecord.GetDatas()
        end

        if panelMenber ~= nil and PanelManager.Instance:IsActive('panelMenber') then
            panelMenber.Refresh()
        end

        if panelMenberManager ~= nil and PanelManager.Instance:IsActive('panelMenberManager')  then
            panelMenberManager.RefreshFee()
        end

        --GOLabel.transform:GetComponent('UILabel').text=string.format('%.2f', lastFeeNum:GetComponent('UILabel').text)
		panelMessageTip.SetParamers(operatType..'成功', 1.5)
        PanelManager.Instance:ShowWindow('panelMessageTip')
        this.initAll()
        this.feeBillRecord()
	else
		panelMessageTip.SetParamers(operatType..'失败'..b.msg, 1.5)
		PanelManager.Instance:ShowWindow('panelMessageTip')
	end
end

function this.OnClickClear(go)
    operatType='疲劳值清零'
    AudioManager.Instance:PlayAudio('btn')
    local lastFeeNumStr=lastFeeNum:GetComponent('UILabel').text
    if lastFeeNumStr~='' then
        local num=tonumber(lastFeeNumStr)
        if num==0 then
            panelMessageTip.SetParamers('当前剩余疲劳值为0', 1)
            PanelManager.Instance:ShowWindow('panelMessageTip')
        else
            this.feeDelete(num,showData.userId)
        end
    end
end


local isNotDownload=true
local isFinish=false
function this.OnScroll()
    if isNotDownload==true and isFinish==false and ScrollView:GetComponent('SpringPanel')~=nil then
        print('到底了')
        UnityEngine.Object.Destroy(ScrollView:GetComponent('SpringPanel'))
        this.feeBillRecord()
    end
end

--初始化所有
function this.initAll()
    this.initData()
    this.initGrid()
    --billNumLabel:GetComponent('UILabel').text='请输入数量'
    billNum.transform:GetComponent('UIInput').value = '请输入数量'
    -- body
end
--初始化滑动界面
function this.initGrid()
    Util.ClearChild(Grid)
    ScrollView.localPosition=Vector3(0,6.7,0)
    ScrollView:GetComponent('UIPanel').clipOffset=Vector2(0,-6)
    Grid:GetComponent('UIGrid'):Reposition()
end
--初始化数据
function this.initData()
    isFinish=false
    page=1
    --isNotDownload=true
end


function this.Update()
   
end
function this.Start()

end

function this.OnEnable()
    print('enable')
end

function this.OnClickFindLord(go)
    
end

--单击事件--
function this.OnClickMask(go)
    PanelManager.Instance:HideWindow(gameObject.name)
end

--扣除记录
function this.feeBillRecord()
    if isNotDownload==false then
        return
    end
    isNotDownload=false
    PanelManager.Instance:ShowWindow('panelNetWaitting')
    local msg = Message.New()
    msg.type = proxy_pb.FEE_DEDUCT_RECORD;
    local body = proxy_pb.PClubUserFeeBill();
    body.clubId = panelClub.clubInfo.clubId;
    body.type = '2001';   -- 1000: "下级玩家贡献" 1001, "玩家自己贡献给自己" 2001: "管理员扣减" 2002: "群主结算"       疲劳值结算和申请记录都是2002     扣除记录是2001
    body.page=tostring(page)
    body.pageSize=tostring(pageSize)
    print('userid'..showData.userId)
    body.userId=showData.userId
    msg.body = body:SerializeToString()
    SendProxyMessage(msg, this.OnGetRecord)
end

--获取到的结算列表
function this.OnGetRecord(msg)
    local b = proxy_pb.RClubUserFeeBillList()
    b:ParseFromString(msg.body);
    RecordList = b
    this.Refresh()
end

function this.Refresh()
    tip.gameObject:SetActive(false)
    if page==1 then
        if #RecordList.datas == 0 then
            tip:GetComponent('UILabel').text='当前还没有记录'
            tip.gameObject:SetActive(true)
        end
    elseif #RecordList.datas == 0 then
        panelMessageTip.SetParamers('没有更多了', 1)
        PanelManager.Instance:ShowWindow('panelMessageTip')
        isFinish=true
    end
    
    
    print('数据条数'..#RecordList.datas)
    local nowNum=Grid.childCount
    if page==1 then
        if RecordList.balanceTotal~=nil and RecordList.balanceTotal~='' then
            lastFeeNum:GetComponent('UILabel').text=RecordList.balanceTotal
        else
            lastFeeNum:GetComponent('UILabel').text='0.00'
        end
    end
    

	for i=1,#RecordList.datas do
        local userGO = {}
        userGO.GO = NGUITools.AddChild(Grid.gameObject, prefabItem.gameObject)
        userGO.GO.transform.localPosition = Vector3(0, -(i+nowNum)*Grid:GetComponent('UIGrid').cellHeight, 0)
        SetUserData(userGO.GO, RecordList.datas[i])
        
        userGO.GO.transform:Find('time'):GetComponent('UILabel').text=os.date('%Y.%m.%d\n%H:%M', RecordList.datas[i].createTime)--RecordList.datas[i].time
        local player=userGO.GO.transform:Find('playerName1')
        player:GetComponent('UILabel').text = RecordList.datas[i].nickname
        player:Find('ID'):GetComponent('UILabel').text = 'ID:'..RecordList.datas[i].userId
        coroutine.start(LoadPlayerIcon, player:Find('TX'):GetComponent('UITexture'), RecordList.datas[i].icon)
        userGO.GO.transform:Find('Num'):GetComponent('UILabel').text = RecordList.datas[i].amount
        userGO.GO.transform:Find('mark'):GetComponent('UILabel').text = RecordList.datas[i].remark


        userGO.GO:SetActive(true)
    end

    Grid:GetComponent('UIGrid'):Reposition()
    if page==1 then
        ScrollView:GetComponent('UIScrollView'):ResetPosition()
        if #RecordList.datas ~= 0 then
            showData.nickname = RecordList.datas[1].nickname 
        end
    end
    print('当前页数'..page)
    page=RecordList.page
    print('下一页'..page)
    PanelManager.Instance:HideWindow('panelNetWaitting')
    isNotDownload=true
    
end


function this.WhoShow(data)
    showData=data.data
    GOLabel=data.GO
    this.initAll()
    this.feeBillRecord()

    local isShow = data.ShowName == 'panelClubCard';
    billNum.gameObject:SetActive(not isShow);
    ButtonSure.gameObject:SetActive(not isShow);
    ButtonClear.gameObject:SetActive(not isShow);
    --FindButton.gameObject:SetActive(isShow);
end