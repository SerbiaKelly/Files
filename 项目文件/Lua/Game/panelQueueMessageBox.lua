panelQueueMessageBox = {}
local this = panelQueueMessageBox

local message;
local gameObject;

local Content = {}

local OpenedArgs = {}

function this.Awake(go)

    gameObject      = go;
    message         = gameObject:GetComponent('LuaBehaviour');

    Content.message = gameObject.transform:Find('message'):GetComponent('UILabel')
    Content.title = {}
    Content.title[1] = gameObject.transform:Find('title/Label1'):GetComponent('UILabel')
    Content.title[2] = gameObject.transform:Find('title/Label1'):GetComponent('UILabel')

    Content.OkButton = gameObject.transform:Find('Buttons/ButtonOK')
    Content.CancelButton = gameObject.transform:Find('Buttons/ButtonCancel')
    Content.CloseButton = gameObject.transform:Find('ButtonClose')

    Content.Animation = gameObject.transform:GetComponent('TweenScale')

    message:AddClick(Content.OkButton.gameObject, this.OnOkButton)
    message:AddClick(Content.CancelButton.gameObject, this.OnCancelButton)
    message:AddClick(Content.CloseButton.gameObject, this.OnCloseButton)
end

local CurArgs = nil
function this.WhoShow(args)
    table.insert(OpenedArgs, args)

    if not CurArgs then
        this.InitView(this.GetOpenedArgs())
    end
end

function this.InitView(args)
    CurArgs = args
    Content.message.text = args.text
    this.SetTitle(args.title)

    if args.spacingY then
        Content.message.spacingY = args.spacingY
    else
        Content.message.spacingY = 0
    end

    Content.CancelButton.gameObject:SetActive(not args.noCancel)

    Content.OkButton:Find('Label'):GetComponent('UILabel').text = args.ok_name and args.ok_name or '确 定'
    Content.CancelButton:Find('Label'):GetComponent('UILabel').text = args.cancle_name and args.cancle_name or '取 消'

    gameObject.transform:Find('Buttons'):GetComponent('UIGrid'):Reposition()

    gameObject.transform.localScale = Content.Animation.from
    Content.Animation:ResetToBeginning()
    Content.Animation:PlayForward()
end

function this.SetTitle(text)
    for i = 1, #Content.title do
        Content.title[i].text = text
    end
end

function this.OnOkButton(go)
    AudioManager.Instance:PlayAudio('btn')
    print('OnOkButton')

    if CurArgs.okFunc ~= nil then
        CurArgs.okFunc()
    end

    this.CloseBox()
end

function this.OnCancelButton(go)
    AudioManager.Instance:PlayAudio('btn')
    print('OnCancelButton')

    if CurArgs.cancelFunc ~= nil then
        CurArgs.cancelFunc()
    end

    this.CloseBox()
end

function this.OnCloseButton(go)
    AudioManager.Instance:PlayAudio('btn')
    print('OnCloseButton')
    
    this.CloseBox()
end

function this.CloseBox()
    CurArgs = nil
    if #OpenedArgs ~= 0 then
        this.InitView(this.GetOpenedArgs())
    else
        PanelManager.Instance:HideWindow('panelQueueMessageBox')
    end    
end

function this.GetOpenedArgs()
    local data = OpenedArgs[1]
    table.remove(OpenedArgs, 1)
    return data
end

function this.Update()
end