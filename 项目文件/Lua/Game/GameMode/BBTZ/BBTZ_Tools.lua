require("common")
require("BBTZ.HandCard")
require("BBTZ.Card")
local bbtz_pb = require("bbtz_pb")

function DebugBegin(msg)
    print("----------------------"..msg.."【开始】----------------------")
end

function DebugEnd(msg)
    print("----------------------"..msg.."【结束】----------------------")
end

function CloseChild(transform)
    for i = 0, transform.childCount - 1 do
        transform:GetChild(i).gameObject:SetActive(false)
    end
end

function OpenChild(transform)
    transform.gameObject:SetActive(true)
    for i = 0, transform.childCount - 1 do
        transform:GetChild(i).gameObject:SetActive(true)
    end
end

function SetChildActive(transform, active)
    local setAction = active and OpenChild or CloseChild
    setAction(transform)
end

function GridResetPosition(obj)
    local grid = obj.gameObject:GetComponent("UIGrid")
    grid:Reposition()
end

--count要删除多少个，比如有{4444}，但我只需要删除3个4，那么count = 3
function RemoveCard(cards, removeCards,count)
    local removeCount = 0;
    for i = 1, #removeCards do
        for j = #cards, 1, -1 do
            if removeCards[i] == cards[j] then
                table.remove(cards, j);
                if not count or count <=0 then
                else
                    removeCount = removeCount + 1;
                    if removeCount >= count then
                        break;
                    end
                end
            end
        end

        if not count or count <=0 then
        else
            if removeCount >= count then
                break;
            end
        end
    end
    return cards
end

function GetMousePosition(transform)
    local mousePosition = UnityEngine.Input.mousePosition;
    local wroldPosition = UICamera.currentCamera:ScreenToWorldPoint(mousePosition);
    local nguiPosition = transform.transform:InverseTransformPoint(wroldPosition);
    return nguiPosition;
end

function SetBoxTouch(obj, enable)
    obj.gameObject:SetActive(not obj.gameObject.activeSelf)
    obj:GetComponent('BoxCollider').enabled = enable
    obj.gameObject:SetActive(not obj.gameObject.activeSelf)
end

function SetLabelText(label, text, color)
    label.gameObject:GetComponent("UILabel").text = text
    if color ~= nil then
        label.gameObject:GetComponent('UILabel').color = color
    end
end

function SetSpriteName(sprite, name)
    sprite.transform.gameObject:GetComponent("UISprite").spriteName = name
    sprite.transform.gameObject:GetComponent("UISprite"):MakePixelPerfect()
end

function SetAnimation(transform)
    transform.gameObject:SetActive(false)
    transform.gameObject:SetActive(true)
end

local colorStrs = {[0] = 'DiamondIcon1', [1] = 'ClubIcon', [2] = 'HeartIcon1', [3] = 'SpadeIcon'}
function SetCardKeyColor(obj, card,bbtzPaiSize)
    local keys = obj.transform:Find("Key")
    local colors = obj.transform:Find("Color")
    local king = obj.transform:Find("King")

    local key = Card.GetCardKey(card)
    local color = Card.GetCardColor(card)

    local isKing = key == 16
    king.gameObject:SetActive(isKing)
    keys.gameObject:SetActive(not isKing)
    colors.gameObject:SetActive(not isKing)

    if isKing then return end

    for i = 0, keys.childCount - 1 do
        local keyImage = keys:GetChild(i)
        keyImage:GetComponent("UISprite").spriteName = GetBBTZCardTypeString(key,bbtzPaiSize);
        keyImage:GetComponent("UISprite").color = (color == 0 or color == 2) and Color(1,1,1) or Color(0,3/256,3/256)
    end

    for i = 0, colors.childCount - 1 do
        local colorImage = colors:GetChild(i)
        colorImage:GetComponent("UISprite").spriteName = colorStrs[color]
    end
end

function GetCardCategoryString(category)
    local categorys = {
        [Card.Category.TIANZHA] = "天炸",
        [Card.Category.DIZHA] = "地炸",
        [Card.Category.THS] = "同花顺",
        [Card.Category.BOOM] = "炸弹",
        [Card.Category.WSK] = "510K",
        [Card.Category.ZWSK] = "510K",
    }
    local str = categorys[category]
    if str == nil then str = "" end
    return str
end

function GetCategoryEffects(restCount, category)
    local categorys = {
        [Card.Category.TIANZHA] = "天炸",
        [Card.Category.DIZHA] = "地炸",
        [Card.Category.THS] = "同花顺",
        [Card.Category.BOOM] = "炸弹",
        [Card.Category.WSK] = "副五十K",
        [Card.Category.ZWSK] = "正五十K",
        [Card.Category.DUI] = "对子",
        [Card.Category.LIAN_DUI] = "连队",
        [Card.Category.FEI] = "飞机",
        [Card.Category.SHUN] = "顺子",
    }
    print(category)
    local str = categorys[category]
    if str == nil then return "" end
    return "Effect-"..str;
end

function GetOptionEffects(option, confim)
    local str = ""
    if option == bbtz_pb.OPTION_EMPTY then 
        str = ""
    elseif option == bbtz_pb.OPTION_HAMMER then
        str = confim and "" or "不锤"
    elseif option == bbtz_pb.OPTION_SHOOT then
        str = confim and "" or "投降" --str = str.."开枪"
    elseif option == bbtz_pb.OPTION_ROBBING then
        str = (confim and "" or "不").."反抢"
    elseif option == bbtz_pb.OPTION_STEEP then
        str = confim and "" or "不陡"
    elseif option == bbtz_pb.OPTION_HELP_STEEP then
        str = ""
    elseif option == bbtz_pb.OPTION_REVERSE then
        str = ""
    end
    if str == "" then return "" end
    return "Effect-"..str
end

function AddChildsClick(message ,parent, clickAction)
    for i = 0, parent.childCount - 1 do
        message:AddClick(parent:GetChild(i).gameObject, clickAction)
    end
end

function SetWidgetDepth(transform, depth)
    local widget = transform.gameObject:GetComponent("UIWidget")
    if widget ~= nil then
        widget.depth = depth
    end

    for i = 0, transform.childCount - 1 do
        SetWidgetDepth(transform:GetChild(i), depth + 1)
    end
end

function SetCardDepth(transform, depth)
    SetWidgetDepth(transform:Find("Background"), depth)
    SetWidgetDepth(transform:Find("Color"), depth + 1)
    SetWidgetDepth(transform:Find("Key"), depth + 1)
    SetWidgetDepth(transform:Find("King"), depth + 1)
    if transform:Find("ColorBox") then
        SetWidgetDepth(transform:Find("ColorBox"), depth)
    end
end


function GetCurBackground()
    return UnityEngine.PlayerPrefs.GetInt("GameBackground_BBTZ", 2)
end


function RefreshPhoneState(gameView, logic, batteryLevel, network)
    while gameView.activeSelf do
        -- 修改电池电量
        batteryLevel.fillAmount =  UnityEngine.SystemInfo.batteryLevel

        -- 重设网络状态
        local networkType = PlatformManager.Instance:GetNetworkType()
        if networkType == 1 then
            network.spriteName = 'wifi' .. logic:GetNetworkLatencyLevel()
        elseif networkType == 2 then
            network.spriteName = 'gprs' .. logic:GetNetworkLatencyLevel()
        elseif string.find(network.spriteName, 'wifi') then
            network.spriteName = 'wifi0'
        else
            network.spriteName = 'gprs0'
        end

        coroutine.wait(10)
    end
end

function PlayOptionEffectSound(option, confim)
    local str = nil
    if option == bbtz_pb.OPTION_EMPTY then 
        str = nil
    elseif option == bbtz_pb.OPTION_HAMMER then
        str = confim and "chui" or "buchui"
    elseif option == bbtz_pb.OPTION_SHOOT then
        str = confim and "kaiqiang" or nil
    elseif option == bbtz_pb.OPTION_ROBBING then
        str = confim and "fanqiang" or "bufanqiang"
    elseif option == bbtz_pb.OPTION_STEEP then
        str = confim and "dou" or nil
    elseif option == bbtz_pb.OPTION_HELP_STEEP then
        str = nil --confim and "fandou" or nil
    elseif option == bbtz_pb.OPTION_REVERSE then
        str = confim and "fandou" or nil
    end
    if str == nil then return end
    AudioManager.Instance:PlayAudio(str)
end

function PlayCardEffectSound(cards, category)
    local str = nil
    local handCard, minKey = Bbtz_CardLogic.GetOutCardCategory(cards, category)
    if category == Card.Category.DAN then
        str = tostring(minKey)
    elseif category == Card.Category.DIZHA then
        str = "dizha"
    elseif category == Card.Category.TIANZHA then
        str = "tianzha"
    elseif category == Card.Category.BOOM then
        str = "zhadan"
    elseif category == Card.Category.DUI then
        str = "d"..tostring(minKey)
    elseif category == Card.Category.LIAN_DUI then
        str = "liandui"
    elseif category == Card.Category.SHUN then
        str = "shunzi"
    elseif category == Card.Category.WSK then
        str = "510k"
    elseif category == Card.Category.ZWSK then
        str = "z510k"
    elseif category == Card.Category.SAN then
        str = "sandai"..tostring(#cards - 3);
    elseif category == Card.Category.THS then
        str = "tonghuashun"
    elseif category == Card.Category.FEI then
        str = "feiji";
    elseif category == Card.Category.SISAN then
        str = "sidai"..tostring(#cards - 4 )
    end
    if str == nil then return end
    --print("audio_str:"..str);
    AudioManager.Instance:PlayAudio(str);
end

function GetBBTZCardTypeString(Cardkey,bbtzPaiSize)
    local typeString = "";
    --print("Cardkey:"..Cardkey.."|bbtzPaiSize:"..bbtzPaiSize);
    if Card.IsJocker(Cardkey) then
    else
        if bbtzPaiSize == 1 then
            typeString = "card_"..Cardkey;
        elseif bbtzPaiSize == 2 then
            typeString = "bcard_"..Cardkey;
        end

    end
    return typeString;
end
