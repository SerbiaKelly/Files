panelMessageBox = {}
local this = panelMessageBox;

local message;
local gameObject;
 
local mask
local labelMessage
local buttonOK
local buttonCancle
local buttonClose
local title1
local title2
ONLY_OK = 1
ONLY_CANCLE = 2
OK_CANCLE = 3
NO_OK_CANCLE_Close = 4
CANCLE_OK = 5

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
	message = gameObject:GetComponent('LuaBehaviour');
    --message:AddClick(mask.gameObject, this.OnClickMask);
    message:AddClick(buttonOK.gameObject, this.OnClicButtonOK);
    message:AddClick(buttonCancle.gameObject, this.OnClickButtonCancle);
    message:AddClick(buttonClose.gameObject, this.OnClickButtonClose);
end

function this.Start()
end

function this.OnEnable()
	print(ok_name)
    if btype == ONLY_OK then
        buttonOK.gameObject:SetActive(true)
        buttonOK.localPosition = Vector3.New(0, buttonOK.localPosition.y, -10)
        buttonCancle.gameObject:SetActive(false)
        gameObject.transform:Find('ButtonOK/Label'):GetComponent('UILabel').text = ok_name
        buttonClose.transform.gameObject:SetActive(false)
    elseif btype == OK_CANCLE then
        buttonOK.gameObject:SetActive(true)
        buttonOK.localPosition = Vector3.New(-150, buttonOK.localPosition.y,-10)
        buttonCancle.localPosition = Vector3.New(150, buttonOK.localPosition.y, -10)
        buttonCancle.gameObject:SetActive(true)
		gameObject.transform:Find('ButtonCancel/Label'):GetComponent('UILabel').text = cancle_name
        gameObject.transform:Find('ButtonOK/Label'):GetComponent('UILabel').text = ok_name
        buttonClose.gameObject:SetActive(true)
    elseif btype == CANCLE_OK then
        buttonOK.gameObject:SetActive(true)
        buttonOK.localPosition = Vector3.New(150, buttonOK.localPosition.y,-10)
        buttonCancle.localPosition = Vector3.New(-150, buttonOK.localPosition.y, -10)
        buttonCancle.gameObject:SetActive(true)
		gameObject.transform:Find('ButtonCancel/Label'):GetComponent('UILabel').text = cancle_name
        gameObject.transform:Find('ButtonOK/Label'):GetComponent('UILabel').text = ok_name
        buttonClose.gameObject:SetActive(true)
    elseif btype == NO_OK_CANCLE_Close then
        buttonClose.gameObject:SetActive(false)
        buttonCancle.gameObject:SetActive(false)
        buttonOK.gameObject:SetActive(false)
    elseif btype == ONLY_CANCLE then 
        buttonOK.gameObject:SetActive(false)
        buttonCancle.localPosition = Vector3.New(0, buttonOK.localPosition.y, -10)
        buttonCancle.gameObject:SetActive(true)
        gameObject.transform:Find('ButtonOK/Label'):GetComponent('UILabel').text = cancle_name
        buttonClose.transform.gameObject:SetActive(false);
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

    if mb_isShowCloseButton then
        buttonClose.gameObject:SetActive(true);
    else
        buttonClose.gameObject:SetActive(false);
    end

end

--单击事件--
function this.OnClickMask(go)
    PanelManager.Instance:HideWindow(gameObject.name)
end

function this.SetParamers(tbtype, tokCall, tcancleCall, tmessage, okName, cancleName, tspacingY, closefunc,isShowCloseButton)
	btype = tbtype
    okCall = tokCall
    print('OkCall是不是为空：'..tostring(tokCall == nil))
	cancleCall = tcancleCall
	msg = tmessage
	ok_name = okName ~= nil and okName or '确 定'
    cancle_name = cancleName ~= nil and cancleName or '取 消'
    
    spacingY = tspacingY

    CloseCall = closefunc
    mb_isShowCloseButton = isShowCloseButton;
    print('CloseCall是不是为空：'..tostring(CloseCall == nil))
end

function this.Update()
   
end
function this.OnClicButtonOK(go)
	AudioManager.Instance:PlayAudio('btn')
    this.OnClickMask(go)
    if okCall then
        okCall(go)
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

    print('CloseCall是不是为空：'..tostring(CloseCall == nil))
    if CloseCall then
        CloseCall(go)
    end
end

function this.VirtualOKClick(waitTime)
    coroutine.start(function()
        buttonOK:GetComponent("BoxCollider").enabled = false;
        buttonCancle:GetComponent("BoxCollider").enabled = false;
        buttonClose:GetComponent("BoxCollider").enabled = false;
        coroutine.wait(waitTime)
        local sp = buttonOK:Find('Background'):GetComponent('UISprite')
        sp.color=Color(183/255,163/255,123/255)
        buttonOK:GetComponent('TweenScale'):ResetToBeginning()
        buttonOK:GetComponent('TweenScale').from = Vector3.one
        buttonOK:GetComponent('TweenScale').to = Vector3(1.05,1.05,1.05)
        buttonOK:GetComponent('TweenScale').duration = 0.2
        buttonOK:GetComponent('TweenScale'):PlayForward()
        coroutine.wait(waitTime*0.2)
        sp.color=Color.white
        buttonOK:GetComponent('TweenScale'):ResetToBeginning()
        buttonOK:GetComponent('TweenScale').from = Vector3(1.05,1.05,1.05)
        buttonOK:GetComponent('TweenScale').to = Vector3.one
        buttonOK:GetComponent('TweenScale').duration = 0.2
        buttonOK:GetComponent('TweenScale'):PlayForward()
        coroutine.wait(waitTime*0.2)
        this.OnClickMask()
        buttonOK:GetComponent("BoxCollider").enabled        = true;
        buttonCancle:GetComponent("BoxCollider").enabled    = true;
        buttonClose:GetComponent("BoxCollider").enabled     = true;
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