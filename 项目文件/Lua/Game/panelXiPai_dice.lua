panelXiPai_dice = {}
local this = panelXiPai_dice;

local message;
local gameObject;

local dice1
local dice2

local spriteNames={'1-1','1-2','1-3','1-4',
                   '2-1','2-2','2-3','2-4',
                   '3-1','3-2','3-3','3-4',
                   '4-1','4-2','4-3','4-4',
                   '5-1','5-2','5-3','5-4',
                   '6-1','6-2','6-3','6-4'}
local speed=0.5
--启动事件--
function this.Awake(obj)
    gameObject = obj;
    message = gameObject:GetComponent('LuaBehaviour');

    dice1 = gameObject.transform:Find('1');
    dice2 = gameObject.transform:Find('2');
    
end

function this.initCards()
    print('初始化')
    dice1:GetComponent('UISprite').spriteName=spriteNames[0]
    dice2:GetComponent('UISprite').spriteName=spriteNames[0]
end

local FUC
local suiJiA
local suiJiB
function this.WhoShow(data)
    FUC=data.fuc
    this.initCards()
    math.randomseed(tostring(os.time()):reverse():sub(1, 7))
    suiJiA=data.diceOnePoints--math.random(1,6)
    suiJiB=data.diceTwoPoints--math.random(1,6)
    StartCoroutine(this.rollA)
    StartCoroutine(this.rollB)
end

function this.Update()
   
end

function this.Start()

end

function this.OnEnable()
    
end

function this.rollA()
    local sprite=dice1:GetComponent('UISprite')
    for i=1,#spriteNames do
        sprite.spriteName=spriteNames[i]
        WaitForEndOfFrame()
    end
    local A
    local B=(suiJiA-1)*4+1
    if suiJiA==1 then
        sprite.spriteName=spriteNames[20]
        WaitForSeconds(speed/15)
        sprite.spriteName=spriteNames[21]
        WaitForSeconds(speed/12)
        sprite.spriteName=spriteNames[22]
        WaitForSeconds(speed/10)
        sprite.spriteName=spriteNames[23]
        WaitForSeconds(speed/10)
        sprite.spriteName=spriteNames[24]
        WaitForSeconds(speed/10)
        sprite.spriteName=spriteNames[1]
        WaitForSeconds(speed/10)
    elseif suiJiA==2 then
        sprite.spriteName=spriteNames[24]
        WaitForSeconds(speed/15)
        sprite.spriteName=spriteNames[1]
        WaitForSeconds(speed/12)
        sprite.spriteName=spriteNames[2]
        WaitForSeconds(speed/10)
        sprite.spriteName=spriteNames[3]
        WaitForSeconds(speed/10)
        sprite.spriteName=spriteNames[4]
        WaitForSeconds(speed/10)
        sprite.spriteName=spriteNames[5]
        WaitForSeconds(speed/10)
    else
        A=B-5
        for i=A,B do
            sprite.spriteName=spriteNames[i]
            WaitForSeconds(speed/10)
        end
    end
    WaitForSeconds(1)
end

function this.rollB()
    local sprite=dice2:GetComponent('UISprite')
    for i=1,#spriteNames do
        sprite.spriteName=spriteNames[i]
        WaitForEndOfFrame()
    end
    local A
    local B=(suiJiB-1)*4+1
    if suiJiB==1 then
        sprite.spriteName=spriteNames[20]
        WaitForSeconds(speed/15)
        sprite.spriteName=spriteNames[21]
        WaitForSeconds(speed/12)
        sprite.spriteName=spriteNames[22]
        WaitForSeconds(speed/10)
        sprite.spriteName=spriteNames[23]
        WaitForSeconds(speed/10)
        sprite.spriteName=spriteNames[24]
        WaitForSeconds(speed/10)
        sprite.spriteName=spriteNames[1]
        WaitForSeconds(speed/10)
    elseif suiJiB==2 then
        sprite.spriteName=spriteNames[24]
        WaitForSeconds(speed/15)
        sprite.spriteName=spriteNames[1]
        WaitForSeconds(speed/12)
        sprite.spriteName=spriteNames[2]
        WaitForSeconds(speed/10)
        sprite.spriteName=spriteNames[3]
        WaitForSeconds(speed/10)
        sprite.spriteName=spriteNames[4]
        WaitForSeconds(speed/10)
        sprite.spriteName=spriteNames[5]
        WaitForSeconds(speed/10)
    else
        A=B-5
        for i=A,B do
            sprite.spriteName=spriteNames[i]
            WaitForSeconds(speed/10)
        end
    end
    WaitForSeconds(1)
    if FUC~=nil then
        FUC()
    end
    gameObject:SetActive(false)
    panelInGame.needXiPai=false
end