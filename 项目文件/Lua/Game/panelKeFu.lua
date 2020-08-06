
panelKeFu = {}
local this = panelKeFu;

local message;
local gameObject;
 
local mask
local buttonClose
local buttonCancel
local labelMessage1
local labelMessage2
local buttonCopy
local title1
local title2

--启动事件--牌友群设置
function this.Awake(obj)
	gameObject = obj;
    title1 =gameObject.transform:Find('bg/Sprite/Label1')
    title2 =gameObject.transform:Find('bg/Sprite/Label2')

    mask = gameObject.transform:Find('mask');
    buttonCancel = gameObject.transform:Find('ButtonCancel');
    buttonCopy = gameObject.transform:Find('ButtonCopy');
    labelMessage1 = gameObject.transform:Find('message1');
    labelMessage2 = gameObject.transform:Find('message2');
	buttonClose = gameObject.transform:Find('ButtonClose');
	message = gameObject:GetComponent('LuaBehaviour');
    --message:AddClick(mask.gameObject, this.OnClickMask);
    message:AddClick(buttonCancel.gameObject, this.OnClickButtonCancel);
    message:AddClick(buttonClose.gameObject, this.OnClickButtonClose);
    message:AddClick(buttonCopy.gameObject,this.OnClickButtonCopy)
end

function this.Start()
end

function this.OnEnable()
	-- print(ok_name)
    -- if btype == ONLY_OK then
    --     buttonOK.localPosition = Vector3.New(0, buttonOK.localPosition.y, 0)
    --     buttonCancle.gameObject:SetActive(false)
	-- 	gameObject.transform:Find('ButtonOK/Label'):GetComponent('UILabel').text = ok_name
    -- elseif btype == OK_CANCLE then
    --     buttonOK.localPosition = Vector3.New(-150, buttonOK.localPosition.y, 0)
    --     buttonCancle.localPosition = Vector3.New(150, buttonOK.localPosition.y, 0)
    --     buttonCancle.gameObject:SetActive(true)
	-- 	gameObject.transform:Find('ButtonCancel/Label'):GetComponent('UILabel').text = cancle_name
	-- 	gameObject.transform:Find('ButtonOK/Label'):GetComponent('UILabel').text = ok_name
    -- end

	-- if msg then
	-- 	labelMessage:GetComponent('UILabel').text = msg
	-- else
	-- 	labelMessage:GetComponent('UILabel').text = ''
	-- end
end

--单击事件--
function this.OnClickMask(go)
    PanelManager.Instance:HideWindow(gameObject.name)
end

function this.Update()   
end


function this.OnClickButtonCancel(go)
	AudioManager.Instance:PlayAudio('btn')
    PanelManager.Instance:HideWindow(gameObject.name)
end

function this.OnClickButtonClose(go)
	AudioManager.Instance:PlayAudio('btn')
    this.OnClickMask(go)
    -- if cancleCall then
    --     cancleCall(go)
    -- end
end

function this.setTitle(str)
    title1:GetComponent('UILabel').text = str
    title2:GetComponent('UILabel').text = str

end

function this.WhoShow(data)
    if data == '客服' then
        this.setTitle(data)
    end
end
function this.OnClickButtonCopy()
    AudioManager.Instance:PlayAudio('btn')
    local copyString = labelMessage2:GetComponent('UILabel').text
    Util.CopyToSystemClipbrd(copyString)
    panelMessageTip.SetParamers('复制成功', 1.5)
    PanelManager.Instance:ShowWindow('panelMessageTip')
    UnityEngine.Application.OpenURL('weixin://')
end