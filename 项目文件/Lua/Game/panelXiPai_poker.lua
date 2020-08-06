panelXiPai_poker = {}
local this = panelXiPai_poker;

local message;
local gameObject;

local cards={}
local paiCang1
local paiCang2

local cardNum= 54
local spead=0.5
--启动事件--
function this.Awake(obj)
    gameObject = obj;
    message = gameObject:GetComponent('LuaBehaviour');

    paiCang1 = gameObject.transform:Find('paiCang1');
    paiCang2 = gameObject.transform:Find('paiCang2');
    -- local card = gameObject.transform:Find('1');
    -- for i=1,cardNum do
    --     local tmpCard =NGUITools.AddChild(gameObject, card.gameObject)
    --     tmpCard.name=i
    --     tmpCard.transform:GetComponent('UIWidget').depth=i
    --     tmpCard.transform.localPosition=Vector3(0,i,0)
    -- end
    for i=1,cardNum do
        cards[i]=gameObject.transform:Find(i)
    end
end

function this.initCards()
    print('初始化')
    for i=1,#cards do
        cards[i].parent=gameObject.transform
        cards[i].localPosition=Vector3(0,i,0)
        cards[i]:GetComponent('UIWidget').depth=i
    end
    paiCang1.localPosition=Vector3(0,0,0)
    paiCang2.localPosition=Vector3(0,0,0)
end
local FUC
function this.WhoShow(fuc)
    FUC=fuc
    this.initCards()
    StartCoroutine(this.qiePai)
end

function this.Update()
   
end

function this.Start()

end

function this.OnEnable()
    
end

function this.qiePai()
    local up=0.2*spead
    local out=0.25*spead
    local back=0.25*spead
    math.randomseed(tostring(os.time()):reverse():sub(1, 7))
    local suiJi=math.random(10,20)
    print('suiJi1 '..suiJi)
    for i=1,20 do
        cards[i].parent=gameObject.transform
    end     
    for i=21,20+suiJi do
        cards[i].parent=paiCang1
        cards[i]:GetComponent('UIWidget').depth=cards[i]:GetComponent('UIWidget').depth+cardNum
    end
    for i=20+suiJi+1,cardNum do
        cards[i].parent=paiCang2
    end
    this.positionTo(paiCang1,paiCang1.localPosition,Vector3(0,40,0),up)
    this.positionTo(paiCang2,paiCang2.localPosition,Vector3(0,40,0),up)
    WaitForSeconds(up)
    this.positionTo(paiCang1,paiCang1.localPosition,Vector3(200,75,0),out)
    this.positionTo(paiCang2,paiCang2.localPosition,Vector3(0,0,0),out)
    WaitForSeconds(out)
    this.positionTo(paiCang1,paiCang1.localPosition,Vector3(0,60-suiJi,0),back)
    this.positionTo(paiCang2,paiCang2.localPosition,Vector3(0,-suiJi,0),back)
    WaitForSeconds(back)
    this.initCards()

    StartCoroutine(this.chaPai)
end

function this.chaPai()
    local part=0.1*spead
    local up=0.1*spead
    local merge=0.26*spead
    for i=1,cardNum,2 do
        cards[i].parent=paiCang1
    end
    for i=2,cardNum,2 do
        cards[i].parent=paiCang2
    end
    for i=1,cardNum,2 do
        cards[i].localPosition=Vector3(-i/6,cards[i].localPosition.y,0)
    end
    for i=2,cardNum,2 do
        cards[i].localPosition=Vector3(i/6,cards[i].localPosition.y,0)
    end
    this.positionTo(paiCang1,paiCang1.localPosition,Vector3(100,0,0),part)
    this.positionTo(paiCang2,paiCang2.localPosition,Vector3(-100,0,0),part)
    this.rotationTo(paiCang1,paiCang1.localRotation,Vector3(0,0,-25),part)
    this.rotationTo(paiCang2,paiCang2.localRotation,Vector3(0,0,25),part)
    WaitForSeconds(part)
    for j=1,4 do
        for i=3,cardNum do
            cards[i].localPosition=Vector3(cards[i].localPosition.x,cards[i].localPosition.y+0.05*i,0)
        end
        WaitForSeconds(up/4)
    end
    this.rotationTo(paiCang1,paiCang1.localRotation,Vector3(0,0,25),merge)
    this.rotationTo(paiCang2,paiCang2.localRotation,Vector3(0,0,-25),merge)
    for j=1,4 do
        for i=1,cardNum,2 do
            cards[i].localPosition=Vector3(cards[i].localPosition.x+i/10,cards[i].localPosition.y,0)
        end
        for i=2,cardNum,2 do
            cards[i].localPosition=Vector3(cards[i].localPosition.x-i/10,cards[i].localPosition.y,0)
        end
        WaitForSeconds(merge/4)
    end
    this.positionTo(paiCang1,paiCang1.localPosition,Vector3(0,0,0),merge)
    this.positionTo(paiCang2,paiCang2.localPosition,Vector3(0,0,0),merge)
    WaitForSeconds(merge)
    this.rotationTo(paiCang1,paiCang1.localRotation,Vector3(0,0,0),merge)
    this.rotationTo(paiCang2,paiCang2.localRotation,Vector3(0,0,0),merge)
    for j=1,4 do
        for i=1,cardNum,2 do
            cards[i].localPosition=Vector3(cards[i].localPosition.x+(i/24-i/10),cards[i].localPosition.y,0)
        end
        for i=2,cardNum,2 do
            cards[i].localPosition=Vector3(cards[i].localPosition.x+(i/10-i/24),cards[i].localPosition.y,0)
        end
        WaitForSeconds(merge/4)
    end
    --this.initCards()
    for i=1,cardNum,2 do --------------------------重复插一次
        cards[i].localPosition=Vector3(-i/6,cards[i].localPosition.y,0)
    end
    for i=2,cardNum,2 do
        cards[i].localPosition=Vector3(i/6,cards[i].localPosition.y,0)
    end
    this.positionTo(paiCang1,paiCang1.localPosition,Vector3(100,0,0),part)
    this.positionTo(paiCang2,paiCang2.localPosition,Vector3(-100,0,0),part)
    this.rotationTo(paiCang1,paiCang1.localRotation,Vector3(0,0,-25),part)
    this.rotationTo(paiCang2,paiCang2.localRotation,Vector3(0,0,25),part)
    WaitForSeconds(part)
    for j=1,4 do
        for i=3,cardNum do
            cards[i].localPosition=Vector3(cards[i].localPosition.x,cards[i].localPosition.y+0.05*i,0)
        end
        WaitForSeconds(up/4)
    end
    this.rotationTo(paiCang1,paiCang1.localRotation,Vector3(0,0,25),merge)
    this.rotationTo(paiCang2,paiCang2.localRotation,Vector3(0,0,-25),merge)
    for j=1,4 do
        for i=1,cardNum,2 do
            cards[i].localPosition=Vector3(cards[i].localPosition.x+i/10,cards[i].localPosition.y,0)
        end
        for i=2,cardNum,2 do
            cards[i].localPosition=Vector3(cards[i].localPosition.x-i/10,cards[i].localPosition.y,0)
        end
        WaitForSeconds(merge/4)
    end
    this.positionTo(paiCang1,paiCang1.localPosition,Vector3(0,0,0),merge)
    this.positionTo(paiCang2,paiCang2.localPosition,Vector3(0,0,0),merge)
    WaitForSeconds(merge)
    this.rotationTo(paiCang1,paiCang1.localRotation,Vector3(0,0,0),merge)
    this.rotationTo(paiCang2,paiCang2.localRotation,Vector3(0,0,0),merge)
    for j=1,4 do
        for i=1,cardNum,2 do
            cards[i].localPosition=Vector3(cards[i].localPosition.x+(i/24-i/10),cards[i].localPosition.y,0)
        end
        for i=2,cardNum,2 do
            cards[i].localPosition=Vector3(cards[i].localPosition.x+(i/10-i/24),cards[i].localPosition.y,0)
        end
        WaitForSeconds(merge/4)
    end
    if FUC~=nil then
        FUC()
    end
    gameObject:SetActive(false)
    panelInGame.needXiPai=false
end

function this.positionTo(transform,from,to,duration)
    gameObject:SetActive(true)
    --TweenPosition.Begin(transform.gameObject, duration, to, false)
    local tweenPosition=transform:GetComponent('TweenPosition')
    tweenPosition:ResetToBeginning()
    tweenPosition.worldSpace = false
    tweenPosition.from = from
    tweenPosition.to = to
    tweenPosition.duration = duration
    tweenPosition:PlayForward()
    return duration
end

function this.rotationTo(transform,from,to,duration)
    gameObject:SetActive(true)
    --TweenRotation.Begin(transform.gameObject, duration, to, false)
    local tweenRotation=transform:GetComponent('TweenRotation')
    tweenRotation:ResetToBeginning()
    tweenRotation.from = from
    tweenRotation.to = to
    tweenRotation.duration = duration
    tweenRotation:PlayForward()
    return duration
end