
effManger = {}
this = effManger

local effs = {};
local cateEffs = {};
local zhiCoroutine = nil;

function this.ShowEffect(panelObj, name, worldPos)
	-- print("effect name:"..name);
	-- print("panelObj:"..tostring(panelObj));
	-- print("worldPos:"..tostring(worldPos));
	local e = nil
    
    if not effs[panelObj.name] then
        effs[panelObj.name] = {};
    end

    --找一个可以重复利用的特效资源
	if effs[panelObj.name][name] and #effs[panelObj.name][name] > 0 then
		for i=1,#effs[panelObj.name][name] do
			if not effs[panelObj.name][name][i].activeSelf then
				e = effs[panelObj.name][name][i]
				break
			end
		end
	end

    --如果没有闲置的则创建一个新的特效
	if not e then
		local e_perfab = ResourceManager.Instance:LoadAssetSync(name)
		e = NGUITools.AddChild(panelObj, e_perfab)
		if effs[panelObj.name][name] then
			table.insert(effs[panelObj.name][name], e)
		else		
			effs[panelObj.name][name] = {e}
		end
	end
	
	e:SetActive(true);
	local tweenScale = e:GetComponent("TweenScale");

	e.transform.position = worldPos == nil and Vector3.zero or worldPos;
	tweenScale:ResetToBeginning();
	tweenScale.duration = 1;
	--tweenScale.worldSpace = true;
	tweenScale.from = Vector3.New(1.5,1.5,1.5);
	tweenScale.to = Vector3.New(1,1,1);
	tweenScale:PlayForward();

	--
	coroutine.start(
		function()
			coroutine.wait(tweenScale.duration);
			e:SetActive(false);
		end
	)
end

function this.ShowCategorieEffect(panelObj, categorie, pos)
    -- print("ShowCategorieEffect was called categorie:"..categorie);
	local Category_prefab = GetCategoryPrefabStr();
    local grid = panelObj:GetComponent("UIGrid");
    this.ShowEffect(panelObj, Category_prefab[categorie+1], pos);
   
    

    StartCoroutine(function ()
        WaitForEndOfFrame();
        if grid then
            grid:Reposition();
        end
    end);



end

function this.ShowZhiShaiziEffect(froms,tos,objs,duration)


	for i = 1, #objs do
		objs[i].position = froms[i];
		local tweenPosition = objs[i]:GetComponent("TweenPosition");
		tweenPosition.from = froms[i];
		tweenPosition.to = tos[i];
		objs[i].gameObject:SetActive(true);
	end
	for i = 1, #objs do

		local tweenScale = objs[i]:GetComponent("TweenScale");
		local tweenPosition = objs[i]:GetComponent("TweenPosition");

		--1.先放大

		tweenScale:ResetToBeginning();
		tweenScale.duration = duration;
		--tweenScale.worldSpace = true;
		tweenScale.from = Vector3.New(1.5,1.5,1.5);
		tweenScale.to = Vector3.New(1,1,1);
		tweenScale:PlayForward();
		--2.再移动
		StartCoroutine(function()
			WaitForEndOfFrame();
			WaitForSeconds(tweenScale.duration);
			tweenPosition:ResetToBeginning();
			tweenPosition.duration = duration;
			tweenPosition.worldSpace = true;
			tweenPosition:PlayForward();
			tweenScale:ResetToBeginning();
			tweenScale.duration = duration;
			--tweenScale.worldSpace = true;
			tweenScale.from = Vector3.New(1.0,1.0,1.0);
			tweenScale.to = Vector3.New(0.5,0.5,0.5);
			tweenScale:PlayForward();
			--还原

			WaitForSeconds(tweenPosition.duration);
			objs[i].gameObject:SetActive(false);
			objs[i].position = froms[i];
			tweenPosition.enabled = false;
		end);

	end
end




