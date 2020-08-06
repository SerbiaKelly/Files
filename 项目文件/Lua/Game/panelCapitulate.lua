local xhzd_pb = require 'xhzd_pb'

panelCapitulate = {}
local this = panelCapitulate;

local message;
local gameObject;

local timeLabel
local rejectButton
local agreeButton
local okButton
local player={}
local playsHead={}
local playsName={}
local playsSelect={}
local mySeat
local time = 10
local coroutineDaoJiShi=nil
function this.Awake(obj)
	gameObject = obj;
	this.gameObject = obj
	message = gameObject:GetComponent('LuaBehaviour');
	
	rejectButton=gameObject.transform:Find('Buttons/ButtonReject');
	agreeButton=gameObject.transform:Find('Buttons/ButtonAgree');
	okButton=gameObject.transform:Find('Buttons/ButtonOK');
	timeLabel=gameObject.transform:Find('Rule/Label1');
	for i=0,3 do
		player[i] = gameObject.transform:Find('player'..i);
		playsHead[i]=gameObject.transform:Find('player'..i..'/head');
		playsName[i]=gameObject.transform:Find('player'..i..'/name');
		playsSelect[i]=gameObject.transform:Find('player'..i..'/select');
	end
    message:AddClick(rejectButton.gameObject, this.OnClickReject);
	message:AddClick(agreeButton.gameObject, this.OnClickAgree);
	message:AddClick(okButton.gameObject, this.OnClickOK);
end

function this.Start()
	
end
function this.Update()
   
end
function this.OnEnable()

end
function this.WhoShow(data)
	print('WHOSHOW '..time)
	for i=0,3 do
		playsHead[i]:GetComponent('UITexture').mainTexture=nil
		playsName[i]:GetComponent('UILabel').text=''
		playsSelect[i]:GetComponent('UISprite').spriteName=''
	end
	for i=0,#data.plays do
		local index = panelInGame.GetUIIndexBySeat(data.plays[i].seat);
		coroutine.start(LoadPlayerIcon, playsHead[index]:GetComponent('UITexture'), data.plays[i].icon)
		print('nickname : '..data.plays[i].name)
		playsName[index]:GetComponent('UILabel').text=data.plays[i].name
		playsSelect[index]:GetComponent('UISprite').spriteName = '考虑中'
		playsSelect[index]:GetComponent('UISprite'):MakePixelPerfect()
	end
	rejectButton.gameObject:SetActive(true)
	agreeButton.gameObject:SetActive(true)
	okButton.gameObject:SetActive(false)
	mySeat = data.mySeat
	time = -1
	if coroutineDaoJiShi~=nil then
		coroutine.stop(coroutineDaoJiShi)
	end
	time = math.floor(data.time/1000)
	coroutineDaoJiShi=coroutine.start(this.daoJiShi)
	if data.mySeat ~= nil and data.seat ~= nil then
		this.ShowButton(data.seat,data.mySeat)
	end
end

function this.daoJiShi()
	while time>=0 do
		timeLabel:GetComponent('UILabel').text='[753B0D]是否同意结束本小局？([-][ff0000]'..time..'[-][753B0D]秒后自动拒绝)[-]'
		coroutine.wait(1)
		time=time-1
	end
end

function this.OnClickReject(go)
	local msg = Message.New()
	msg.type = xhzd_pb.DISARM
	local body = xhzd_pb.PDisarm();
	body.type = xhzd_pb.DISARM_REJECT
	msg.body = body:SerializeToString();
	SendGameMessage(msg, nil);
end

function this.OnClickAgree(go)
	local msg = Message.New()
	msg.type = xhzd_pb.DISARM
	local body = xhzd_pb.PDisarm();
	body.type = xhzd_pb.DISARM_AGREE
	msg.body = body:SerializeToString();
	SendGameMessage(msg, nil);
end

function this.ShowButton(seat,mySeat)
	local index = panelInGame.GetUIIndexBySeat(seat);
	playsSelect[index]:GetComponent('UISprite').spriteName = '同意'
	playsSelect[index]:GetComponent('UISprite'):MakePixelPerfect()
	if mySeat == seat then
		rejectButton.gameObject:SetActive(false)
		agreeButton.gameObject:SetActive(false)
	end
end
function this.ShowReject(seat)
	local index = panelInGame.GetUIIndexBySeat(seat);
	playsSelect[index]:GetComponent('UISprite').spriteName = '拒绝'
	playsSelect[index]:GetComponent('UISprite'):MakePixelPerfect()
	rejectButton.gameObject:SetActive(false)
	agreeButton.gameObject:SetActive(false)
	okButton.gameObject:SetActive(true)
end

function this.OnClickOK(go)
	PanelManager.Instance:HideWindow('panelCapitulate')
end