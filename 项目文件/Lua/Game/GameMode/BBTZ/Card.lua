local gid = 0
function GetGid()
    gid = gid + 1
    return gid
end

local CardBase = {}
CardBase.__eq = function(a, b)
    return a.value == b.value and a.gid == b.gid
end

CardBase.__mod = function(a, num)
    return a.value % num
end

CardBase.__div = function(a, num)
    return a.value / num
end

CardBase.__lt = function(a, b)
    return a.value < b.value
end

CardBase.__le = function(a, b)
    return a.value <= b.value
end

Card = {}
function Card.New(value)
    local card = {}
    setmetatable(card, CardBase)
    card.gid = GetGid()
    card.value = value
    return card
end

function Card.GetCardKey(card)
    return math.modf(card / 4) + 3
end

function Card.GetCardColor(card)
    return card % 4
end

--一张牌是大王还是否是大小王
function Card.IsJocker(cardKey)
    if cardKey == 16 or cardKey == 17 then
        return true;
    end
    return false;
end


--是否是大王
function Card.IsRedJocker(cardKey)
    return cardKey == 17
end

--是否是小王
function Card.IsGrayJocker(cardKey)
    return cardKey == 16;
end

Card.Category = {
    DAN = 0, DUI = 1, SAN = 2, LIAN_DUI = 3, FEI = 4, SISAN = 5, SHUN = 6, WSK = 7, ZWSK = 8, BOOM = 9, THS = 10, DIZHA = 11, TIANZHA = 12,
}