panelAutoDissolve = {}
local this = panelAutoDissolve

local gameObject
local message
local ButtonClose

local delayTime = 10
local delayCoroutine

local OkBtn

function this.Awake(go)
    gameObject = go
    message = gameObject:GetComponent('LuaBehaviour')

    OkBtn = gameObject.transform:Find('ButtonOK')
    ButtonClose = gameObject.transform:Find('ButtonClose')

    message:AddClick(OkBtn.gameObject, this.OnNextClick)
    message:AddClick(ButtonClose.gameObject, function (go)
        AudioManager.Instance:PlayAudio('btn')
        gameObject:SetActive(false)
    end)
end

local autoDissolveDate
function this.WhoShow(data)
    local playerData = panelInGame.GetPlayerDataBySeat(data.seat)
    local str = "";
    if data.dissolveByMinus then
        str = '玩家【'..playerData.name..'】在第'..DestroyRoomData.roomData.round..'局结算后，疲劳值小于等于0，该房间提前进行大结算'
    else
        if data.huangDissolve then
            str = "群主已设置荒庄"..data.phzAutoDissolve.."次荒庄自动解散，如有疑问请联系群主";
        else
            str = '玩家【'..playerData.name..'】第'..DestroyRoomData.roomData.round..'局结算后，'..
                    '疲劳值低于群主设定的'..data.dissolveMinFee..'界限，'..
                    '该房间提前进行大结算。';
        end
    end
    
    this.SetText(str)
    --this.StartCoroutine()
    gameObject.transform.localPosition = Vector3(0,0,-40)
end

function this.SetText(str)
    gameObject.transform:Find('message'):GetComponent('UILabel').text = str
end

function this.StartCoroutine()
    this.StopCoroutine()
    delayCoroutine = coroutine.start(this.Coroutine)
end

function this.StopCoroutine()
    if delayCoroutine then
        coroutine.stop(delayCoroutine)
        delayCoroutine = nil
    end
end

function this.Coroutine()
    for i=delayTime, 1, -1 do
        
        OkBtn.transform:Find('Label'):GetComponent('UILabel').text = '已知晓('..i..')'

        coroutine.wait(1)
    end

    gameObject:SetActive(false)
    --panelInGame.ShowStageClear()
end

function this.OnNextClick()
    AudioManager.Instance:PlayAudio('btn')
    --this.StopCoroutine()
    gameObject:SetActive(false)
    --panelInGame.ShowStageClear()
end

function this.OnEnable()
    
end

function this.Update()
    
end