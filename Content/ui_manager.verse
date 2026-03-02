using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/UI }

ToMessage<localizes>(Content : string): message = "{Content}"

category := class<concrete>():
    @editable
    Label : string = ""

    @editable
    Items : []item = array{}

item := class<concrete>():
    @editable
    Label : string = ""

    @editable
    Items : []finalitem = array{}

finalitem := class<concrete>():
    Label : string = ""

ui_manager := class(creative_device):
    MainWidget : Widgets.W_GameConfig = Widgets.W_GameConfig{}

    @editable
    GameManager : game_manager = game_manager{}

    @editable
    SignalRemoteManager : signal_remote_manager_device = signal_remote_manager_device{}

    @editable
    Categories : []category = array{}

    OnBegin<override>()<suspends>:void=
        SignalRemoteManager.PrimarySignalEvent.Subscribe(OnSignalRemotePrimary)

    OnSignalRemotePrimary(Agent : agent):void=
        ToggleUserInterface(Agent, true)

    ToggleUserInterface(Agent : agent, Toggle : logic):void=
        for (xPlayerMaybe : GameManager.xPlayers):
            if (xPlayerMaybe.Agent = Agent):
                xPlayer := xPlayerMaybe
                if (Player := player[Agent], PlayerUI := GetPlayerUI[Player]):
                    if (not xPlayer.InitializedUI?):
                        spawn:
                            InitializeButtons(Agent)

                        set xPlayer.InitializedUI = true
                    if (Toggle?):
                        MainWidget.SetVisibility(widget_visibility.Visible)
                        PlayerUI.AddWidget(MainWidget, player_ui_slot{InputMode := ui_input_mode.All})
                    else:
                        MainWidget.SetVisibility(widget_visibility.Hidden)
                        PlayerUI.RemoveWidget(MainWidget)

    InitializeButtons(Agent : agent)<suspends>:void=
        Print("Initalizing Buttons")
        # Setting Text on Buttons
        set MainWidget.WeaponsText = ToMessage("Weapons")
        set MainWidget.SettingsText = ToMessage("Settings")
        set MainWidget.CloseText = ToMessage("Close")
        set MainWidget.PreviousText = ToMessage("<-")
        set MainWidget.NextText = ToMessage("->")

        race:
            loop:
                MainWidget.CloseEvent.Await()
                Print("Close")
                ToggleUserInterface(Agent, false)
            loop:
                MainWidget.PreviousEvent.Await()
                Print("Prev")
            loop:
                MainWidget.NextEvent.Await()
                Print("Next")
            loop:
                MainWidget.WeaponsEvent.Await()
                OnCategoryClick(Agent, "weapons")
            loop:
                MainWidget.SettingsEvent.Await()
                OnCategoryClick(Agent, "settings")
            loop:
                MainWidget.Item1Event.Await()
                OnItemClick(Agent, 1)
            loop:
                MainWidget.Item2Event.Await()
                OnItemClick(Agent, 2)
            loop:
                MainWidget.Item3Event.Await()
                OnItemClick(Agent, 3)
            loop:
                MainWidget.Item4Event.Await()
                OnItemClick(Agent, 4)
            loop:
                MainWidget.Item5Event.Await()
                OnItemClick(Agent, 5)
            loop:
                MainWidget.Item6Event.Await()
                OnItemClick(Agent, 6)

    OnCategoryClick(Agent : agent, cat : string):void=
        for (xPlayerMaybe : GameManager.xPlayers):
            if (xPlayerMaybe.Agent = Agent):
                xPlayer := xPlayerMaybe

                case (cat):
                    "weapons" => {
                        for (CategoryMaybe : Categories):
                            if (CategoryMaybe.Label = cat):
                                set xPlayer.SelectedCategory = CategoryMaybe
                                LoadCategoryContent(xPlayer)
                    }
                    "settings" => {
                        for (CategoryMaybe : Categories):
                            if (CategoryMaybe.Label = cat):
                                set xPlayer.SelectedCategory = CategoryMaybe
                                LoadCategoryContent(xPlayer)
                    }
                    _ => {}   
    
    LoadCategoryContent(xPlayer : xplayer):void=
        {}


    OnItemClick(Agent : agent, Index : int):void=
        for (xPlayerMaybe : GameManager.xPlayers):
            if (xPlayerMaybe.Agent = Agent):
                xPlayer := xPlayerMaybe

                case (Index):
                    1 => {

                    }
                    2 => {}
                    3 => {}
                    4 => {}
                    5 => {}
                    6 => {}
                    _ => {}