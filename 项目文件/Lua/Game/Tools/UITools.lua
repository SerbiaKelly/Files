UITools = {}
local this = UITools

--UILabel 超过Label 自动省略号补全
function this.SetAutoLabel(label, text)
    label.text = text
    -- local strOut = ''
    -- label:ProcessText()
    -- local bWarp, strOut = label:Wrap(text, nil, label.height)
    -- while (not bWarp) do
    --     strOut = string.sub(text, 1, string.len(text) - 1)
    --     text = strOut
    --     strOut = strOut.."..."
    --     bWarp = label:Wrap(strOut,  nil, label.height)
    -- end
    -- label.text = strOut
end

--UIScrollView 返回当前节点下的内容可不可以移动
function this.ScrollViewCanMove(scrollView)
    if not scrollView.disableDragIfFits then
        return true
    end

    scrollView:InvalidateBounds()
    local panel = scrollView:GetComponent('UIPanel')
    local clip = panel.finalClipRegion
    local bounds = scrollView.bounds

    local hx = (clip.z == 0) and UnityEngine.Screen.width or clip.z * 0.5
    local hy = (clip.w == 0) and UnityEngine.Screen.height or clip.w * 0.5

    if scrollView.canMoveHorizontally then
        if bounds.size.x > hx / 0.5 then
            return true;
        end
    end

    if scrollView.canMoveVertically then
        if bounds.size.y > hy / 0.5 then
            return true
        end
    end

    return false
end

function this.GetCheckFloatFunc(num)
    local func = function (text, pos, ch)
        local fpos = string.find(text,'%.');
        if fpos ~= nil then fpos = fpos - 1 end
        if tonumber(ch)>=48 and tonumber(ch)<=57 then 
            if fpos ~= nil and pos - fpos ~= num then
                return '0' 
            end
            return ch
        end
        if tonumber(ch)==45 and pos == 0 and string.find(text,'-')==nil then return ch end
        if tonumber(ch)==46 and string.find(text,'%.')==nil then return ch end
        return '0'
    end

    return func
end