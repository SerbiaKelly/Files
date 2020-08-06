local proxy_pb = require 'proxy_pb'

panelHelp = {}
local this = panelHelp;

local message;
local gameObject;
local buttonClose
local mask

local typeGrid

local whoShow
local dic = {}


function this.SetGameShowOrHide()
	dic = {}
	dic[proxy_pb.SYZP] = 'SYZP'
	dic[proxy_pb.SYBP] = 'SYBP'
	dic[proxy_pb.LDFPF] = 'LDFPF'
	dic[proxy_pb.XXGHZ] = 'XXGHZ'

	dic[proxy_pb.PDKSWZ] = 'PDK'
	dic[proxy_pb.PDKSLZ] = 'PDK'
	dic[proxy_pb.PKXHZD] = 'XHZD'
	dic[proxy_pb.PKDTZ] = 'DTZ'
	dic[proxy_pb.PKBBTZ] = 'BBTZ'

	dic[proxy_pb.CSM] = 'CSM'
	dic[proxy_pb.ZZM] = 'ZZM'
    dic[proxy_pb.HZM] = 'HZM'
    
	if CONST.showAllGame then
		dic[proxy_pb.HHHGW] = 'HHHGW'
		dic[proxy_pb.CSPHZ] = 'CSPHZ'
		dic[proxy_pb.CDPHZ] = 'CDPHZ'
		dic[proxy_pb.HYSHK] = 'HYSHK'
		dic[proxy_pb.HYLHQ] = 'HYLHQ'
		dic[proxy_pb.LYZP] = 'LYZP'
		dic[proxy_pb.HSPHZ] = 'HSPHZ'
		dic[proxy_pb.CDDHD] = 'CDDHD'
		dic[proxy_pb.NXPHZ] = 'NXPHZ'
        dic[proxy_pb.XTPHZ] = 'XTPHZ'
        dic[proxy_pb.YXPHZ] = 'YXPHZ'
        dic[proxy_pb.HNHSM] = 'HNHSM'
        dic[proxy_pb.XPLPM] = 'XPLPM'
        dic[proxy_pb.HNZZM] = 'HNZZM'
        dic[proxy_pb.YJGHZ] = 'YJGHZ'
        dic[proxy_pb.PKYJQF] = 'YJQF'
        dic[proxy_pb.PKHSTH] = 'HSTH'
        dic[proxy_pb.CZZP] = 'CZZP' 
        dic[proxy_pb.AHPHZ] = 'AHPHZ'
        dic[proxy_pb.DZAHM] = 'DZAHM'
	end
	
	for i=0,typeGrid.childCount-1 do
		typeGrid:GetChild(i).gameObject:SetActive(false)
		for j=0,100 do 
			if(dic[j] ~= nil and typeGrid:GetChild(i).name == dic[j]) then
				typeGrid:GetChild(i).gameObject:SetActive(true)
				break
			end
		end
    end
end

function this.Awake(obj)
	gameObject = obj;

    mask = gameObject.transform:Find('mask');
	buttonClose = gameObject.transform:Find('ButtonClose')

    message = gameObject:GetComponent('LuaBehaviour')

    typeGrid = gameObject.transform:Find('Table/grid')
    
    message:AddClick(buttonClose.gameObject, this.OnClickMask)
end


function this.WhoShow(data)
	this.SetGameShowOrHide()
    for i=0,typeGrid.childCount-1 do
        typeGrid:GetChild(i):GetComponent('UIToggle'):Set(false)
    end
    whoShow=data
    
    print(data)

    if data ~= 'lobby' then
       if dic[data] ~= nil then
        typeGrid:Find(dic[data]):SetAsFirstSibling()
        typeGrid:Find(dic[data]):GetComponent('UIToggle'):Set(true)
        typeGrid.transform:GetComponent('UIGrid').animateSmoothly = true 
       end
    else
        for i = 1, 100 do
            if dic[i] ~= nil then
                typeGrid:Find(dic[i]):SetAsLastSibling()
            end
        end
        typeGrid.transform:GetComponent('UIGrid').animateSmoothly = false
    end
    
    if data == "lobby" then
        typeGrid:GetChild(0):GetComponent('UIToggle'):Set(true)
        gameObject.transform:Find('bg/Label1'):GetComponent('UILabel').text = "帮助"
        gameObject.transform:Find('bg/Label2'):GetComponent('UILabel').text = "帮助"
        gameObject.transform:Find('bg/Label3'):GetComponent('UILabel').text = "帮助"
    else
        gameObject.transform:Find('bg/Label1'):GetComponent('UILabel').text = "玩法细则"
        gameObject.transform:Find('bg/Label2'):GetComponent('UILabel').text = "玩法细则"
        gameObject.transform:Find('bg/Label3'):GetComponent('UILabel').text = "玩法细则"
    end

    typeGrid.transform:GetComponent('UIGrid'):Reposition()
    typeGrid.parent.transform:GetComponent('UIScrollView'):ResetPosition()
end

function this.Update()
    
end
function this.Start()
end

function this.OnEnable()
end

function this.OnClickMask(go)
    PanelManager.Instance:HideWindow(gameObject.name)
end
