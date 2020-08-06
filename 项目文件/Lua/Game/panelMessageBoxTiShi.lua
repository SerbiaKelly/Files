panelMessageBoxTiShi = {}
local this = panelMessageBoxTiShi;
local message;
local gameObject;
 
local mask
local labelMessage
local buttonOK
local buttonCancle
local buttonClose
local title1
local title2
local timeLabel

-- messageBoxTime=5
-- messageBoxNeedTime=false--是否需要显示倒计时
-- messageBoxTimeCoroutine=nil

-- ONLY_OK = 1
-- OK_CANCLE = 2
-- ONLY_OK_CANCLE =3
--启动事件--牌友群设置
function this.Awake(obj)
	gameObject = obj;
    title1 =gameObject.transform:Find('bg/Sprite/Label1')
    title2 =gameObject.transform:Find('bg/Sprite/Label2')

    mask = gameObject.transform:Find('mask');
    buttonOK = gameObject.transform:Find('ButtonOK');
    buttonCancle = gameObject.transform:Find('ButtonCancel');
    labelMessage = gameObject.transform:Find('message');
    buttonClose = gameObject.transform:Find('ButtonClose');
    timeLabel = buttonOK:Find('time'):GetComponent('UILabel');

	message = gameObject:GetComponent('LuaBehaviour');
    --message:AddClick(mask.gameObject, this.OnClickMask);
    message:AddClick(buttonOK.gameObject, this.OnClicButtonOK);
    message:AddClick(buttonCancle.gameObject, this.OnClickButtonCancle);
    message:AddClick(buttonClose.gameObject, this.OnClickButtonClose);
end

function this.Start()
end

function this.OnEnable()
    if btype == ONLY_OK then
        buttonOK.localPosition = Vector3.New(0, buttonOK.localPosition.y, -10)
        buttonCancle.gameObject:SetActive(false)
		gameObject.transform:Find('ButtonOK/Label'):GetComponent('UILabel').text = ok_name
    elseif btype == OK_CANCLE then
        buttonOK.localPosition = Vector3.New(150, buttonOK.localPosition.y,-10)
        buttonCancle.localPosition = Vector3.New(-150, buttonOK.localPosition.y, -10)
        buttonCancle.gameObject:SetActive(true)
		gameObject.transform:Find('ButtonCancel/Label'):GetComponent('UILabel').text = cancle_name
        gameObject.transform:Find('ButtonOK/Label'):GetComponent('UILabel').text = ok_name
    elseif btype == ONLY_OK_CANCLE then
        buttonOK.localPosition = Vector3.New(-150, buttonOK.localPosition.y,-10)
        buttonCancle.localPosition = Vector3.New(150, buttonOK.localPosition.y, -10)
        buttonCancle.gameObject:SetActive(true)
		gameObject.transform:Find('ButtonCancel/Label'):GetComponent('UILabel').text = cancle_name
		gameObject.transform:Find('ButtonOK/Label'):GetComponent('UILabel').text = ok_name
    end

    if spacingY then
        labelMessage:GetComponent('UILabel').spacingY = spacingY
    else
        labelMessage:GetComponent('UILabel').spacingY = 0
    end

	if msg then
		labelMessage:GetComponent('UILabel').text = msg
	else
		labelMessage:GetComponent('UILabel').text = ''
    end

    if  HideClose==nil then
        buttonClose.gameObject:SetActive(true);
    else
        buttonClose.gameObject:SetActive(HideClose);
    end
    
    if messageBoxNeedTime==true then
        messageBoxTimeCoroutine=coroutine.start(this.DaoJiShi)
    end
end

function this.initTime()
    if messageBoxTimeCoroutine then
        coroutine.stop(messageBoxTimeCoroutine)
    end
    messageBoxTime=3
    messageBoxNeedTime=false
end

function this.DaoJiShi()
    buttonOK:GetComponent('UIButton').isEnabled=false
    for i=messageBoxTime,0,-1 do
        timeLabel.gameObject:SetActive(true)
        timeLabel.text='('..i..')'
        coroutine.wait(1)
    end
    this.initTime()
    buttonOK:GetComponent('UIButton').isEnabled=true
    timeLabel.gameObject:SetActive(false)
end

--单击事件--
function this.OnClickMask(go)
    this.initTime()
    buttonOK:GetComponent('UIButton').isEnabled=true
    timeLabel.gameObject:SetActive(false)
    PanelManager.Instance:HideWindow(gameObject.name)
end

function this.SetParamers(tbtype, tokCall, tcancleCall, tmessage, okName, cancleName, tspacingY, closeCall,hideClose)
	btype = tbtype
    okCallTiShi = tokCall
	cancleCall = tcancleCall
	msg = tmessage
	ok_name = okName ~= nil and okName or '确 定'
    cancle_name = cancleName ~= nil and cancleName or '取 消'

    spacingY = tspacingY

    CloseCall = closeCall

    HideClose = hideClose;
    
    -- if msg=='是否确定放弃胡牌？' then
    --     this.initTime()
    --     messageBoxNeedTime=true
    -- end
end

function this.Update()
   
end
function this.OnClicButtonOK(go)
	AudioManager.Instance:PlayAudio('btn')
    this.OnClickMask(go)
    if okCallTiShi then
        okCallTiShi(go)
    else
        print('okCall为空')
    end
end

function this.OnClickButtonCancle(go)
	AudioManager.Instance:PlayAudio('btn')
    this.OnClickMask(go)
    if cancleCall then
        cancleCall(go)
    end
end

function this.OnClickButtonClose(go)
	AudioManager.Instance:PlayAudio('btn')
    this.OnClickMask(go)
    -- if cancleCall then
    --     cancleCall(go)
    -- end
    if CloseCall then
        CloseCall()
    else
        print('close为空')
    end
end

function this.VirtualOKClick()
    coroutine.start(function()
        coroutine.wait(1)
        local sp = buttonOK:Find('Background'):GetComponent('UISprite')
        sp.color=Color(183/255,163/255,123/255)
        buttonOK:GetComponent('TweenScale'):ResetToBeginning()
        buttonOK:GetComponent('TweenScale').from = Vector3.one
        buttonOK:GetComponent('TweenScale').to = Vector3(1.05,1.05,1.05)
        buttonOK:GetComponent('TweenScale').duration = 0.2
        buttonOK:GetComponent('TweenScale'):PlayForward()
        coroutine.wait(0.2)
        sp.color=Color.white
        buttonOK:GetComponent('TweenScale'):ResetToBeginning()
        buttonOK:GetComponent('TweenScale').from = Vector3(1.05,1.05,1.05)
        buttonOK:GetComponent('TweenScale').to = Vector3.one
        buttonOK:GetComponent('TweenScale').duration = 0.2
        buttonOK:GetComponent('TweenScale'):PlayForward()
        coroutine.wait(0.2)
        this.OnClickMask()
    end)
end

-- function this.setTitle(str)
--     title1:GetComponent('UILabel').text = str
--     title2:GetComponent('UILabel').text = str

-- end

-- function this.WhoShow(data)
--     if data == '客服' then
--         this.setTitle(data)
--     end
-- end