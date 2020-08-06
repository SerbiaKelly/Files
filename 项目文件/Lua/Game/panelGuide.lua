local proxy_pb = require 'proxy_pb'
local json = require 'json'

panelGuide = {}
local this=panelGuide
local gameObject

local message;
local ClubHandle = {}

local ClubGuideIndex = 1
local MaxClubGuideIndex = 4
local ClubGuideCompleted = false;

local PlayGuideIndex = 1
local MaxPlayGuideIndex = 3
local PlayGuideCompleted = false;

local CurGuide = {}
local IsStartGuide = false;
--启动事件--
function this.Awake(obj)
    gameObject = obj;
    ClubHandle.panel = gameObject.transform:Find("Handle")
    ClubHandle.jumpBtn = gameObject.transform:Find("Handle/JumpBtn")
    ClubHandle.knowBtn = gameObject.transform:Find('Handle/KnowBtn')

    ClubGuideIndex = 1

    message = gameObject:GetComponent('LuaBehaviour');
    message:AddClick(ClubHandle.knowBtn.gameObject, function (go)
        this.Completed()
    end)
    message:AddClick(ClubHandle.jumpBtn.gameObject, this.NextGuide)

    -- -- 测试开启
    -- UnityEngine.PlayerPrefs.SetInt('ClubGuide', 0)
    -- UnityEngine.PlayerPrefs.SetInt('PlayGuide', 0)
end

function this.OnEnable()
    ClubGuideCompleted = UnityEngine.PlayerPrefs.GetInt('ClubGuide', 0) == 1
    PlayGuideCompleted = UnityEngine.PlayerPrefs.GetInt('PlayGuide', 0) == 1

    print('ClubGuideCompleted:'..tostring(ClubGuideCompleted))
    print('PlayGuideCompleted:'..tostring(PlayGuideCompleted))

    if not IsCanSetPlay() then
        MaxPlayGuideIndex = 1;
    end
end


function this.WhoShow(data)
    print('IsStartGuide:'..tostring(IsStartGuide))
    
    if IsGuideCompleted() or IsStartGuide then
        return 
    end

    CurGuide = {}
    if data == 'Club' then
        CurGuide.panel = 'ClubGuide';
        CurGuide.GuideIndex = ClubGuideIndex;
        CurGuide.MaxGuideIndex = MaxClubGuideIndex;
        CurGuide.GuideCompleted = ClubGuideCompleted;

        CurGuide.GuideFunc = {};
        CurGuide.GuideFunc[2] = this.ClubGuideFunc2;
        CurGuide.GuideFunc[3] = this.ClubGuideFunc3;

    elseif data == 'Play' then
        CurGuide.panel = 'PlayGuide';
        CurGuide.GuideIndex = PlayGuideIndex;
        CurGuide.MaxGuideIndex = MaxPlayGuideIndex;
        CurGuide.GuideCompleted = PlayGuideCompleted;

        CurGuide.GuideFunc = {};
        CurGuide.GuideFunc[1] = this.PlayGuideFunc1
    end

    this.Refresh()
end

function this.ClubGuideFunc2(guideUI)
    -- local pos = panelClub.GetTabel().transform.position
    -- print('x:'..pos.x.."  y:"..pos.y)
    -- local obj = this.SetGuideView(panelClub.GetTabel(), guideUI)

    -- if isShapedScreen  then
    --         local pos =  obj.transform.localPosition
    --         obj.transform.localPosition = Vector3(pos.x + FitOffset, pos.y, 0)
    -- end
end

function this.ClubGuideFunc3(guideUI)
    local obj = this.SetGuideView(panelClub.GetPlays(), guideUI)
    obj.transform.localScale = Vector3(1, 1, 1)
end

function this.PlayGuideFunc1(guideUI)
    this.SetGuideView(panelSetPlay.GetOnePlayRules(), guideUI)
end

function this.SetGuideView(prefab, guideUI)
    local obj = UnityEngine.Object.Instantiate(prefab.gameObject)

    local oldObj = guideUI.transform:Find(obj.name)
    if oldObj ~= nil then
        UnityEngine.Object.Destroy(oldObj)
    end

    obj.transform:SetParent(guideUI.transform)
    obj.transform.localScale = Vector3(1, 1, 1)
    obj.transform.position = prefab.transform.position
    obj:SetActive(true)
    
    return obj;
end

function this.Update()
   
end

function this.Start()

end



function this.Refresh()
    if  CurGuide.GuideCompleted then
        gameObject:SetActive(false)
        return 
    end

    if CurGuide.panel == 'ClubGuide' and PanelManager.Instance:IsActive('panelSetPlay') then
        gameObject:SetActive(false)
        return 
    end

    IsStartGuide = true;
    panelClub.CloseClubListView()

    this.ShowGuide()
end

function this.ShowGuide()
    local panel = CurGuide.panel..'/'
    local guide = gameObject.transform:Find(panel..'Guide'..CurGuide.GuideIndex)
    guide.gameObject:SetActive(true)
    
    if CurGuide.GuideIndex == CurGuide.MaxGuideIndex then
        ClubHandle.jumpBtn:Find('Label'):GetComponent('UILabel').text = '完成'
    else
        ClubHandle.jumpBtn:Find('Label'):GetComponent('UILabel').text = '下一步'
    end
    ClubHandle.panel.gameObject:SetActive(true)

    local func = CurGuide.GuideFunc[CurGuide.GuideIndex]
    if func ~= nil then
        func(guide)
    end
end

function this.NextGuide(go)
    this.HideGuide(CurGuide.GuideIndex)

    CurGuide.GuideIndex = CurGuide.GuideIndex + 1
    if CurGuide.GuideIndex > CurGuide.MaxGuideIndex then
        this.Completed()
    else
        this.ShowGuide()
    end
end

function this.HideGuide(index)
    local panel = CurGuide.panel..'/'
    local guide = gameObject.transform:Find(panel..'Guide'..CurGuide.GuideIndex)
    guide.transform.gameObject:SetActive(false)
    ClubHandle.panel.gameObject:SetActive(false)
end

function this.Completed()
    IsStartGuide = false;
    PanelManager.Instance:HideWindow(gameObject.name)
    UnityEngine.PlayerPrefs.SetInt(CurGuide.panel, 1)
    local panel = gameObject.transform:Find(CurGuide.panel)
    for i = 0, panel.transform.childCount - 1 do
        panel.transform:GetChild(i).gameObject:SetActive(false)
    end
    print('CurGuide.panel:'..CurGuide.panel)
end