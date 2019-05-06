--宇宙中位置会变化的动态对象基类
local UnivBaseObject = require("Game/Module/SUniverse/UnivObject/UnivBaseObject");
local __super = UnivBaseObject;
local UnivDynamicObj = class("UnivDynamicObj", __super);

local UnitySetLocalPos = GameObjectUtil.SetLocalPosition;
local UnitySetLocalRot = GameObjectUtil.SetLocalRotation
local Vector3 = Vector3;
local mathabs = math.abs;
local mathsqrt = math.sqrt;
local Vector3_cForward = Vector3.New(0,0,1)

function UnivDynamicObj:ctor(id)
    __super.ctor(self, id);
    self.nBlockIdx = -1;--所在区块
    self.Target = Vector3(0,0,0);--移动目标位置
    self.MoveDir = Vector3(0,0,0);--移动方向向量
    self.MoveV = 10.0;--移动速度
    self.bMoving = false;--是否在移动状态
    self.nTargetNum = 0;
    self.nTargetIndex = 1
    self.fMoveTmLen = 0
    self.fMoveTmDur = 0
    self.setedPos = {x=0,y=0,z=0}
    self.setedTargetPos = {x=0,y=0,z=0}
end


function UnivDynamicObj:SetPostion(x,y,z)
    __super.SetPostion(self, x, y, z);
    self.setedPos = {x = x,y = y,z = z}
    self:OnMyPosChanged();
end

function UnivDynamicObj:StopMove()
    self.bMoving = false
    self.nTargetNum = 0
    self.nTargetIndex = 1
    __super.SetViewStatus(self, false)
end

function UnivDynamicObj:IsPosEqual(v1, v2)
    return mathabs(v1.x-v2.x) <= 0.1 and mathabs(v1.z-v2.z) <= 0.1;
end

function UnivDynamicObj:InitMove(x,y,z)
    self.Target.x = x;
    self.Target.y = y;
    self.Target.z = z;
    self.bMoving = not self:IsPosEqual(self.Pos, self.Target);
    if self.bMoving then 
        local dx = x-self.Pos.x
        local dz = z-self.Pos.z
        local dist = math.sqrt(dx^2 + dz^2)
        self.MoveDir.x = dx/dist;
        self.MoveDir.y = 0
        self.MoveDir.z = dz/dist
        
        self.fMoveTmLen = dist/self.MoveV
        self.fMoveTmDur = 0
        --set rot
        local dAngle = 90 - math.deg(math.atan2(dz,dx))
        self:SetRot(0, dAngle, 0)
    end
    __super.SetViewStatus(self,true)
end
--@dur 已经走了多久的时间
function UnivDynamicObj:SetMoveTarget(x, y, z, dur)
    self:InitMove(x,y,z)
    self.setedTargetPos = {x = x,y = y,z = z}
    self.nTargetNum = 0;
    self.nTargetIndex = 1
    if dur ~= nil and dur > 0 then 
        self:Update(dur)
    end
end
--多段移动目标
--@lstPos = {x,y,z,x,y,z...}
function UnivDynamicObj:SetMoveTargetList(lstPos)
    local n = #lstPos
    if n < 3 then 
        return
    end
    --1.设置第一个点
    self:InitMove(lstPos[1], lstPos[2], lstPos[3])
    if n >= 6 then 
        self.lstTarget = clone(lstPos)
        self.nTargetNum = math.floor(n/3)
        self.nTargetIndex = 1
    end
end

function UnivDynamicObj:GetBlockIdx()
    return self.nBlockIdx;
end

function UnivDynamicObj:SetBlockIdx(idx)
    self.nBlockIdx = idx;
end

function UnivDynamicObj:Update(dt)
    if self.bMoving then 
        self:UpdatePos(dt);
    end
end

function UnivDynamicObj:UpdatePos(dt)
    local fMovDis = dt*self.MoveV;
    self.fMoveTmDur = self.fMoveTmDur+dt
    --不用Vector3对象操作，可以减少Vector3对象生成
    local dtx = self.Target.x - self.Pos.x;
    --local dty = self.Target.y - self.Pos.x;
    local dtz = self.Target.z - self.Pos.z;
    local dis = dtx*dtx + dtz*dtz;
    
    if fMovDis* fMovDis > dis then 
        fMovDis = mathsqrt(dis);
    end
    local newx = self.Pos.x + self.MoveDir.x*fMovDis;
    local newz = self.Pos.z + self.MoveDir.z*fMovDis;
    
    if self.fMoveTmDur >= self.fMoveTmLen then
        self:SetPostion(self.Target.x, self.Target.y, self.Target.z)
        --到达一个点
        if self.nTargetIndex < self.nTargetNum then 
            self.nTargetIndex = self.nTargetIndex+1
            local posidx = math.floor((self.nTargetIndex-1)*3 + 1)
            self:InitMove(self.lstTarget[posidx],self.lstTarget[posidx+1],self.lstTarget[posidx+2])
        else 
            self.bMoving = false;
        end
    else
        self:SetPostion(newx, self.Pos.y, newz)
    end
end

function UnivDynamicObj:SetPosChangedCallback(func, target)
    self.PosChangedCallback = {func, target};
end

function UnivDynamicObj:OnMyPosChanged()
    if self.PosChangedCallback ~= nil then 
        self.PosChangedCallback[1](self.PosChangedCallback[2], self);
    end
end

function UnivDynamicObj:GetRemainDistance()
    local dtx = self.Target.x - self.Pos.x
    local dtz = self.Target.z - self.Pos.z
    local dis = math.sqrt(dtx*dtx + dtz*dtz)
    return dis
end

return UnivDynamicObj;