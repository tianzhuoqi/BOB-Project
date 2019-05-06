local LoginMediator = require("Game/Module/SLogin/LoginMediator")
local LoginPanel = register("LoginPanel", PanelBase)
local defaultIP = "192.168.80.17"
local defaultPort = "8000"
local defaultName = "admin"


function LoginPanel:Awake(gameObject)
	self.gameObject = gameObject
	self.loginButton = self:FindGameObject('LoginButton')
	self.nameText = self:FindGameObject('InputName'):GetComponent("UILabel")
	
	self.IPText = self:FindGameObject('InputIP'):GetComponent("UIInput")
	self.IPText.value = UnityEngine.PlayerPrefs.GetString("lastIP", defaultIP)
	self.portText = self:FindGameObject("InputPort"):GetComponent("UIInput")
	self.portText.value = UnityEngine.PlayerPrefs.GetString("lastPort", defaultPort)
	self.nameText = self:FindGameObject("InputName"):GetComponent("UIInput")
	self.nameText.value = UnityEngine.PlayerPrefs.GetString("lastName", defaultName)
	self.mediator = LoginMediator.New("LoginMediator")
	self.mediator:SetViewComponent(self)
	Facade:RegisterMediator(self.mediator)
end

return LoginPanel