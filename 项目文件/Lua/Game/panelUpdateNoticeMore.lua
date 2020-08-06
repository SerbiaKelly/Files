panelUpdateNoticeMore = {}
local this = panelUpdateNoticeMore

local message;
local gameObject;

function this.Awake(go)
    gameObject = go
    message = gameObject:GetComponent('LuaBehaviour');

    local closeButton = gameObject.transform:Find('BaseContent/ButtonClose')
    message:AddClick(closeButton.gameObject, this.OnClickClose)


end

function this.OnClickClose(go)
    PanelManager.Instance:HideWindow(gameObject.name)
end

function this.WhoShow(data)
    local info = data.info
    local isGongGao = data.isGongGao

    if isGongGao then
        local panel = gameObject.transform:Find('panel1')
        panel.transform:Find('message/Time'):GetComponent('UILabel').text = os.date('%Y-%m-%d %X',info.startTime)..' 至 '..os.date('%Y-%m-%d %X',info.endTime)
        panel.gameObject:SetActive(true)
        gameObject.transform:Find('panel2').gameObject:SetActive(false)
    else
        local panel = gameObject.transform:Find('panel2')
        panel.transform:Find('message/Time'):GetComponent('UILabel').text = os.date('%Y-%m-%d %X',info.startTime)..' 至 '..os.date('%Y-%m-%d %X',info.endTime)
        panel.gameObject:SetActive(true)
        gameObject.transform:Find('panel1').gameObject:SetActive(false)
    end
end

function this.Start()
	
end
function this.Update()
   
end
function this.OnEnable()

    
end